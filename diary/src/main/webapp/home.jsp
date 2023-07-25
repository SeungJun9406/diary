<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import ="vo.*" %>
<%@ page import ="java.util.*" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home.jsp</title>
	<link rel="stylesheet" href="./resources/bootstrap.css">
</head>

<body>
<div>
		<h1>Project Diary 개요</h1>
		<h3>1. 개발 환경 및 라이브러리</h3>
		<p>JDK17, HTML, CSS, JSP, MariaDB, Eclipse, HeidiSQL</p>
		<h3>2. 담당 기능</h3>
		<p>
			1)게시글 입력, 수정, 삭제<br>
			2)Calendar API 사용 달력 구현
		</p>
</div>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<div class="container-fluid"><!--  메인메뉴 -->
		<a class="navbar-brand" href="./home.jsp">홈으로</a>
		<a class="navbar-brand" href="./noticeThree.jsp">공지 리스트</a>
		<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</nav>
	<!-- 날짜 순 최근 공지5개 -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<h1 class="container-fluid" >홈페이지</h1>
	
</nav>
	<% 
				
		//일반 메서드 new 연산자 사용 static 메서드 . 찍어서 사용
		
		// select notice_no notice_title, createdate from notice 
		// order by creat desc
		// limit 0, 5
		
		// 1) 드라이버 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("드라이버 로딩 성공");
		
		// 2) mariadb에 로그인 후 접속정보 반환받아야 한다.
		Connection conn = null; // 접속 정보 변수 선언
		// 접속 정보 타입 알아야할 정보 (프로토콜, 주소, 포트번호, 자원이름)
		// url, user, password -> String 으로 받는다
		conn = DriverManager.getConnection(
				"jdbc:mariadb://3.38.14.38/diary", "root", "java1234");
		System.out.println("접속 성공" + conn);
		// 날짜순 최근 공지 5개
		//쿼리로 데이터 전송하여 실행
		String sql1 = "select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit 0, 5";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		
		ResultSet rs = stmt1.executeQuery(); // ResultSet 다형성 사용됨
		System.out.println(stmt1 + "<--stmt");
		//rs -> ArrayList
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		while(rs.next()) {
			Notice n = new Notice();
			n.noticeNo = rs.getInt("noticeNo");
			n.noticeTitle = rs.getString("noticeTitle");
			n.createdate = rs.getString("createdate");
			noticeList.add(n);
		}
		
		/*
		select schedule_no, schedule_date, schedule_time, substr(schedule_memo, 1, 10) memo 
		from schedule where schedule_date = curdate() 
		order by schedule_time ASC
		*/
		
		// 오늘 일정 
		String sql2 = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo, 1, 10) scheduleMemo from schedule where schedule_date = curdate() order by schedule_time ASC";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		ResultSet rs2 = stmt2.executeQuery();
		System.out.println(stmt2 + "<--stmt");
		
		ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
		while(rs.next()) {
			Schedule s = new Schedule();
			s.scheduleNo = rs.getInt("scheduleNo");
			s.scheduleDate = rs.getString("scheduleDate");
			s.scheduleTime = rs.getString("scheduleTime");
			s.scheduleMemo = rs.getString("scheduleMemo");
			scheduleList.add(s);
		}
	%>
	<table class="table table-hover">
		<tr class="table-warning">
			<th>공지 제목</th>
			<th>작성 날짜</th>
		</tr>
	
	<%
		for(Notice n : noticeList) {
	%>		
		<tr>
			<td>
				<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
				<%=n.noticeTitle%>
				</a>
			</td>
			<td><%=n.createdate.substring(0, 10)%></td>
		</tr>
	<%
		}
	%>
	</table>
	 <h1 class="container-fluid">오늘일정</h1>
   <table class="table table-hover">
      <tr class="table-warning">
         <th>날짜</th>
         <th>시간</th>
         <th>내용</th>
      </tr>
      <%
      	for(Schedule s : scheduleList) {
      %>
         <tr>
            <td>
               <%=s.scheduleDate%>
            </td>
            <td><%=s.scheduleTime%></td>
            <td>
               <a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>">
                  <%=s.scheduleMemo%>
               </a>
            </td>
         </tr>
      <%      
         }
      %>
   </table>

</body>
</html>