<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm</title>
	<link rel="stylesheet" href="./resources/bootstrap.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<div class="container-fluid"><!--  메인메뉴 -->
		<a class="navbar-brand" href="./home.jsp">홈으로</a>
		<a class="navbar-brand" href="./noticeThree.jsp">공지 리스트</a>
		<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</nav>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<h1 class="container-fluid">공지 입력</h1>
</nav>
	<form action="./insertNoticeAction.jsp" method="post">
		<table>
			<tr>
				<td>공지 제목</td>
				<td>
					<input type="text" name="noticeTitle">
				</td>
			</tr>
			<tr>
            	<td>내용</td>
	            <td>
	               <textarea rows="5" cols="80" name="noticeContent"></textarea>
	            </td>
	       </tr>
	       <tr>
	            <td>작성자</td>
	            <td>
	               <input type="text" name="noticeWriter">
	            </td>
	       </tr>
	       <tr>
	            <td>비밀번호</td>
	            <td>
	               <input type="password" name="noticePw">
	            </td>
	       </tr>
	       <tr>
	            <td colspan="2">
	               <button type="submit" class="btn btn-primary btn-lg">입력</button>
	            </td>
	       </tr>
      </table>
	</form>
</body>
</html>