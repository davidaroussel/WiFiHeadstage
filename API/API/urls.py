from django.urls import path
from .HeadstageServer import views

urlpatterns = [
    path('research-centers/', views.research_center_api),
    path('research-centers/<int:research_center_id>/', views.research_center_detail_api),

    path('subjects/', views.subject_api),
    path('subjects/<int:subject_id>/', views.research_center_detail_api),

    path('devices/', views.device_api),
    path('devices/<int:device_id>/', views.research_center_detail_api),
]