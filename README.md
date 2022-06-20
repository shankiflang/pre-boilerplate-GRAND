# pre-boilerplate-GRAND
Boilerplate for GraphQL React Apollo Node Directus (GRAND)


## Create snapshot from docker 
```bash
docker compose run directus npx directus schema snapshot --yes ./snapshots/snapshot.yaml
```

## Import snapshot to Directus
```bash
docker compose run directus npx directus schema snapshot apply ./snapshots/snapshot.yaml
```