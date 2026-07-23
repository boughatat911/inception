USER_DOC

Start/Stop the stack
- Copy srcs/.env.example to srcs/.env and fill passwords (local only).
- Run: make up  (starts containers)
- Stop: make down
- Clean: make clean

Access
- Website: https://<login>.42.fr
- Admin: https://<login>.42.fr/wp-admin (use admin credentials from srcs/.env)

Notes
- The repo must not contain real passwords. Use the example file and provide secrets locally to the evaluator.