# Generated by Django 5.0.4 on 2024-05-06 20:36

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Devices',
            fields=[
                ('DeviceId', models.AutoField(primary_key=True, serialize=False)),
                ('DeviceName', models.CharField(max_length=500)),
                ('DateOfJoining', models.DateField(auto_now_add=True)),
            ],
        ),
        migrations.CreateModel(
            name='Subjects',
            fields=[
                ('SubjectId', models.AutoField(primary_key=True, serialize=False)),
                ('SubjectName', models.CharField(max_length=500)),
                ('DateOfJoining', models.DateField(auto_now_add=True)),
            ],
        ),
        migrations.CreateModel(
            name='Experiments',
            fields=[
                ('ExperimentId', models.AutoField(primary_key=True, serialize=False)),
                ('ExperimentName', models.CharField(max_length=500)),
                ('DateOfJoining', models.DateField(auto_now_add=True)),
                ('Device', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='HeadstageServer.devices')),
                ('Subject', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='HeadstageServer.subjects')),
            ],
        ),
        migrations.CreateModel(
            name='ResearchCenters',
            fields=[
                ('ResearchCenterId', models.AutoField(primary_key=True, serialize=False)),
                ('ResearchCenterName', models.CharField(max_length=500)),
                ('DateOfJoining', models.DateField(auto_now_add=True)),
                ('Experiment', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='HeadstageServer.experiments')),
            ],
        ),
    ]