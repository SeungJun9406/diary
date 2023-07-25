<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");	
	
	//validation(요청 파라미터값 유효성 검사)
	if(request.getParameter("scheduleDate") == null 			// 파라미터가 null일 경우
		|| request.getParameter("scheduleTime") == null 
		|| request.getParameter("scheduleColor") == null 
		|| request.getParameter("scheduleMemo") == null  
		|| request.getParameter("scheduleDate").equals("")  	// 파라미터가 공백일 경우
		|| request.getParameter("scheduleTime").equals("") 
		|| request.getParameter("scheduleColor").equals("") 
		|| request.getParameter("scheduleMemo").equals("")) 
	{ 
		
		response.sendRedirect("./scheduleListByDate.jsp");	// 입력 폼으로 가라고 명령
		return;
	}
	// 넘어온 값 변수에 저장
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	
	// 디버깅
	System.out.println(scheduleDate + " <-- insertScheduleAction param scheduleDate");
	System.out.println(scheduleTime + " <-- insertScheduleAction param scheduleTime");
	System.out.println(scheduleColor + " <-- insertScheduleAction param scheduleColor");
	System.out.println(scheduleMemo + " <-- insertScheduleAction param scheduleMemo");
	
	// 드라이버
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://3.38.14.38:3306/diary","root","java1234");
	String sql = "insert into schedule(schedule_date, schedule_time, schedule_memo, schedule_color, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	System.out.println(stmt + " <-- insertScheduleAction stmt");
	
	// 데이터 수정 확인
	int row = stmt.executeUpdate();
	if(row==1) {
		System.out.println("insertScheduleAction 정상 입력");
	} else {
		System.out.println("insertScheduleAction 비정상 입력 row : "+ row);
	}
	// 문자열 자르기
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1 ;
	String d = scheduleDate.substring(8);
	
	// 디버깅
	System.out.println(y + " <-- insertScheduleAction y");
	System.out.println(m + " <-- insertScheduleAction m");
	System.out.println(d + " <-- insertScheduleAction d");
	
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
%>