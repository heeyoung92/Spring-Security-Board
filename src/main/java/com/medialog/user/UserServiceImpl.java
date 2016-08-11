package com.medialog.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.medialog.entity.UserVO;

@Service("userService")
public class UserServiceImpl implements UserService {
	
	@Resource(name="userRepository")
	private UserRepository userRepository;
	
	@Override
	public UserVO findOne(String id) {
		return userRepository.getUser(id);

	}

	@Override
	public boolean create(UserVO entity) {
		return userRepository.createUser(entity) == 1 ? true : false;

	}

	@Override
	public boolean update(UserVO entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean exists(String id) {
		return userRepository.getUser(id) != null ? true : false;
	}

	@Override
	public boolean delete(String id) {
		// TODO Auto-generated method stub
		return false;
	}

}
