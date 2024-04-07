source /scripts/utils/check-server.sh

GAME=$1

execute_until_success "./${GAME}server monitor" "./${GAME}server mi" "metamod" "yes"
handle_error