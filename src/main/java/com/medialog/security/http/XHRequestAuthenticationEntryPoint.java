package com.medialog.security.http;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.lf5.LogLevel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

/**
 * 
 * <pre>
 * kr.co.wincom.curation.client.security.handler
 *	|_ AuthenticationEntryPointImpl.java
 * </pre>
 *
 * @Company : Medialog	
 * @Author : medialog
 * @Date : 2015. 7. 9. �삤�쟾 10:10:37
 * @Description : 인증 절차의 EntryPoint 에서 오류 또는 성공 여부 상관없이 XHttpRequest에 대한 응답 Respone 처리
 * 오류에 대한 메세지 및 페이지 처리는 exception.do url에서 처리 합니다.
 *
 */
public class XHRequestAuthenticationEntryPoint extends LoginUrlAuthenticationEntryPoint {
	
	public Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public XHRequestAuthenticationEntryPoint(String loginFormUrl) {
		super(loginFormUrl);
	}
	
	@Override
	public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException, ServletException {
		// 에러 페이지에 대한 확장자를 현재 호출한 확장자와 마추어준다.
		if(isXHRequest(request)) {
			response.setStatus(HttpStatus.FORBIDDEN.value());
			response.getWriter().write("{ \"error\" : \"Session Not Exist\" }");
			response.setContentType(MediaType.APPLICATION_JSON_VALUE);
		} else {
			super.commence(request, response, authException);
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
