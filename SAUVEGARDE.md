# Sauvegarde Wallabag

> Voir aussi : [Déploiement et Docker](DEPLOIEMENT.md) · [Configuration](CONFIGURATION.md)

## Stratégie

Rotation sur **7 jours** : les fichiers sont nommés par numéro de jour (`1` = lundi … `7` = dimanche).
Chaque semaine, les fichiers du même jour sont **écrasés** — une seule semaine de rétention.

## Ce qui est sauvegardé

| Élément | Source | Fichier généré |
|---|---|---|
| Base MariaDB | `docker exec mysqldump` | `db_<jour>.sql` |
| Données utilisateur | volume Docker `docker_wallabag-data` | `volumes_<jour>.tar.gz` |
| Images téléchargées | volume Docker `docker_wallabag-images` | `volumes_<jour>.tar.gz` |

Les sauvegardes sont stockées dans `/home/andykw/backups/wallabag/`.

## Script

**Fichier** : [`scripts/backup.sh`](scripts/backup.sh)

Exécution automatique tous les jours à **2h du matin** via cron :

```
0 2 * * * /home/andykw/wallabag/scripts/backup.sh
```

Vérifier le cron : `crontab -l`

## Utilisation manuelle

```bash
# Lancer une sauvegarde immédiatement
bash /home/andykw/wallabag/scripts/backup.sh

# Consulter les logs
cat /home/andykw/backups/wallabag/backup.log

# Lister les fichiers de sauvegarde
ls -lh /home/andykw/backups/wallabag/
```

## Restauration

```bash
# 1. Restaurer la base de données (ex: sauvegarde du lundi)
docker exec -i wallabag-db mysql -u wallabag -pwallabag wallabag < /home/andykw/backups/wallabag/db_1.sql

# 2. Restaurer les volumes
docker run --rm \
    -v docker_wallabag-data:/data/wallabag-data \
    -v docker_wallabag-images:/data/wallabag-images \
    -v /home/andykw/backups/wallabag:/backup \
    alpine tar xzf /backup/volumes_1.tar.gz -C /
```

> Arrêter les conteneurs avant de restaurer : `docker compose -f docker/docker-compose.yml down`
