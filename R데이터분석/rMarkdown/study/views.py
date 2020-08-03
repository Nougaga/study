from django.shortcuts import render


def s_200730(request):
    return render(request, '200730-study.html')

def s_200731(request):
    return render(request, '200731-study.html')

def s_200803(request):
    return render(request, '200803-study.html')

def guide(request):
    return render(request,'rmarkdown-reference.pdf', content_type='application/pdf')