from datetime import datetime
from django.db import models

class ResearchCenter(models.Model):
    ResearchCenterId = models.AutoField(primary_key=True)
    ResearchCenterName = models.CharField(max_length=500)
    DateOfJoining = models.DateField(default=datetime.now)


class Subject(models.Model):
    SubjectId = models.AutoField(primary_key=True)
    SubjectName = models.CharField(max_length=500)
    ResearchCenter = models.ForeignKey(ResearchCenter, on_delete=models.CASCADE)
    DateOfJoining = models.DateField(default=datetime.now)
    devices = models.ManyToManyField('Device', related_name='subject_set', blank=True)


class Device(models.Model):
    DeviceId = models.AutoField(primary_key=True)
    DeviceName = models.CharField(max_length=500)
    ResearchCenter = models.ForeignKey(ResearchCenter, on_delete=models.CASCADE)
    DateOfJoining = models.DateField(default=datetime.now)
    subjects = models.ManyToManyField('Subject', related_name='device_set', blank=True)
