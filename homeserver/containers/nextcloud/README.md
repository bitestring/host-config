# Postgres Upgrade

# Backup
To perform major version upgrade, use `pg_dumpall` to dump the entire database cluster into a SQL file.

```
sudo docker exec -u postgres nextcloud_db_1 pg_dumpall > db.dump
```

# Restore
To restore the data to newer Posgtres version, use `psql` to execute the SQL dump captured earlier.

```
cat db.dump | sudo docker exec -i nextcloud_db_1 psql -U postgres
```
