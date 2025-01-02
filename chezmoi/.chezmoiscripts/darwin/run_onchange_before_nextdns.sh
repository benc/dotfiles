#!/bin/bash
if security find-certificate -c "NextDNS" /Library/Keychains/System.keychain >/dev/null 2>&1; then
    echo "NextDNS certificaat is al geïnstalleerd"
else
    echo "NextDNS certificaat wordt gedownload en geïnstalleerd..."
    curl -fsSL -o "/tmp/NextDNS.cer" https://nextdns.io/ca
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "/tmp/NextDNS.cer"
    rm -rfv "/tmp/NextDNS.cer"
    echo "Installatie voltooid"
fi
