package com.medialog.security;


import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.medialog.board.BoardService;
import com.medialog.board.BoardServiceImpl;
import com.medialog.entity.UserVO;
import com.medialog.security.RoleUser;
import com.medialog.user.UserService;

public class AuthenicationSerivce implements UserDetailsService {
	
	private static final Logger logger = LoggerFactory.getLogger(AuthenicationSerivce.class);
	public UserVO entity;

	public AuthenicationSerivce(UserService userService) {
		super();
		this.userService = userService;
	}
	
	private UserService userService;

	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		 entity = userService.findOne(username);
		if(entity == null) 
			throw new UsernameNotFoundException("사용자를 찾을 수 없습니다.");
		
		logger.info(entity.toString());

		List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
		authorities.add(new SimpleGrantedAuthority(RoleUser.ROLE_ANONYMOUS.name()));
		int level = 0;
		try {
			level = Integer.parseInt(entity.getUser_admin_level());
		} catch(Exception e) {
			logger.info("[Authenication Service Bad User Admin Level] : ", entity.getUser_admin_level());
		}
		
		for(RoleUser role : RoleUser.values()) {
			if((level & role.getIntValue()) == role.getIntValue()) {
				authorities.add(new SimpleGrantedAuthority(role.name()));
			}
		}
		logger.info("[Authenication Service Load User Role] : {} ", authorities.toString());
		
		User user = new User(
				entity.getUser_id(), 
				entity.getUser_pwd(),
				entity.getUser_disable_yn().equalsIgnoreCase("N"),	//계정 상태 
				true, 	// 만료일
				true,	//유효한 인증 여부 
				true, 	// 잠김 여부 
				authorities);
		return user;
	}
	
	public void plusPasswordWrongCount(String username)  {
//		userService.setWrongCntPlus(username);
	}
	
	public void resetPasswordWrongCount(String username) {
//		userService.setWrongCntZero(username);
	}

}
