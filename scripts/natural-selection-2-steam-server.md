# Guide: Host Natural Selection 2 Dedicated Server

## Windows - Command Line

1. Download [`steamcmd`](https://developer.valvesoftware.com/wiki/SteamCMD#Windows) and extract.
2. Install or update both client and game server:
```
# use single-line command
steamcmd +login anonymous +force_install_dir ./ns2 +app_update 4940 validate +quit
```
3. Run game server
```
cd ./ns2

# for base game
server -limit 16 -password CHANGEME_GAME_PASSWORD -webadmin -webport 8182 -webpassword CHANGEME_ADMIN_PASSWORD -map ns2_unearthed -name "Pan Filuta se zlobi (dedicated)" -config_path "config-base\"
```

4. Notes
```
Web admin: http://localhost:8182/index.html
Change map: sv_changemap ns2_eclipse
For Infested - use web admin:
- install/enable/disable or "Mods" mode - search for "Infested"
- enable/disable on "Maps"
- then change map
```
