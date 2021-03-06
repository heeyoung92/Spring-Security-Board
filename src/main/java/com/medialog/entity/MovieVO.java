package com.medialog.entity;

import java.util.List;

public class MovieVO {


	private int year;
	private String title;
	private String image_url;
	private double rating;
	private String plot;
	
	private List<String> actors;
	private List<String> directors;
	private List<String> genres;
	private String release_date;
	
	private double running_time_secs;
	private double rank;
	
	@Override
	public String toString() {
		return "MovieVO [title=" + title + " rating="+rating+" actors="+actors.toString()+" release_date="+release_date+"]";
	}
	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getImage_url() {
		return image_url;
	}

	public void setImage_url(String image_url) {
		this.image_url = image_url;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}
	
	public String getPlot() {
		return plot;
	}

	public void setPlot(String plot) {
		this.plot = plot;
	}
	


	public List<String> getActors() {
		return actors;
	}

	public void setActors(List<String> actors) {
		this.actors = actors;
	}
	public List<String> getDirectors() {
		return directors;
	}
	public void setDirectors(List<String> directors) {
		this.directors = directors;
	}
	public List<String> getGenres() {
		return genres;
	}
	public void setGenres(List<String> genres) {
		this.genres = genres;
	}
	public String getRelease_date() {
		return release_date;
	}
	public void setRelease_date(String release_date) {
		this.release_date = release_date;
	}
	public double getRank() {
		return rank;
	}
	public void setRank(double rank) {
		this.rank = rank;
	}
	public double getRunning_time_secs() {
		return running_time_secs;
	}
	public void setRunning_time_secs(double running_time_secs) {
		this.running_time_secs = running_time_secs;
	}


	
}
