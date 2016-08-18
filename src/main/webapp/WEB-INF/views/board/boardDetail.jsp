<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<sec:authorize var="isLogin" access="hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../include/include-header.jspf"%>
</head>
<body>

		<div id="wrapper">
				<jsp:include page="../include/navigator.jsp" />
				<div class="container-fluid">
				  <form id="frm" name="frm" enctype="multipart/form-data">
				
						<h4>
								<strong><i class="fa fa-angle-double-right"></i> Board 상세 </strong>
						</h4>
						<div class="underline"></div>
						<p>
						<!-- user에 따라 유동적 레이아웃-->
					  <sec:authentication property="name" var="userName"/>
						<c:set var="writer">${map.WRITER}</c:set>

            <c:if test="${ writer eq userName }">
              <a href="#this" class="btn btn-sm btn-info pull-right m-r-5" id="update">수정하기</a> &nbsp; 
              <a href="#this" class="btn btn-sm btn-info pull-right m-r-5" id="delete">삭제하기</a>
            </c:if> 

						<a href="openBoardList.do" class="btn btn-sm btn-info pull-right m-r-5">목록보기</a> &nbsp; 
						<a href="#this" class="btn btn-sm btn-info pull-right m-r-5" id="replyBoard">답글쓰기</a> &nbsp;&nbsp;&nbsp; 
						
        		<p>
						<table class="table table-bordered">
								<colgroup>
										<col width="70%" />
										<col width="*" />
								</colgroup>
								<tbody>
										<tr>
												<td><b>${map.TITLE }</b> <input type="hidden" id="IDX" value="${map.IDX }"></td>
												<td>${map.CREA_DATE }</td>
										</tr>
										<tr>
												<td colspan="2"><pre>${map.CONTENTS }</pre></td>
										</tr>
										<tr>
												<td colspan="2"><b>첨부파일</b></td>
										</tr>
										<tr>
												<td colspan="2" align="center">
												  <c:choose>
											   		<c:when test="${fn:length(list) > 0}">
															<c:forEach var="row" items="${list }">
					   										<p>
	   															<input type="hidden" id="IDX" value="${row.IDX }"> 
	   															${row.FILE_NAME }&nbsp;&nbsp; 
	   															<a href="#this" id="download" class="btn btn-sm m-r-3" name="download">다운로드</a>
																</p>
															</c:forEach>
														</c:when>
												
												  	<c:otherwise>
                		        	첨부파일이 없습니다.
            		    	      </c:otherwise>
												  </c:choose>
												 </td>
										 </tr>
								</tbody>
						</table>
						<br><br>
						<div class="post_opt" align="right">
								<select id=changeListCount class="_changeListCount">
										<option value="5">5개씩 보기</option>
										<option value="10">10개씩 보기</option>
										<option value="15">15개씩 보기</option>
								</select>
						</div>
						<b> Comments</b>
						<div class="panel panel-primary">
								<div class="container-fluid">
										<table class="reply_list">
										  	<c:set value='0' var="reply_total" />
												<tbody>
														<c:choose>
																<c:when test="${fn:length(replyList) > 0}">
																		<c:set value="${replyList.get(0).COUNT }" var="reply_total" />
																</c:when>
														</c:choose>
												</tbody>
										</table>
								</div>
						</div>
			</form>
						
						<div id="selector"></div>
						<form class="form-inline" onsubmit="return false;">
								<div class="form-group">
									 <input type="text" id="REPLY_CONT" name="REPLY_CONT" class="form-control" onsubmit="return false;"></input>&nbsp;
										<a href="#this" class="btn btn-sm btn-default m-r-2" id="writeReply">댓글추가</a>
								</div>
						</form>
				</div>
		</div>
		<%@ include file="../include/include-body.jspf"%>
		<script type="text/javascript">
			var reply_total = ${reply_total}; //댓글 총 갯수
			var row = 5;

			var board_idx = $("#IDX").val();
			var parent_idx = "";
			var indent = 0;

			$(function() {
				$(selector).pagination({
					items : reply_total,
					itemsOnPage : row,
					cssStyle : 'light-theme',
					onPageClick : fn_selectReplyList
				});
			});

			$(document).ready(function() {
				fn_selectReplyList($(this));
				/* 			pagingDiv(1, row); */
				$("#replyBoard").on("click", function(e) { //게시글답글 버튼
					e.preventDefault();
					fn_replyBoard();
				});

				$("#update").on("click", function(e) { //수정하기 버튼
					e.preventDefault();
					fn_updateBoard();
				});

				$("#delete").on("click", function(e) { //삭제하기 버튼
					e.preventDefault();
					fn_deleteBoard();
				});

				$("a[id='download']").on("click", function(e) { //다운로드 버튼
					e.preventDefault();
					fn_downlaodFile($(this));
				});

				$("#writeReply").on("click", function(e) { //댓글추가 버튼
					indent = 0
					parent_idx = "";
					e.preventDefault();
					fn_writeReply($(this));
				});

				$("a[id='re_reply']").on("click", function(e) { //댓글-답글 버튼
					e.preventDefault();
					fn_re_reply($(this));

				});

				$('#changeListCount').change(function() {
					row = $('#changeListCount option:selected').val(); // paging row 값 변경
					$(selector).pagination('updateItemsOnPage', row);
					fn_selectReplyList($(this));
				});
			});

			function fn_replyBoard() {
				var idx = "${map.IDX}";
				var url = "<c:url value='openBoardWrite.do?idx=" + idx + "' />";

				var comSubmit = new ComSubmit();
				comSubmit.setUrl(url);
				comSubmit.submit();
			}

			function fn_updateBoard() {
				var idx = "${map.IDX}";
				var password = "";
				var url2 = "<c:url value='openBoardUpdate.do' />";
		    var comSubmit = new ComSubmit("");
        comSubmit.setUrl(url2);
        comSubmit.addParam("IDX", idx);
        comSubmit.submit();
			  
//				password = prompt('정말 수정하시겠습니까?\n비밀번호를 입력해주세요.', '');
//				fn_checkPWD(idx, password, url2);
			}
	    
			/* 게시글 삭제*/
			function fn_deleteBoard() {
				var idx = "${map.IDX}";
				var password = "";
				var url2 = "<c:url value='deleteBoard.do' />";

	      var comSubmit = new ComSubmit("");
	      comSubmit.setUrl(url2);
	      comSubmit.addParam("IDX", idx);
	      comSubmit.submit();
	              
//				password = prompt('정말 삭제하시겠습니까?\n비밀번호를 입력해주세요.', '');
//				fn_checkPWD(idx, password, url2);
			}

			/*인증: 비밀번호 체크 */
			function fn_checkPWD(idx, pwd, url2) {
				var Parms = '?idx=' + idx;
				Parms += '&pwd=' + pwd;

				re = /[~"!@\#.`$%^&*\()\-=+><']/gi;
				if (re.test(pwd)) { //특수문자가 포함되면 삭제하여 값으로 다시셋팅
					alert("특수문자 입력불가");
					return false;
				}

				$.ajax({
					url : "checkPWD.do" + Parms,
					method : "post",
					type : "json",
					contentType : "application/json",
					success : function(data) {
						console.log("data(check): " + data);
						if (data) {
							check = false;
							var comSubmit = new ComSubmit("");
							comSubmit.setUrl(url2);
							comSubmit.addParam("IDX", idx);
							comSubmit.submit();
						} else {
							alert('비밀번호 오류.');
						}
					}
				});
			}

			/* 첨부파일 다운로드 */
			function fn_downlaodFile(obj) {

				var idx = obj.parent().find("#IDX").val();

				var comSubmit = new ComSubmit();
		    $("#commonForm > #IDX").remove();   //파일 연속 다운로드 , 기존 IDX값삭제

				comSubmit.setUrl("<c:url value='downloadFile.do' />");
				comSubmit.addParam("IDX", idx);
				comSubmit.submit();
			}

			/* 댓글 작성 (Ajax->DB) */
			function fn_writeReply(obj) {
				var reply_contents = obj.parent().find("#REPLY_CONT").val();
				// 정규표현식으로 태그 막기
				if (reply_contents == '' || reply_contents == null) {
					alert('댓글을 입력해주세요');
					return false;
				}
				var blank_pattern = /^\s+|\s+$/g;
				if (reply_contents.replace(blank_pattern, '') == "") {
					alert('공백만 입력되었습니다');
					return false;
				}
				reply_contents = reply_contents.replace(/</gi, "&lt;");
				reply_contents = reply_contents.replace(/>/gi, "&gt;");

				var data = {
					BOARD_IDX : board_idx,
					PARENT_IDX : parent_idx,
					INDENT : indent,
					CONTENTS : reply_contents
				};

				$.ajax({
					type : 'POST', // Http Request Method로 POST로 지정
					url : 'writeReply.do', // 서버 요청 주소
					contentType : 'application/json;charset=UTF-8', // 서버 요청시 전송할 데이터가 UTF-8 형식의 JSON 객체임을 명시
					data : JSON.stringify(data), // JavaScript 객체를 JSON 객체로 변환하여 서버 요청시 전송
					success : alertContents
				// 서버로부터 응답 데이터 도착시 로직 처리, 응답 데이터는 JavaScript 객체로 바로 사용 가능
				});
			}

			/* 댓글 DB 작성 성공*/
			function alertContents() {
				//			alert('DB등록!');
				fn_selectReplyList($(this));
				$("#REPLY_CONT").val('');

				$(selector).pagination('updateItems', (++reply_total));
			}

			/* 대댓글 입력창 */

			function fn_re_reply(obj) {
				$("#Add_re_reply").empty();

				parent_idx = obj.parent().find("#IDX").val();
				indent = obj.parent().find("#INDENT").val(); //indent 1 증가
				indent++;

				var str = "<div id='Add_re_reply'> ㄴ <input type='text' id='REPLY_CONT' name='REPLY_CONT' width='90%' ></input>&nbsp;"
						+ "<a href=''#this' class='btn' id='writeReReply'>대댓글추가</a></div>";
				obj.parent().append(str);

				$("#writeReReply").on("click", function(e) { //대댓글 추가 버튼
					e.preventDefault();
					fn_writeReply($(this));
					//			$("Add_re_reply").empty();
				});
			}

			/*댓글 paging*/
			function fn_selectReplyList(obj) {

				var pageNo = $(selector).pagination('getCurrentPage');

				var Parms = '?board_idx=' + board_idx;
				Parms += '&page_index=' + pageNo;
				Parms += '&page_row=' + row;

				$.ajax({
					url : "selectReplyPaging.do" + Parms,
					method : "post",
					type : "json",
					contentType : "application/json",
					success : fn_selectReplyListCallback
				});
			}

			function fn_selectReplyListCallback(data) {
				console.log(data);

				var body = $("table[class='reply_list']>tbody");
				body.empty();

				var str = "";
				$.each(data, function(key, value) {
					  var num = 8 * value.INDENT;
						var indent = "";
						var indent2 = "";

						for (var i = 0; i < num; i++) {
							  indent += '&nbsp;'
								indent2 += '- '
						}

						str += "<tr>"
								+ "<td>"
								+ indent
								+ fn_toDateFormat(value.CREA_DATE)
								+ "</br>"
								+ indent
								+ value.CONTENTS
								+ "&nbsp;"
								+ "<input type='hidden' id='IDX' value=" + value.IDX + ">"
								+ "<input type='hidden' id='INDENT' value=" + value.INDENT + ">"
								+ "<a href='#this' class='btn' id='re_reply'>답글</a>"
								+ "</td>" + "</tr>";
						});
				body.append(str);

				$("a[id='re_reply']").on("click", function(e) {
					e.preventDefault();
					fn_re_reply($(this));
				});
			}

		</script>
</body>
</html>