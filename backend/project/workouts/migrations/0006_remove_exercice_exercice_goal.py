# Generated by Django 3.2.8 on 2021-11-13 21:30

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('workouts', '0005_alter_exercice_exercice_goal'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='exercice',
            name='exercice_goal',
        ),
    ]