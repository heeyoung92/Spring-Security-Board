package com.medialog.security;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class EncryptUtil {
	
	private static EncryptUtil _INSTANCE = null;
	private EncryptUtil() {}
	public static  EncryptUtil getInstance() {
		if (_INSTANCE == null) {
			_INSTANCE = new EncryptUtil();
		}
		return _INSTANCE;
	}
	
	public enum EnumSHA {
		SHA256("SHA-256"), SHA512("SHA-512"), MD5("MD5");
		private String value;

		private EnumSHA(String value) {
			this.value = value;
		}

		public String getValue() {
			return value;
		}
	}
	

	

	public static String sha_encrypt(String planText, EnumSHA sha) throws NoSuchAlgorithmException {

		MessageDigest md = MessageDigest.getInstance(sha.getValue());
		md.update(planText.getBytes());
		byte byteData[] = md.digest();

		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < byteData.length; i++) {
			sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
		}

		StringBuffer hexString = new StringBuffer();
		for (int i = 0; i < byteData.length; i++) {
			String hex = Integer.toHexString(0xff & byteData[i]);
			if (hex.length() == 1) {
				hexString.append('0');
			}
			hexString.append(hex);
		}

		return hexString.toString();

	}
}
