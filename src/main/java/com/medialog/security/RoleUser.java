package com.medialog.security;

public enum RoleUser {
	ROLE_ANONYMOUS("-1"), ROLE_USER("0"), ROLE_ADMIN("1"), ROLE_MANAGER("2");
	private String value;

	private RoleUser(String value) {
		this.value = value;
	}

	public String getValue() {
		return value;
	}
	
	public int getIntValue() {
		return Integer.parseInt(value);
	}
}
