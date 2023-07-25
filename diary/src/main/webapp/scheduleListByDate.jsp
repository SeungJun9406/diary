<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>

<%

	// 유효성 검사
	if(request.getParameter("y") == null 			// 파라미터가 null일 경우
		|| request.getParameter("m") == null 
		|| request.getParameter("d") == null  
		|| request.getParameter("y").equals("")  	// 파라미터가 공백일 경우
		|| request.getParameter("m").equals("") 
		|| request.getParameter("d").equals("")) 
	{ 
		
		response.sendRedirect("./scheduleList.jsp");	// 입력 폼으로 가라고 명령
		return;
	}
	// y, m, d 값이 null or "" -> redirection scheduleList.jsp
	// 값 넘겨 받기
	int y = Integer.parseInt(request.getParameter("y"));
	// 출력단에서 +1 해주기 db와 java api 다름으로인한
	int m = Integer.parseInt(request.getParameter("m")) + 1;
	int d = Integer.parseInt(request.getParameter("d"));
	
	// 받아온 값 디버깅
	System.out.println(y + " <-- scheduleListByDate param y");
	System.out.println(m + " <-- scheduleListByDate param m");
	System.out.println(d + " <-- scheduleListByDate param d");
	
	// 10이하 숫자에 문자 "0" 붙혀주기
	// int 형 변수 m 을 문자열(string)으로 바꿔주는 기법
	String strM = m+"";
	if(m<10) {
		strM = "0"+strM;
	}
	String strD = d+"";
	if(d<10) {
		strD = "0"+strD;
	}
	
	// 일별 스케줄 리스트
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://3.38.14.38:3306/diary","root","java1234");
	// sql 문 수정 필요
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_color scheduleColor, schedule_memo scheduleMemo, createdate, updatedate from schedule where schedule_date = ? order by schedule_time asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, y+"-"+strM+"-"+strD);
	System.out.println(stmt + " <-- scheduleListByDate stmt");
	ResultSet rs = stmt.executeQuery();
	
	//rs -> ArrayList
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleColor = rs.getString("scheduleColor");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleListByDate</title>
	<link rel="stylesheet" href="./resources/bootstrap.css">
	<style>
		th, tr  {
			border : 1px solid #000000
		}
	</style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<div class="container-fluid"><!--  메인메뉴 -->
		<a class="navbar-brand" href="./home.jsp">홈으로</a>
		<a class="navbar-brand" href="./noticethree.jsp">공지 리스트</a>
		<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</nav>
	<h1>입력 화면</h1>
	<form action="./insertScheduleAction.jsp" method="post">
		<table >
			<tr>
				<th>날짜</th>
				<td><input type="date" name="scheduleDate" 
							value="<%=y%>-<%=strM%>-<%=strD%>" 
							readonly="readonly"></td>
			</tr>
			<tr>
				<th>시간</th>
				<td><input type="time" name="scheduleTime"></td>
			</tr>
			<tr>
				<th>구분 색</th>
				<td>
					<input type="color" name="scheduleColor" value="#00000">
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea></td>
			</tr>
		</table>
		<button class="btn btn-primary btn-lg" type="submit">스케줄 입력</button>
	</form>
	
	<h1 ><%=y%>년 <%=m%>월 <%=d%>일 스케줄 목록</h1>
	<table class="table-active container-fluid">
		<tr>
			<th>시간</th>
			<th>내용</th>
			<th>작성 시간</th>
			<th>수정 시간</th>
			<th>수정하기</th>
			<th>삭제하기</th>
		</tr>
		<%
			for(Schedule s : scheduleList) {
		%>
				<tr>
					<td><%=s.scheduleTime%></td>
					<td><%=s.scheduleMemo%></td>
					<td><%=s.createdate%></td>
					<td><%=s.updatedate%></td>
					<td><a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">수정</a></td>
					<td><a href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">삭제</a></td>
				</tr>
		<%		
			}
		%>
	</table>
</body>
</html>