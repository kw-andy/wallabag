# Déploiement Wallabag

> Voir aussi : [Sauvegarde](SAUVEGARDE.md) · [Configuration](CONFIGURATION.md)

## Architecture

Wallabag tourne en production via **`docker/docker-compose.yml`** avec deux conteneurs Docker.

### Conteneur `wallabag`

- Image : `wallabag/wallabag` (officielle)
- Port exposé : `127.0.0.1:8080` → derrière un reverse proxy
- Domaine : `https://wallabag.just-go.dev`
- Inscription publique désactivée (`FOSUSER_REGISTRATION=false`)
- Volumes persistants : `wallabag-data`, `wallabag-images`

### Conteneur `wallabag-db`

- Image : `mariadb:10.6`
- Base de données : `wallabag` (user/pass : `wallabag`)
- Volume persistant : `db-data`

Les deux conteneurs partagent un réseau interne `wallabag-net` et ont `restart: always`.

## Commandes utiles

```bash
# Démarrer
docker compose -f docker/docker-compose.yml up -d

# Arrêter
docker compose -f docker/docker-compose.yml down

# Voir les logs
docker compose -f docker/docker-compose.yml logs -f

# Statut des conteneurs
docker compose -f docker/docker-compose.yml ps
```

## Redémarrage automatique

Les conteneurs redémarrent automatiquement grâce à `restart: always` :
- en cas de crash
- au reboot du serveur (si Docker démarre au boot)

Vérifier que Docker démarre au boot :

```bash
sudo systemctl is-enabled docker
# doit répondre "enabled"

# Si ce n'est pas le cas :
sudo systemctl enable docker
```

## Environnements

| Fichier | Usage |
|---|---|
| [`docker/docker-compose.yml`](docker/docker-compose.yml) | Production |
| [`compose.yaml`](compose.yaml) | Développement (build local PHP + Redis, port 8000) |

## Sauvegarde

Les sauvegardes automatiques sont documentées dans [SAUVEGARDE.md](SAUVEGARDE.md).
