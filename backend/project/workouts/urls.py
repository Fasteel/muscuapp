from django.urls import path
from . import views

urlpatterns = [
    path('workouts/', views.WorkoutList.as_view()),
    path('workouts/<int:pk>', views.WorkoutDetail.as_view())
]
