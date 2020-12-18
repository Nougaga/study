from django.contrib import admin
from polls.models import Question, Choice


class ChoiceInline(admin.TabularInline):
    model = Choice
    extra = 2


class QuestionAdmin(admin.ModelAdmin):
    fieldsets = [
        (None, {'fields': ['question_text'], }),
        ('Date Information', {'fields': ['pub_date'], 'classes':['collapse']}),
    ]
    inlines = [ChoiceInline]    # Choice 모델을 같이 볼 수 있음
    list_display = ('question_text', 'pub_date')    # 리스트에 보여줄 속성들
    list_filter = ['pub_date']  # pub_date로 필터 기능
    search_fields = ['question_text']   # question_text 검색 기능


admin.site.register(Question, QuestionAdmin)
admin.site.register(Choice)
