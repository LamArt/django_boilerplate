#!/bin/bash

# Export variables
source ENV

# Create venv
mv project $PROJECT_NAME
cd $PROJECT_NAME
python3 -mvenv venv
source venv/bin/activate
pip3 install -r requirements.txt

# Rename django project
python3 manage.py rename project $PROJECT_NAME

# Fix configs
cd ..
for file in `ls deploy`; do
    sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" deploy/$file 
    sed -i "s/DOMAIN/$DOMAIN/g" deploy/$file
    sed -i "s/REPONAME/$REPONAME/g" deploy/$file 
done    

# Deploy on remote and exec
scp -r deploy $REMOTE_USER@$HOST:~
scp -r ENV $REMOTE_USER@$HOST:~/deploy/
ssh $REMOTE_USER@$HOST:~ "bash deploy/deploy.sh"

# Remove trash
rm -rf deploy ENV init.sh README.md

# Init README.md
echo "# $PROJECT_NAME" > README.md

# Init git
rm -rf .git
git init
git add -A
git commit -m "Initial commit"
git remote add origin $GITHUB_URL
