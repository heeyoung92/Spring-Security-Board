<%@ page language="java" session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<sec:authorize var="isLogin" access="hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')" />

<!-- Navigation -->
<nav id="navigation" class="navbar navbar-default navbar-fixed-top " role="navigation">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#sidenavigation">
						<span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="<c:url value="/openBoardList.do"/>">SpringMVC</a>
		</div>
		<!-- Top Menu Items -->
		<ul class="nav navbar-right top-nav ">
				<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"> <i class="fa fa-user"></i> <sec:authentication property="name" /> <b class="caret"></b>
				</a>
						<ul class="dropdown-menu">
<!-- 								<li><a data-toggle="modal" data-target="#modal_editpassword" href=#><strong><i class="fa fa-key"></i> Edit Password</strong></a></li>
								<li class="divider"></li> -->
								<li><a href="<c:url value="/logout.do"/>"><strong><i class="fa fa-power-off"></i> Log Out</strong></a></li>
						</ul></li>
		</ul>
		<!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
		<div id="sidenavigation" class="collapse navbar-collapse">
				<ul class="nav navbar-nav navbar-default side-nav">
						<%-- 
						<li >
                <a href="<c:url value="/index.do"/>"><i class="fa fa-laptop"></i> Dashboard</a>
            </li> 
            --%>
					
						<li><a href="javascript:;" data-toggle="collapse" data-target="#nav_coupon"> <i class="glyphicon glyphicon-question-sign"></i> Board <i class="fa fa-caret-down"></i>
						</a>
								<ul id="nav_coupon" class="collapse in">
										<li><a href="<c:url value="/openBoardList.do"/>"><i class="fa fa-angle-right"></i>&nbsp;Q & A</a></li>
								</ul></li>
						<li><a href="javascript:;" data-toggle="collapse" data-target="#nav_vas"> <i class="glyphicon glyphicon-facetime-video"></i> Movie <i class="fa fa-caret-down"></i>
						</a>
								<ul id="nav_vas" class="collapse in">
										<li><a href="<c:url value="/openMovieList.do"/>"><i class="fa fa-angle-right"></i>&nbsp;Dynamo DB</a></li>
								</ul></li>
								  <li><a href="javascript:;" data-toggle="collapse" data-target="#nav_game"> <i class="glyphicon glyphicon-user"></i> Profile <i class="fa fa-caret-down"></i>
            </a>
                <ul id="nav_game" class="collapse in" aria-expanded="true">
                    <li><a href="<c:url value="/openProfile.do"/>"><i class="fa fa-angle-right"></i>&nbsp;</a></li>
<%--                     <li><a href="<c:url value="/openProfile.do"/>"><i class="fa fa-angle-right"></i>&nbsp;contact</a></li>
 --%>                </ul></li>
				</ul>
		</div>
		
		<!-- Edit Password -->
		<div id="modal_editpassword" class="modal fade reset" tabindex="-1" role="dialog"  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title"><strong><i class="fa fa-angle-double-right"></i> 비밀번호 변경 </strong></h4>
        </div>
        <form name="form_editpassword" action="editpassword.do" class="form-horizontal"  method="POST" data-parsley-validate="true">
          <div class="modal-body">
            <fieldset>
              <div class="form-group form-group-sm">
                <label class="col-lg-3 control-label">User ID</label>
                <div class="col-lg-9">
                 <strong> <sec:authentication property="name" /></strong>
                </div>
              </div>
     
              <div class="form-group form-group-sm">
                <label class="col-lg-3 control-label">Old Password</label>
                <div class="col-lg-9">
                  <input id="old_user_pwd" name="user_pwd" type="password" class="form-control" placeholder="Password" required="required" 
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
                <label class="col-lg-3 control-label">New Password</label>
                <div class="col-lg-9">
                  <input id="new_user_pwd" name="user_pwd" type="password" class="form-control" placeholder="Password" required="required" 
                    data-parsley-continuous="true"
                    data-parsley-required="true" 
                    data-parsley-required-message="비밀번호를 입력하세요" />
                </div>
              </div>
                    
              <div class="form-group form-group-sm">
                <label class="col-lg-3 control-label">Password Repact</label>
                <div class="col-lg-9">
                  <input id="user_pwd_prev" name="user_pwd_prev" type="password" class="form-control" placeholder="Password Repact" required="required" 
                    data-parsley-required-message="비밀번호 확인을 입력하세요"
                    data-parsley-equalto="#new_user_pwd"
                    data-parsley-equalto-message="비밀번호와 입력한 값이 다릅니다.">
                </div>
              </div>
              
            </fieldset>
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">Change Password</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          </div>
        </form>
      </div>
    </div>
  </div>
		
		<!-- /.navbar-collapse -->
</nav>
