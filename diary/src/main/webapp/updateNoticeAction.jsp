<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>

<%
	//인코딩
	request.setCharacterEncoding("UTF-8");

	// 넘어온 값 확인 - 디버깅
	System.out.println(request.getParameter("noticeNo")
         +" <--updateNoticeAction param noticeNo");
  	System.out.println(request.getParameter("noticeTitle")
      +" <--updateNoticeAction param noticeTitle");
   	System.out.println(request.getParameter("noticeContent")
         +" <--updateNoticeAction param noticeContent");
  	System.out.println(request.getParameter("noticePw")
         +" <--updateNoticeAction param noticePw");

  	String msg = null;
	// updateNoticeAction.jsp
	// 재요청(redirection) : 현재페이지에서 다른곳을 요청하라고 하는 코드
	// 유효성 검사 하면서 공백 null 값 제외시킴
	
	// 주소로 접속했을경우 리턴
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeTwo.jsp");
		return;
	}
	
	if(request.getParameter("noticeTitle")==null 
         || request.getParameter("noticeTitle").equals("")) {
         msg = "noticeTitle is required";
   } else if(request.getParameter("noticeContent")==null 
         || request.getParameter("noticeContent").equals("")) {
         msg = "noticeContent is required";
   } else if(request.getParameter("noticePw")==null 
         || request.getParameter("noticePw").equals("")) {
         msg = "noticePw is required";
   }
   if(request.getParameter("noticeNo") ==null || msg != null) { // 위 ifelse문에 하나라도 해당된다
      	response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
                        +request.getParameter("noticeNo")
                        +"&msg="+msg);
		return; // 코드 종료 안하면 밑에 redirect 충돌에러남
   }

	// 값 넘겨 받아 int 로 변환, 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// String 으로 변환, 변수에 저장
	String noticePw = request.getParameter("noticePw");
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	// 디버깅 입력 
	// 선택한 값 확인
	System.out.println(noticeNo
         +" <--updateNoticeAction noticeNo");
   	System.out.println(noticeTitle
         +" <--updateNoticeAction noticeTitle");
   	System.out.println(noticeContent
         +" <--updateNoticeAction noticeContent");
   	System.out.println(noticePw
         +" <--updateNoticeAction noticePw");

	// DB 드라이버 
	Class.forName("org.mariadb.jdbc.Driver");
	// 드라이버 로딩 디버깅
	System.out.println("updateNoticeAction 드라이버 로딩");
	// 변수에 쿼리 정보 저장
	Connection conn = DriverManager.getConnection("jdbc:mariadb://3.38.14.38:3306/diary", "root", "java1234");
	// 서버연결 디버깅
	System.out.println("updateNoticeAction DB서버 연결 -->" + conn);
	//쿼리 입력
	// 문자열로 sql문을 받아서 sql로 적용
	String sql = "update notice set notice_title=?, notice_content=?, updatedate=now() where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ?에 값 넘겨줌
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setInt(3, noticeNo);
	stmt.setString(4, noticePw);
	// sql 디버깅
	System.out.println("updateNoticeAction sql --> : " + stmt);

	
	// 쿼리 1이면 1행 변화, 0 이면 변화 x
	// row는 적용된 행의 수
	int row = stmt.executeUpdate(); // 쿼리 실행문, 영향받은 행 반환
	// row 디버깅
	System.out.println("updateNoticeAction param row 실행 = 1 미실행 = 0 -->" + row);
	
	
	
	
	System.out.println(noticePw);
	if(row == 0 ) {	// 비밀번호 틀려 0 입력 되면
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+noticeNo+"&msg=incorrect noticePw");
	 	// 비밀번호 틀렸을시 페이지 재요청
		System.out.println("updateNoticeAction pw 틀림");
	} else if ( row > 1) {
		System.out.println("error row값" + row);
	} else {
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo); // 비밀번호 맞을시 리스트로 이동
		System.out.println("updateNoticeAction pw 일치");
	}

	
%>
