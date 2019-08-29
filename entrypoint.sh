#!/bin/bash
set -e

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  chown -R ${SQUID_USER}:${SQUID_GROUP} ${SQUID_LOG_DIR}
  touch ${SQUID_LOG_DIR}/access.log
  touch ${SQUID_LOG_DIR}/cache.log
  touch ${SQUID_LOG_DIR}/store.log
  chmod +x ${SQUID_LOG_DIR}/access.log
  chmod +x ${SQUID_LOG_DIR}/cache.log
  chmod +x ${SQUID_LOG_DIR}/store.log
  chown ${SQUID_USER}:${SQUID_GROUP} ${SQUID_LOG_DIR}/access.log
  chown ${SQUID_USER}:${SQUID_GROUP} ${SQUID_LOG_DIR}/cache.log
  chown ${SQUID_USER}:${SQUID_GROUP} ${SQUID_LOG_DIR}/store.log
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
  chown -R ${SQUID_USER}:${SQUID_GROUP} ${SQUID_CACHE_DIR}
}

create_log_dir
create_cache_dir

# allow arguments to be passed to squid
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid || ${1} == $(which squid) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid) -N -f /usr/local/squid/etc/squid.conf -z
  fi
  echo "Starting squid..."
  exec $(which squid) -f /usr/local/squid/etc/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
