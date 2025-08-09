#!/usr/bin/env bash
set -e

mkdir -p certs
cd certs

# 1. create CA key and cert
openssl genrsa -out ca.key.pem 4096
openssl req -x509 -new -nodes -key ca.key.pem -sha256 -days 3650 -out ca.cert.pem -subj "/C=NG/ST=Test/L=Test/O=Test CA/OU=Test CA/CN=Test CA"

# 2. server key and CSR + sign by CA
openssl genrsa -out server.key.pem 2048
openssl req -new -key server.key.pem -out server.csr.pem -subj "/C=NG/ST=Test/L=Test/O=MyOrg/OU=Server/CN=localhost"

# create v3 ext file for SAN (localhost)
cat > server_ext.cnf <<EOL
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
EOL

openssl x509 -req -in server.csr.pem -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -out server.cert.pem -days 365 -sha256 -extfile server_ext.cnf

# 3. client key and cert signed by CA
openssl genrsa -out client.key.pem 2048
openssl req -new -key client.key.pem -out client.csr.pem -subj "/C=NG/ST=Test/L=Test/O=Client/OU=Client/CN=shopify-client"

openssl x509 -req -in client.csr.pem -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -out client.cert.pem -days 365 -sha256

# set permissions
chmod 600 *.key.pem

echo "Generated certs in $(pwd):"
ls -l *.pem
