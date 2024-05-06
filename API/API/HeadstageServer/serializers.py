from rest_framework import serializers
from .models import ResearchCenter, Subject, Device, Experiment
from datetime import datetime


class DateField(serializers.ReadOnlyField):
    def to_representation(self, value):
        if isinstance(value, datetime):
            return value.date()
        return value


class ResearchCenterSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()

    class Meta:
        model = ResearchCenter
        fields = ['ResearchCenterId', 'ResearchCenterName', 'DateOfJoining']

    def validate_ResearchCenterName(self, value):
        """
        Check that the ResearchCenterName is unique.
        """
        existing_centers = ResearchCenter.objects.filter(ResearchCenterName=value)
        if existing_centers.exists():
            raise serializers.ValidationError("A research center with this name already exists.")
        return value

class ExperimentSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()
    Location = ResearchCenterSerializer(source='research_center', read_only=True)
    ResearchCenter = ResearchCenter()
    print(ResearchCenter)
    class Meta:
        model = Experiment
        fields = ['ResearchCenterName', 'Location', 'ExperimentId', 'ExperimentName', 'DateOfJoining']

    def create(self, validated_data):
        research_center_name = validated_data.pop('ResearchCenterName', None)
        if research_center_name:
            try:
                research_center = ResearchCenter.objects.get(ResearchCenterName=research_center_name)
                validated_data['research_center'] = research_center
            except ResearchCenter.DoesNotExist:
                raise serializers.ValidationError("Research center not found")
        else:
            raise serializers.ValidationError("ResearchCenterName is required")

        return super().create(validated_data)


class SubjectSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()
    Location = ExperimentSerializer(source='Experiment', read_only=True)
    class Meta:
        model = Subject
        fields = ['SubjectId', 'SubjectName', 'Location', 'DateOfJoining']


class DeviceSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()
    Location = ExperimentSerializer(source='Experiment', read_only=True)
    class Meta:
        model = Subject
        fields = ['DeviceId', 'DeviceName', 'Location', 'DateOfJoining']
