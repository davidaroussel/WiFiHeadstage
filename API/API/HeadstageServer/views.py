from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from .models import ResearchCenters, Experiments, Devices, Subjects
from .serializers import ResearchCenterSerializer, ExperimentSerializer, DeviceSerializer, SubjectSerializer

from django.views.decorators.csrf import csrf_exempt
from django.conf import settings

import os
import zipfile
from datetime import datetime

@csrf_exempt
@api_view(['POST'])
def upload_experiment(request):
    if request.method == 'POST':
        # Retrieve data from the request
        experiment_name = request.data.get('ExperimentName')
        subject_name = request.data.get('Subject')
        device_name = request.data.get('Device')
        zip_file = request.FILES.get('zip_file')

        # Ensure that all required data is provided
        if not all([experiment_name, subject_name, device_name, zip_file]):
            return Response({'error': 'Missing required data'}, status=400)

        if not Experiments.objects.filter(ExperimentName=experiment_name).exists():
            return Response({'error': 'Experiment name doesnt exist'}, status=400)

        if not Subjects.objects.filter(SubjectName=subject_name).exists():
            return Response({'error': 'Subject name doesnt exist'}, status=400)

        if not Devices.objects.filter(DeviceName=device_name).exists():
            return Response({'error': 'Device name doesnt exist'}, status=400)


        base_directory = os.path.join(settings.MEDIA_ROOT, experiment_name, subject_name, device_name)
        timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        timestamp_directory = os.path.join(base_directory, timestamp)
        os.makedirs(timestamp_directory, exist_ok=True)

        with open(os.path.join(timestamp_directory, zip_file.name), 'wb+') as destination:
            for chunk in zip_file.chunks():
                destination.write(chunk)

        with zipfile.ZipFile(os.path.join(timestamp_directory, zip_file.name), 'r') as zip_ref:
            zip_ref.extractall(timestamp_directory)

        os.remove(os.path.join(timestamp_directory, zip_file.name))

        return Response({'message': 'Zip file uploaded, extracted, and deleted successfully'}, status=200)
    else:
        return Response({'error': 'Invalid request method'}, status=405)



@api_view(['GET', 'PUT', 'POST', 'DELETE'])
def subjects_api(request):
    if request.method == 'GET':
        # Check if SubjectName is provided in the query parameters
        subject_name = request.data.get('SubjectName')
        if subject_name:
            # Retrieve the specific Subject by name
            try:
                subject = Subjects.objects.get(SubjectName=subject_name)
                serializer = SubjectSerializer(subject)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Subjects.DoesNotExist:
                return Response({"error": "Subject not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            # If no SubjectName provided, return all Subjects
            subjects = Subjects.objects.all()
            serializer = SubjectSerializer(subjects, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'POST':
        subject_name = request.data.get("SubjectName")
        if Subjects.objects.filter(SubjectName=subject_name).exists():
            return Response({"error": "Subject already exists"}, status=status.HTTP_400_BAD_REQUEST)
        serializer = SubjectSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'PUT':
        # Extract the SubjectId and updated name from request.data
        subject_id = request.data.get('SubjectId')
        updated_name = request.data.get('SubjectName')

        if subject_id and updated_name:
            # Attempt to update the name of the subject with the given ID
            try:
                subject = Subjects.objects.get(SubjectId=subject_id)
                subject.SubjectName = updated_name
                subject.save()
                serializer = SubjectSerializer(subject)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Subjects.DoesNotExist:
                return Response({"error": "Subject not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "Both SubjectId and SubjectName are required for updating"},
                            status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        # Extract the SubjectId from request.data
        subject_id = request.data.get('SubjectId')

        if subject_id:
            # Attempt to delete the subject with the given ID
            try:
                subject = Subjects.objects.get(SubjectId=subject_id)
                subject.delete()
                return Response({"message": "Subject deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
            except Subjects.DoesNotExist:
                return Response({"error": "Subject not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "SubjectId is required for deletion"}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'POST', 'DELETE'])
def devices_api(request):
    if request.method == 'GET':
        # Check if DeviceName is provided in the query parameters
        device_name = request.data.get('DeviceName')
        if device_name:
            # Retrieve the specific Device by name
            try:
                device = Devices.objects.get(DeviceName=device_name)
                serializer = DeviceSerializer(device)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Devices.DoesNotExist:
                return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            # If no DeviceName provided, return all Devices
            devices = Devices.objects.all()
            serializer = DeviceSerializer(devices, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'POST':
        device_name = request.data.get("DeviceName")
        if Devices.objects.filter(DeviceName=device_name).exists():
            return Response({"error": "Device already exists"}, status=status.HTTP_400_BAD_REQUEST)
        serializer = DeviceSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'PUT':
        # Extract the DeviceId and updated name from request.data
        device_id = request.data.get('DeviceId')
        updated_name = request.data.get('DeviceName')

        if device_id and updated_name:
            # Attempt to update the name of the device with the given ID
            try:
                device = Devices.objects.get(DeviceId=device_id)
                device.DeviceName = updated_name
                device.save()
                serializer = DeviceSerializer(device)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Devices.DoesNotExist:
                return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "Both DeviceId and DeviceName are required for updating"},
                            status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        # Extract the DeviceId from request.data
        device_id = request.data.get('DeviceId')

        if device_id:
            # Attempt to delete the device with the given ID
            try:
                device = Devices.objects.get(DeviceId=device_id)
                device.delete()
                return Response({"message": "Device deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
            except Devices.DoesNotExist:
                return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "DeviceId is required for deletion"}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'POST', 'DELETE'])
def experiments_api(request):
    if request.method == 'GET':
        experiment_name = request.data.get('ExperimentName')
        if experiment_name is not None:
            try:
                experiment = Experiments.objects.get(ExperimentName=experiment_name)
                serializer = ExperimentSerializer(experiment)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Experiments.DoesNotExist:
                return Response({"error": "Experiment not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            experiments = Experiments.objects.all()
            serializer = ExperimentSerializer(experiments, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'POST':
        experiment_name = request.data.get('ExperimentName')
        if Experiments.objects.filter(ExperimentName=experiment_name).exists():
            return Response("Already Exists", status=status.HTTP_400_BAD_REQUEST)

        serializer = ExperimentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'PUT':
        experiment_name = request.data.get('ExperimentName')
        device_name = request.data.get('DeviceName')
        subject_name = request.data.get('SubjectName')
        if experiment_name:
            try:
                # Retrieve the experiment object from the database
                experiment = Experiments.objects.get(ExperimentName=experiment_name)

                if device_name:
                    if Devices.objects.filter(DeviceName=device_name).exists():
                        device = Devices.objects.get(DeviceName=device_name)
                        if experiment.Device is None:
                            experiment.Device = device

                            temp_history = device.ExperimentsList
                            if temp_history is None:
                                device.ExperimentsList = [experiment.ExperimentName]
                            else:
                                data_listed = eval(device.ExperimentsList)
                                data_listed.append(experiment.ExperimentName)
                                device.ExperimentsList = data_listed
                            device.save()
                        else:
                            print("TODO: Logic for Device Already Exist")
                    else:
                        return Response({"error": "Device Not found"}, status=status.HTTP_404_NOT_FOUND)

                if subject_name:
                    if Subjects.objects.filter(SubjectName=subject_name).exists():
                        subject = Subjects.objects.create(SubjectName=subject_name)
                        if experiment.Subject is None:
                            experiment.Subject = subject

                            temp_history = subject.ExperimentsList
                            if temp_history is None:
                                subject.ExperimentsList = [experiment.ExperimentName]
                            else:
                                data_listed = eval(subject.ExperimentsList)
                                data_listed.append(experiment.ExperimentName)
                                subject.ExperimentsList = data_listed
                            subject.save()


                        else:
                            print("TODO: Logic for Subject Already Exist")
                    else:
                        return Response({"error": "Subject Not found"}, status=status.HTTP_404_NOT_FOUND)

                experiment.save()
                serializer = ExperimentSerializer(experiment)
                return Response(serializer.data, status=status.HTTP_200_OK)

            except Experiments.DoesNotExist:
                return Response({"error": "Experiment Not found"}, status=status.HTTP_404_NOT_FOUND)

        else:
            return Response({"error": "ExperimentName is required for updating"}, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        experiment_id = request.data.get('ExperimentId')
        if experiment_id:
            try:
                experiment = Experiments.objects.get(ExperimentId=experiment_id)
                experiment.delete()
                return Response({"message": "Experiment deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
            except Experiments.DoesNotExist:
                return Response({"error": "Experiment not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "ExperimentId is required for deletion"}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'POST', 'DELETE'])
def research_center_api(request):
    if request.method == 'GET':
        # Check if ResearchCenterName is provided in the query parameters
        research_center_name = request.data.get('ResearchCenterName')
        if research_center_name:
            # Retrieve the specific ResearchCenter by name
            try:
                research_center = ResearchCenters.objects.get(ResearchCenterName=research_center_name)
                serializer = ResearchCenterSerializer(research_center)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except ResearchCenters.DoesNotExist:
                return Response({"error": "Research center not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            # If no ResearchCenterName provided, return all ResearchCenters
            research_centers = ResearchCenters.objects.all()
            serializer = ResearchCenterSerializer(research_centers, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'POST':
        researchCenter_name = request.data.get('ResearchCenterName')
        if ResearchCenters.objects.filter(ResearchCenterName=researchCenter_name).exists():
            return Response("Already Exists", status=status.HTTP_400_BAD_REQUEST)

        serializer = ResearchCenterSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'PUT':
        research_center_name = request.data.get('ResearchCenterName')
        experiments_name = request.data.get('ExperimentName')
        if research_center_name and experiments_name:
            try:
                # Retrieve the ResearchCenter object
                research_center = ResearchCenters.objects.get(ResearchCenterName=research_center_name)
                try:
                    experiment = Experiments.objects.get(ExperimentName=experiments_name)
                    research_center.Experiments.add(experiment)
                    research_center.save()
                    serializer = ResearchCenterSerializer(research_center)
                    return Response(serializer.data, status=status.HTTP_200_OK)

                except Experiments.DoesNotExist:
                    return Response({"error": "Experiment not found"}, status=status.HTTP_404_NOT_FOUND)

            except ResearchCenters.DoesNotExist:
                return Response({"error": "Research center not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "Both ResearchCenterName and ExperimentsName are required for updating"},
                            status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        # Extract the ResearchCenterId from request.data
        research_center_id = request.data.get('ResearchCenterId')

        if research_center_id:
            # Attempt to delete the research center with the given ID
            try:
                research_center = ResearchCenters.objects.get(ResearchCenterId=research_center_id)
                research_center.delete()
                return Response({"message": "Research center deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
            except ResearchCenters.DoesNotExist:
                return Response({"error": "Research center not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "ResearchCenterId is required for deletion"}, status=status.HTTP_400_BAD_REQUEST)

