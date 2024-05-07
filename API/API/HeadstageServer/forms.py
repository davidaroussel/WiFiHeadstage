# forms.py
from django import forms
from .models import Experiments

class ExperimentForm(forms.ModelForm):
    class Meta:
        model = Experiments
        fields = ['data_file', 'FilePath', 'ExperimentName', 'Subject', 'Device']
