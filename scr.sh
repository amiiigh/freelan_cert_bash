#!/bin/bash
cd
wget http://www.freelan.org/static/files/certificate_authority.zip
unzip certificate_authority.zip
cd certificate_authority
CLIENTS=('alice' 'carol' 'jack' 'bob')
# CLIENTS=('alice')
echo "[##########################]"
echo "[#    generating ca.crt    ]"
echo "[##########################]"
openssl req -new -x509 -extensions v3_ca -keyout key/ca.key -out crt/ca.crt -config ca.cnf -days 3650
for client in ${CLIENTS[@]}; do
	echo "[#################################]"
	echo "[# generating .key for ${client} #]"
	echo "[#################################]"
	openssl genrsa -out "${client}.key" 4096
	echo "[#################################]"
	echo "[# generating .csr for ${client} #]"
	echo "[#################################]"
	openssl req -new -sha1 -key "${client}.key" -out "${client}.csr"
	echo "[#################################]"
	echo "[# generating .crt for ${client} #]"
	echo "[#################################]"
	openssl ca -out crt/"${client}.crt" -in "${client}.csr" -config ca.cnf
done
rm certs.zip
mkdir certs
mv *.csr certs
mv *.key certs
mv crt/*.crt certs
cp key/ca.key certs
zip -r certs.zip certs
rm -rf certs
