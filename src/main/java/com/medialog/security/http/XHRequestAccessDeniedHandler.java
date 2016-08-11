package com.medialog.security.http;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandlerImpl;

/**
 * 
 * <pre>
 * kr.co.wincom.curation.client.security.handler
 *	|_ AccessDeniedHandlerImpl.java
 * </pre>
 *
 * @Company : Medialog
 * @Author : medialog
 * @Date : 2015. 7. 9. �삤�쟾 10:10:17
 * @Description : 접근 권한 오류 처리 핸들러
 *
 */
public class XHRequestAccessDeniedHandler extends AccessDeniedHandlerImpl {

	public Logger logger = LoggerFactory.getLogger(this.getClass());

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		logger.info("[AccessDenied] : {} ", accessDeniedException.getMessage());
		// 에러 페이지에 대한 확장자를 현재 호출한 확장자와 마추어준다.
		if (isXHRequest(request)) {
			response.setStatus(HttpStatus.FORBIDDEN.value());
			response.getWriter().write("{ \"error\" : \"Access is Denied\" }");
			response.setContentType(MediaType.APPLICATION_JSON_VALUE);
		} else {
			super.handle(request, response, accessDeniedException);
		}

	}

	private boolean isXHRequest(HttpServletRequest request) {
		String val;
		if ((val = request.getHeader("x-requested-with")) != null) {
			if (val.equalsIgnoreCase("XMLHttpRequest")) {
				return true;
			}
		}
		return false;
	}
}
