repl_passwd="53e86ccf52925c77fa9ac9afc05b5a4e"

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

service postgresql stop || echo.error "can't stop postgresql"

[ -d /var/lib/postgresql/9.3/main ] && rm -rf /var/lib/postgresql/9.3/main
pg_basebackup -R -D /var/lib/postgresql/9.3/main --host=$address --port=5432 -U repl_user

[ -d "/opt/psql/archive" ] || mkdir -p /opt/psql/archive/ 


template "recovery.conf" /etc/postgresql/9.3/main/
template "slave-hba.conf" /etc/postgresql/9.3/main/
template "slave-psql.conf" /etc/postgresql/9.3/main/
