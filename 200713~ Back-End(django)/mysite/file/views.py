from django.shortcuts import render
from django.http import request, HttpResponse
import mysite.settings as settings
import os


def upload(request):
    if request.method == 'GET':
        return render(request, 'file/upload.html', {})
    else:
        upload_files = request.FILES.getlist('my_file')
        try:
            os.mkdir('upload')
        except FileExistsError as e:
            pass
        for upload_file in upload_files:
            file_name = upload_file.name
            with open('upload/' + file_name, 'wb') as file:
                for chunk in upload_file.chunks():
                    file.write(chunk)
        return HttpResponse('파일 업로드 완료')


def download(request):
    filepath = os.path.join(settings.BASE_DIR, 'upload/파일명.txt')
    filename = os.path.basename(filepath)
    with open(filepath, 'rb') as f:
        response = HttpResponse(
            f, content_type='application/octet-stream')
        response['Content-Disposition'] = 'filename="{}"'.format(
            filename)
        return response
