from django.test import TestCase
from workouts.models import Workout
from django.contrib.auth.models import User

class WorkoutTestCase(TestCase):
    title = "My first workout"

    def setUp(self) -> None:
        user = User.objects.create_user('user', 'user@gmail.com', 'user')
        user.save()
        Workout.objects.create(title=self.title, user=user)

    def test_workout_with_default_state(self):
        state = getattr(Workout.objects.get(title=self.title), 'state')
        self.assertEqual(state, "AC")
