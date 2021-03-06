#!/bin/bash

# Tested and works on "casper-testnet-8"

# Bond validat to networks
# Requirements: 'apt install jq'
# Requirements: Set 'validator public hex' , 'BID_AMOUNT' , 'PROFIT ( fee ), 'CHAIN_NAME', 'OWNER_PRIVATE_KEY' path, 'API' end pint, 'BONDING_CONTRACT' path.

PUB_KEY_HEX='<PUBLIC_HEX_KEY>'

BID_AMOUNT="1100011"
PROFIT="10"

CHAIN_NAME="casper-testnet-8"
OWNER_PRIVATE_KEY="/etc/casper/validator_keys/secret_key.pem"
API_HOST="http://127.0.0.1:7777"
BONDING_CONTRACT="$HOME/casper-node/target/wasm32-unknown-unknown/release/add_bid.wasm"

RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo && echo -e "Broadcasting bind transaction ..." && echo

TX=$(casper-client put-deploy \
        --chain-name "$CHAIN_NAME" \
        --node-address "$API_HOST" \
        --secret-key "$OWNER_PRIVATE_KEY" \
        --session-path "$BONDING_CONTRACT" \
        --payment-amount 1000000000000 \
        --session-arg="public_key:public_key='$PUB_KEY_HEX'" \
        --session-arg="amount:u512='$BID_AMOUNT'" \
        --session-arg="delegation_rate:u64='$PROFIT'" | jq -r '.result | .deploy_hash')

echo -e "${RED}Transaction hash: ${CYAN}$TX${NC}" && echo
