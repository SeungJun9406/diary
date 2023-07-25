<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//유효성 검사
	if(request.getParameter("scheduleNo") == null
	|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}

	// 넘어온 값 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println("deleteScheduleForm scheduleNo : " + scheduleNo);
		
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
	<form action="./deleteScheduleAction.jsp" method="post">
<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<h1>스케줄 삭제</h1>
</nav>
		<table>
			<tr>
				<th>일정 번호</th>
				<td><input type="text" name="scheduleNo" value=<%=scheduleNo %> readonly></td>
			</tr>
			<tr>
				<th>일정 비밀번호</th>
				<td><input type="password" name="schedulePw"></td>
			</tr>
		</table>
		<button class="btn btn-primary btn-lg" type="submit">삭제하기</button>
	</form>
</body>
</html>