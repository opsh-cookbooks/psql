
backup_path="/opt/psql"
trigger_file="${backup_path}/be-psql-master"


echo "[notice] stop postgresql"
service postgresql stop

repl_user="repl_user"

while [ "$address" == "" ]; do
  echo -n "Please input the master ip: "
  read address
done

while [ "$slave_name" == "" ]; do
  echo -n "Please input the slave name:"
  read slave_name
done


echo  "Please input $repl_user password:"

su - postgres <<EOF

[ -d /var/lib/postgresql/9.3/main ] && rm -rf /var/lib/postgresql/9.3/main

pg_basebackup -R -D /var/lib/postgresql/9.3/main --host=$address --port=5432 -U $repl_user -W

sed -i "s/primary_conninfo\(.*\)'/primary_conninfo\1 application_name=${slave_name}'/g" /var/lib/postgresql/9.3/main/recovery.conf

echo "trigger_file = '${trigger_file}'" >> /var/lib/postgresql/9.3/main/recovery.conf

EOF

echo "[finish] please start postgresql and check status in master"
echo

cat <<EOF
echo  " psql -c 'select application_name,state,sync_priority,sync_state from pg_stat_replication;'" | su - postgres -
EOF
