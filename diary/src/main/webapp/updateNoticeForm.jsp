<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%	
	// updateNoticeForm
	// 요청값 인코딩
   	request.setCharacterEncoding("utf-8");

	// 유효성검사: 요청값이 null이나 공백이면 주소로 가라고 요청하고 코드진행을 종료한다
  	 if (request.getParameter("noticeNo") == null
         || request.getParameter("noticeNo").equals("")) {
      response.sendRedirect("./noticeList.jsp");
      return;
   }

	// noticeNo 넘겨 받기
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 디버깅
	System.out.println(noticeNo + " <-- updateNoticeForm param storeNo");
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 드라이버 디버깅
	System.out.println("updateNoticeForm 드라이버 로딩");
	// 변수에 쿼리 정보 저장
	Connection conn = DriverManager.getConnection("jdbc:mariadb://3.38.14.38:3306/diary","root","java1234");
	// 서버연결 디버깅
	System.out.println("updateNoticeForm DB서버 연결 -->" + conn);
	// 첫번째 ? 생성
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, notice_pw noticePw, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 미완성 첫번째 ? 값 완성하기
	stmt.setInt(1, noticeNo);
	// sql 디버깅
	System.out.println("updateNoticeForm sql --> : " + stmt);
	ResultSet rs = stmt.executeQuery(); // ResultSet 다형성 사용됨
	//rs -> ArrayList
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()) {
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticePw = rs.getString("noticePw");
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
<title>updateNoticeForm</title>
	<link rel="stylesheet" href="./resources/bootstrap.css">
</head>
<body><!-- 데이터 숨김 : post 방식 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<div class="container-fluid"><!--  메인메뉴 -->
		<a class="navbar-brand" href="./home.jsp">홈으로</a>
		<a class="navbar-brand" href="./noticeThree.jsp">공지 리스트</a>
		<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</nav>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<h1>공지 수정</h1>
</nav>
		<div>

         <%
            if(request.getParameter("msg") != null) {
         %>
               <%=request.getParameter("msg")%>
         <%
            }
         %>
    	</div>
	<form action ="./updateNoticeAction.jsp" method = "get">
		<table class="table table-hover">
		<%
			for(Notice n : noticeList) {
		%>
			<tr class="table-warning">
				<td>
					번호
				</td>
				<td>
					<input class="form-control is-invalid" type="number" name="noticeNo" value="<%=n.noticeNo%>" readonly="readonly">
				</td>
			</tr>
			<tr class="table-warning">
				<td>
					비밀번호 입력
				</td>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
			<tr class="table-warning">
				<td>
					공지 제목
				</td>
				<td>
					<input type="text" name="noticeTitle" value="<%=n.noticeTitle%>">
				</td>
			</tr>
			<tr class="table-warning">
				<td>
					내용
				</td>
				<td>
					<textarea rows="5" cols="80" name="noticeContent">
						<%=n.noticeContent %>
					</textarea>
				</td>
			</tr>
			<tr class="table-warning">
				<td>
					작성자
				</td>
				<td>
					<%=n.noticeWriter %>
				</td>
			</tr>
			<tr class="table-warning">
				<td>
					작성 시간
				</td>
				<td>
					<%=n.createdate %>
				</td>
			</tr>
			<tr class="table-warning">
				<td>
					수정 시간
				</td>
				<td>
					<%=n.updatedate %>
				</td>
			</tr>
		
		<%
			}
		%>
		</table>
		<div>
			<button type="submit" class="btn btn-primary btn-lg">수정</button>	
		</div>
	</form>
</body>
</html>