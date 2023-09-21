#! /usr/bin/env sh
set -e

if [ ! -z "$RUN_MIGRATIONS" ]; then
  python manage.py migrate
fi

if [ ! -z "$RUN_MIGRATIONS_CELERY_BEAT" ]; then
  python manage.py migrate django_celery_beat
fi

if [ ! -z "$RUN_MIGRATIONS" ]; then
  python manage.py migrate
fi

if [ ! -z "$RUN_INITDB" ]; then
  python manage.py initdb
fi

if [ ! -z "$RUN_COMPILE_THEMES" ]; then
  python manage.py compile_themes
fi

if [ ! -z "$RUN_COLLECT_STATIC" ]; then
  python manage.py collectstatic -! -zo-input
fi

if [ ! -z "$RUN_ADMIN_CODE" ]; then
  python manage.py admin_code
fi

exec "$@"
