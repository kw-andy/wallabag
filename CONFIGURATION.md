# Configuration de wallabag

> Version : 2.7.0-dev — Symfony / PHP 8.2
> Voir aussi : [Déploiement et Docker](DEPLOIEMENT.md) · [Sauvegarde](SAUVEGARDE.md)

---

## 1. Fichiers de configuration principaux

| Fichier | Rôle |
|---|---|
| `app/config/parameters.yml.dist` | Template de référence à copier en `parameters.yml` |
| `app/config/parameters.yml` | Paramètres locaux (non versionné) |
| `app/config/config.yml` | Configuration Symfony principale, importe les autres |
| `app/config/wallabag.yml` | Paramètres métier wallabag (lecture, export, partage…) |
| `app/config/security.yml` | Firewalls, rôles, contrôle d'accès |
| `app/config/services.yml` | Déclaration des services Symfony |
| `app/config/config_prod.yml` / `config_dev.yml` | Surcharges par environnement |

---

## 2. Paramètres d'instance (`parameters.yml`)

### Base de données

| Paramètre | Défaut | Description |
|---|---|---|
| `database_driver` | `pdo_mysql` | Driver PDO : `pdo_mysql`, `pdo_pgsql`, `pdo_sqlite` |
| `database_host` | `127.0.0.1` | Hôte du serveur |
| `database_port` | `~` (null) | Port (null = défaut du driver) |
| `database_name` | `wallabag` | Nom de la base |
| `database_user` | `root` | Utilisateur |
| `database_password` | `~` | Mot de passe |
| `database_path` | `null` | Chemin fichier SQLite uniquement |
| `database_table_prefix` | `wallabag_` | Préfixe des tables |
| `database_socket` | `null` | Socket Unix (optionnel) |
| `database_charset` | `utf8mb4` | `utf8mb4` pour MySQL, `utf8` pour PostgreSQL/SQLite |

### Application

| Paramètre | Défaut | Description |
|---|---|---|
| `domain_name` | `https://your-wallabag-instance…` | URL publique de l'instance |
| `server_name` | `"Your wallabag instance"` | Nom affiché dans les emails 2FA |
| `locale` | `en` | Langue par défaut |
| `secret` | *(à changer)* | Clé secrète Symfony (tokens CSRF, remember-me…) |

### Messagerie

| Paramètre | Défaut | Description |
|---|---|---|
| `mailer_dsn` | `smtp://127.0.0.1` | DSN Symfony Mailer |
| `from_email` | `no-reply@wallabag.org` | Adresse expéditeur |
| `twofactor_sender` | `no-reply@wallabag.org` | Expéditeur des codes 2FA par email |

### Comptes utilisateurs (FOSUserBundle)

| Paramètre | Défaut | Description |
|---|---|---|
| `fosuser_registration` | `false` | Autoriser l'inscription publique |
| `fosuser_confirmation` | `true` | Exiger la confirmation par email |

### API OAuth2

| Paramètre | Défaut | Description |
|---|---|---|
| `fos_oauth_server_access_token_lifetime` | `3600` | Durée de vie de l'access token (secondes) |
| `fos_oauth_server_refresh_token_lifetime` | `1209600` | Durée de vie du refresh token (14 jours) |

### RabbitMQ (import asynchrone)

| Paramètre | Défaut |
|---|---|
| `rabbitmq_host` | `localhost` |
| `rabbitmq_port` | `5672` |
| `rabbitmq_user` | `guest` |
| `rabbitmq_password` | `guest` |
| `rabbitmq_prefetch_count` | `10` |

### Redis (sessions et/ou import asynchrone)

| Paramètre | Défaut |
|---|---|
| `redis_scheme` | `redis` |
| `redis_host` | `localhost` |
| `redis_port` | `6379` |
| `redis_path` | `null` |
| `redis_password` | `null` |

### Monitoring

| Paramètre | Défaut | Description |
|---|---|---|
| `sentry_dsn` | `~` | DSN Sentry pour la remontée d'erreurs |

---

## 3. Paramètres métier (`wallabag.yml`)

### Interface et lecture

| Paramètre | Valeur |
|---|---|
| `wallabag.items_on_page` | `12` |
| `wallabag.feed_limit` | `50` |
| `wallabag.reading_speed` | `200` mots/min |
| `wallabag.cache_lifetime` | `10` minutes |
| `wallabag.action_mark_as_read` | `1` (marquer comme lu à l'ouverture) |
| `wallabag.list_mode` | `0` (mode grille) |
| `wallabag.display_thumbnails` | `1` |
| `wallabag.api_limit_mass_actions` | `10` entrées max par action de masse |

### Polices disponibles

Sans-serif, Serif, Atkinson Hyperlegible, EB Garamond, Lato, Montserrat, OpenDyslexicRegular, Oswald.

### Paramètres internes (base de données, modifiables en admin)

**Section `entry` (partage)**

| Nom | Valeur par défaut |
|---|---|
| `share_public` | `1` |
| `share_twitter` | `1` |
| `share_mail` | `1` |
| `share_diaspora` / `diaspora_url` | `1` / `https://diasporapod.com` |
| `share_unmark` / `unmark_url` | `1` / `https://unmark.it` |
| `share_shaarli` / `shaarli_url` | `1` / `https://myshaarli.com` |
| `share_linkding` / `linkding_url` | `1` / `https://linkding.example.com` |
| `show_printlink` | `1` |
| `restricted_access` | `0` |
| `store_article_headers` | `0` |
| `shaarli_share_origin_url` | `0` |

**Section `export`**

| Format | Activé par défaut |
|---|---|
| EPUB | oui |
| PDF | oui |
| CSV | oui |
| JSON | oui |
| TXT | oui |
| XML | oui |
| Markdown | oui |

**Section `import`**

| Paramètre | Valeur par défaut |
|---|---|
| `import_with_redis` | `0` (synchrone) |
| `import_with_rabbitmq` | `0` (synchrone) |

**Section `analytics`**

| Paramètre | Valeur par défaut |
|---|---|
| `matomo_enabled` | `0` |
| `matomo_host` | `matomo.wallabag.org` |
| `matomo_site_id` | `1` |

**Section `misc`**

| Paramètre | Valeur par défaut |
|---|---|
| `download_images_enabled` | `0` |
| `wallabag_support_url` | GitHub Issues |

**Section `api`**

| Paramètre | Valeur par défaut |
|---|---|
| `api_user_registration` | `0` |

---

## 4. Sécurité (`security.yml`)

### Rôles

```
ROLE_USER < ROLE_ADMIN < ROLE_SUPER_ADMIN
```

`ROLE_SUPER_ADMIN` inclut `ROLE_ALLOWED_TO_SWITCH` (impersonnation d'utilisateur).

### Firewalls

| Firewall | Pattern | Mode |
|---|---|---|
| `dev` | profiler, assets | Pas d'auth |
| `oauth_token` | `/oauth/v2/token` | Pas d'auth |
| `api` | `/api/.*` | OAuth2 stateless |
| `login_firewall` | `/login` | Anonyme |
| `secured_area` | `^/` | Form login + remember-me (1 an) + 2FA |

### Authentification à deux facteurs (2FA)

- **Google Authenticator** (TOTP) : activé, émetteur = `server_name`
- **Email** : activé, 6 chiffres, expéditeur = `twofactor_sender`
- **Trusted devices** : cookie `wllbg_trusted_computer`, durée 30 jours
- **Backup codes** : activés

### Accès public (sans authentification)

- Flux RSS/Atom (`*.xml`, `/feed`)
- Pages de partage (`/share`)
- Inscription / réinitialisation de mot de passe
- Endpoints API : `/api/doc`, `/api/version`, `/api/info`, `/api/user`

### CORS API

Les routes `/api/` et `/oauth/` acceptent toutes les origines (`*`) avec les méthodes GET, POST, PUT, PATCH, DELETE.

---

## 5. Déploiement Docker

> Pour les commandes de démarrage, redémarrage automatique et sauvegarde, voir [DEPLOIEMENT.md](DEPLOIEMENT.md) et [SAUVEGARDE.md](SAUVEGARDE.md).

### `compose.yaml` (développement)

Démarre par défaut avec **SQLite** et **Redis** (sessions PHP via Redis).

```
php service → port 8000
redis service → Redis 6 Alpine
```

Variables d'environnement lues depuis `docker/php/env` (copier depuis `docker/php/env.example`).

Services optionnels commentés : MariaDB, PostgreSQL, RabbitMQ, Blackfire.

### `docker/docker-compose.yml` (production, image officielle)

Utilise l'image `wallabag/wallabag` + MariaDB 10.6.

```yaml
SYMFONY__ENV__DOMAIN_NAME=https://wallabag.just-go.dev
SYMFONY__ENV__FOSUSER_REGISTRATION=false
```

Exposition : `127.0.0.1:8080:80` (derrière un reverse-proxy).

### Variables d'environnement Docker

L'entrypoint génère `parameters.yml` et `wallabag-php.ini` via `envsubst`.

| Variable | Défaut |
|---|---|
| `DATABASE_DRIVER` | `pdo_sqlite` |
| `DATABASE_PATH` | `data/db/wallabag.sqlite` |
| `DOMAIN_NAME` | `http://127.0.0.1:8000` |
| `SECRET` | `ch4n63m31fy0uc4n` *(à changer)* |
| `PHP_SESSION_HANDLER` | `redis` |
| `PHP_SESSION_SAVE_PATH` | `redis://redis:6379?database=2` |
| `PHP_MEMORY_LIMIT` | `512M` |
| `PHP_MAX_EXECUTION_TIME` | `60` |
| `PHP_TIMEZONE` | `Europe/Paris` |
| `FOSUSER_REGISTRATION` | `false` |
| `LOCALE` | `en` |

---

## 6. Import asynchrone

Deux backends supportés (désactivés par défaut) :

- **Redis** : activer `import_with_redis = 1` dans les paramètres internes
- **RabbitMQ** : activer `import_with_rabbitmq = 1` — les queues sont nommées `wallabag.import.<source>`

Sources supportées : Pocket, Pocket HTML/CSV, Readability, Pinboard, Delicious, Instapaper, Wallabag v1/v2, Elcurator, Omnivore, Firefox, Chrome, Shaarli.

---

## 7. Chiffrement des credentials de sites

La clé de chiffrement est stockée dans :

```
data/site-credentials-secret-key.txt
```

Paramètre : `wallabag.site_credentials.encryption_key_path`.

---

## 8. Règles d'origine ignorées (par défaut)

Les URLs intermédiaires suivantes sont ignorées lors du fetch :

- `host = "feedproxy.google.com"`
- `host = "feeds.reuters.com"`
- `_all ~ "https?://www\.lemonde\.fr/tiny.*"`
