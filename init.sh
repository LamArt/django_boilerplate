#!/bin/bash

echo "Importing config.ini..."
source <(grep = config.ini)
vars=($(grep -aoP ".*(?=\=)" config.ini))
for var in ${vars[@]}; do
    if [ -z ${!var} ]; then
        echo "$var is unset. Edit config.ini"
        exit 1
    fi
done

echo "Creating venv..."
mv project $PROJECT_NAME
cd $PROJECT_NAME
python3 -mvenv venv 2>/dev/null || py -mvenv venv                        #<-- hack for windows
source venv/bin/activate 2>/dev/null || source venv/Scripts/activate     #<-- hack for windows
pip3 install --quiet -r requirements.txt

echo "Renaming django project..."
python manage.py rename project $PROJECT_NAME

echo "Changing configs..."
cd ..
for file in `ls deploy`; do
    for var in ${vars[@]}; do
        sed -i "s/$var/${!var}/g" deploy/$file
    done    
done    

echo "Deploying on remote host..."
scp -r deploy -p $REMOTE_PORT $REMOTE_USER@$REMOTE_HOST:~
scp -r deploy/update.sh -p $REMOTE_PORT $REMOTE_USER@$REMOTE_HOST:~
scp -r config.ini -p $REMOTE_PORT $REMOTE_USER@$REMOTE_HOST:~/deploy/

echo "Removing temp files..."
rm -rf deploy config.ini init.sh README.md

echo "Creating new README..."
echo "# $PROJECT_NAME" > README.md

echo "Creating git..."
rm -rf .git
git init
git add -A
git commit -m "Initial commit" > /dev/null
git remote add origin $GITHUB_URL
git push -q --set-upstream origin master

echo "Configure remote..."
ssh $REMOTE_USER@$REMOTE_HOST -p $REMOTE_PORT "bash ~/deploy/deploy.sh"
