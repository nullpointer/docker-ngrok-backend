#!/bin/sh -e

NGROK_HOME=ngrok-backend

cd $NGROK_HOME

# init ngrok server if build.info is not exist.
if [ ! -f "build.info" ]; then
  echo "> init ngrok server ..."
  DOMAIN=$1
  HTTP_PORT=$2
  HTTPS_PORT=$3
  TUNNEL_PORT=$4

  echo ">> generate certification ..."
  openssl genrsa -out rootCA.key 2048
  openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$DOMAIN" -days 5000 -out rootCA.pem
  openssl genrsa -out device.key 2048
  openssl req -new -key device.key -subj "/CN=$DOMAIN" -out device.csr
  openssl x509 -req -in device.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out device.crt -days 5000 

  cp rootCA.pem assets/client/tls/ngrokroot.crt
  cp device.crt assets/server/tls/snakeoil.crt
  cp device.key assets/server/tls/snakeoil.key
  echo "<< generate cerification done"  

  echo ">> build ngrok server ..."
  make release-server
  echo "<< build ngrok server done"

  echo ">> build ngrok client ..."
  GOOS=linux GOARCH=386 make release-client
  GOOS=linux GOARCH=arm64 make release-client
  GOOS=windows GOARCH=amd64 make release-client
  GOOS=windows GOARCH=386 make release-client  
  GOOS=darwin GOARCH=amd64 make release-client
  echo "<< build ngrok client done"

  echo ">> save build info to file ..."
  echo "$DOMAIN" >> build.info
  echo "$HTTP_PORT" >> build.info
  echo "$HTTPS_PORT" >> build.info
  echo "$TUNNEL_PORT" >> build.info
  echo "<< save build info to file done"

  echo "< init ngrok server done"
fi

DOMAIN=$(sed -n "1p" build.info)
HTTP_PORT=$(sed -n "2p" build.info)
HTTPS_PORT=$(sed -n "3p" build.info)
TUNNEL_PORT=$(sed -n "4p" build.info)

echo "> start ngrok server ..."
echo "  DOMAIN = ${DOMAIN}"
echo "  HTTP_PORT = ${HTTP_PORT}"
echo "  HTTPS_PORT = ${HTTPS_PORT}"

./bin/ngrokd -tlsKey=device.key -tlsCrt=device.crt -domain="$DOMAIN" -httpAddr=":$HTTP_PORT" -httpsAddr=":$HTTPS_PORT" -tunnelAddr=":$TUNNEL_PORT"