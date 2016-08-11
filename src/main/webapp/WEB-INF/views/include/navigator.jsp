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
								<li><a href="<c:url value="/password_edit"/>"><strong><i class="fa fa-key"></i> Edit Password</strong></a></li>
								<li class="divider"></li>
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
		<!-- /.navbar-collapse -->
</nav>
