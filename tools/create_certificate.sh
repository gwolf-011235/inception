#!/bin/bash

# See https://docs.docker.com/engine/swarm/configs/#advanced-example-use-configs-with-a-nginx-service

echo "Generating dummy certificates."
echo "1/9 Generate a root key."
openssl genrsa -out "root-ca.key" 4096

echo "2/9 Generate a CSR using the root key."
openssl req \
	-new \
	-key "root-ca.key" \
	-out "root-ca.csr" \
	-sha256 \
	-subj '/C=AT/ST=NOe/L=Vienna/O=42Vienna/CN=gwolf CA'

echo "3/9 Configure the root CA."
# This constrains the root CA to only sign leaf certificates and not intermediate CAs.
echo "[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash" > root-ca.cnf

echo "4/9 Sign the certificate."
openssl x509 \
	-req \
	-days 3650 \
	-in "root-ca.csr" \
	-signkey "root-ca.key" \
	-sha256 \
	-out "root-ca.crt" \
	-extfile "root-ca.cnf" \
	-extensions root_ca

echo "5/9 Generate the site key."
openssl genrsa -out "site.key" 4096

echo "6/9 Generate the site certificate and sign it with the site key."
openssl req \
	-new \
	-key "site.key" \
	-out "site.csr" \
	-sha256 \
	-subj '/C=AT/ST=NOe/L=Vienna/O=42Vienna/CN=gwolf.42.fr'

echo "7/9 Configure the site certificate."
# This constrains the site certificate so that it can only be used to authenticate a server and can't be used to sign certificates.
echo "[server]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = DNS:localhost, IP:127.0.0.1
subjectKeyIdentifier=hash" > site.cnf

echo "8/9 Sign the site certificate."
openssl x509 \
	-req \
	-days 750 \
	-in "site.csr" \
	-sha256 \
    -CA "root-ca.crt" \
	-CAkey "root-ca.key" \
	-CAcreateserial \
    -out "site.crt" \
	-extfile "site.cnf" \
	-extensions server

# The site.csr and site.cnf files are not needed by the Nginx service, but you need them if you want to generate a new site certificate. Protect the root-ca.key file.

# Succes
echo "9/9 Success: Generated 'site.crt' and 'site.key'!"

