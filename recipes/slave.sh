repl_passwd="53e86ccf52925c77fa9ac9afc05b5a4e"
export repl_user="repl_user"

#su - postgres <<EOF
#psql -c "create user repl_user replication login encrypted password '$repl_passwd'"
#EOF

echo -n "please enter master address: "
read address

if [ "$address" == "" ]
then
  echo.error "no address input"
else
  echo "$address"
  export address
fi

service postgresql status | grep "down" &> /dev/null
if [ $? -ne 0 ]
then
service postgresql stop || echo.error "can't stop postgresql"
fi

#init db for slave
[ -d /var/lib/postgresql/9.3/main ] && rm -rf /var/lib/postgresql/9.3/main
pg_basebackup -R -D /var/lib/postgresql/9.3/main --host=$address --port=5432 -U $repl_user
chown -R postgres:postgres /var/lib/postgresql
echo

[ -d "/opt/psql/archive" ] || mkdir -p /opt/psql/archive/ 


#!important: recovery.conf in directory /var/lib/postgresql/9.3/main/
template "recovery.conf" /var/lib/postgresql/9.3/main/recovery.conf

template "slave-hba.conf" /etc/postgresql/9.3/main/pg_hba.conf
template "slave-psql.conf" /etc/postgresql/9.3/main/postgresql.conf
