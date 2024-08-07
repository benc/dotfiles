#!/bin/bash
op_account_size="$(op account list --format=json | jq -r '. | length')"

if [[ "${op_account_size}" == "0" ]]; then
    echo "⚠️ 1password is not configured, run this command to set it up:"
    echo
    echo "   op account add --address $SUBDOMAIN.1password.com --email $LOGIN"
    echo
    exit 1
fi

eval $(op signin)
