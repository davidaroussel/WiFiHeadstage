# Generated by Django 5.0.4 on 2024-05-09 00:10

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
                ('ExperimentsList', models.CharField(blank=True, max_length=500, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='Subjects',
            fields=[
                ('SubjectId', models.AutoField(primary_key=True, serialize=False)),
                ('SubjectName', models.CharField(max_length=500)),
                ('DateOfJoining', models.DateField(auto_now_add=True)),
                ('ExperimentsList', models.CharField(blank=True, max_length=500, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='Experiments',
            fields=[
                ('ExperimentId', models.AutoField(primary_key=True, serialize=False)),
                ('ExperimentName', models.CharField(max_length=500)),
                ('DateOfJoining', models.DateField(auto_now_add=True)),
                ('data_file', models.FileField(blank=True, null=True, upload_to='upload/')),
                ('Device', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='HeadstageServer.devices')),
                ('Subject', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='HeadstageServer.subjects')),
            ],
        ),
        migrations.CreateModel(
            name='ResearchCenters',
            fields=[
                ('ResearchCenterId', models.AutoField(primary_key=True, serialize=False)),
                ('ResearchCenterName', models.CharField(max_length=500)),
                ('DateOfJoining', models.DateField(auto_now_add=True)),
                ('ExperimentsList', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='HeadstageServer.experiments')),
            ],
        ),
    ]
