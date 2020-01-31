STATICFILES_DIRS = [os.path.join(BASE_DIR, "static")]

try:
	from .local_settings import *
except ImportError:
	pass

