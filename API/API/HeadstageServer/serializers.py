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


class ExperimentSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()
    Subject = SubjectSerializer()
    Device = DeviceSerializer()

    class Meta:
        model = Experiments
        fields = ['ExperimentId', 'ExperimentName', 'DateOfJoining', 'Subject', 'Device']

    def create(self, validated_data):
        subject_data = validated_data.pop('Subject')
        device_data = validated_data.pop('Device')

        subject = Subjects.objects.get(SubjectName=subject_data['SubjectName'])
        device = Devices.objects.get(DeviceName=device_data['DeviceName'])

        experiment = Experiments.objects.create(Subject=subject, Device=device, **validated_data)
        return experiment


class ResearchCenterSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()

    class Meta:
        model = ResearchCenters
        fields = ['ResearchCenterId', 'ResearchCenterName', 'DateOfJoining', 'Experiments']

    def create(self, validated_data):
        subject_data = validated_data.pop('Subject')
        device_data = validated_data.pop('Device')

        subject = Subjects.objects.get(SubjectName=subject_data['SubjectName'])
        device = Devices.objects.get(DeviceName=device_data['DeviceName'])

        experiment = Experiments.objects.create(Subject=subject, Device=device, **validated_data)
        return experiment