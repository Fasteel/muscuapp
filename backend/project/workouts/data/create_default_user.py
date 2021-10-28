from django.contrib.auth.models import User

def run(app, schema_editor):
    User.objects.all().delete()
    user = User.objects.create_user('user', 'user@gmail.com', 'user')
    user.save()
