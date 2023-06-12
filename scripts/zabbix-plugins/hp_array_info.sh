#!/usr/bin/python3

# Generates flat JSON array output from "ssacli" (HP Smart Storage Admin CLI). Output can be consumed in Zabbix or other monitoring.

import json
import re
import subprocess

def extract_slot_number(string):
    match = re.search(r'Slot (\d+)', string)
    if match:
        return match.group(1)
    else:
        return '?'

def extract_drive_id(string):
    match = re.search(r'drive (\d+.+)', string)
    if match:
        return match.group(1)
    else:
        return '?'

def convert_to_camel_case(string):
    string = re.sub(r'[^a-zA-Z0-9 ]', ' ', string).lower()
    words = string.split()
    camel_case = words[0].lower() + ''.join(word.capitalize() for word in words[1:])
    return camel_case

def process_lines_to_json(lines):
    result = []
    current = {}
    stack = []

    for line in lines:

        # count leading spaces and use it to determine level of indentation
        level = int(line.count(' ', 0, -len(line.lstrip())) / 3);
        line = line.strip()

        if line == '':
            continue

        while level < len(stack):
            stack.pop()

        # level 0: controller ID, for example: Smart Array P410i in Slot 0 (Embedded)
        # level 1: array ID, for example: Array A
        # level 2: device ID, for example: physicaldrive 1I:1:1
        if level < 3:
            stack.append(line)

            if len(stack) == 3:
                current = {}
                result.append(current)
                current["id"] = extract_slot_number(stack[0]) + "-" + extract_drive_id(stack[2])
                current["controller"] = stack[0]
                current["array"] = stack[1]
                current["physicalDrive"] = stack[2]

        else:
            # remove leading and trailing spaces and split at first ':'
            parts = line.split(':', 1)

            if len(parts) == 1:
                parts.append("")

            key = convert_to_camel_case(parts[0].strip())
            value = parts[1].strip()
            current[key] = value

    return json.dumps(result, indent=4)

def read_ssacli_lines(slot_index):
    cli_result = subprocess.run(['ssacli', 'ctrl', 'slot=' + slot_index, 'physicaldrive', 'all', 'show', 'detail'], stdout=subprocess.PIPE)
    lines = str.splitlines(cli_result.stdout.decode('utf-8'))
    return lines

lines = read_ssacli_lines("0") # default slot index is "0"
json = process_lines_to_json(lines)

print(json)
