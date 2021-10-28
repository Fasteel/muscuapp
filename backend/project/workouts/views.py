from django.http.response import JsonResponse
from workouts.models import Day
from workouts.serializers import DaySerializer
from workouts.models import Workout
from workouts.serializers import WorkoutListSerializer, WorkoutCreateSerializer
from rest_framework import generics

class WorkoutListCreate(generics.ListCreateAPIView):
    queryset = Workout.objects.all()

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return WorkoutCreateSerializer
        return WorkoutListSerializer

class WorkoutDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Workout.objects.all()
    serializer_class = WorkoutListSerializer

class DayList(generics.ListAPIView):
    queryset = Day.objects.all()
    serializer_class = DaySerializer