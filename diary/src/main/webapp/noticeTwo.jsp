<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
	// 요청 분석(currentPage,....)
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage +"<--currentPage");
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	// 시작 행 번호
	int startRow = (currentPage-1)*rowPerPage;
		
	// DB연결
	//일반 메서드 new 연산자 사용 static 메서드 . 찍어서 사용
		
	// select notice_no notice_title, createdate from notice 
	// order by creat desc
	// limit ?, ?
		
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
		
	// 2) mariadb에 로그인 후 접속정보 반환받아야 한다.
	Connection conn = null; // 접속 정보 변수 선언
	// 접속 정보 타입 알아야할 정보 (프로토콜, 주소, 포트번호, 자원이름)
	// url, user, password -> String 으로 받는다
	conn = DriverManager.getConnection(
			"jdbc:mariadb://3.38.14.38:3306/diary", "root", "java1234");
	System.out.println("접속 성공" + conn);
	
	//쿼리로 데이터 전송하여 실행
	String sql = "select notice_no, notice_title, createdate from notice order by createdate desc limit ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
		
	
		
		
	// 1번째 ? 값은 startRow
	// 2번째 ? 값은 rowPerPage
	stmt.setInt(1,startRow);
	stmt.setInt(2,rowPerPage);
	// 출력할 공지 데이터
	ResultSet rs = stmt.executeQuery(); // ResultSet 다형성 사용됨
	System.out.println(stmt + "<--stmt");
	
	// 마지막 페이지
	// SELECT COUNT(*) FROM notice
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	
	int totalRow = 0;
	if(rs2.next()) {
		rs2.getInt("count(*)");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage +1;
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeTwo.jsp</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>

<body>
	<div><!--  메인메뉴 -->
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeTwo.jsp">공지 리스트</a>
		<a href="./diaryList.jsp">일정 리스트</a>
	</div>
	
	<!-- 날짜 순 최근 공지5개 -->
	<h1>공지 리스트</h1>
	<table class= "table-striped">
		<tr>
			<th>notice_title</th>
			<th>createdate</th>
		</tr>
	
	<%
		while(rs.next()) {
	%>		
		<tr>
			<td>
				<a href="./noticeOne.jsp?noticeNo=<%=rs.getInt("notice_no")%>">
				<%=rs.getString("notice_title")%>
				</a>
			</td>
			<td><%=rs.getString("createdate").substring(0, 10)%></td>
		</tr>
	<%
		}
	%>
	</table>
	
	<%
		if(currentPage >1) {
	%>
			<a href="./noticeTwo.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		} 
		
		
	%>
			<%=currentPage%>
	<%
		if(currentPage < lastPage) {
	%>
			<a href="./noticeTwo.jsp?currentPage=<%=currentPage+1%>">다음</a>
	<%
		}
	%>
	
</body>
</html>