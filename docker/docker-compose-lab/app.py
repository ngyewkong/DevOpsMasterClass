import os

app_version = os.environ.get('APP_VERSION', 'UNKNOWN')
environment = os.environ.get('ENVIRONMENT', 'UNKNOWN')

print(f"Running App Version {app_version} in {environment}.")
