package com.medialog.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AccountExpiredException;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.medialog.security.exception.SecurityAuthenticationException;
import com.medialog.security.exception.SecurityAuthenticationException.AuthenticationCode;


public class AuthenticationProvider extends DaoAuthenticationProvider {
	
	private Logger logger = LoggerFactory.getLogger(this.getClass());

	public AuthenticationProvider(AuthenicationSerivce service) {
		super.setUserDetailsService(service);
	}
	
	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
		AuthenicationSerivce service = (AuthenicationSerivce) getUserDetailsService();
		String browser = attr.getRequest().getHeader("User-Agent");
		int pos = 0;
		if((pos = browser.indexOf("MSIE")) != -1){
			String version = browser.substring(pos + 4 , browser.indexOf(";", pos));
			if(Math.floor(Double.parseDouble(version.trim())) <= 8) {
				throw new SecurityAuthenticationException(AuthenticationCode.UserLoginNotSupportBrowser, "IE 9이하 및 기타 기기에선 지원되지 않습니다. ");
			} 
		}
		try {
			Authentication user = super.authenticate(authentication);
			service.resetPasswordWrongCount(user.getName());
			return user;
		} catch (BadCredentialsException e ) {
			service.plusPasswordWrongCount(String.valueOf(authentication.getPrincipal()));
			throw new SecurityAuthenticationException(AuthenticationCode.UserLoginFail, "로그인에 실패하였습니다. 5번 이상 실패시 잠금 처리 됩니다.", e);
		} catch (LockedException e) {
			throw new SecurityAuthenticationException(AuthenticationCode.UserLoginLock, "로그인 최대 횟수 초과로 잠금 처리 되었습니다. ", e);
		} catch (DisabledException e) {
			throw new SecurityAuthenticationException(AuthenticationCode.UserLoginDisable, "사용 중지된 사용자 입니다.", e);
		} catch (AccountExpiredException e) {
			throw new SecurityAuthenticationException(AuthenticationCode.UserLoginExpire, "비밀번호 사용일이 만료되었습니다.", e);
		} catch (AuthenticationServiceException e) {
			logger.error("[AuthenticationServiceException] : {} ", e.getMessage());
			throw new SecurityAuthenticationException(AuthenticationCode.UserLoginFail, "사용자 인증 도중 오류가 발생하였습니다.", e);
		} catch (Exception e) {
			throw new SecurityAuthenticationException(AuthenticationCode.UserLoginFail, "사용자 인증 도중 오류가 발생하였습니다.", e);
		}
	}
	
}
