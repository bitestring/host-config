https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/postgres/apache


# Postgres Upgrade

## Backup
To perform major version upgrade, use `pg_dumpall` to dump the entire database cluster into a SQL file.


    sudo docker exec -u postgres nextcloud-db-1 pg_dumpall > db.dump


## Restore
To restore the data to newer Posgtres version, use `psql` to execute the SQL dump captured earlier.


    cat db.dump | sudo docker exec -i nextcloud-db-1 psql -U postgres


# Nextcloud Maintanence

Sometimes Nextcloud maintanence jobs need to be executed manually. For example, to create indexes. Use following command to achieve the same.


    sudo docker exec --user www-data --interactive --tty nextcloud-nextcloud-1 php occ db:add-missing-indices
