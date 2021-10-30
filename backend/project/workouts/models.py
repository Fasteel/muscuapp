from django.db import models
from django.contrib.auth.models import User
from django.utils.translation import gettext_lazy as _

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
