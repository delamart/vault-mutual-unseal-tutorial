# README

## Requirements

You'll need:
- docker
- docker-compose

For this tutorial you'll need to setup the local hostname `vault.localhost` in your `hosts` file and point it to `127.0.0.1`.

## STEPS

### Step 0

```
> docker-compose -f docker-compose.yml -f dc.vault-init.yml pull
Pulling db         ... done
Pulling traefik    ... done
Pulling vault-init ... done
> docker-compose -f docker-compose.yml -f dc.vault-init.yml build
```


### Step 1

```
> docker-compose up -d
Creating network "vault_net" with the default driver
Creating traefik ... done
Creating mysql   ... done
```
Wait for `mysqld: ready for connections.`

### Step 2

```
> docker-compose -f docker-compose.yml -f dc.vault-u.yml up -d
traefik is up-to-date
mysql is up-to-date
Creating vault-u ... done

> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault-init.yml run --rm vault-init /home/vault/vault-u-init.sh
```
Visit http://vault.localhost:8200/ui/

### Step 3

```
> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault.yml up -d
traefik is up-to-date
vault-u is up-to-date
mysql is up-to-date
Creating vault_vault_1 ... done

> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault.yml -f dc.vault-init.yml run --rm vault-init /home/vault/vault-init.sh
```
Visit http://vault.localhost/ui/

### Step 4

```
> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault.yml -f dc.seal.yml up -d
mysql is up-to-date
Recreating vault-u ...
traefik is up-to-date
Recreating vault-u ... done

> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault.yml -f dc.vault-init.yml run --rm vault-init /home/vault/migrate.sh
```
Visit http://vault.localhost:8200/ui/

### Step 5

```
> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault.yml -f dc.seal.yml up -d --scale vault=2
traefik is up-to-date
vault-u is up-to-date
mysql is up-to-date
Starting vault_vault_1 ... done
Creating vault_vault_2 ... done

> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault.yml -f dc.seal.yml up -d --scale vault-u=0
Stopping and removing vault-u ...
traefik is up-to-date
Stopping and removing vault-u       ... done
Stopping and removing vault_vault_2 ... done
Starting vault_vault_1              ... done

> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault.yml -f dc.seal.yml up -
mysql is up-to-date
traefik is up-to-date
vault_vault_1 is up-to-date
Creating vault-u ... done

```


### Recovery

```
> docker-compose up -d --remove-orphans
Removing orphan container "vault_vault_1"
Removing orphan container "vault-u"
mysql is up-to-date
traefik is up-to-date

> docker-compose -f docker-compose.yml -f dc.vault-u.yml up -d
mysql is up-to-date
traefik is up-to-date
Creating vault-u ... done

> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault-init.yml run --rm vault-init /home/vault/unseal.sh

> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault.yml up -d
vault-u is up-to-date
mysql is up-to-date
traefik is up-to-date
Creating vault_vault_1 ... done

> docker-compose -f docker-compose.yml -f dc.vault-u.yml -f dc.vault.yml -f dc.seal.yml up -d
traefik is up-to-date
Recreating vault-u ...
mysql is up-to-date
Recreating vault-u ... done
```

## Cleanup
```
> docker-compose.exe down --remove-orphans
> rm -rf db/*
> rm -rf vault/*
> rm -rf vault-with-seal/*
> rm -rf secrets/*
```
