<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>서-버</title>
<style>
*{font-family:"메이플스토리";}
</style>
</head>
<body>
<h1>서버 프로그램이 실행되었습니다.</h1>
<p>ID: ${param.userID}</p>
<p>이름: ${param.userName}</p>
<p>생일: ${param.userBrith}</p>
<p>전화번호: ${param.userPhone}</p>
</body>
</html>