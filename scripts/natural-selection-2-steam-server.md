# Guide: Host Natural Selection 2 Dedicated Server

Remark: You can start the NS2 dedicated server from the game. But we have issues with that - the game was unstable and if the host minimized the window, the game froze.

## Windows - Powershell

1. Server: Download [`steamcmd`](https://developer.valvesoftware.com/wiki/SteamCMD#Windows) and extract.
  
2. Server: Update client and/or install game and/or update game with command:
```powershell
./steamcmd +login anonymous +force_install_dir ./ns2 +app_update 4940 validate +quit
```

3. Server: Run game server
```powershell
cd ./ns2/x64
while(-not $Env:NS2_GAME_PASSWORD) { $Env:NS2_GAME_PASSWORD = Read-Host "Enter game password" }
while(-not $Env:NS2_ADMIN_PASSWORD) { $Env:NS2_ADMIN_PASSWORD = Read-Host "Enter admin password" }
./server -limit 16 -password $Env:NS2_GAME_PASSWORD -webadmin -webport 8182 -webpassword $Env:NS2_ADMIN_PASSWORD -name "Pan Filuta se zlobi (dedicated)" -config_path "my_config\"
```

4. Server: Disable bots in file `my_config/ServerConfig.json` set `settings:filler_bots` to `0` - then restart the server.

5. Server: Admin UI at: http://localhost:8182/index.html
   - Change map with: `sv_changemap ns2_eclipse`
   - To play infested marines mod:
      - install/enable/disable or "Mods" mode - search for "Infested"
      - enable/disable on "Maps"
      - then change map

6. Server: Allow ports on firewall
   - Incoming: 27015/tcp (steam)
   - Incoming: 27015/udp (steam)

7. Clients: Players connect
   1. Buy and install Natural Selection 2 (Steam).
   2. Run the game.
   3. Open console in game (with "`").
   4. Command `connect SERVER_IPADDRESS GAME_PASSWORD` (example: `connect 127.0.0.1 password123`)
