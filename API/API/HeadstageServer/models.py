from datetime import datetime
from django.db import models


class ResearchCenter(models.Model):
    ResearchCenterId = models.AutoField(primary_key=True)
    ResearchCenterName = models.CharField(max_length=500)
    DateOfJoining = models.DateField(default=datetime.now)


class Experiment(models.Model):
    ExperimentId = models.AutoField(primary_key=True)
    ExperimentName = models.CharField(max_length=500)
    ResearchCenterName = models.ForeignKey(ResearchCenter, on_delete=models.CASCADE)


class Subject(models.Model):
    SubjectId = models.AutoField(primary_key=True)
    SubjectName = models.CharField(max_length=500)
    DateOfJoining = models.DateField(default=datetime.now)
    ResearchCenter = models.ForeignKey(ResearchCenter, on_delete=models.CASCADE)


class Device(models.Model):
    DeviceId = models.AutoField(primary_key=True)
    DeviceName = models.CharField(max_length=500)
    DateOfJoining = models.DateField(default=datetime.now)
    ResearchCenter = models.ForeignKey(ResearchCenter, on_delete=models.CASCADE)
