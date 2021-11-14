# Generated by Django 3.2.8 on 2021-11-11 19:11

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('workouts', '0003_auto_20211026_2158'),
    ]

    operations = [
        migrations.CreateModel(
            name='Exercice',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.TextField()),
                ('pause_duration', models.IntegerField()),
                ('set_number', models.IntegerField()),
                ('repetition_number', models.IntegerField()),
                ('weight', models.IntegerField()),
                ('exercice_goal', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='workouts.exercice')),
                ('workout', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='workouts.workout')),
            ],
        ),
    ]
