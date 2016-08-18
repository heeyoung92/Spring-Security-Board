<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../include/include-header.jspf"%>
</head>
<body>
  <div id="wrapper">
        <jsp:include page="../include/navigator.jsp" />
        <div class="container-fluid">
            <h4>
                <strong><i class="fa fa-angle-double-right"></i> Board 등록</strong>
            </h4>
            <div class="underline"></div>
            <p>
  
	
	<form id="frm" name="frm" enctype="multipart/form-data">

		<input type="text"  class="form-control" placeholder="포스트 제목을 입력해주세요" id="TITLE" name="TITLE" ></input>
		<p>
			<textarea class="form-control" rows="15" title="내용" id="CONTENTS" name="CONTENTS"></textarea>
		<p>

		<div id="fileDiv" class="wdp_90" align="center">
<!-- 			<p>
				<input type="file" id="file" name="file_0">
				<a href="#this"  id="delete" name="delete">삭제</a>
			</p> -->
		</div>
		
		<a href="#this" class="btn btn-sm btn-default m-2" id="addFile">파일 추가</a> <br>

		<div class="wdp_90" align="right" background-color="#c0c0c0">
			<input type="hidden" id="ID" name="ID" value='<sec:authentication property="name" /> '> 
			<!-- Password: <input type="password" placeholder="비밀번호[필수]" id="PWD" name="PWD"></input> &nbsp;  -->
			<a href="#this" class="btn btn-sm btn-default m-2" id="write">확인</a>
			<a href="openBoardList.do" class="btn btn-sm btn-default m-2" id="list">작성취소</a>
		</div>
	</form>
	</div>
	</div>

	<%@ include file="../include/include-body.jspf"%>
	<script type="text/javascript">
	
		$(document).ready(function() {
			$("#write").on("click", function(e) { //확인 버튼
				e.preventDefault();
				fn_insertBoard();
			});

			$("#addFile").on("click", function(e) { //파일 추가 버튼
				e.preventDefault();
				fn_addFile();
			});
			
			// 답글일 경우
			var idx =  getQuerystring('idx');
			if(idx != '') {
				$.ajax({
					url : "selectOrigin.do?idx=" + idx,
					method : "post",
					type : "json",
					contentType : "application/json",
					success : function(data) {
				          	console.log(data); 
							$(TITLE).val("[re: ]");
				          	$(CONTENTS).val("\n\n------원본글------\n"+"제목: "+data.TITLE+"\n내용: "+data.CONTENTS);
				        }
				});
			}
		});
		
/* 		$("#ID").bind("keyup",function(){
			 re = /[~!@`.\#$%^:&*\()\-=+><"']/gi; 
			 var temp=$("#ID").val();
			 if(re.test(temp)){ //특수문자가 포함되면 삭제하여 값으로 다시셋팅
				 $("#ID").val(temp.replace(re,"")); 
			 	alert("[~!@\#$%:\"^&*\()\-=+_><']... 특수문자 입력불가");
			 }
		});
		
		$("#PWD").bind("keyup",function(){
			 re = /[~"!@\#.`$%^&*\()\-=+><']/gi; 
			 var temp=$("#PWD").val();
			 if(re.test(temp)){ //특수문자가 포함되면 삭제하여 값으로 다시셋팅
				 $("#PWD").val(temp.replace(re,"")); 
			 	alert("특수문자 입력불가");
			 } 
		});
 */		
		function fn_insertBoard() {
			
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
	/* 		if( $("#ID").val() == '' || $("#ID").val()== null ){
			    alert( 'ID를 입력해주세요' );
			    return false;
			}
			if( $("#PWD").val() == '' || $("#PWD").val()== null ){
			    alert( 'password를 입력해주세요' );
			    return false;
			}
			 */
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
			
			// 답글일 경우
			var idx =  getQuerystring('idx');
			/* 		
			if(idx != '') {
				title = "[re: ]"+title;
				$(TITLE).val(title);
			} */
			
			var url = "<c:url value='boardWrite.do?idx="+idx+" ' />";

			var comSubmit = new ComSubmit("frm");
			comSubmit.setUrl(url);
			comSubmit.submit();
			
	}
	function getQuerystring(paramName){

			var _tempUrl = window.location.search.substring(1); //url에서 처음부터 '?'까지 삭제
			var _tempArray = _tempUrl.split('&'); // '&'을 기준으로 분리하기
			
			for(var i = 0; _tempArray.length; i++) {
				var _keyValuePair = _tempArray[i].split('='); // '=' 을 기준으로 분리하기
				
				if(_keyValuePair[0] == paramName){ // _keyValuePair[0] : 파라미터 명
					// _keyValuePair[1] : 파라미터 값
					return _keyValuePair[1];
				}
			} 
		}

		var f_count = 0;
		function fn_addFile() {
			var str = "<p><input type='file' name='file_" + (f_count++)
					+ "'  onchange='CheckUploadFileSize(this); CheckuploadFileExt(this);'  accept='.gif, .jpg, .png'>"
					+ "<a href='#this' name='delete'>삭제</a></p>";
			$("#fileDiv").append(str);
			$("a[name='delete']").on("click", function(e) { //삭제 버튼
				e.preventDefault();
				fn_deleteFile($(this));
			});
	
		}
		function fn_deleteFile(obj) {
			obj.parent().remove();
		}
		
		function CheckUploadFileSize(objFile)
		{
		 var nMaxSize = 4 * 1024 * 1024; // 4 MB
		 var nFileSize = objFile.files[0].size;
		 
		 if (nFileSize > nMaxSize){
			 alert("4MB보다 큰 파일은 첨부할 수 없습니다.\n현재 파일 크기: " + nFileSize + " byte");
       objFile.outerHTML = objFile.outerHTML;
		 }
// 		 else alert("4MB보다 작은 파일은 첨부할 수 없습니다.\n현재 파일 크기: " + nFileSize + " byte");
		}

		function CheckuploadFileExt(objFile)
		{
		 var strFilePath = objFile.value;
		 
		 // 정규식
		 var RegExtFilter = /\.(gif|jpg|jpeg|png)$/i;  // 업로드 가능 확장자.
		 if (strFilePath.match(RegExtFilter) == null){ 
			 alert("첨부파일은 gif, jpg, png로 된 이미지만 가능합니다.");
		   objFile.outerHTML = objFile.outerHTML;
		 }
		}
	
	</script>

</body>
</html>