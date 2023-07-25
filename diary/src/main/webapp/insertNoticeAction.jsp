<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>

<%	
	// post 방식 인코딩 방식
	request.setCharacterEncoding("utf8");

	// 유효성 검사(validation)
	if(request.getParameter("noticeTitle") == null 
		||	request.getParameter("noticeContent") == null 
		||	request.getParameter("noticeWriter") == null
		||	request.getParameter("noticePw") == null 
		|| 	request.getParameter("noticeContent").equals("")
		|| 	request.getParameter("noticeWriter").equals("")
		|| 	request.getParameter("noticePw").equals("")
		|| 	request.getParameter("noticeTitle").equals(""))
	{
		
		response.sendRedirect("./insertNoticeForm.jsp");
		return;
	}
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
	// 값들을 DB에 테이블에 입력
	/*
		insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate
		) values(?, ?, ?, ?, ?, ?)
	*/
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 마리아db 접속을 유지해야 함 
	Connection conn = DriverManager.getConnection("jdbc:mariadb://3.38.14.38:3306/diary", "root", "java1234");
	
	String sql = "insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate)  values(?, ?, ?, ?, now(), now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 4개(1~4)
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	
	// 디버깅용 값 반환 ex) 2이면 2행 입력성공, 0이면 입력된 행이없다
	// conn.setAutoCommit (true);	
	// auto commit 디폴트 값 true 자동으로 commit 입력됨
	int row = stmt.executeUpdate();
	// row 값을 이용한 디버깅 입력하기 행입력 실패
	// 테이블까지 데이터를 입력하라
	conn.commit();
	// redirection
	response.sendRedirect("./noticeThree.jsp");
%>