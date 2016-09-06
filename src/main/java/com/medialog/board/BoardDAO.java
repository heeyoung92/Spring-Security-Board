package com.medialog.board;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDAO {
    
	@Autowired
    private SqlSessionTemplate sqlSession;
	
	private static final Logger logger = LoggerFactory.getLogger(BoardDAO.class);

	public void insertBoard(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
	    insert("board.insertBoard", map);

	}
	
	 public Object insert(String queryId, Object params) {
	        return sqlSession.insert(queryId, params);
	 }


	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectBoardList(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return  (List<Map<String, Object>>)selectList("board.selectBoardList", map);
	
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectBoardPaging(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub

		int nPageIndex = 1;
	    int nPageRow = 10;
	     
	    nPageIndex = (int) map.get("page_index")-1;
	    nPageRow = (int)  map.get("page_row");
	 
	    int start = (nPageIndex * nPageRow) + 1;
	    int end = (nPageIndex * nPageRow) + nPageRow;
	        
	    map.put("START", start);
	    map.put("END", end);
	     
//        logger.info("Board Start : "+ map.get("START") +", END: "+ map.get("END"));

	    String buy = "swim 4 + flymo 10 + shoese 3 + hagang 5 // onepiece for wedding 6 shoese 3 // flymodel 10  // one 6 hair 4 //";
		return  (List<Map<String, Object>>)selectList("board.selectBoardPaging", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectReplyPaging(Map<String, Object> map) throws Exception {

		int nPageIndex = 1;
	    int nPageRow = 5;
	     
	    nPageIndex = (int) map.get("page_index")-1;
	    nPageRow = (int)  map.get("page_row");
	 
	    int start = (nPageIndex * nPageRow) + 1;
	    int end = (nPageIndex * nPageRow) + nPageRow;
	        
	    map.put("START", start);
	    map.put("END", end);
	     
//        logger.info("Reply Start : "+ map.get("START") +", END: "+ map.get("END"));

		return  (List<Map<String, Object>>)selectList("board.selectCommentPaging", map);
	}

    @SuppressWarnings("rawtypes")
    public List selectList(String queryId, Object params){
        return sqlSession.selectList(queryId,params);
    }
    
    public Object selectOne(String queryId, Object params){
        return sqlSession.selectOne(queryId, params);
    }

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBoardDetail(Map<String, Object> map)  throws Exception {
		// TODO Auto-generated method stub
		return (Map<String, Object>) selectOne("board.selectBoardDetail", map);
	}

	public void deleteBoard(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		sqlSession.delete("board.deleteBoard", map);
	}

	public void updateBoard(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		sqlSession.update("board.updateBoard", map);

	}

	public void insertFile(Map<String, Object> map) throws Exception{
		// TODO Auto-generated method stub
		sqlSession.insert("board.insertFile",map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectFileList(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>)selectList("board.selectFileList", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectFile(Map<String, Object> map) throws Exception{
		// TODO Auto-generated method stub
		return  (Map<String, Object>) selectOne("board.selectFile", map);
	}

	public void deleteFile(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
			sqlSession.delete("board.deleteFile", map);
	}

	public void writeReply(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		insert("board.insertReply", map);
		
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectReplyList(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>)selectList("board.selectReplyList", map);
	}

	@SuppressWarnings("unchecked")
	public boolean checkPWD(Map<String, Object> map) throws Exception{
		// TODO Auto-generated method stub
		Map<String, Object> map2 = (Map<String, Object>) selectOne("board.selectPWD", map);

		String origin_pwd =(String) map2.get("PASSWORD");
		String pwd = (String) map.get("PASSWORD");
		logger.info("origin: "+origin_pwd+" pwd: "+pwd);
		if(origin_pwd.equals(pwd)) return true;
		return false;
	}

	public void updateHitCnt(Map<String, Object> map)  throws Exception{
		// TODO Auto-generated method stub
		sqlSession.update("board.updateHitCnt", map);
	}
}
