<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%	
	// y, m, d가 null이거나 공백이면	
	if(request.getParameter("scheduleNo") == null
	|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}

	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println("updateScheduleForm scheduleNo : " + scheduleNo);
	
	// DB에서 저장된 정보 가져오기
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://3.38.14.38:3306/diary", "root", "java1234");
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_color scheduleColor, schedule_memo scheduleMemo, schedule_pw schedulePw from schedule where schedule_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	System.out.println("updateScheduleForm query : " + stmt);
	
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleColor = rs.getString("scheduleColor");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.schedulePw = rs.getString("schedulePw");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="./resources/bootstrap.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<div class="container-fluid"><!--  메인메뉴 -->
		<a class="navbar-brand" href="./home.jsp">홈으로</a>
		<a class="navbar-brand" href="./noticethree.jsp">공지 리스트</a>
		<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</nav>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<h1>스케줄 수정</h1>
</nav>
	<form action="./updateScheduleAction.jsp" method="post">
		<table>
			<%
				for(Schedule s : scheduleList) {
			%>
				<tr>
					<th>일정 번호</th>
					<td><input class="form-control is-invalid" type="text" value=<%=s.scheduleNo %> readonly name="scheduleNo">
				</tr>
				<tr>
					<th>날짜</th>
					<td><input type="date" value="<%=s.scheduleDate%>" name="scheduleDate"></td>
				</tr>
				<tr>
					<th>시간 설정</th>
					<td><input type="time" value="<%=s.scheduleTime%>" name="scheduleTime"></td>
				</tr>
				<tr>
					<th>구분 색</th> 
					<td><input type="color" value="<%=s.scheduleColor%>" name="scheduleColor"></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea name="scheduleMemo" cols="80" rows="3" ><%=s.scheduleMemo%></textarea></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="schedulePw"></input></td>
				</tr>
			<%
				}
			%>
		</table>
		<button class="btn btn-primary btn-lg" type="submit">스케줄 수정</button>
	</form>
</body>
</html>