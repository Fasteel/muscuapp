# Generated by Django 3.2.8 on 2021-10-26 21:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('workouts', '0002_auto_20211026_2153'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='workout',
            name='days',
        ),
        migrations.AddField(
            model_name='workout',
            name='days',
            field=models.ManyToManyField(to='workouts.Day'),
        ),
    ]