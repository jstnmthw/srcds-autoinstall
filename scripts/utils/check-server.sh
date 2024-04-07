# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
TIMER=10

# Function to execute a command until it succeeds
execute_until_success() {
    local command=$1
    local install_command=$2

    echo -e "Checking if the application is ready..."

    # Infinite loop
    while true; do
        # Execute the command and capture its output
        output=$($command)

        # Check if the application is ready
        if [[ $output == *"OK"* ]]; then
            echo -e "${GREEN}Application is ready.${NC}"
            
            # Create an array to hold the optional arguments
            args=("$@")

            # Execute the install command
            command_install="${install_command}"

            # Provide the arguments as input to the command
            $command_install < <(for arg in "${args[@]:2}"; do echo "$arg"; done)

            break
        else
            echo $output
            echo -e "${RED}Application is not ready. Waiting for $TIMER seconds...${NC}"
            sleep $TIMER
        fi
    done
}

# Error handling
handle_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}An error occurred while executing the command.${NC}"
        exit 1
    fi
}