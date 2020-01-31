ALLOWED_HOSTS = ['DOMAIN', 'www.DOMAIN']
STATIC_ROOT = '/var/cache/PROJECT_NAME/static/'
STATIC_URL = '/static/'
MEDIA_ROOT = '/var/opt/PROJECT_NAME/media/'
MEDIA_URL = '/media/'
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/var/opt/PROJECT_NAME/PROJECT_NAME.db',
    }
}
