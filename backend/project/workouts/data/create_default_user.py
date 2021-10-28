from django.contrib.auth.models import User

def run(app, schema_editor):
    User.objects.all().delete()
    user = User.objects.create_user('user1', 'user1@gmail.com', 'user1')
    user.save()

    user2 = User.objects.create_user('user2', 'user2@gmail.com', 'user2')
    user2.save()
