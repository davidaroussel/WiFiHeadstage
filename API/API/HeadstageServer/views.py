from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from .models import ResearchCenter, Subject, Device, Experiment
from .serializers import ResearchCenterSerializer, SubjectSerializer, DeviceSerializer, ExperimentSerializer


@api_view(['GET', 'PUT', 'POST', 'DELETE'])
def research_center_api(request):
    if request.method == 'GET':
        # Check if ResearchCenterName is provided in the query parameters
        research_center_name = request.data.get('ResearchCenterName')
        if research_center_name:
            # Retrieve the specific ResearchCenter by name
            try:
                research_center = ResearchCenter.objects.get(ResearchCenterName=research_center_name)
                serializer = ResearchCenterSerializer(research_center)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except ResearchCenter.DoesNotExist:
                return Response({"error": "Research center not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            # If no ResearchCenterName provided, return all ResearchCenters
            research_centers = ResearchCenter.objects.all()
            serializer = ResearchCenterSerializer(research_centers, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'POST':
        serializer = ResearchCenterSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'PUT':
        # Extract the ResearchCenterId and updated name from request.data
        research_center_id = request.data.get('ResearchCenterId')
        updated_name = request.data.get('ResearchCenterName')

        if research_center_id and updated_name:
            # Attempt to update the name of the research center with the given ID
            try:
                research_center = ResearchCenter.objects.get(ResearchCenterId=research_center_id)
                research_center.ResearchCenterName = updated_name
                research_center.save()
                serializer = ResearchCenterSerializer(research_center)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except ResearchCenter.DoesNotExist:
                return Response({"error": "Research center not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "Both ResearchCenterId and ResearchCenterName are required for updating"},
                            status=status.HTTP_400_BAD_REQUEST)


    elif request.method == 'DELETE':
        # Extract the ResearchCenterId from request.data
        research_center_id = request.data.get('ResearchCenterId')

        if research_center_id:
            # Attempt to delete the research center with the given ID
            try:
                research_center = ResearchCenter.objects.get(ResearchCenterId=research_center_id)
                research_center.delete()
                return Response({"message": "Research center deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
            except ResearchCenter.DoesNotExist:
                return Response({"error": "Research center not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "ResearchCenterId is required for deletion"}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def research_center_detail_api(request, research_center_id):
    print("LABS DETAILS !!!")
    try:
        research_center = ResearchCenter.objects.get(ResearchCenterId=research_center_id)
    except ResearchCenter.DoesNotExist:
        return Response({"error": "Research center not found"}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = ResearchCenterSerializer(research_center)
        return Response(serializer.data, status=status.HTTP_200_OK)

    if request.method == 'PUT':
        serializer = ResearchCenterSerializer(research_center, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        research_center.delete()
        return Response({"message": "Research center deleted successfully"}, status=status.HTTP_204_NO_CONTENT)



@api_view(['GET', 'PUT', 'POST', 'DELETE'])
def experiment_api(request):
    if request.method == 'GET':
        experiments = Experiment.objects.all()
        serializer = ExperimentSerializer(experiments, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'POST':
        serializer = ExperimentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'PUT':
        experiment_id = request.data.get('ExperimentId')
        if experiment_id:
            try:
                experiment = Experiment.objects.get(ExperimentId=experiment_id)
                serializer = ExperimentSerializer(experiment, data=request.data, partial=True)
                if serializer.is_valid():
                    serializer.save()
                    return Response(serializer.data, status=status.HTTP_200_OK)
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
            except Experiment.DoesNotExist:
                return Response({"error": "Experiment not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "ExperimentId is required for updating"}, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        experiment_id = request.data.get('ExperimentId')
        if experiment_id:
            try:
                experiment = Experiment.objects.get(ExperimentId=experiment_id)
                experiment.delete()
                return Response({"message": "Experiment deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
            except Experiment.DoesNotExist:
                return Response({"error": "Experiment not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "ExperimentId is required for deletion"}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def experiment_detail_api(request, experiment_id):
    try:
        experiment = Experiment.objects.get(ExperimentId=experiment_id)
    except Experiment.DoesNotExist:
        return Response({"error": "Experiment not found"}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = ExperimentSerializer(experiment)
        return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'PUT':
        serializer = ExperimentSerializer(experiment, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        experiment.delete()
        return Response({"message": "Experiment deleted successfully"}, status=status.HTTP_204_NO_CONTENT)




@api_view(['GET', 'PUT', 'POST', 'DELETE'])
def subject_api(request):
    if request.method == 'GET':
        # Check if SubjectId is provided in the request data
        subject_id = request.data.get('SubjectId')
        if subject_id:
            # Retrieve the specific Subject by ID
            try:
                subject = Subject.objects.get(SubjectId=subject_id)
                serializer = SubjectSerializer(subject)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Subject.DoesNotExist:
                return Response({"error": "Subject not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            # If no SubjectId provided, return all Subjects
            subjects = Subject.objects.all()
            serializer = SubjectSerializer(subjects, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

    if request.method == 'POST':
        subject_name = request.data.get('SubjectName')
        research_center_name = request.data.get('ResearchCenterName')
        research_center = ResearchCenter.objects.get(name=research_center_name)
        print(research_center)

        print("HERE", research_center_name)
        if not subject_name:
            return Response({"error": "SubjectName is required"}, status=status.HTTP_400_BAD_REQUEST)
        if not research_center_name:
            return Response({"error": "ResearchCenterName is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            research_center = ResearchCenter.objects.get(ResearchCenterName=research_center_name)
        except ResearchCenter.DoesNotExist:
            return Response({"error": "Research center not found"}, status=status.HTTP_404_NOT_FOUND)

        subject_data = {'SubjectName': subject_name, 'ResearchCenter_id': research_center.id}
        serializer = SubjectSerializer(data=subject_data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    if request.method == 'PUT':
        subject_id = request.data.get('SubjectId')
        if subject_id:
            try:
                subject = Subject.objects.get(SubjectId=subject_id)
                serializer = SubjectSerializer(subject, data=request.data)
                if serializer.is_valid():
                    serializer.save()
                    return Response(serializer.data, status=status.HTTP_200_OK)
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

            except Subject.DoesNotExist:
                return Response({"error": "Subject not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "SubjectId is required for updating"}, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        # Extract the SubjectId from request.data
        subject_id = request.data.get('SubjectId')
        if subject_id:
            # Attempt to delete the subject with the given ID
            try:
                subject = Subject.objects.get(SubjectId=subject_id)
                subject.delete()
                return Response({"message": "Subject deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
            except Subject.DoesNotExist:
                return Response({"error": "Subject not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "SubjectId is required for deletion"}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def subject_detail_api(request, subject_id):
    print("---- SUBJECT DETAIL ----")
    try:
        subject = Subject.objects.get(SubjectId=subject_id)
    except Subject.DoesNotExist:
        return Response({"error": "Subject not found"}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = SubjectSerializer(subject)
        return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'PUT':
        serializer = SubjectSerializer(subject, data=request.data)
        print(serializer, request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        subject.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(['GET', 'PUT', 'POST', 'DELETE'])
def device_api(request):
    if request.method == 'GET':
        # Check if DeviceId is provided in the request data
        device_id = request.data.get('DeviceId')
        if device_id:
            # Retrieve the specific Device by ID
            try:
                device = Device.objects.get(DeviceId=device_id)
                serializer = DeviceSerializer(device)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Device.DoesNotExist:
                return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            # If no DeviceId provided, return all Devices
            devices = Device.objects.all()
            serializer = DeviceSerializer(devices, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'POST':
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
                device = Device.objects.get(DeviceId=device_id)
                device.DeviceName = updated_name
                device.save()
                serializer = DeviceSerializer(device)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Device.DoesNotExist:
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
                device = Device.objects.get(DeviceId=device_id)
                device.delete()
                return Response({"message": "Device deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
            except Device.DoesNotExist:
                return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({"error": "DeviceId is required for deletion"}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def device_detail_api(request, device_id):
    try:
        device = Device.objects.get(DeviceId=device_id)
    except Device.DoesNotExist:
        return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = DeviceSerializer(device)
        return Response(serializer.data, status=status.HTTP_200_OK)

    elif request.method == 'PUT':
        serializer = DeviceSerializer(device, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        device.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)