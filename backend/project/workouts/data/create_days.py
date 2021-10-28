from workouts.models import Day

def run(apps, schema_editor):
    Day.objects.create(key="MON")
    Day.objects.create(key="TUE")
    Day.objects.create(key="WED")
    Day.objects.create(key="THU")
    Day.objects.create(key="FRI")
    Day.objects.create(key="SAT")
    Day.objects.create(key="SUN")
