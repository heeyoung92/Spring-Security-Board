package com.medialog.board;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.medialog.common.CommandMap;
import com.medialog.common.CustomJsonUtil;
import com.medialog.entity.UserVO;
import com.medialog.user.UserService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class BoardController {
	
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
    @Resource(name="boardService")
    private BoardService boardService;

    @Resource(name="userService")
    private UserService userService;


	@RequestMapping(value = "/openBoardList.do*")
	public ModelAndView openBoardList(Map<String,Object> map) throws Exception {
		logger.info("openBoardList");
		ModelAndView mv = new ModelAndView("board/boardList");
	    
		map.put("page_index", 1);
	    map.put("page_row", 10);

		List<Map<String,Object>> list = boardService.selectBoardPaging(map);
				
		mv.addObject("list", list);
		
		return mv;
	}

	@RequestMapping(value = "/selectBoardPaging.do")
	@ResponseBody
	public  List<Map<String,Object>>  selectBoardPaging(
			@RequestParam int page_index, // Ajax
			@RequestParam int page_row 
			) throws Exception{
	
		logger.info("selectBoardPaging");
		
	    Map<String, Object > map = new HashMap<String,Object>();
	    map.put("page_index", page_index);
	    map.put("page_row", page_row);

		List<Map<String,Object>> list = boardService.selectBoardPaging(map);
		
		return list;
	}

	@RequestMapping(value = "/selectReplyPaging.do")
	@ResponseBody
	public  List<Map<String,Object>> selectReplyPaging(
			@RequestParam int board_idx,
			@RequestParam int page_index,
			@RequestParam int page_row 		) throws Exception{
	
		logger.info("selectReplyPaging");
		
	    Map<String, Object > map = new HashMap<String,Object>();
	    map.put("BOARD_IDX", board_idx);
	    map.put("page_index", page_index);
	    map.put("page_row", page_row);

		List<Map<String,Object>> list = boardService.selectReplyPaging(map);
		
		return list;
	}
	
	
	@RequestMapping(value = "/openBoardWrite.do")
	public ModelAndView openBoardWrite(
	//		@RequestParam String idx
		) throws Exception {
		logger.info("openBoardWrite");
		ModelAndView mv = new ModelAndView("board/boardWrite");
			
		return mv;
	}
	
	@RequestMapping(value = "/boardWrite.do")
	public ModelAndView boardWrite(
			CommandMap commandMap, 
			@RequestParam String idx, 	//parent_idx
			HttpServletRequest request	
			) throws Exception {
		logger.info("boardWrite, Parent_idx:"+idx);
		
		ModelAndView mv = new ModelAndView("redirect:/openBoardList.do");
		commandMap.put("PARENT_IDX",(String)idx);
		logger.info("userid: "+commandMap.get("ID")+" TITLE: "+commandMap.get("TITLE"));
		
		UserVO entity = userService.findOne("user2");
		logger.info(entity.toString());

		commandMap.put("PWD",(String)entity.getUser_pwd());
		
		boardService.insertBoard(commandMap.getMap(), request);
	             	
		return mv;
	}
	
	@RequestMapping(value = "/openBoardDetail.do")
	public ModelAndView openBoardDetail(
			CommandMap commandMap,
			@RequestParam String idx
			) throws Exception {
		logger.info("openBoardDetail, IDX:"+idx);

		ModelAndView mv = new ModelAndView("board/boardDetail");
		commandMap.put("IDX",(String)idx);
		
		boardService.updateHitCnt(commandMap.getMap()); //hit count
		
	    Map<String, Object> map = boardService.selectBoardDetail(commandMap.getMap());
	    List<Map<String, Object>> list = boardService.selectFileList(commandMap.getMap());

	    commandMap.put("BOARD_IDX", (String)commandMap.get("IDX"));
	    commandMap.put("page_index", 1);
	    commandMap.put("page_row", 5);
	    List<Map<String, Object>> replyList = boardService.selectReplyPaging(commandMap.getMap());
	    
	    mv.addObject("map", map);
	    mv.addObject("replyList", replyList);
	    mv.addObject("list", list);
	    
		return mv;
	}
	
	@RequestMapping(value = "/selectOrigin.do")
	@ResponseBody
	public Map<String, Object> selectOrigin(
			CommandMap commandMap,
			@RequestParam String idx
			) throws Exception {
		logger.info("selectOrigin, IDX:"+idx);

		commandMap.put("IDX",(String)idx);
		
		
	    Map<String, Object> map = boardService.selectBoardDetail(commandMap.getMap());

		return map;
	}
	@RequestMapping(value = "/openBoardUpdate.do")
	public ModelAndView openBoardUpdate(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("board/boardUpdate");

		Map<String, Object> map = boardService.selectBoardDetail(commandMap.getMap());
		List<Map<String, Object>> list = boardService.selectFileList(commandMap.getMap());
		mv.addObject("map", map);
	    mv.addObject("list", list);

		return mv;
	}
	
	@RequestMapping(value = "/deleteBoard.do")
	public ModelAndView deleteBoard(CommandMap commandMap) throws Exception {
		logger.info("deleteBoard");

		ModelAndView mv = new ModelAndView("redirect:/openBoardList.do");
		boardService.deleteBoard(commandMap.getMap());
		
		return mv;
	}
	
	@RequestMapping(value = "/updateBoard.do")
	public ModelAndView updateBoard(CommandMap commandMap, HttpServletRequest request) throws Exception {
		logger.info("updateBoard");

		ModelAndView mv = new ModelAndView("redirect:/openBoardList.do");
		boardService.updateBoard(commandMap.getMap(), request);
		
		return mv;
	}
	
	
	@RequestMapping(value = "/downloadFile.do")
	public void downloadFile(CommandMap commandMap, HttpServletResponse response) throws Exception {
		logger.info("downladFile " + commandMap.get("IDX"));

		Map<String, Object> map = boardService.selectFile(commandMap.getMap());
		String storedFileName = map.get("STORED_FILE_NAME").toString();
		String originalFileName = map.get("FILE_NAME").toString();

	    byte fileByte[] = FileUtils.readFileToByteArray(new File("C:\\dev\\file\\"+storedFileName));
	     
	    response.setContentType("application/octet-stream");
	    response.setContentLength(fileByte.length);
	    response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(originalFileName,"UTF-8")+"\";");
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.getOutputStream().write(fileByte);
	     
	    response.getOutputStream().flush();
	    response.getOutputStream().close();
	    
	}
	
	
	@RequestMapping(value = "/writeReply.do")
	public void writeReply(
		//  @RequestBody BoardVO, // Ajax Post, Accept : appliction/json 
		//	@ModelAttribute BoardVO, // Ajax Get, Accept : application/x-www-form-urlencoded
	//		@RequestParam String board_idx, // Ajax
	//		@RequestParam String parent_idx,
//			@RequestParam int indent,
//			@RequestParam String contents,
			@RequestBody String filterJSON,
			HttpServletResponse response) throws Exception {
		
	
//	    Map<String, Object > map = new HashMap<String,Object>();
	    Map<String, Object> map = CustomJsonUtil.convertJsonToObject(filterJSON);
//	    map.put("BOARD_IDX", board_idx);
//	    map.put("PARENT_IDX", parent_idx);
//	    map.put("INDENT", indent);
//	    map.put("CONTENTS", contents);
	    boardService.writeReply(map);
 
	//	logger.info("writeReply "+map.get(key));
	}
	
	@RequestMapping(value = "/checkPWD.do")
	@ResponseBody
	public boolean checkPWD(
			@RequestParam String idx, // Ajax
			@RequestParam String pwd,
			HttpServletResponse response) throws Exception {
		
	    Map<String, Object > map = new HashMap<String,Object>();
	    map.put("IDX", idx);
	    map.put("PASSWORD", pwd);
	    logger.info("pwd "+pwd);
	  	
	    boolean check = boardService.checkPWD(map);
	  	logger.info("check "+check);
	  	return check;
	}
}
