repl_passwd="53e86ccf52925c77fa9ac9afc05b5a4e"
export repl_user="repl_user"

#create user, show users
su - postgres <<EOF
psql -c "create user repl_user replication login encrypted password '$repl_passwd'"
psql -c '\du'
EOF


echo -n "please enter slave address: "
read address

if [ "$address" == "" ]
then
  echo.error "no address input"
else
  echo "$address"
  export address
fi

template "master-hba.conf" /etc/postgresql/9.3/main/pg_hba.conf
template "master-psql.conf" /etc/postgresql/9.3/main/postgresql.conf


service postgresql restart


test_postgresql() {
su - postgres <<EOF
psql -c "CREATE TABLE rep_test (test varchar(40));"
psql -c "INSERT INTO rep_test VALUES ('data one');"
psql -c "INSERT INTO rep_test VALUES ('some more words');"
psql -c "INSERT INTO rep_test VALUES ('lalala');"
psql -c "INSERT INTO rep_test VALUES ('hello there');"
psql -c "INSERT INTO rep_test VALUES ('blahblah');"
psql -c "SELECT * FROM rep_test;"
EOF
}


