package com.medialog.movie;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.print.attribute.standard.PrinterState;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

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
				movie.setYear(item.getString("year"));
				movie.setTitle(item.getString("title"));

				movie.setTitle(item.getString("title"));
				movie.setImage_url((String) item.getMap("info").get("image_url"));
				movie.setRelease_date((String) item.getMap("info").get("release_date"));

				movie.setActors((List<String>) item.getMap("info").get("actors"));
				movie.setDirectors((List<String>) item.getMap("info").get("directors"));
				movie.setGenres((List<String>) item.getMap("info").get("genres"));

				try {
					movie.setRating(Double.parseDouble(String.valueOf(item.getMap("info").get("rating"))));  // 'java.math.BigDecimal cannot be cast to java.lang.Integer'
					
				} catch (Exception e) {
					// TODO: handle exception
//					System.out.println(e.getMessage());
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

}
