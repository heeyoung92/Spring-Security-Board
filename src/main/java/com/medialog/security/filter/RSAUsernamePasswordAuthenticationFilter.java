package com.medialog.security.filter;

import java.io.IOException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Cipher;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.web.filter.GenericFilterBean;

public class RSAUsernamePasswordAuthenticationFilter extends GenericFilterBean {

	private static final String LOGIN_URL = "/login.login";
	private static final String LOGIN_CHECK_URL = "/loginCheck.login";
	private static final int KEY_SIZE = 1024;
	private static final String ID_PARAMETER = "userid"; 
	private static final String PWD_PARAMETER = "userpwd";  
	
	private RequestMatcher preLoginRequestMatcher;
	private RequestMatcher postLoginRequestMatcher;
	private KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
	
	
	private String paramName_Id;
	private String paramName_Pwd;
	
	public RSAUsernamePasswordAuthenticationFilter() throws NoSuchAlgorithmException {
		this(LOGIN_URL, LOGIN_CHECK_URL, ID_PARAMETER, PWD_PARAMETER);
	}

	public RSAUsernamePasswordAuthenticationFilter(String login, String loginprocess, String paramid, String parampwd) throws NoSuchAlgorithmException {
		this.preLoginRequestMatcher = new AntPathRequestMatcher(login);
		this.postLoginRequestMatcher = new AntPathRequestMatcher(loginprocess);
		this.generator.initialize(KEY_SIZE);
		this.paramName_Id = paramid;
		this.paramName_Pwd = parampwd;
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

		if (preLoginRequestMatcher.matches(req)) {
			
			try {
				KeyPair keyPair = generator.genKeyPair();
				KeyFactory keyFactory = KeyFactory.getInstance("RSA");

				PublicKey publicKey = keyPair.getPublic();
				PrivateKey privateKey = keyPair.getPrivate();

				HttpSession session = req.getSession(true);
				// 세션에 공개키의 문자열을 키로하여 개인키를 저장한다.
				session.setAttribute("__rsaPrivateKey__", privateKey);

				// 공개키를 문자열로 변환하여 JavaScript RSA 라이브러리 넘겨준다.
				RSAPublicKeySpec publicSpec = (RSAPublicKeySpec) keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);

				String publicKeyModulus = publicSpec.getModulus().toString(16);
				String publicKeyExponent = publicSpec.getPublicExponent().toString(16);
				
				req.setAttribute("publicKeyModulus", publicKeyModulus);
				req.setAttribute("publicKeyExponent", publicKeyExponent);
			} catch (Exception e) {
				throw new AuthenticationServiceException("RSA Key Generator Fail", e);
			}
			chain.doFilter(req, res);
			
		} else if (postLoginRequestMatcher.matches(req)) {
			
			String securedUsername = req.getParameter(paramName_Id);
			String securedPassword = req.getParameter(paramName_Pwd);
			
			HttpSession session = req.getSession();
	        PrivateKey privateKey = (PrivateKey) session.getAttribute("__rsaPrivateKey__");
	        session.removeAttribute("__rsaPrivateKey__"); // 키의 재사용을 막는다. 항상 새로운 키를 받도록 강제.

	        if (privateKey == null) {
	            throw new AuthenticationServiceException("RSA Private Key Not Found");
	        }
	        try {
	            String username = decryptRsa(privateKey, securedUsername);
	            String password = decryptRsa(privateKey, securedPassword);
	            
	            //Wrapper 로 감싸 파라미터 값을 다시 변조 한다.
	            RSAHttpServletRequestWrapper wrapper = new RSAHttpServletRequestWrapper(req);
		        wrapper.setParameter(paramName_Id, username);
		        wrapper.setParameter(paramName_Pwd, password);
		        
				chain.doFilter(wrapper, res);
				
	        } catch (Exception ex) {
	            throw new AuthenticationServiceException("RSA Decrypt Fail", ex);
	        }
		} else {
			chain.doFilter(req, res);
		}
		
	}

	private String decryptRsa(PrivateKey privateKey, String securedValue) throws Exception {
		Cipher cipher = Cipher.getInstance("RSA");
		byte[] encryptedBytes = hexToByteArray(securedValue);
		cipher.init(Cipher.DECRYPT_MODE, privateKey);
		byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
		String decryptedValue = new String(decryptedBytes, "utf-8");
		return decryptedValue;
	}

	/**
	 * 16진 문자열을 byte 배열로 변환한다.
	 */
	public static byte[] hexToByteArray(String hex) {
		if (hex == null || hex.length() % 2 != 0) {
			return new byte[] {};
		}

		byte[] bytes = new byte[hex.length() / 2];
		for (int i = 0; i < hex.length(); i += 2) {
			byte value = (byte) Integer.parseInt(hex.substring(i, i + 2), 16);
			bytes[(int) Math.floor(i / 2)] = value;
		}
		return bytes;
	}

	public class RSAHttpServletRequestWrapper extends HttpServletRequestWrapper {

		private HashMap<String, Object> params;

		@SuppressWarnings("unchecked")
		public RSAHttpServletRequestWrapper(HttpServletRequest request) {
			super(request);
			this.params = new HashMap<String, Object>(request.getParameterMap());
		}

		public String getParameter(String name) {
			String returnValue = null;
			String[] paramArray = getParameterValues(name);
			if (paramArray != null && paramArray.length > 0) {
				returnValue = paramArray[0];
			}
			return returnValue;
		}

		@SuppressWarnings("unchecked")
		public Map getParameterMap() {
			return Collections.unmodifiableMap(params);
		}

		@SuppressWarnings("unchecked")
		public Enumeration getParameterNames() {
			return Collections.enumeration(params.keySet());
		}

		public String[] getParameterValues(String name) {
			String[] result = null;
			String[] temp = (String[]) params.get(name);
			if (temp != null) {
				result = new String[temp.length];
				System.arraycopy(temp, 0, result, 0, temp.length);
			}
			return result;
		}

		public void setParameter(String name, String value) {
			String[] oneParam = { value };
			setParameter(name, oneParam);
		}

		public void setParameter(String name, String[] value) {
			params.put(name, value);
		}
	}
}
