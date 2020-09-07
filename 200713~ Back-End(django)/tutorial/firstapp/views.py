from django.shortcuts import render
from django.http import HttpResponse
from .models import *

# Create your views here.
def index1(request):
    return HttpResponse("<h1>Hello?</h1>")

def index2(request):
    return HttpResponse("<h1>Hi!</h1>")

def main(request):
    return HttpResponse("<h1>Main</h1>")

def show(request):
    # SELECT *
    curri = Curriculum.objects.all()
    # html = ''
    # for c in curri:
    #     html += c.name + '<br>'
    # return HttpResponse(html)
    return render(request, 'firstapp/show.html',{'list':curri})

def users(request):
    member = Member.objects.all()
    return render(request, 'firstapp/users.html',{'list':member})    