package com.medialog.user;


import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.medialog.entity.UserVO;
import com.medialog.security.EncryptUtil;
import com.medialog.security.EncryptUtil.EnumSHA;

@Controller
public class UserController {
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);

	@Resource(name="userService")
	private UserService userService;
	
	@Value("#{ systemProperties['webapp.root']}")
	private String webAppRoot;
	
    @RequestMapping(value = "/login.login", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
//    	System.out.println(webAppRoot);
//    	System.out.println(this.getClass().getClassLoader().getResource("").toString());
    	
		logger.info("login {}.", locale);
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		String formattedDate = dateFormat.format(date);
		model.addAttribute("serverTime", formattedDate );
		return "login";
	}
    
	@RequestMapping(value = "/getUser.do")
	public ModelAndView getUserList(){
		logger.info("getUser!");
		UserVO entity = userService.findOne("admin");
		logger.info("name: "+ entity.getUser_name()+ " password: "+ entity.getUser_pwd());
		
		return null;

	}
/*	@RequestMapping(value = { "/user/list" }, method = RequestMethod.GET)
	public ModelAndView getUserList(
			@RequestParam(defaultValue="1") int page,
			@RequestParam(defaultValue="")  String keyword_id,
			HttpServletRequest request){
//		PagingRequest param = PagingRequest.create().page(page).param("user_id", keyword_id);
//		List<MemberVO> result =  userService.findToPaging(param);
//		int total =  userService.findToPagingSize(param);
//		return new ModelAndView("/user/user_list", "result", new PagingResult(param, total, result));
		return null;

	}*/
	
	@RequestMapping(value = { "/create.join" }, method = RequestMethod.POST)
	public RedirectView postUserCreate(@ModelAttribute UserVO user, HttpServletRequest request) throws NoSuchAlgorithmException {
		if(!userService.exists(user.getUser_id())) {
			user.setUser_pwd(EncryptUtil.sha_encrypt(user.getUser_pwd(), EnumSHA.SHA512)); 
			user.setUser_disable_yn("N");
			if(userService.create(user)){
				logger.info("[USER CREATE] : {} {}", user.getUser_id(), user.getUser_pwd() );
			}
		}
		return new RedirectView("login.login");
	}

	@ResponseBody
	@RequestMapping(value = "/checkid.join", method = RequestMethod.GET, consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	public boolean hasUserId(@RequestParam String user_id, HttpServletRequest request, HttpServletResponse response) {
		if(!userService.exists(user_id)){
			response.setStatus(200);
			return true;
		} else {
			response.setStatus(404);
			return false;
		}
	}
}
