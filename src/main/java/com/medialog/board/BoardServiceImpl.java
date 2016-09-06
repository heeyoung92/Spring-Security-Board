package com.medialog.board;

import java.net.InetAddress;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("boardService")
public class BoardServiceImpl implements BoardService{

	@Resource(name="boardDAO")
	private BoardDAO boardDAO;
	
	@Resource(name="fileUtils")
	 private CustomFileUtils fileUtils;
	     
	private static final Logger logger = LoggerFactory.getLogger(BoardServiceImpl.class);
	
	@Override
	public void insertBoard(Map<String, Object> map, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
	    boardDAO.insertBoard(map);
	    
	    
	    List<Map<String,Object>> list = fileUtils.parseInsertFileInfo(map, request);
        for(int i=0, size=list.size(); i<size; i++){
            boardDAO.insertFile(list.get(i));
            
        }
        
/*	    MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
	    Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
	    
	    MultipartFile multipartFile = null;
	    while(iterator.hasNext()){
	        multipartFile = multipartHttpServletRequest.getFile(iterator.next());
	        if(multipartFile.isEmpty() == false){
	            logger.info("name : "+multipartFile.getName());
	            logger.info("filename : "+multipartFile.getOriginalFilename());
	            logger.info("size : "+multipartFile.getSize());
	        }
	    }*/

	}

	@Override
	public List<Map<String, Object>> selectBoardList(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return boardDAO.selectBoardList(map); 
	}
	
	@Override
	public List<Map<String, Object>> selectBoardPaging(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return boardDAO.selectBoardPaging(map); 
	}
	
	@Override
	public List<Map<String, Object>> selectReplyPaging(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return boardDAO.selectReplyPaging(map); 
	}

	@Override
	public Map<String, Object> selectBoardDetail(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return boardDAO.selectBoardDetail(map);
	}

	@Override
	public void deleteBoard(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		boardDAO.deleteBoard(map);
		
	}

	@Override
	public void updateBoard(Map<String, Object> map, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		boardDAO.updateBoard(map);
		
		 int deleteFileCount = Integer.parseInt(map.get("deleteFileCount")+""); 
	
		 for(int i=0; deleteFileCount > 0; i++){			
			map.put("DEL_FILE_IDX", Integer.parseInt(map.get("FILE_IDX_"+i)+""));
			
			boardDAO.deleteFile(map);
			deleteFileCount--;
		}
		 
		List<Map<String,Object>> list = fileUtils.parseInsertFileInfo(map, request);
        for(int i=0, size=list.size(); i<size; i++){
            boardDAO.insertFile(list.get(i));
        }
	}

	@Override
	public List<Map<String, Object>> selectFileList(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return boardDAO.selectFileList(map);
	}

	@Override
	public Map<String, Object> selectFile(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return boardDAO.selectFile(map);
	}

	@Override
	public void writeReply(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		InetAddress IP =InetAddress.getLocalHost();
		logger.info(IP.getHostAddress());
		map.put("IP_ADDR", IP.getHostAddress());
		boardDAO.writeReply(map);
	}

	@Override
	public List<Map<String, Object>> selectReplyList(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return boardDAO.selectReplyList(map);
	}

	@Override
	public boolean checkPWD(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return boardDAO.checkPWD(map);
	}

	@Override
	public void updateHitCnt(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		boardDAO.updateHitCnt(map);
	}

}
