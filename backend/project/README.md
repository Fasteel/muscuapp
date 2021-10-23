# Initialization

```
python3 -m venv env
source env/bin/activate
pip install django
pip install djangorestframework
```

# Create or re-create the default user

```
python3 manage.py shell < ./scripts/create-user.py
```