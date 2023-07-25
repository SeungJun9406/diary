<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	int targetYear = 0;
	int targetMonth = 0;
	
	// 년 or 월이 요청값에 넘어오지 않으면 오늘 날짜의 년월 값으로
	if(request.getParameter("targetYear") == null 
			||(request.getParameter("targetMonth") == null)) {
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR); 
		targetMonth = c.get(Calendar.MONTH); // 출력 단에서 +1 하기 (데이터 단에서 건들지 않기)
	} else { 
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	
	// Calendar 디버깅
	System.out.println(targetYear + "<-- scheduleList param targetYear");
	System.out.println(targetMonth + "<-- scheduleList param targetMonth");
	
	// 오늘 날짜
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	
	// 지난 달 출력하기 위한 변수들
	Calendar lastMonth = Calendar.getInstance();
	lastMonth.set(Calendar.MONTH, targetMonth-1);
	int lastDateNum = lastMonth.getActualMaximum(Calendar.DATE);
	// 지난달 디버깅
	System.out.println(lastMonth + "<-- scheduleList param lastMonth");
	System.out.println(lastDateNum + "<-- scheduleList param lastDateNum");
	
	// targetMonth 1일의 요일은?
	Calendar firstDay = Calendar.getInstance(); // 2023 04 24
	firstDay.set(Calendar.YEAR, targetYear); // 2023
	firstDay.set(Calendar.MONTH, targetMonth); // 04
	firstDay.set(Calendar.DATE, 1); // 2023 04 01
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); // 2023 04 01 몇번째 요일인지 일 = 1 토 = 7
	
	// YEAR, MONTH 값 리셋팅 (내부 API 알고리즘)
	// 년23월12 입력 Calendar API 년24 월1 변경
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	
	// 1일 앞의 공백 칸의 수 
	int startBlank = firstYoil - 1;
	
	// targetMonth 마지막 날
	int lastDate  = firstDay.getActualMaximum(Calendar.DATE);
	System.out.println(lastDate + "<-- scheduleList param lastDate");
	
	// 전체 td의 값은 7로 나누어 떨어져야 한다
	// lastDate 뒤 공백칸의 수 
	int endBlank = 0;
	if((startBlank + lastDate) % 7 != 0) {
		endBlank = 7 - (startBlank + lastDate) % 7;
	}
	System.out.println(endBlank + "<-- scheduleList param endBlank");
	
	// 전체 td의 개수
	int totalTd = startBlank + lastDate + endBlank;
	System.out.println(totalTd + "<-- scheduleList param totalTd");
	
	// 전체 TD의 수
	int totalTD = startBlank + lastDate + endBlank;
	System.out.println(totalTD + " <-- totalTD");
	
	// DB data 가져오는 알고리즘
	/*
		select schedule_no scheduleNo, day(schedule_date) scheduleDate,
		substr(schedule_memo, 1, 5) scheduleMemo
		from schedule
		where year(schedule_date) = ? and month(schedule_date) = ?
		oreder by month(schedule_date) asc;
	*/
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://3.38.14.38:3306/diary","root","java1234");
	// sql 문 수정 필요
	String sql = "select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by month(schedule_date) asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth+1);
	System.out.println(stmt + " <-- scheduleList stmt");
	ResultSet rs = stmt.executeQuery();
	// rs. -> ArrayList
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 전체 날짜가 아닌 날(day)의 값
		s.scheduleMemo = rs.getString("scheduleMemo"); // 전체메모가 아닌 5글자만
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="./resources/bootstrap.css">
	<style>
		td, tr {
			width : 150px;
			height : 70px;
		}
	</style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<div class="container-fluid"><!--  메인메뉴 -->
		<a class="navbar-brand" href="./home.jsp">홈으로</a>
		<a class="navbar-brand" href="./noticethree.jsp">공지 리스트</a>
		<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</nav>
	
	<!-- 출력단에서 targetMonth 값 +1 -->
	<h1><%=targetYear%>년 <%=targetMonth+1%>월</h1>
<div>
	<ul class="pagination pagination-lg">
			<a class="container-fluid page-link" href = "./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
			<a class="container-fluid page-link" href = "./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
	</ul>
</div>
	<table class = "table-bordered">
		<thead class="text-bg-success">
			<tr>
				<th class = "text-danger">일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>		
			</tr>
		</thead>
		<tr>
         <% int nextDate =1;
            for(int i=0; i<totalTd; i+=1) {
               int num = i-startBlank+1;
               
               if(i != 0 && i%7==0) {
         %>
                  </tr><tr>
         <%         
               }
               
               
               if(num>0 && num<=lastDate) {
					
					
       	%>			
       	
    	<%			// 오늘 날짜이면 표시
    				String tdStyle = "";	
    				if(today.get(Calendar.YEAR) == targetYear 
						&& today.get(Calendar.MONTH) == targetMonth
						&& today.get(Calendar.DATE) == num) {
						tdStyle = "background-color:orange;";
					}
    				if(i%7 == 0){
    	%>			
							<td style="<%=tdStyle%>" >
								<div><!-- 일요일 숫자 -->
									<a class="text-danger" href="./scheduleListByDate.jsp?y=<%=targetYear %>&m=<%=targetMonth %>&d=<%=num %>" ><%=num %></a>
								</div>
								<div><!-- 일정  -->
									<%
										for(Schedule s: scheduleList) {
											if(num == Integer.parseInt(s.scheduleDate)) {
										
									%>
											<div style="colr : <%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
									<%
											}
										}
									%>
								</div>
							</td>		
		<%		
					} 
    				else {
		%>
						<td style="<%=tdStyle%>" >
							<div><!-- 날짜 숫자 -->
								<a class="text-dark" href="./scheduleListByDate.jsp?y=<%=targetYear %>&m=<%=targetMonth %>&d=<%=num %>"><%=num %></a>
							</div>
							<div><!--  일정 (5글자만) -->
								<%
									for(Schedule s : scheduleList) {
										if(num == Integer.parseInt(s.scheduleDate)) {
								%>
										<div style="color : <%=s.scheduleColor%>"><%=s.scheduleMemo %></div>	
								<%	
										}
									}
								%>
							</div>
						</td>
		<%	
					}
				} else if(num >= lastDate) {			
		%>			<td class = "text-secondary "><%= nextDate %></td>
		<%			nextDate++;
				} else if (num < startBlank) {
				
		%>
					<td class = "text-secondary "><%= lastDateNum - startBlank+1%></td>
		<%			lastDateNum++;
				} else{
		%>
					<td>&nbsp;</td>
		<%	
				}
			}
		%>
	</tr>
</table>
</body>
</html>