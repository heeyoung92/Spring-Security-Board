package com.medialog.entity;

import java.util.Date;

public class UserVO {
	private String user_id;
	private String user_name;
	private String user_pwd;
	
	private String user_admin_level; 
	private String user_disable_yn;
	
	private Date create_date;
	
	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}

	public String getUser_pwd() {
		return user_pwd;
	}

	public void setUser_pwd(String user_pwd) {
		this.user_pwd = user_pwd;
	}

	public String getUser_admin_level() {
		return user_admin_level;
	}

	public void setUser_admin_level(String user_admin_level) {
		this.user_admin_level = user_admin_level;
	}

	public String getUser_disable_yn() {
		return user_disable_yn;
	}

	public void setUser_disable_yn(String user_disable_yn) {
		this.user_disable_yn = user_disable_yn;
	}

	public Date getCreate_date() {
		return create_date;
	}

	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}

	@Override
	public String toString() {
		return "MemberVO [user_id=" + user_id + ", user_name=" + user_name + ", user_pwd=" + user_pwd  
				+ ", user_admin_level=" + user_admin_level + ", user_disable_yn=" + user_disable_yn + ", create_date=" + create_date ;
	}
	
}
