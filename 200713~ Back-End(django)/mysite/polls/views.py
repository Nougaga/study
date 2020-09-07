from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from django.utils import timezone
from django.urls import reverse
from .models import *


def index(request):
    q_list = Question.objects.order_by('pub_date')[:5]
    # html = ','.join([q.question_text for q in q_list])
    # return HttpResponse(html)
    return render(request, 'polls/index.html', {'latest_question_list': q_list})


def detail(request, question_id):
    # return HttpResponse("You're looking at question %s." % question_id)
    try:
        question = Question.objects.get(pk=question_id)
    except:
        pass
        # return render(request, 'polls/exception.html', {})
    else:
        return render(request, 'polls/detail.html', {'question': question})


def results(request, question_id):
    response = "You're looking at the results of question %s."
    return HttpResponse(response % question_id)


def vote(request, question_id):
    # 질문 조회
    # POST['choice'] 시 값이 없으면 동작이 죽어버림
    choice_id = request.POST.get('choice')
    question = get_object_or_404(Question, id=question_id)
    try:  # 보기 조회
        choice = question.choice_set.get(id=choice_id)
    except(KeyError, Choice.DoesNotExist):
        pass
        # return render(request, 'polls/exception.html', {})
    else:
        choice.votes += 1
        choice.save()
    # return HttpResponseRedirect('/polls/%s'%question_id)
    return HttpResponseRedirect(reverse('detail', args=(question.id,)))

def reset(request, question_id):
    question = Question.objects.get(pk=question_id)
    c_list = question.choice_set.all()
    for choice in c_list:
        choice.votes = 0
        choice.save()
    return HttpResponseRedirect(reverse('detail', args=(question.id,)))

def index2(request):
    return render(request, 'polls/index2.html',{})

def login(request):
    return render(request, 'polls/login.html')
    
def login_post(request):
    user_id = request.GET.get('user_id')
    user_pw = request.GET.get('user_pw')
    request.session['user_id'] = user_id

    return HttpResponse(str(user_id)+"님, 환영합니다.")

def logout(request):
    # request.session['user_id'] = None
    request.session.clear()
    return HttpResponse("로그아웃 되었습니다.")