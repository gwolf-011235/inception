#!/bin/bash

# See https://docs.docker.com/engine/swarm/configs/#advanced-example-use-configs-with-a-nginx-service

TOTAL_STEPS=13 # Define the total number of steps
STEP=1  # Initialize step counter

echo "Generating dummy certificates."

echo "$STEP/$TOTAL_STEPS Generate a root key."
((STEP++))
openssl genrsa -out "root-ca.key" 4096

echo "$STEP/$TOTAL_STEPS Generate a CSR using the root key."
((STEP++))
openssl req \
	-new \
	-key "root-ca.key" \
	-out "root-ca.csr" \
	-sha256 \
	-subj '/C=AT/ST=NOe/L=Vienna/O=42Vienna/CN=gwolf CA'

echo "$STEP/$TOTAL_STEPS Configure the root CA."
((STEP++))
# This constrains the root CA to only sign leaf certificates and not intermediate CAs.
echo "[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash" > root-ca.cnf

echo "$STEP/$TOTAL_STEPS Sign the certificate."
((STEP++))
openssl x509 \
	-req \
	-days 3650 \
	-in "root-ca.csr" \
	-signkey "root-ca.key" \
	-sha256 \
	-out "root-ca.crt" \
	-extfile "root-ca.cnf" \
	-extensions root_ca

echo "$STEP/$TOTAL_STEPS Generate the site key."
((STEP++))
openssl genrsa -out "site.key" 4096

echo "$STEP/$TOTAL_STEPS Generate the site certificate and sign it with the site key."
((STEP++))
openssl req \
	-new \
	-key "site.key" \
	-out "site.csr" \
	-sha256 \
	-subj '/C=AT/ST=V/L=Vienna/O=42Vienna/CN=gwolf.42.fr'

echo "$STEP/$TOTAL_STEPS Configure the site certificate."
((STEP++))
# This constrains the site certificate so that it can only be used to authenticate a server and can't be used to sign certificates.
echo "[server]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = DNS:gwolf.42.fr, IP:127.0.0.1
subjectKeyIdentifier=hash" > site.cnf

echo "$STEP/$TOTAL_STEPS Sign the site certificate."
((STEP++))
openssl x509 \
	-req \
	-days 365 \
	-in "site.csr" \
	-sha256 \
	-CA "root-ca.crt" \
	-CAkey "root-ca.key" \
	-CAcreateserial \
	-out "site.crt" \
	-extfile "site.cnf" \
	-extensions server

# The site.csr and site.cnf files are not needed by the Nginx service, but you need them if you want to generate a new site certificate. Protect the root-ca.key file.

# Do similar for ftp certificate
echo "$STEP/$TOTAL_STEPS Generate the ftp key."
((STEP++))
openssl genrsa -out "ftp.key" 4096

echo "$STEP/$TOTAL_STEPS Generate the ftp certificate and sign it with the ftp key."
((STEP++))
openssl req \
	-new \
	-key "ftp.key" \
	-out "ftp.csr" \
	-sha256 \
	-subj '/C=AT/ST=V/L=Vienna/O=42Vienna/CN=ftp.gwolf.42.fr'

echo "$STEP/$TOTAL_STEPS Configure the ftp certificate."
((STEP++))
echo "[ftp]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage = serverAuth, clientAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = DNS:ftp.gwolf.42.fr, IP:127.0.0.1
subjectKeyIdentifier=hash" > ftp.cnf

echo "$STEP/$TOTAL_STEPS Sign the ftp certificate."
((STEP++))
openssl x509 \
	-req \
	-days 365 \
	-in "ftp.csr" \
	-sha256 \
	-CA "root-ca.crt" \
	-CAkey "root-ca.key" \
	-CAcreateserial \
	-out "ftp.crt" \
	-extfile "ftp.cnf" \
	-extensions ftp

# Success
echo "$STEP/$TOTAL_STEPS Success: Generated 'site.crt' - 'site.key' and 'ftp.crt' - 'ftp.key'!"
