# Initialization

```
python3 -m venv env
source env/bin/activate
pip install django
pip install djangorestframework
pip install python-dotenv
pip install django-filter
cd project
python3 manage.py migrate
python3 manage.py runserver
```

## Usefull backend tips

### Replay a transaction

Fake back to the migration before the one you want to rerun.

`python3 manage.py migrate --fake workouts 0005_day`

And then re-run

`python3 manage.py migrate workouts 0006_auto_20211026_1929`

### Display model as json

```python
from django.core import serializers
from workouts.models import Day

print(serializers.serialize('json', Day.objects.all()))
```

### Reset db

`python3 manage.py flush`
