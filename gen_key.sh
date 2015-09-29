#!/bin/bash
#openssl req -nodes -x509 -sha256 -newkey rsa:2048 -keyout serverkey.pem -out server.pem -days 365 -passout pass:foobar -subj /CN=www.pigsapien2.com/O=Pigsapien/C=AU
#openssl req -nodes -x509 -sha256 -newkey rsa:2048 -keyout serverkey.pem -out server.pem -days 365 -passout pass:foobar -subj /CN=nowhere/O=None/C=AU/L=None
openssl  req -nodes -x509 -sha256 -newkey rsa:2048 -keyout serverkey.pem -out server.pem -days 365 -subj /CN=nowhere/O=None/C=AU/L=None
