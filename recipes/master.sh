repl_passwd="53e86ccf52925c77fa9ac9afc05b5a4e"

su - postgres <<EOF
psql -c "create user repl_user replication login encrypted password '$repl_passwd'"
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
