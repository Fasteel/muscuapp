from workouts.models import Day
from workouts.serializers import DaySerializer
from workouts.models import Workout
from workouts.serializers import WorkoutListSerializer, WorkoutCreateSerializer
from rest_framework import generics
from rest_framework import permissions

class WorkoutListCreate(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Workout.objects.filter(user=self.request.user)

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return WorkoutCreateSerializer
        return WorkoutListSerializer

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class WorkoutDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Workout.objects.all()
    serializer_class = WorkoutListSerializer

class DayList(generics.ListAPIView):
    queryset = Day.objects.all()
    serializer_class = DaySerializer