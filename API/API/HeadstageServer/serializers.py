from rest_framework import serializers
from .models import ResearchCenters, Experiments, Subjects, Devices


class DateField(serializers.ReadOnlyField):
    def to_representation(self, value):
        if value:
            return value.strftime('%Y-%m-%d')
        return None


class SubjectSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()

    class Meta:
        model = Subjects
        fields = ['SubjectId', 'SubjectName', 'DateOfJoining']


class DeviceSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()

    class Meta:
        model = Devices
        fields = ['DeviceId', 'DeviceName', 'DateOfJoining']


# serializers.py
class ExperimentSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()
    SubjectList = SubjectSerializer(required=False)
    DeviceList = DeviceSerializer(required=False)

    class Meta:
        model = Experiments
        fields = ['ExperimentId', 'ExperimentName', 'DateOfJoining', 'SubjectList', 'DeviceList', 'FilePath']

    def create(self, validated_data):
        subject_data = validated_data.pop('Subject', None)
        device_data = validated_data.pop('Device', None)

        experiment = Experiments.objects.create(**validated_data)

        if subject_data:
            subject = Subjects.objects.get_or_create(SubjectName=subject_data['SubjectName'])[0]
            experiment.Subject = subject

        if device_data:
            device = Devices.objects.get_or_create(DeviceName=device_data['DeviceName'])[0]
            experiment.Device = device

        experiment.save()
        return experiment


class ResearchCenterSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()
    ExperimentList = ExperimentSerializer(required=False)

    class Meta:
        model = ResearchCenters
        fields = ['ResearchCenterId', 'ResearchCenterName', 'DateOfJoining', 'ExperimentList']

    def create(self, validated_data):
        print(validated_data)
        subject_data = validated_data.pop('Experiment', None)
        device_data = validated_data.pop('Device', None)

        experiment = Experiments.objects.create(**validated_data)

        if subject_data:
            subject = Subjects.objects.get_or_create(SubjectName=subject_data['SubjectName'])[0]
            experiment.Subject = subject

        if device_data:
            device = Devices.objects.get_or_create(DeviceName=device_data['DeviceName'])[0]
            experiment.Device = device

        experiment.save()
        return experiment
