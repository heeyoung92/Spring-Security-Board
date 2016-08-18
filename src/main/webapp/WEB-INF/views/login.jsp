<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="ko">
<!--<![endif]-->
<head>
<%@ include file="./include/include-header.jspf"%>

<title>SpringMVC Board Admin</title>
</head>
<body class="p-0 m-0 height-auto" onLoad="getid()" >
	<div id="container">
	    <!-- begin login -->
        <div class="login" >
            <!-- begin brand --> 
            <div class="login-header">
                <div class="brand">
                   	Spring Board Admin
                    <small>Login</small>
                </div>
                <div class="icon">
                    <a href="openBoardList.do"> <i class="fa fa-sign-in"></i> </a>
                </div>


            </div>
			<!-- end brand -->
			<div class="login-content">
				<form name="form_login" id="form_login" onsubmit="form_submit(); return false;" data-parsley-validate="true" class="margin-bottom-0">
					<div class="form-group m-b-20">
						<input type="text" name="userid" class="form-control " placeholder="User ID" required="required" data-parsley-required-message="아이디를 입력하세요." />
					</div>
					<div class="form-group m-b-20">
						<input type="password" name="userpwd" class="form-control " placeholder="Password" required="required" data-parsley-required-message="비밀번호를 입력하세요." />
					</div>
					<div class="checkbox m-b-20">
						<label> <input id="remeber" name="remeber" type="checkbox" /> 아이디 기억
						</label>
					</div>
					<div class="login-buttons">
						<button id="btn_login" type="submit" class="btn btn-success btn-block ">Sign me in</button>
						<button type="button" data-toggle="modal" data-target="#modal_userinsert" class="btn btn-success btn-block ">Sign up</button>

					</div>


					<c:if test="${not empty param.fail && not empty sessionScope['SPRING_SECURITY_LAST_EXCEPTION'].message }">
						<div class="form-group m-t-20 m-t-20 f-s-12 text-center">
							<span class="label label-danger ">${sessionScope['SPRING_SECURITY_LAST_EXCEPTION'].message }</span>
						</div>
						<c:remove var="SPRING_SECURITY_LAST_EXCEPTION" scope="session" />
					</c:if>
					<c:if test="${not empty param.pwdedit }">
						<div class="form-group m-t-20 m-t-20 f-s-12 text-center">
							<span class="label label-primary ">비밀번호 변경에 성공하였습니다.</span>
						</div>
						<c:remove var="pwdedit" scope="request" />
					</c:if>
					<c:if test="${not empty param.pwdreset }">
						<div class="form-group m-t-20 m-t-20 f-s-12 text-center">
							<span class="label label-primary ">해당 이메일로 임시 비밀번호가 발송 되었습니다.</span>
						</div>
						<c:remove var="pwdreset" scope="request" />
					</c:if>

				</form>
				<form name="form_secure" id="form_secure" action="<c:url value="/loginCheck.login"/>" method="POST">
					<input name="userid" type="hidden"> <input name="userpwd" type="hidden">
				</form>
			</div>
		</div>

        <!-- end login -->
	</div>
	<!-- end page container -->
	
	 <div id="modal_userinsert" class="modal fade reset" tabindex="-1" role="dialog"  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title"><strong><i class="fa fa-angle-double-right"></i> 사용자 등록</strong></h4>
        </div>
        <form name="form_userinsert" action="create.join" class="form-horizontal"  method="POST" data-parsley-validate="true">
          <div class="modal-body">
            <fieldset>
              <div class="form-group form-group-sm">
                <label class="col-lg-2 control-label">User ID</label>
                <div class="col-lg-10">
                  <input id="user_id" name="user_id" type="text" class="form-control" placeholder="User ID" required="required" 
                    data-parsley-remote="checkid.join"
                    data-parsley-remote-message="이미 사용중인 아이디입니다."
                    data-parsley-maxlength="12"
                    data-parsley-maxlength-message="최대 12자리 까지 허용됩니다."
                    data-parsley-type="alphanum"
                    data-parsley-type-message="아이디는 영문,숫자 입니다."  
                    data-parsley-trigger="focusout change" 
                    data-parsley-remote-options='{ "type": "GET" ,  "contentType" : "application/x-www-form-urlencoded;charset=UTF-8"}'
                    data-parsley-required-message="아이디를 입력하세요.">
                </div>
              </div>
              <div class="form-group form-group-sm">
                <label class="col-lg-2 control-label">User Name</label>
                <div class="col-lg-10">
                  <input id="user_name" name="user_name" type="text" class="form-control" placeholder="User Name" required="required" 
                    data-parsley-maxlength="50"
                    data-parsley-maxlength-message="최대 50자리 까지 허용됩니다."
                    data-parsley-type="alphanum"
                    data-parsley-type-message="이름은 영문,숫자만 입력가능합니다."   
                    data-parsley-required-message="이름를 입력하세요.">
                </div>
              </div>
              <div class="form-group form-group-sm">
                <label class="col-lg-2 control-label">Password</label>
                <div class="col-lg-10">
                  <input id="user_pwd" name="user_pwd" type="password" class="form-control" placeholder="Password" required="required" 
                    data-parsley-continuous="true"
                    data-parsley-repact="true"
                    data-parsley-repact-message="같은 문자는 3번이상 반복 될 수 없습니다."
                    data-parsley-required="true" 
                    data-parsley-required-message="비밀번호를 입력하세요" />
                </div>
              </div>
<!--                data-parsley-pattern="/.*(?=.{8,})(?=.*\d)(?=.*[\W|\s])(?=.*[a-zA-Z]).*/"
                    data-parsley-pattern-message="비밀번호는 8글자 이상, 문자, 특수문자, 숫자를 혼용하여야 합니다." -->
                    
              <div class="form-group form-group-sm">
                <label class="col-lg-2 control-label">Password Repact</label>
                <div class="col-lg-10">
                  <input id="user_pwd_prev" name="user_pwd_prev" type="password" class="form-control" placeholder="Password Repact" required="required" 
                    data-parsley-required-message="비밀번호 확인을 입력하세요"
                    data-parsley-equalto="#user_pwd"  
                    data-parsley-equalto-message="비밀번호와 입력한 값이 다릅니다.">
                </div>
              </div>
              <div class="form-group form-group-sm">
                <label class="col-lg-2 control-label">Admin Level</label>
                <div class="col-lg-10">
                  <div class="radio">
                    <label>
                      <input type="radio" name="user_admin_level" value="1" required="required" 
                        data-parsley-required-message="Level을 선택하세요."> 관리자
                    </label>
                  </div>
                  <div class="radio">
                    <label>
                      <input type="radio" name="user_admin_level" value="2"> 매니저(일반)
                    </label>
                  </div>
                </div>
              </div>
              
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
  
	<script type="text/javascript">
 	var LoginSecureInit = function() {
 		var rsaPublicKeyModulus = '${publicKeyModulus}';
		var rsaPublicKeyExponent = '${publicKeyExponent}';
		var rsa = new RSAKey();
		rsa.setPublic(rsaPublicKeyModulus, rsaPublicKeyExponent);

 		return {
	  	openBlockUI : function() {
				$.blockUI({ message: '<h4><img src="<c:url value="/img/loading.gif"/>" width="16px" height="16px" /> 암호화 처리중입니다. 잠시만 기다려주세요...</h4>' });
			},
			closeBlockUI : function() {
				$.unblockUI();
			}, 
			onSubmit : function() {
 				this.openBlockUI(); 
				try {
  				var secureid = rsa.encrypt(document.form_login.userid.value)
					var securepwd = rsa.encrypt(document.form_login.userpwd.value)
					document.form_secure.userid.value = secureid;
					document.form_secure.userpwd.value = securepwd;
					console.log("RSA secured id: "+secureid+"\nRSA secured password: "+securepwd);

					document.form_secure.submit();
				} catch(exception) {
					alert('RSA로 암호화 하는데 실패하였습니다. ' + exception)
 					this.closeBlockUI(); 
				}
			}
		}
	}();
	function form_submit() {
 		if($('input[name=remeber]').is(':checked')) {
			$.cookie('svid', document.form_login.userid.value, {
                "expires" : 365                
      });	
		} else {
			$.removeCookie('svid');
		} 
 		if($('#form_login').parsley().validate()){
 		    LoginSecureInit.onSubmit();
 		}
	}
	
	function getid() {
		var svid = $.cookie('svid')
		if (svid) {
			document.form_login.userid.value = svid;
			document.form_login.userpwd.focus();
			$('input[name=remeber]').attr('checked', true);
		} else {
			document.form_login.userid.focus();
		}
	} 
	
	</script>
</body>
</html>