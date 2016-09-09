<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>BoardList</title>
<%@ include file="../include/include-header.jspf"%>
</head>
<body>
	<div id="wrapper">
		<jsp:include page="../include/navigator.jsp" />
		<div class="container-fluid">
			<h4>
				<strong><i class="fa fa-angle-double-right"></i> Board 리스트 </strong>
			</h4>
			<div class="underline"></div>

			<div class="row p-10">
				<div class="col-lg-12">
					<blockquote class="f-s-16">
					
						<form class="form-inline clearfix">
						<input type="hidden" name="page" value="1" />
						<div class="form-group p-r-10">
							<label class="p-r-30">제 목</label>
							<input id="keyword" type="text" class="form-control input-sm"  placeholder="Board Title" value="">
						</div>
						  <div style="height: 5px;"></div>
            <div class="form-group p-r-20">
                <label class="p-r-30">날 짜</label>
                <input id="startDate" type="text" class="form-control datetime bg-white pointer input-sm" readonly="readonly" required="required" placeholder="시작일" value="${result.param.srchCouponStartDate}">
                <input id="endDate" type="text" class="form-control datetime bg-white pointer input-sm" readonly="readonly" required="required" placeholder="종료일" value="${result.param.srchCouponEndDate}">
            </div>
            <div class="form-group">
              <button type="button" id="search" class="btn btn-sm btn-primary">검색</button>
            </div>
						</form>
					
						<div class="row m-b-10">
							<a href="openBoardWrite.do?idx=" class="btn btn-sm btn-info pull-right m-r-5" id="write">게시글 작성</a>
						</div>
					</blockquote>
				</div>
			</div>

			<c:choose>
				<c:when test="${fn:length(list) > 0}">
					<c:set value="${list.get(0).COUNT }" var="total" />
				</c:when>
				<c:otherwise>
					<c:set value='0' var="total" />
				</c:otherwise>
			</c:choose>
			<div class="panel panel-primary">
				<div class="panel-heading">
					<h6 class="panel-title f-s-14">
						<i class="fa fa-table"></i> 전체보기 
						<span class="pull-right"> 
						  <span class="label label-success ">TOTAL : ${total}</span>
						  <button type="button" class="btn btn-xs btn-info" id="excelDownBtn_list">Excel Download</button>
						</span>
					</h6>
				</div>
				<div class="panel-body">
					<form action="openBoardDetail" method="post">
						<table id="board_list" class="table table-hover table-striped">
							<colgroup>
								<col width="*" />
								<col width="15%" />
								<col width="10%" />
								<col width="20%" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">제목</th>
									<th scope="col">작성자</th>
									<th scope="col">조회수</th>
									<th scope="col">날짜</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${fn:length(list) > 0}">
										<c:forEach items="${list }" var="row">
											<tr>
												<td class="title">
													<a href="openBoardDetail.do" name="title"> 
													<c:forEach var="str" begin="2" end="${row.LEVEL }" step="1"> &nbsp;&nbsp;&nbsp; </c:forEach>
									        ${row.TITLE }
													</a> 
													<input type="hidden" id="IDX" value="${row.IDX }">
												<td>${row.WRITER }</td>
												<td>${row.HIT_CNT }</td>
												<td>${row.CREA_DATE }</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="4">조회된 결과가 없습니다.</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</form>

					<p>
					<div class="dropdown" align="right">
						<select id=changeListCount class="_changeListCount">
							<option value="10">10줄 보기</option>
							<option value="15">15줄 보기</option>
							<option value="20">20줄 보기</option>
						</select>
					</div>
					<div id="selector" align="center"></div>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="../include/include-body.jspf"%>
	<script type="text/javascript">
			var total = ${total}; // 게시글 수
			var row = 10; //paging 행 개수
	    
			$(document).ready(function() {
				initDatePickerInit();
				
				$("a[name='title']").on("click", function(e) { //제목 
					e.preventDefault();
					fn_openBoardDetail($(this));
				});

				$("a[id='page']").on("click", function(e) { //paging
					e.preventDefault();
//					fn_selectBoardList($(this));
				});

				$('#changeListCount').change(function() { // paging row 값 변경
					row = $('#changeListCount option:selected').val();
					$(selector).pagination('updateItemsOnPage', row);
			         $(selector).pagination('updateItems',total);

//					fn_selectBoardList($(this));
				});
	
				$('#excelDownBtn_list').click(function(){
				  var param = "?page_index=" + 1;
				  param += '&page_row=' + ${total};
				  
				  location.href = "/board/downloadExcelFile.do"+param;
	        return;
	      });
				
			  $('#search').click(function(){
		      $(selector).pagination('selectPage', 1);
//				  fn_selectBoardList($(this));
			  });
			  
			});
			
			// color picker - yyyy/mm/dd 형식    
		  var initDatePickerInit = function() {
		      var options = {
            //minDate: moment(),
            maxDate: moment().add(250, 'days'),
            showWeekNumbers : false,
            singleDatePicker : true,
            //timePicker: true,
            //timePickerIncrement: 1,
            //timePicker12Hour: false,
            format: 'YYYY/MM/DD',
            opens: 'center',
            locale: {
                applyLabel: '적용',
                cancelLabel: '초기화',
                fromLabel: 'From',
                toLabel: 'To',
                customRangeLabel: '편집',
                daysOfWeek: ['일', '월', '화', '수', '목', '금','토'],
                monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                firstDay: 1
            }
        }
        $('.datetime').daterangepicker($.extend(options, { timePicker: false, format : 'YYYY/MM/DD' }));
        //$('.date').daterangepicker($.extend(options, { timePicker: false, format : 'YYYY/MM/DD' }));
    }
			$(function() {
				$(selector).pagination({
					items : total,
					itemsOnPage : row,
					cssStyle : 'light-theme',
					onPageClick : fn_selectBoardList
				});
			});
			
			
			function fn_openBoardDetail(obj) {
				var Parms = '?idx=' + obj.parent().find("#IDX").val();

				var comSubmit = new ComSubmit();
				comSubmit.setUrl("<c:url value='/openBoardDetail.do"+Parms+"' />");
				comSubmit.submit();

			}

			function fn_selectBoardList() {

				var pageNo = $(selector).pagination('getCurrentPage');

				if (window.XMLHttpRequest) { // Mozilla, Safari, ...
					httpRequest = new XMLHttpRequest();
				} else if (window.ActiveXObject) { // IE
					try {
						httpRequest = new ActiveXObject("Msxml2.XMLHTTP");
					} catch (e) {
						try {
							httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
						} catch (e) {
						}
					}
				}
				if (!httpRequest) {
					alert('Giving up :( Cannot create an XMLHTTP instance');
					return false;
				}
				var Parms = '?page_index=' + pageNo;
				Parms += '&page_row=' + row;
				// 검색조건이 있을 경우
				if($("#keyword").val()!='')
					  Parms +='&keyword='+ $("#keyword").val();
		    if($("#startDate").val()!='')
		        Parms +='&startDate='+ $("#startDate").val();
        if($("#endDate").val()!='')
            Parms +='&endDate='+ $("#endDate").val();

				$.ajax({
					url : "selectBoardPaging.do" + Parms,
					method : "post",
					type : "json",
					contentType : "application/json",
					success : fn_selectBoardListCallback
				});
			}

			function fn_selectBoardListCallback(data) {

				var body = $("table[id='board_list']>tbody");
				body.empty();

				var str = "";
				$.each(data,function(key, value) {
					  total = value.COUNT;
					  var indent = "";
						for (var i = 1; i < value.LEVEL; i++) {
							indent += '&nbsp;&nbsp;&nbsp;'
						}

						str += "<tr>"
								+ "<td class='title'>"
								+ "<a href='openBoardDetail.do' name='title'>"
								+ indent
								+ value.TITLE
								+ "</a>"
								+ "<input type='hidden' id='IDX' value=" + value.IDX + ">"
								+ "</td>" + "<td>" + value.WRITER
								+ "</td>" + "<td>" + value.HIT_CNT
								+ "</td>" + "<td>"
								+ fn_toDateFormat(value.CREA_DATE)
								+ "</td>" + "</tr>";
					});
				body.append(str);

				//검색 결과에 따른 Total수 변경 for Paging
				if(keyword != null || startDate != null || endDate != null){
  			  $(selector).pagination('updateItems',total);
				}
				
				$("a[name='title']").on("click", function(e) { //제목 
					e.preventDefault();
					fn_openBoardDetail($(this));
				});
			}
		</script>

</body>
</html>