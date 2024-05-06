from django.db import models

class Subjects(models.Model):
    SubjectId = models.AutoField(primary_key=True)
    SubjectName = models.CharField(max_length=500)
    DateOfJoining = models.DateField(auto_now_add=True)

class Devices(models.Model):
    DeviceId = models.AutoField(primary_key=True)
    DeviceName = models.CharField(max_length=500)
    DateOfJoining = models.DateField(auto_now_add=True)

class Experiments(models.Model):
    ExperimentId = models.AutoField(primary_key=True)
    ExperimentName = models.CharField(max_length=500)
    DateOfJoining = models.DateField(auto_now_add=True)
    Subject = models.ForeignKey(Subjects, on_delete=models.CASCADE)
    Device = models.ForeignKey(Devices, on_delete=models.CASCADE)


class ResearchCenters(models.Model):
    ResearchCenterId = models.AutoField(primary_key=True)
    ResearchCenterName = models.CharField(max_length=500)
    DateOfJoining = models.DateField(auto_now_add=True)
