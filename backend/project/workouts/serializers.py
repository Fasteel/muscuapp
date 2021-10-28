from rest_framework import serializers
from rest_framework.fields import ReadOnlyField
from workouts.models import Workout, Day

class DaySerializer(serializers.ModelSerializer):
    class Meta():
        model = Day
        fields = ['id', 'key']

class WorkoutListSerializer(serializers.ModelSerializer):
    days = DaySerializer(many=True)

    class Meta:
        model = Workout
        fields = ['id', 'title', 'state', 'user', 'days']

class WorkoutCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Workout
        fields = ['id', 'title', 'state', 'user', 'days']

    def create(self, validated_data):
        days = validated_data.pop('days')
        instance = Workout.objects.create(**validated_data)
        for day in days:
            instance.days.add(day)

        return instance