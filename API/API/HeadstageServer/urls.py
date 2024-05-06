from django.urls import path
from .views import ResearchCenter, Subject, Device, Experiment


urlpatterns = [
    path('research-centers/', ResearchCenter, name='research_centers'),
    path('experiments/', Experiment, name='experiments'),
    path('subjects/', Subject, name='subjects'),
    path('devices/', Device, name='devices'),
]
