package com.medialog.movie;

import java.io.FileNotFoundException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.ItemCollection;
import com.amazonaws.services.dynamodbv2.document.QueryOutcome;
import com.medialog.entity.MovieVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class MovieController {
	
	private static final Logger logger = LoggerFactory.getLogger(MovieController.class);
	
    @Resource(name="movieService")
    private MovieService movieService;


	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/openMovieList.do*")
	@ResponseBody
	public ModelAndView openBoardList(Map<String,Object> map) throws Exception {
		logger.info("openBoardList");
		ModelAndView mv = new ModelAndView("movie/movieList");
	    
		ItemCollection<QueryOutcome> items = movieService.selectMovieList(map);
		ArrayList<MovieVO> list = new ArrayList<MovieVO>();
//		MovieVO movie = new MovieVO();

		Iterator<Item> iterator = null;
		Item item = null;

		try {
			System.out.println("Movies from 2013");
			iterator = items.iterator();
			
			while (iterator.hasNext()) {
				item = iterator.next();
				MovieVO movie = new MovieVO();
				
				movie.setTitle(item.getString("title"));

				movie.setTitle(item.getString("title"));
				movie.setImage_url((String) item.getMap("info").get("image_url"));
				movie.setRelease_date((String) item.getMap("info").get("release_date"));

				movie.setActors((List<String>) item.getMap("info").get("actors"));
				movie.setDirectors((List<String>) item.getMap("info").get("directors"));
				movie.setGenres((List<String>) item.getMap("info").get("genres"));

				try {
					movie.setYear(Integer.parseInt(String.valueOf(item.getString("year"))));
					movie.setRating(Double.parseDouble(String.valueOf(item.getMap("info").get("rating"))));  // 'java.math.BigDecimal cannot be cast to java.lang.Integer'
					
				} catch (Exception e) {
					// TODO: handle exception
					System.out.println("["+movie.getTitle()+"] "+e.getMessage());
				}

				movie.setPlot((String) item.getMap("info").get("plot"));

				list.add(movie);
//				System.out.println(movie.toString());
//				System.out.println(item.getNumber("year") + ": " + item.getString("title") +", " + item.getMap("info").get("directors"));
			}
			mv.addObject("list", list);

		} catch (Exception e) {
			System.err.println("Unable to query movies from 2013");
			System.err.println(e.getMessage());
		}
		return mv;
	}
	
	
	@RequestMapping(value = { "/registerMovie.do" }, method = RequestMethod.POST)
	public RedirectView postEventCreate(
			@ModelAttribute MovieVO movieVo,
			@RequestParam String event,
			@RequestParam(defaultValue="1") int page,
			@RequestParam(defaultValue="")  String srchEventName,
			HttpServletRequest request) throws Exception, NoSuchAlgorithmException, FileNotFoundException {
		
		//logger.info("[Movie CREATE] :"+movieVo.getTitle());
		if(movieService.createMovie(movieVo)){
			logger.info("[Movie CREATE] : {} ", movieVo.getTitle());
		} 
		
		//insert
		if(event.equals("create")) {
			logger.info("Create [Movie CREATE] : {} ", movieVo.getTitle());
		}
		
		//update
		if(event.equals("update")){
//			if(eventService.updateEvent(movieVo)){
//				log.info("[EVENT UPDATE] : {} / [RESULT] : {}", "Event_no : " +movieVo.getEvent_name(), CMSCode.EventOK);
//			}
		}
			
		//WEB 캐시갱신
//		cachePurge.callPurge();
		
		//return search&list
		RedirectView redirectView = new RedirectView();
		redirectView.setUrl("openMovieList.do");
		redirectView.setExposeModelAttributes(true);
		
//		redirectView.addStaticAttribute("page", page);
//		redirectView.addStaticAttribute("srchEventName", srchEventName);
		
		return redirectView;
	}

	@RequestMapping(value = "/deleteMovie.do")
	public ModelAndView deleteBoard(@ModelAttribute MovieVO movieVo) throws Exception {
//		logger.info("deleteMovie: "+movieVo.getTitle()+", "+movieVo.getYear());
		ModelAndView mv = new ModelAndView("redirect:/openMovieList.do");
		movieService.deleteBoard(movieVo);

		return mv;
	}

}
