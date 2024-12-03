#!/bin/bash

export NODE_NO_WARNINGS=1

ENV_DIR="./env"
TARGET_ACTIVE_ENV=".env"

# Reset
RESET="\e[0m"

# Regular Colors
BLACK="\e[30m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"

# Bold Colors
BOLD_BLACK="\e[1;30m"
BOLD_RED="\e[1;31m"
BOLD_GREEN="\e[1;32m"
BOLD_YELLOW="\e[1;33m"
BOLD_BLUE="\e[1;34m"
BOLD_MAGENTA="\e[1;35m"
BOLD_CYAN="\e[1;36m"
BOLD_WHITE="\e[1;37m"


log_error(){
    echo -e "${RED}$1${RESET}"
}

log_success(){
    echo -e "${GREEN}$1${RESET}"
}
log_info(){
    echo -e "${YELLOW}$1${RESET}"
}

validate_env_name() {
    
    if [ -z "$1" ]; then
        log_error "Environment name cannot be empty"
        return 1
    fi

    case "$1" in
        *[!a-zA-Z0-9_-]*)
            log_error "Environment name can only contain letters, numbers, underscores, and hyphens"
            return 1
            ;;
    esac
    
    return 0
}

activate() {
    local ENV_NAME="$1"

    validate_env_name "$ENV_NAME"

    if [ -f "$ENV_DIR/.env.$ENV_NAME" ]; then
        cp $ENV_DIR/.env.$ENV_NAME $TARGET_ACTIVE_ENV || {
            log_error "Failed to copy environment file"
            return 1
        }
        ACTIVATE_ENV=$1
        log_info "Using Environment ""$ENV_NAME"
    else
        log_error "Environment $ENV_NAME not found"
        return 1
    fi
}

deactivate() {
    if [ ! -f "$TARGET_ACTIVE_ENV" ]; then
        log_info "No active environment"
        return 0
    fi
    if ! rm "$TARGET_ACTIVE_ENV"; then
        log_error "Failed to remove environment file"
        return 1
    fi
    ACTIVATE_ENV=
    log_info "Environment deactivated"
}

list(){

    if [ ! -d "./$ENV_DIR" ]; then
        log_error "The 'env' directory was not found in the root directory."
        log_error "Please ensure that your environment files are placed in the './env/' directory."
        return 1
    fi

    if ! ls "./$ENV_DIR/.env."* >/dev/null 2>&1; then
        log_info "No environment files found in ./$ENV_DIR"
        log_info "Environment files should be named as .env.{environment}"
        return 0
    fi

    if [ -d "./$ENV_DIR" ]; then
        for ENV_LIST in $ENV_DIR/.env.*; do
            ENV_NAME=$(echo "$ENV_LIST" | cut -d. -f4)
            if [ "$ENV_NAME" = "$ACTIVATE_ENV" ]; then
                echo -e "\033[32m$ENV_NAME\033[0m <-- active"
            else
                echo -e "\033[32m$ENV_NAME\033[0m"
            fi
        done
    fi
}

if [ $# -eq 0 ]; then
    echo "Usage: envswitcher [command]"
    echo ""
    echo "Commands:"
    echo "  list              List all available environments"
    echo "  activate [env]    Switch to specified environment"
    echo "  deactivate        Remove active environment"
fi

init(){
    if [ ! -d "./$ENV_DIR" ]; then
    mkdir "env"
    fi
    if [ ! -f "./env/.env.development" ]; then
    touch "env/.env.development"
    fi
    if [ ! -f "./env/.env.staging" ]; then
    touch "env/.env.staging"
    fi
        if [ ! -f "./env/.env.production" ]; then
    touch "env/.env.production"
    fi
    
}


delete(){
    if [ -f "$ENV_DIR""/.env.""$1" ]; then
        rm "$ENV_DIR""/.env.""$1"
    else
    log_error "$1 file not found"
    fi
}

case $1 in
    "list")
        list
        ;;
    "activate")
        activate "$2"
        ;;
    "deactivate")
        deactivate
        ;;
    "init")
        init
        ;;
    "delete")
        delete "$2"
        ;;
    *)
        log_error "Unknown command: $1"
        echo "Usage: envswitcher [command]"
        echo ""
        echo "Commands:"
        echo "  list              List all available environments"
        echo "  activate [env]    Switch to specified environment"
        echo "  deactivate        Remove active environment"
        ;;
esac