<%@page import="com.skill.support.EmpDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
Class.forName("oracle.jdbc.driver.OracleDriver");
Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "hr", "hr");
String sal = request.getParameter("sal");

String sql="select employee_id, first_name, last_name, salary from employees where salary >=" + sal;
Statement st = conn.createStatement();
ResultSet rs = st.executeQuery(sql);
ArrayList<EmpDTO> emplist = new ArrayList<>();
while(rs.next()){
	EmpDTO emp = new EmpDTO(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getInt(4));
	emplist.add(emp);
}
session.setAttribute("emplist", emplist);
%>



<table border="1">
 <tr>
   <td>직원번호</td><td>직원이름</td><td>성</td><td>급여</td>
 </tr>
 
 <c:forEach items="${emplist}" var="emp">
  <tr>
     <td>${emp.employee_id}</td>
     <td>${emp.first_name}</td>
     <td>${emp.last_name}</td>
     <td>${emp.salary}</td>
  </tr> 
 </c:forEach>
</table>




