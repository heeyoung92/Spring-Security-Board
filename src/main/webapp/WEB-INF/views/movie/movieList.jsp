<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>MovieList</title>
<%@ include file="../include/include-header.jspf"%>
</head>
<body>
	<div id="wrapper">
		<jsp:include page="../include/navigator.jsp" />
		<div class="container-fluid">
			<h4>
				<strong><i class="fa fa-angle-double-right"></i> Movie 리스트 </strong>
			</h4> 
			<!-- <div id="stars"></div> -->
			<div class="underline"></div>
			<p>
			<div class="row m-b-10">
				<button type="button" data-toggle="modal" data-target="#modal_movieinfo" class="btn btn-sm btn-info pull-right m-r-5" 
				    data-whatever-json='{ "event" : "create" }'>영화 등록</button>
			</div>

			<div class="row">
				<div class="col-sm-12">
					<h3>Movies from 2013</h3>
				</div>
			</div>

			<div class="row">
				<c:choose>
					<c:when test="${fn:length(list) > 0}">
						<c:forEach items="${list }" var="row">
							<div class="col-sm-3">
								<div class="jb-cell" align="center">
									<c:set var="img" value="${row.image_url }" />
									<c:if test="${ img ne null}">
										<a href="${row.image_url }" data-lightbox="data-lightbox" data-title="Action Movies"> 
										  <img src="${row.image_url }" width="90%" />
										</a>
									</c:if>
									<c:if test="${ img eq null}">
										<img src="<c:url value='/img/image-not-found.jpg'/>" width="90%" />
									</c:if>
									<h5><a href='#' data-toggle="modal" data-target="#modal_detail" 
                                                                data-whatever-json='{ "event" : "detail", 
                                                                                      "title" : "${row.title}",
                                                                                    "actors" : "${row.actors}",
                                                                                      "directors" : "${row.directors}",
                                                                                      "genres" : "${row.genres}",
                                                                                      "release_date" : "${row.release_date}",
                                                                                      "rating" : "${row.rating}",
                                                                                      "plot" : "${row.plot}"}'> ${row.title }</a ></h5>
									<small>${row.plot}</small>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
								  조회된 결과가 없습니다.
					</c:otherwise>
				</c:choose>

			</div>

		</div>
	</div>
	<%@ include file="../include/include-body.jspf"%>


    
  <!-- ############################################################################################################################## -->
  <!-- Detail Layer -->    
  <!-- ############################################################################################################################## -->
  <div id="modal_detail" class="modal fade reset" tabindex="-1" role="dialog"  >
      <div class="modal-dialog">
          <div class="modal-content">
              
              <div class="row">
                  <div class="col-lg-12">
                      <h4><strong><i class="fa fa-angle-double-right"></i>영화 상세</strong></h4>  
               
                  </div>

              </div>
              <div class="modal-header">
                <button type="button" class="btn btn-primary">수정</button>
                <button type="button" class="btn btn-import">삭제</button>
              
              </div>
              
              <div class="row p-10">
                  <div class="col-lg-12">
                      <h3 class="movie-title">
                        <strong><label style="padding-right:38px;">here is 제목</label> </strong>
                      </h3>
                      <div style="height: 5px;"></div>
                            
                      <blockquote class="f-s-13">
                          <form name="form_eventdetaillist" class="form-inline clearfix" id="form_eventdetaillist">
                              <input type="hidden" name="srch_event_no"/>
                              <label style="padding-right:38px;">출연</label>
                              <h5 class="movie-actors"></h5>
  
                              <div style="height: 5px;"></div>

                              <label style="padding-right:38px;">감독</label>
                              <h5 class="movie-directors"></h5>
 
                              <div style="height: 5px;"></div>

                              <label style="padding-right:38px;">장르</label>
                              <h5 class="movie-genres"></h5>
                              <div style="height: 5px;"></div>

                              <label style="padding-right:38px;">개봉일</label>
                              <h5 class="movie-release_date"></h5>
             
                              <div style="height: 5px;"></div>
                              
                              <label style="padding-right:38px;">평점</label>
                              <h5 class="movie-rating"></h5> 
                              <div id="stars"></div>
                              
                              
                              <div style="height: 5px;"></div>
                         </form> 
                         <label style="padding-right:38px;">줄거리</label> 
                         <div class="well">
                            <h5 class="movie-plot"></h5>
                         </div>
                        </blockquote>
                    </div>
                </div>
            </div>
        </div>
    </div>
  
	<!-- ############ 영화등록 Dialog ############## -->
	<div id="modal_movieinfo" class="modal fade reset" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title">
						<strong><i class="fa fa-angle-double-right"></i> 영화 등록</strong>
					</h4>
				</div>
				<form name="form_movieinfo" id="form_movieinfo" action="registerMovie.do" class="form-horizontal" method="POST" data-parsley-validate="true">
					<div class="modal-body">
						<fieldset>

							<input type="hidden" name="page" value="${result.page}" /> 
							<input type="hidden" name="srchEventName" value="${result.param.srchEventName}" /> 
							<input type="hidden" name="event"> 
							<input type="hidden" name="event_no">

							<div class="form-group form-group-sm">
								<label class="col-lg-2 control-label">* Title</label>
								<div class="col-lg-10">
									<input id="title" name="title" type="text" class="form-control" placeholder="Movie Title" 
									       required="required" data-parsley-maxlength="50" data-parsley-maxlength-message="최대 50자리 까지 허용됩니다." 
									       data-parsley-notspecial="true" data-parsley-notspecial-message="일부 특수문자는 허용하지 않습니다." 
									       data-parsley-required-message="영화 제목을 입력하세요.">
								</div>
							</div>
            
             <div class="form-group form-group-sm">
                <label for="select" class="col-lg-2 control-label">* 개봉일</label>
                <div class="col-lg-10">
                  <input type="text" name="release_date" id="release_date" class="form-control" placeholder="YYYY-MM-DD형식으로 입력해주세요." required="required" data-parsley-required-message="개봉일 지정하세요." />
                
<!--                   <input type="text" name="release_date" id="release_date" class="form-control datetime bg-white pointer input-sm" readonly="readonly" 
                         placeholder="YYYY-MM-dd" required="required" data-parsley-required-message="개봉일 지정하세요." value="" />
 -->                </div>
              </div> 

				     <div class="form-group form-group-sm">
                <label for="select" class="col-lg-2 control-label">장르</label>
                <div class="col-lg-10">
                  <input type="text" name="genres" id="genres" class="form-control"/>
                </div>
              </div>
              
              <div class="form-group form-group-sm">
                <label for="select" class="col-lg-2 control-label">출연배우</label>
                <div class="col-lg-10">
                  <input type="text" name="actors" id="actors" class="form-control" />
                </div>
              </div>
              
              <div class="form-group form-group-sm">
                <label for="select" class="col-lg-2 control-label">감독</label>
                <div class="col-lg-10">
                  <input type="text" name="directors" id="directors" class="form-control"/>
                </div>
              </div>
              
							<div class="form-group form-group-sm">
								<label class="col-lg-2 control-label">줄거리</label>
								<div class="col-lg-10">
									<input id="plot" name="plot" type="text" class="form-control" placeholder="short story" 
									       data-parsley-maxlength="200" data-parsley-maxlength-message="최대 200자리 까지 허용됩니다." data-parsley-notspecial="true" data-parsley-notspecial-message="일부 특수문자는 허용하지 않습니다.">
								</div>
							</div> 
  <!--             <div class="form-group form-group-sm">
                <label class="control-label col-lg-2" for="inputGroupSuccess1">JSON 파일 첨부</label>
                <div class="col-lg-10 ">
                  <div id="fileupload" class="input-group input-group-sm sigleupload">
                    <span class="input-group-addon fileinput-button"> <i class="fa fa-folder-open-o"></i> <input type="file" name="files[]" accept=".json" data-parsley-ui-enabled="false">
                    </span> <input type="text" id="file_name" name="imgfile.file_name" class="form-control fileinput-text bg-white" readonly="readonly" data-parsley-trigger="change focusin focusout" data-parsley-errors-container="#error_event_image_upload" data-parsley-pattern="\.(json)$" data-parsley-required="true" data-parsley-required-message="파일을 선택하세요." data-parsley-pattern-message="JSON 확장자가 아닙니다." /> 
                    <input type="text" id="file_no" name="imgfile.file_no" class="fileinput-id hide" data-parsley-trigger="change" data-parsley-errors-container="#error_event_image_upload" data-parsley-required="true" data-parsley-required-message="이미지를 업로드하세요." /> <span class="input-group-btn">
                      <button class="btn btn-primary fileinput-upload" type="button">
                        <i class="fa fa-upload"></i> UPLOAD
                      </button>
                    </span>
                  </div>
                  <div id="error_event_image_upload"></div>
                  <label><small>* JSON 파일만 지원합니다.</small></label>
                </div> 
              </div> -->
						</fieldset>
					</div>
					<div class="modal-footer">
						<button type="submit" class="btn btn-primary">Save</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.blockUI.js"></script>
  <script src="<%=request.getContextPath()%>/parsley/parsley.remote.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/rsa/jsbn.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/rsa/rsa.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/rsa/prng4.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/rsa/rng.js"></script>
	<script>
	 $(document).ready(function() {
    var stars = document.querySelector('#stars');
    var currentRating = 0;
    var maxRating= 1;
    var callback = function(rating) { alert(currentRating); };

    var myRating = rating(stars, currentRating, maxRating, callback);

    initDatePickerInit();

	  //detail list
	  $('#modal_detail').on('shown.bs.modal', function(e) {
		  //getEventDetailList();
		  var button = $(e.relatedTarget);
		  var data = button.data('whatever-json');
		  var modal = $(this)
//    console.log(data);
	
		  modal.find('.movie-title').text(data.title)
		  modal.find('.movie-plot').text(data.plot)
	    modal.find('.movie-actors').text(data.actors)
	    modal.find('.movie-directors').text(data.directors)
	    modal.find('.movie-genres').text(data.genres)
	    modal.find('.movie-release_date').text(data.release_date)
	    modal.find('.movie-rating').text(data.rating)

		  myRating.setRating(data.rating, false);
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
           format: 'YYYY-MM-DD',
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
       $('.datetime').daterangepicker($.extend(options, { timePicker: false, format : 'YYYY-MM-DD' }));
       //$('.date').daterangepicker($.extend(options, { timePicker: false, format : 'YYYY/MM/DD' }));
   }
	</script>
</body>
</html>