<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>

<%
	// 재요청(redirection)
	if(request.getParameter("noticeNo") == null
	|| request.getParameter("noticeNo").equals("")) {
		response.sendRedirect("./noticeThree.jsp");
		return; //1) 코드 진행 종료 2) 반환값을 남길 때
	}	
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://3.38.14.38:3306/diary","root","java1234");

	// 첫번째 ? 생성
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 미완성 첫번째 ? 값 완성하기
	stmt.setInt(1, noticeNo);
	System.out.println(stmt + "<--stmt");
	ResultSet rs = stmt.executeQuery(); // ResultSet 다형성 사용됨
	//rs -> ArrayList
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()) {
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeContent = rs.getString("noticeContent");
		n.noticeWriter = rs.getString("noticeWriter");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
		noticeList.add(n);
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
		<a class="navbar-brand" href="./noticeThree.jsp">공지 리스트</a>
		<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</nav>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<h1>공지 상세</h1>
</nav>
	<%
		for(Notice n : noticeList) {
	%>
			<table class="table table-hover">
				<tr class="table-warning">
					<td>번호</td>
					<td><%=n.noticeNo%></td>
				</tr>
				<tr class="table-warning">
					<td>공지 제목</td>
					<td><%=n.noticeTitle%></td>
				</tr>
				<tr class="table-warning">
					<td>내용</td>
					<td><%=n.noticeContent%></td>
				</tr>
				<tr class="table-warning">
					<td>작성자</td>
					<td><%=n.noticeWriter%></td>
				</tr>
				<tr class="table-warning">
					<td>작성 시간</td>
					<td><%=n.createdate%></td>
				</tr>
				<tr class="table-warning">
					<td>수정 시간</td>
					<td><%=n.updatedate%></td>
				</tr>
			</table>
	<%		
		}
	%>
	<div>
		<a href = "./updateNoticeForm.jsp?noticeNo=<%=noticeNo%>">수정</a>
		<a href = "./deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>">삭제</a>
	</div>
</body>
</html>