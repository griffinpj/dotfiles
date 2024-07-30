#!/bin/bash

api_key="JTANX1IE7TGMFEQ0"

# Parse command line arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    *)    # unknown option
    symbol="$1"
    shift # past argument
    ;;
esac
done

# Verify symbol is valid and retrieve current price
price=$(curl -s "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$api_key" | jq -r '.["Global Quote"]["05. price"]')

# Print current price
echo "Current price of $symbol is: $price"
