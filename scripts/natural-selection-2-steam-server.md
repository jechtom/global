# Guide: Host Natural Selection 2 Dedicated Server

## Windows - Powershell

1. Download [`steamcmd`](https://developer.valvesoftware.com/wiki/SteamCMD#Windows) and extract.
  
2. Update client and/or install game and/or update game with command:
```powershell
./steamcmd +login anonymous +force_install_dir ./ns2 +app_update 4940 validate +quit
```

3. Run game server
```powershell
cd ./ns2/x64
while(-not $Env:NS2_GAME_PASSWORD) { $Env:NS2_GAME_PASSWORD = Read-Host "Enter game password" }
while(-not $Env:NS2_ADMIN_PASSWORD) { $Env:NS2_ADMIN_PASSWORD = Read-Host "Enter admin password" }
./server -limit 16 -password $Env:NS2_GAME_PASSWORD -webadmin -webport 8182 -webpassword $Env:NS2_ADMIN_PASSWORD -name "Pan Filuta se zlobi (dedicated)" -config_path "my_config\"
```

4. Notes
```
Web admin: http://localhost:8182/index.html (you can enter admin commands here)

Change map: sv_changemap ns2_eclipse

To disable bots in file ServerConfig.json set settings:filler_bots to 0 - then restart server
Or command to remove it from current game: sv_maxbots 0

For Infested - use web admin:
- install/enable/disable or "Mods" mode - search for "Infested"
- enable/disable on "Maps"
- then change map

```

5. Connect
```
Port: 27015 (default)

Open console in game (with "`").
Command:

connect IPADDRESS PASSWORD
// example: connect 127.0.0.1 password123
```
