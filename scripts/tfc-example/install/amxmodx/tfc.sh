source /scripts/utils/check-server.sh

GAME=$1

execute_until_success "./${GAME}server monitor" "./${GAME}server mi" "amxmodxtfc" "yes"
handle_error