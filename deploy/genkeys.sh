#/bin/bash

echo "Generating key..."
ssh-keygen -t rsa -b 4096 -C "REMOTE_USER@DOMAIN" -q -N "" -f ~/.ssh/id_rsa
echo "You should set up deploy key, secrets.HOST and secrets.SSH_KEY in you github settings"
echo "HOST: REMOTE_HOST"
echo "Public key:"
cat ~/.ssh/id_rsa.pub
