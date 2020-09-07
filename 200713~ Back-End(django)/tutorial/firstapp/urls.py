from django.urls import path
from . import views

urlpatterns = [
    path('main/', views.main, name='main'),
    path('show/', views.show, name='show'),
    path('users/', views.users, name='users'),
]