from django.urls import path
from .views import ResearchCenters, Experiments, Devices, Subjects, upload_experiment


urlpatterns = [
    path('research-centers/', ResearchCenters, name='research_centers'),
    path('experiments/', Experiments, name='experiments'),
    path('devices/', Devices, name='devices'),
    path('subjects/', Subjects, name='subjects'),
    path('upload/', upload_experiment, name='upload_experiment'),

]
