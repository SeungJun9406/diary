<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>

<%
	// deleteNoticeAction
	// 재요청(redirection)
	if(request.getParameter("noticeNo") == null
		|| request.getParameter("noticePw") == null
		|| request.getParameter("noticeNo").equals("")
		|| request.getParameter("noticePw").equals("")) {
		response.sendRedirect("./deleteNoticeForm.jsp");
		return; //1) 코드 진행 종료 2) 반환값을 남길 때
	}	
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	
	// 디버깅
	System.out.println(noticeNo + "<-- deleteNoticeAction param noticeNo");
	System.out.println(noticePw + "<-- deleteNoticeAction param noticePw");
	// DB 드라이버  로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 변수에 쿼리 정보 저장
	Connection conn = DriverManager.getConnection("jdbc:mariadb://3.38.14.38/diary", "root", "java1234");
	//쿼리 입력
	// delete from notice where notice_no=? and notice_pw=?
	// 문자열로 sql문을 받아서 sql로 적용
	String sql = "delete from notice where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	System.out.println(stmt + "<-- deleteNoticeAction sql");

	
	// 쿼리 1이면 1행 변화, 0 이면 변화 x
	int row = stmt.executeUpdate(); // 쿼리 실행문, 영향받은 행 반환
	// row 디버깅
	System.out.println(row + "<-- deleteNoticeAction param row");
	if(row == 0 ) {	// 비밀번호 틀려 0 입력 되면
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+noticeNo); // 비밀번호 틀렸을시
	} else {
		response.sendRedirect("./noticeThree.jsp"); // 비밀번호 맞을시 리스트로 이동
	}
	
%>
