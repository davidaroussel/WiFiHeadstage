from django.urls import path
from .views import ResearchCenter, Subject, Device


urlpatterns = [
    path('research-centers/', ResearchCenter, name='research_centers'),
    path('subjects/', Subject, name='subjects'),
    path('devices/', Device, name='devices'),
]
