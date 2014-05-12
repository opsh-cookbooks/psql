
case "${node[os]} ${node[version]}" in
ubuntu*14.04*)
  apt-install postgresql-9.3
  ;;
ubuntu*)
  code="$(lsb_release -c | awk '{print $2}')"
  echo "deb http://apt.postgresql.org/pub/repos/apt/ ${code}-pgdg main" > /etc/apt/sources.list.d/psql.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  apt-key add -
  apt-get update
  apt-get install postgresql-9.3
  ;;
esac
