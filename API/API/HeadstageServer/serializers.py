from rest_framework import serializers
from .models import ResearchCenter, Subject, Device
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


class SubjectSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()
    Location = ResearchCenterSerializer(source='ResearchCenter', read_only=True)
    ResearchCenterName = serializers.CharField(write_only=True)  # Add this line
    print(ResearchCenterName)
    class Meta:
        model = Subject
        fields = ['SubjectId', 'SubjectName', 'Location', 'DateOfJoining', 'ResearchCenterName']

    def create(self, validated_data):
        research_center_name = validated_data.pop('ResearchCenterName', None)
        if not research_center_name:
            raise serializers.ValidationError("ResearchCenterName is missing")

        try:
            # Get the ResearchCenter instance based on the provided name
            research_center = ResearchCenter.objects.get(ResearchCenterName=research_center_name)
        except ResearchCenter.DoesNotExist:
            raise serializers.ValidationError(
                "Research center with name '{}' does not exist".format(research_center_name))

        # Create the Subject associated with the found ResearchCenter
        subject = Subject.objects.create(ResearchCenter=research_center, **validated_data)
        return subject


class DeviceSerializer(serializers.ModelSerializer):
    DateOfJoining = DateField()
    class Meta:
        model = Device
        fields = '__all__'
