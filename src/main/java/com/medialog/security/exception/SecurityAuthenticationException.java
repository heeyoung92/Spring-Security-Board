package com.medialog.security.exception;

import org.springframework.security.core.AuthenticationException;

public class SecurityAuthenticationException extends AuthenticationException {

	private static final long serialVersionUID = 5919057142715477144L;
	
	private AuthenticationCode code;
	
	public SecurityAuthenticationException(AuthenticationCode code) {
		super(code.name());
		this.code = code;
	}
	
	public SecurityAuthenticationException(AuthenticationCode code, String msg) {
		super(msg);
		this.code = code;
	}

	public SecurityAuthenticationException(AuthenticationCode code, String msg, Throwable t) {
		super(msg, t);
		this.code = code;
	}
	
	
	public AuthenticationCode getCode() {
		return code;
	}


	public enum AuthenticationCode {
		UserLoginOk,
		UserLoginFail,
		UserLoginLock,
		UserLoginExpire,
		UserLoginNotSupportBrowser,
		UserLoginDisable;
		
	}
}
