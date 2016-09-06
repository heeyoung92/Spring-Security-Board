<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<head>
<title>UPlus Game Admin</title>
<%@ include file="./include/include-header.jspf"%>

</head>
<body class="p-0 m-0 height-auto">
	<!-- begin #page-container -->
	<div id="container">
	    <!-- begin error -->
        <div class="error">
            <div class="error-code m-b-10">401 <i class="fa fa-warning"></i></div>
            <div class="error-content">
                <div class="error-message">BLOCK ACCESS REQUEST</div>
                <div class="error-desc m-b-20">
					             해당 요청에 대한 권한이 없어 접근이 거부되었습니다. 
                </div>
                <div>
                    <a href="javascript:history.back(-1);" class="btn btn-success">Go Back to Prev Page</a>
                </div>
            </div>
        </div>
        <!-- end error -->
      	
	</div>
	<!-- end page container -->
	
</body>
</html>
