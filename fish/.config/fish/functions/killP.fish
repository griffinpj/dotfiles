function killP
    if test (count $argv) -eq 0
        echo "No parameter provided. Please specify a port number."
        return 1
    end

    set port $argv[1]

    if test (math $port > /dev/null) ^/dev/null
        if lsof -ti :$port > /dev/null
            kill (lsof -t -i:$port)
        else
            echo "No process found running on port $port"
        end
    else
        echo "Invalid port number: $port"
    end
end

