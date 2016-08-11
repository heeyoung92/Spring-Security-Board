package com.medialog.board;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;


public interface BoardService {

	void insertBoard(Map<String, Object> map, HttpServletRequest request) throws Exception;

	List<Map<String, Object>> selectBoardList(Map<String, Object> map) throws Exception;

	Map<String, Object> selectBoardDetail(Map<String, Object> map) throws Exception;

	void deleteBoard(Map<String, Object> map) throws Exception;

	void updateBoard(Map<String, Object> map, HttpServletRequest request) throws Exception;

	List<Map<String, Object>> selectFileList(Map<String, Object> map) throws Exception;

	Map<String, Object> selectFile(Map<String, Object> map)  throws Exception;

	void writeReply(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> selectReplyList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> selectBoardPaging(Map<String, Object> map) throws Exception;

	boolean checkPWD(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> selectReplyPaging(Map<String, Object> map) throws Exception;

	void updateHitCnt(Map<String, Object> map)throws Exception;



	
}
