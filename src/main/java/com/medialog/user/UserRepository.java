package com.medialog.user;

import org.springframework.stereotype.Repository;
import com.medialog.entity.UserVO;

@Repository
public interface UserRepository {

	public UserVO getUser(String user_id);

	public int createUser(UserVO entity);
	
}
