function swpenv
    if test -z $argv[1]
        echo "Usage: swpenv <selector>"
        return 1
    end

    set base_directory ~/dev

    # Construct the full directory path based on the selector
    set target_directory $base_directory/$argv[1]

    # Close current Docker containers
    clear
    docker-compose down

    # Change directory to the specified parameter
    cd $target_directory
    docker-compose up -d
    clear

    git status
end

