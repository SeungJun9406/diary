<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%	
	// 요청값 유효성 검사
	if(request.getParameter("noticeNo") ==null
		|| request.getParameter("noticeNo").equals("")) {
		response.sendRedirect("./noticeThree.jsp");
		return; // 위의 페이지로 이동
	}

	// 변수 생성 시 현재 페이지에서 어떤값이 저장되었는지 디버깅
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 디버깅
	System.out.println(noticeNo + " <-- deleteNoticeForm param noticeNo");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteNoticeForm</title>
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
	<h1>공지 삭제</h1>
</nav>
	
	<form action="./deleteNoticeAction.jsp" method= "post">
		<table><!-- noticeNo, noticePw 값 입력 -->
			<tr>
				<td>번호</td><!-- hidden 상자 숨기기, readonly 적용 -->
				<td><input class="form-control is valid" type="text" name="noticeNo" value="<%=noticeNo %>" readonly="readonly"></td>
			</tr>
			<tr>
				<td>비밀번호 입력</td><!-- password 입력 받기 -->
				<td><input  type="password" name="noticePw"></td>
			</tr>
			<tr>
				<td colspan="2">
					<button class="btn btn-primary btn-lg" type="submit">삭제</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>