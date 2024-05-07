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
    Subject = models.ForeignKey(Subjects, on_delete=models.CASCADE, null=True, blank=True)
    Device = models.ForeignKey(Devices, on_delete=models.CASCADE, null=True, blank=True)
    data_file = models.FileField(upload_to='upload/', null=True, blank=True)
    FilePath = models.CharField(max_length=500)

class ResearchCenters(models.Model):
    ResearchCenterId = models.AutoField(primary_key=True)
    ResearchCenterName = models.CharField(max_length=500)
    DateOfJoining = models.DateField(auto_now_add=True)
    ExperimentsList = models.ForeignKey(Experiments, on_delete=models.CASCADE, null=True, blank=True)
