#!/bin/bash

cd /opt/REPONAME
git pull
python3 -m compileall -x /opt/REPONAME/PROJECT_NAME/venv/ /opt/REPONAME/PROJECT_NAME
cd /opt/REPONAME/PROJECT_NAME
source venv/bin/activate
python3 manage.py collectstatic --no-input
python3 manage.py migrate
