from django.db import models

class Curriculum(models.Model):

    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Member(models.Model):

    name = models.CharField(max_length=20)
    age = models.IntegerField()

    def __str__(self):
        return self.name + str(self.age)