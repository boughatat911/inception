# USER_DOC

## Start the Stack

1. Create the `srcs/.env` file and fill in the required environment variables.
2. Create the required files inside the `secrets/` directory:
   - db_root_password
   - mysql_password
   - wp_admin_password
   - wp_user_password
3. Run:

```bash
make
```

## Stop the Stack

```bash
make down
```

## Clean the Project

```bash
make clean
```

## Access the Services

- Website: https://<login>.42.fr
- WordPress Admin: https://<login>.42.fr/wp-admin

Use the administrator username from `.env` and the administrator password stored in `secrets/wp_admin_password`.

## Check the Services

```bash
docker-compose ps
```

All three services (`nginx`, `wordpress`, and `mariadb`) should be in the **Up** state.

## Credentials

Environment variables are stored in `srcs/.env`.

Passwords are stored locally in the `secrets/` directory and must never be committed to Git.