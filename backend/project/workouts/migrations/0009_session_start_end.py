# Generated by Django 3.2.8 on 2021-11-13 21:38

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('workouts', '0008_session'),
    ]

    operations = [
        migrations.AddField(
            model_name='session',
            name='start_end',
            field=models.DateTimeField(null=True),
        ),
    ]
