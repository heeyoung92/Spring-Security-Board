package com.medialog.movie;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.amazonaws.services.dynamodbv2.document.ItemCollection;
import com.amazonaws.services.dynamodbv2.document.QueryOutcome;

public interface MovieService {


	ItemCollection<QueryOutcome> selectMovieList(Map<String, Object> map) throws Exception;
	
}
