<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%
	// select 쿼리를 mariadb에 전송 후 결과 셋을 받아서 출력하는 페이지
	// select notice_no, notiec_title from notice order by notice_no desc
	
	// 1) mariadb 프로그램 사용가능하도록 장치드라이버를 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환받아야 한다.
	Connection conn = null; // 접속 정보 타입
	conn = DriverManager.getConnection("jdbc:mariadb://3.38.14.38:3306/student", "root", "java1234"); 
	// 프로토콜, 주소, 자원이름
	System.out.println("접속 성공" + conn);
	
	// 3) 쿼리 생성 후 실행
	String sql = "select no, name, age from student";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery(); // ResultSet 다형성 사용됨
	System.out.println("쿼리 실행 성공" + rs);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>student.jsp</title>
</head>
<body>
	<table border = "1">
		<tr>
			<th>no</th>
			<th>name</th>
			<th>age</th>
		</tr>
	
		<%
			while(rs.next()) {
		%>
			<tr>
				<td><%=rs.getInt("no") %></td>
				<td><a href=""><%=rs.getString("name")%></a></td>
				<td><a href=""><%=rs.getInt("age")%></a></td>
			</tr>
		<%
			}
		%>
	</table>
</body>
</html>