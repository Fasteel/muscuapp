from django.urls import path
from . import views

urlpatterns = [
    path('days/', views.DayList.as_view()),
    path('workouts/', views.WorkoutListCreate.as_view()),
    path('workouts/<int:pk>', views.WorkoutDetail.as_view()),
    path('exercices/', views.ExerciceListCreate.as_view())
]
