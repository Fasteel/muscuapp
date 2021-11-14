from workouts.serializers import ExerciceListSerializer
from workouts.models import Exercice
from workouts.models import Day
from workouts.serializers import DaySerializer
from workouts.models import Workout
from workouts.serializers import WorkoutListSerializer, WorkoutCreateSerializer
from rest_framework import generics
from rest_framework import permissions
from django_filters.rest_framework import DjangoFilterBackend

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
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = WorkoutCreateSerializer

    def get_queryset(self):
        return Workout.objects.filter(user=self.request.user)

class DayList(generics.ListAPIView):
    queryset = Day.objects.all()
    serializer_class = DaySerializer

class ExerciceListCreate(generics.ListCreateAPIView):
    permissions = [permissions.IsAuthenticated]
    queryset = Exercice.objects.all()
    serializer_class = ExerciceListSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['workout']
