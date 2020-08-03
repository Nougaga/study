from django.contrib import admin
from django.urls import path
from . import views

urlpatterns = [
    # 파일명 앞자리 6자 같은 걸로 대체해서 쓰자 더럽다
    path('200730/', views.s_200730, name='s_200730'),
    path('200731/', views.s_200731, name='s_200731'),
    path('200803/', views.s_200803, name='s_200803'),   

    path('guide',views.guide, name='guide'),    # UnicodeDecodeError
]
