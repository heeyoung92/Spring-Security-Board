<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>BoardUpdate</title>
<%@ include file="../include/include-header.jspf"%>

</head>
<body>
  <div id="wrapper">
        <jsp:include page="../include/navigator.jsp" />
        <div class="container-fluid">
            <h4>
                <strong><i class="fa fa-angle-double-right"></i> Board 수정 </strong>
            </h4>
            <div class="underline"></div>
            <p>
  
	<form id="frm" name="frm" enctype="multipart/form-data">
		<input type="hidden" id="IDX" name="IDX" value="${map.IDX }"></input> 
		<input type="text" id="TITLE" name="TITLE" class="form-control" value="${map.TITLE}"></input>
		<p>
			<textarea rows="15" class="form-control" title="내용" id="CONTENTS" name="CONTENTS">${map.CONTENTS}</textarea>
		<p>

		<c:choose>
			<c:when test="${fn:length(list) > 0}">
				<div id="fileDiv" class="wdp_90" align="center">
					<c:forEach var="row" items="${list }">
						<p>
							<input type="hidden" id="IDX" value="${row.IDX }"></input>
							${row.FILE_NAME }
							<a href="#this" id="delete" name="delete">삭제</a>
						</p>
					</c:forEach>
				</div>
			</c:when>
			<c:otherwise>
        	</c:otherwise>
		</c:choose>
		<div id="fileDiv"></div>

		<a href="#this" class="btn btn-sm btn-default m-2" id="addFile">파일 추가</a> </br>
		
		<div class="wdp_90" align="right">
			<a href="#this" class="btn btn-sm btn-default m-2" id="update">수정</a> 
			<a href="openBoardList.do" class="btn btn-sm btn-default m-2" id="list">취소</a>
		</div>
	</form>
	</div>
	</div>

	<%@ include file="../include/include-body.jspf"%>

	<script type="text/javascript">
		
		$(document).ready(function(){
			$("#update").on("click", function(e) { //작성하기 버튼
				e.preventDefault();
				fn_updateBoard();
			});
			
			$("#addFile").on("click", function(e) { //파일추가 버튼
				e.preventDefault();
				fn_addFile();
			});
			$("a[name='delete']").on("click", function(e) { //파일삭제 버튼
				e.preventDefault();
				fn_deleteOldFile($(this));
			});
		});

		var comSubmit = new ComSubmit("frm");
		var deleteFileCount = 0;
		function fn_updateBoard() {
			var title = $(TITLE).val();
			var contents = $(CONTENTS).val();
			
			//null 및 공백 입력막기
			if( title == '' || title == null ){
			    alert( '제목을 입력해주세요' );
			    return false;
			}
			if( contents == '' || contents == null ){
			    alert( '내용을 입력해주세요' );
			    return false;
			}			

			var blank_pattern = /^\s+|\s+$/g;
			if(title.replace( blank_pattern, '' ) == "" ||contents.replace( blank_pattern, '' ) ==""){
				alert('공백만 입력되었습니다');
			    return false;
			}

			// 정규표현식으로 태그 막기
			title = title.replace(/</gi,"&lt;");
			title = title.replace(/>/gi,"&gt;");
			$(TITLE).val(title);

			contents = contents.replace(/</gi,"&lt;");
			contents = contents.replace(/>/gi,"&gt;");
			$(CONTENTS).val(contents);
			
			comSubmit.setUrl("<c:url value='updateBoard.do' />");
			comSubmit.addParam("deleteFileCount", deleteFileCount);
			
			comSubmit.submit();
		}

		var f_count = 0;
		function fn_addFile() {
			var str = "<p><input type='file' name='file_"+ (f_count++) +" '>"
							+"<a href='#this' name='delete'>삭제</a></p>";

			$("#fileDiv").append(str);

			$("a[name='delete']").on("click", function(e) { //삭제 버튼
				e.preventDefault();
				fn_deleteNewFile($(this));
			});
		}

		function fn_deleteOldFile(obj) {
			obj.parent().remove();
//			alert("IDX: " + obj.parent().find("#IDX").val());
			comSubmit.addParam("FILE_IDX_" + deleteFileCount, obj.parent().find("#IDX").val());
			deleteFileCount++;
		}

		function fn_deleteNewFile(obj) {
			obj.parent().remove();
		}
	</script>


</body>
</html>