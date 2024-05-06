from django.urls import path
from .HeadstageServer import views

urlpatterns = [
    path('research-centers/', views.research_center_api),
    path('experiments/', views.experiments_api),
    path('devices/', views.devices_api),
    path('subjects/', views.subjects_api)
]
