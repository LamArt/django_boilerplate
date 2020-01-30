#!/bin/bash
source ENV

apt-get install git libxml2-dev libxslt1-dev python-dev python3-dev virtualenv nginx
cd /opt
git clone GITHUB_URL
cd ./REPONAME

virtualenv --system-site-packages --python=/usr/bin/python3 /opt/REPONAME/PROJECT_NAME/venv
source PROJECT_NAME/venv/bin/activate

pip install --quiet -r /opt/REPONAME/DJANGO_PROJECT/requirements.txt

mkdir -p /var/opt/PROJECT_NAME
mkdir /var/opt/PROJECT_NAME/media 
mkdir -p /var/cache/PROJECT_NAME/static
mkdir -p /var/log/PROJECT_NAME/

cat ~/deploy/local_settings.py > /opt/REPONAME/PROJECT_NAME/PROJECT_NAME/local_settings.py
python3 -m compileall -x /opt/REPONAME/PROJECT_NAME/venv/ /opt/REPONAME/PROJECT_NAME 

cd /opt/REPONAME/PROJECT_NAME
python3 manage.py --verbosity 0 collectstatic
python3 manage.py --verbosity 0 migrate

cd /etc/nginx/sites-available/
cat ~/deploy/nginx.conf DOMAIN

cd /etc/nginx/sites-enabled
ln -s ../sites-available/DOMAIN

systemctl restart nginx

pip install gunicorn
cd /etc/systemd/system/
cat ~/deploy/systemd.conf > PROJECT_NAME.service

cat  ~/deploy/my_gunicorn  > my_gunicorn
chmod 755 my_gunicorn
systemctl enable --now PROJECT_NAME

ssh-keygen -t rsa -b 4096 -C "REMOTE_USER@DOMAIN"
echo "You should set up deploy key, secrets.HOST and secrets.SSH_KEY in you github settins"
echo "HOST: REMOTE_HOST"
echo "Public key:"
cat ~/.ssh/id_rsa.pub

rm -rf ~/deploy
