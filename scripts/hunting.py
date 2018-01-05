#!/usr/bin/python

"""Notifikuje o novych inzeratech z Bazar hunting shop - bazar.hunting-shop.cz"""


import urllib.request
from html.parser import HTMLParser
import re
import json
import datetime
from pathlib import Path

def getAttrVal(attrs, attrName):
    return next((x[1] for x in attrs if x[0]==attrName), '')

def isClass(attrs, expectedClass):
    return expectedClass in getAttrVal(attrs, 'class')

def isElementWithClass(tag, attrs, expectedTag, expectedClass):
    return tag == expectedTag and isClass(attrs, expectedClass)

"""Hunting-shop Parser"""
class huntingParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.stack = [{ 'tag': 'root' }]
        self.items = []
        self.item = {}

    def handle_starttag(self, tag, attrs):
        peek = self.stack[-1]
        pushItem = { 'tag' : tag }
        if(peek.__contains__('meaning')):
            pushItem['meaning'] = peek['meaning']

        if isClass(attrs, 'zbozi_okno'):
            pushItem["container"] = True
        elif isClass(attrs, 'nalepka'):
            pushItem["meaning"] = 'category'
        elif isClass(attrs, 'zbozi_nazev'):
            pushItem["meaning"] = 'name'
        elif isClass(attrs, 'zbozi_text'):
            pushItem["meaning"] = 'description'
        elif isClass(attrs, 'kontakt'):
            pushItem["meaning"] = 'contact'
        elif peek.get('meaning', '') == 'name' and tag == 'a':
            self.item['url'] = getAttrVal(attrs, 'href')

        self.stack.append(pushItem)

    def handle_endtag(self, tag):
        element = self.stack.pop()

        if element['tag'] != tag:
            raise Exception("Mismatch elements " + tag + " but expected is " + element['tag'])

        if element.get('container', False):
            for key, value in self.item.items():
                self.item[key] = re.sub('[ \n|]+', ' ', value).strip()
            self.items.append(self.item)
            self.item = {}

    def handle_data(self, data):
        peek = self.stack[-1]
        meaning = peek.get('meaning', '')
        if(meaning != ''):
            self.item[meaning] = self.item.get(meaning,'') + data


"""Send mail with new items"""
def sendMailWithItems(items, title, to, smtpServer, smtpPort, user, password):
    print('Sending mail with', len(items), 'items')

    message = 'Found new %i item(s)\n' % len(items)
    for item in items:
        message += '\n'
        message += item["name"]
        message += ' - ' 
        message += item["url"]
        message += ' - ' 
        message += item["description"]

        message += '\n\n--------------------------------------------------\n'
    

    import smtplib
    from email.message import EmailMessage
    msg = EmailMessage()
    
    msg.set_content(message)
    msg['Subject'] = 'Watchdog %s - new item(s)' % title
    msg['From'] = 'watchdog@jecha.net'
    msg['To'] = to
    s = smtplib.SMTP(smtpServer, smtpPort)
    s.login(user, password)
    s.send_message(msg)
    s.quit()
    print('Mail sent.')


def main(argv):

    import sys, getopt

    longArgs = ["title=","url=","path=","regexFilter=","mailTo=","smtpServer=","smtpPort=","smtpUser=","smtpPassword="]
    try:
        opts, args = getopt.getopt(argv,"",longArgs)
    except getopt.GetoptError:
        print('Invalid arguments. Required:', longArgs)
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("--title"): title = arg
        elif opt in ("--url"): url = arg
        elif opt in ("--path"): path = arg
        elif opt in ("--regexFilter"): regexFilter = arg
        elif opt in ("--mailTo"): mailTo = arg
        elif opt in ("--smtpServer"): smtpServer = arg
        elif opt in ("--smtpPort"): smtpPort = arg
        elif opt in ("--smtpUser"): smtpUser = arg
        elif opt in ("--smtpPassword"): smtpPassword = arg
        else:
            assert False, "unhandled option"

    # url = 'http://bazar.hunting-shop.cz/sekce/138-malorazky/'
    # path = 'known_items.json'
    # regexFilter = 'buLL|3000'
    # title = 'Test search'
    # mailTo = 'xxxx'
    # smtpServer = 'smtp.sendgrid.net'
    # smtpPort = 25
    # smtpUser = 'xxxx'
    # smtpPassword = 'xxxx'

    # Fetch data
    print('Watchdog title:', title)
    print('Email:', mailTo)
    print('Local store path:', path)
    print('Filter regex:', regexFilter)
    print('Fetching:', url)
    with urllib.request.urlopen(url) as f:
        content = f.read().decode('utf-8')
        contentParser = huntingParser()
        contentParser.feed(content)
        items = contentParser.items

    print('Found', len(items), 'items on webpage')

    if Path(path).exists():
        knownItems = json.loads(Path(path).read_text())
        print('Local file items:', len(knownItems))
    else:
        knownItems = []
        print('First run. Input file not found.')

    knownItemsUrls = set()

    for knownItem in knownItems:
        knownItemsUrls.add(knownItem['url'])

    knownItemsChanged = False
    newItems = []

    for item in items:
        if not knownItemsUrls.__contains__(item['url']):
            knownItems.append({'url': item['url'], 'date': datetime.datetime.now().isoformat()})
            knownItemsChanged = True
            newItems.append(item)

    if any(newItems):
        print('New items:', len(newItems))
        if regexFilter:
            newItems = [i for i in newItems if any(re.search(regexFilter, v, re.IGNORECASE) for _,v in i.items())]
            print('New items after filter applied:', len(newItems))
        else:
            print('No filter applied. All new items are valid.')
        sendMailWithItems(newItems, title, mailTo, smtpServer, smtpPort, smtpUser, smtpPassword)
    else:
        print('No new items')

    if(knownItemsChanged):
        Path(path).write_text(json.dumps(knownItems))

    print('Done')


import sys
if __name__ == "__main__":
   main(sys.argv[1:])