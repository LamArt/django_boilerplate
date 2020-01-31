#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
set -e
trap "exit" INT

cd ~/deploy

echo "Installing packages..."
apt-get install -y git libxml2-dev libxslt1-dev python-dev python3-dev virtualenv nginx certbot python-certbot-nginx  > /dev/null

echo "Cloning repo..."
cd /opt
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone -q GITHUB_URL REPONAME
cd ./REPONAME

echo "Creating venv..."
virtualenv --system-site-packages --python=/usr/bin/python3 -q /opt/REPONAME/PROJECT_NAME/venv
source PROJECT_NAME/venv/bin/activate

echo "Installing requirements..."
pip install --quiet -r /opt/REPONAME/PROJECT_NAME/requirements.txt

echo "Configuring project dir..."
mkdir -p /var/opt/PROJECT_NAME
mkdir /var/opt/PROJECT_NAME/media 
mkdir -p /var/cache/PROJECT_NAME/static
mkdir -p /var/log/PROJECT_NAME/

cat ~/deploy/local_settings.py > /opt/REPONAME/PROJECT_NAME/PROJECT_NAME/local_settings.py
python3 -m compileall -x /opt/REPONAME/PROJECT_NAME/venv/ /opt/REPONAME/PROJECT_NAME > /dev/null 

echo "Configuring django..."
cd /opt/REPONAME/PROJECT_NAME
#python3 manage.py collectstatic --no-input > /dev/null
python3 manage.py migrate > /dev/null

echo "Configuring nginx..."
cd /etc/nginx/sites-available/
cat ~/deploy/nginx.conf > DOMAIN

cd /etc/nginx/sites-enabled
ln -s ../sites-available/DOMAIN
certbot --nginx -n --agree-tos --email root@DOMAIN -d DOMAIN -d www.DOMAIN || echo "certbot failed"

systemctl restart nginx

echo "Configuring gunicorn..."
pip install gunicorn
cd /etc/systemd/system/
cat ~/deploy/systemd.conf > PROJECT_NAME.service

cat  ~/deploy/my_gunicorn > my_gunicorn
chmod 755 my_gunicorn
systemctl enable --now PROJECT_NAME

rm -rf ~/deploy
