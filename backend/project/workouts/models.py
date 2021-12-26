from django.db import models
from django.contrib.auth.models import User

class Day(models.Model):
    key = models.TextField()

class Workout(models.Model):
    class State(models.TextChoices):
        ACTIVE = 'AC'
        INACTIVE = 'IN'
        ARCHIVED = 'AR'
    title = models.TextField()
    state = models.CharField(max_length=2, choices=State.choices, default=State.ACTIVE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    days = models.ManyToManyField(Day)

class Exercice(models.Model):
    title = models.TextField()
    pause_duration = models.IntegerField()
    set_number = models.IntegerField()
    repetition_number = models.IntegerField()
    weight = models.IntegerField()
    position = models.IntegerField()
    workout = models.ForeignKey(Workout, on_delete=models.CASCADE)

class Session(models.Model):
    start_at = models.DateTimeField(auto_now_add=True, blank=True)
    start_end = models.DateTimeField(null=True)
    workout = models.ForeignKey(Workout, on_delete=models.CASCADE)

class SetCompleted(models.Model):
    repetition_number = models.IntegerField()
    weight = models.IntegerField()
    position = models.IntegerField()
    exercice = models.ForeignKey(Exercice, on_delete=models.CASCADE)
    session = models.ForeignKey(Session, on_delete=models.CASCADE)
