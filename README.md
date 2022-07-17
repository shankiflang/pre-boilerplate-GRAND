# pre-boilerplate-GRAND
Boilerplate for GraphQL React Apollo Node Directus (GRAND)

## Prerequisites
- Docker (with docker-compose)
- Mkcert (https://github.com/FiloSottile/mkcert)

## How to install
Run the install script:
```bash
sh install.sh
```

Here is the steps that the install script will take:
1. Install npm packages
2. Start the database and seed the database for Directus
3. Import the snapshot storted in the `snapshot.json` file
4. Create an "admin" role
5. Create an "admin" user
7. Create the SSL files
8. Docker up everything

## Commands

### Any Directus command 
```bash
docker-compose run --rm directus <command>
```
> example, to create a snapshot : `docker compose run --rm directus npx directus schema snapshot --yes ./snapshots/snapshot.yaml`


### Any npm/yarn command 
```bash
docker-compose run --rm react <command>
```

> example, to create node_modules : `docker compose run --rm react yarn`


### For mkcert in WSL2
You'll need to change the CA folder. Cause Windows need the CA to trust your files

Run on PowerShell:
```powershell
setx CAROOT "$(mkcert -CAROOT)"; setx WSLENV "CAROOT/up:$Env:WSLENV"