package com.medialog.movie;

import java.net.InetAddress;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.swing.Spring;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.ItemCollection;
import com.amazonaws.services.dynamodbv2.document.PutItemOutcome;
import com.amazonaws.services.dynamodbv2.document.QueryOutcome;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.spec.QuerySpec;
import com.amazonaws.services.dynamodbv2.document.utils.NameMap;
import com.medialog.entity.MovieVO;

@Service("movieService")
public class MovieServiceImpl implements MovieService {

	private static final Logger logger = LoggerFactory.getLogger(MovieServiceImpl.class);
	AmazonDynamoDBClient client = new AmazonDynamoDBClient()
			// .withEndpoint("http://localhost:8000");
			.withRegion(Regions.AP_NORTHEAST_2); // Seoul
	DynamoDB dynamoDB = new DynamoDB(client);
	Table table = dynamoDB.getTable("Movies");
	
	@Override
	public ItemCollection<QueryOutcome> selectMovieList(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		

		HashMap<String, String> nameMap = new HashMap<String, String>();
		nameMap.put("#yr", "year");

		HashMap<String, Object> valueMap = new HashMap<String, Object>();
		valueMap.put(":yyyy", 2013);

		QuerySpec querySpec = new QuerySpec().withKeyConditionExpression("#yr = :yyyy")
				.withNameMap(new NameMap().with("#yr", "year")).withValueMap(valueMap);

		ItemCollection<QueryOutcome> items = null;
		Iterator<Item> iterator = null;
		Item item = null;

		try {
//			System.out.println("Movies from 2013");
			items = table.query(querySpec);
//			iterator = items.iterator();
//			while (iterator.hasNext()) {
//				item = iterator.next();
//				System.out.println(item.getNumber("year") + ": " + item.getString("title") +", "+item.getMap("info").get("image_url"));
//			}

		} catch (Exception e) {
			System.err.println("Unable to query movies from 2013");
			System.err.println(e.getMessage());
		}

//		valueMap.put(":yyyy", 1992);
//		valueMap.put(":letter1", "A");
//		valueMap.put(":letter2", "L");
//
//		querySpec.withProjectionExpression("#yr, title, info.genres, info.actors[0]")
//				.withKeyConditionExpression("#yr = :yyyy and title between :letter1 and :letter2").withNameMap(nameMap)
//				.withValueMap(valueMap);
//
//		try {
//			System.out.println("Movies from 1992 - titles A-L, with genres and lead actor");
//			items = table.query(querySpec);
//
//			iterator = items.iterator();
//			while (iterator.hasNext()) {
//				item = iterator.next();
//				System.out.println(item.getNumber("year") + ": " + item.getString("title") + " " + item.getMap("info"));
//			}
//
//		} catch (Exception e) {
//			System.err.println("Unable to query movies from 1992:");
//			System.err.println(e.getMessage());
//		}
		return items;
	}

	@Override
	public boolean createMovie(MovieVO movieVo) throws Exception {
		// TODO Auto-generated method stub
		
		String release_date = movieVo.getRelease_date();
		//System.out.println(release_date.substring(0, 4));
		int year = Integer.parseInt(release_date.substring(0, 4));
		
		String title = movieVo.getTitle();
		
		final Map<String, Object> infoMap = new HashMap<String, Object>();
		infoMap.put("release_date",  release_date);
		infoMap.put("plot",  movieVo.getPlot());
		infoMap.put("actors", movieVo.getActors());
		infoMap.put("directors", movieVo.getDirectors());
		infoMap.put("genres", movieVo.getGenres());
		infoMap.put("rating",  movieVo.getRating());
	   
		System.out.println("Adding a new item...");
        PutItemOutcome outcome = table.putItem(new Item()
              .withPrimaryKey("year", year, "title", title)
              .withMap("info", infoMap));

        System.out.println("PutItem succeeded:\n" + outcome.getPutItemResult());

		return false;
	}

}
