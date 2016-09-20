package com.medialog.movie;

import java.util.Map;

import com.amazonaws.services.dynamodbv2.document.ItemCollection;
import com.amazonaws.services.dynamodbv2.document.QueryOutcome;
import com.medialog.entity.MovieVO;

public interface MovieService {


	ItemCollection<QueryOutcome> selectMovieList(Map<String, Object> map) throws Exception;

	boolean createMovie(MovieVO movieVo) throws Exception;

	void deleteBoard(MovieVO movieVo) throws Exception;

	boolean updateMovie(MovieVO movieVo) throws Exception;
}
