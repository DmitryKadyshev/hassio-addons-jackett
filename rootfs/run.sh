#!/usr/bin/env bashio
WAIT_PIDS=()

bashio::log.info "starting jackett"

cd /opt/Jackett || bashio::exit.nok "setup gone wrong!"

exec ./jackett -d /config --NoUpdates &
WAIT_PIDS+=($!)

function stop_addon() {
  bashio::log.info "Kill Processes..."
  kill -15 "${WAIT_PIDS[@]}"
  bashio::log.info "Done"
}

trap "stop_addon" SIGTERM SIGHUP

bashio::log.info "All is running smoothly"
wait "${WAIT_PIDS[@]}"
