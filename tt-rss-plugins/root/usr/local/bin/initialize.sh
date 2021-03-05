#!/bin/sh
if [  -n "$TTRSS_DB_HOST" ] && [ -n "$TTRSS_DB_USER" ] && [ -n "$TTRSS_DB_NAME" ] && [ -n "$TTRSS_DB_PASS" ] ;  then
    while ! pg_isready -h $TTRSS_DB_HOST -U $TTRSS_DB_USER; do
	    sleep 3
    done
    PSQL="psql -q -h $TTRSS_DB_HOST -U $TTRSS_DB_USER $TTRSS_DB_NAME"
    $PSQL -c "create extension if not exists pg_trgm"
    if ! $PSQL -c 'select * from ttrss_version'; then
	    $PSQL < /usr/local/tt-rss/schema/ttrss_schema_pgsql.sql
    fi
else
    echo 环境变量TTRSS_DB_[HOST、USER、NAME、PASS]未填写完全...
fi
