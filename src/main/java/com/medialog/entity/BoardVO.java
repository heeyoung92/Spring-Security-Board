package com.medialog.entity;

import javax.xml.crypto.Data;

public class BoardVO {

	private int board_idx;
	private String board_title;
	private String board_contents;
	private int hit_cnt;
	private Data crea_date;
//	private String writer;
//	private String password;
	private int parent_idx;
	
	private UserVO board_user;
	
	public UserVO getBoard_user() {
		return board_user;
	}
	public void setBoard_user(UserVO board_user) {
		this.board_user = board_user;
	}
	private BoardVO parent_board;
	
	public int getBoard_idx() {
		return board_idx;
	}
	public void setBoard_idx(int board_idx) {
		this.board_idx = board_idx;
	}
	public String getBoard_title() {
		return board_title;
	}
	public void setBoard_title(String board_title) {
		this.board_title = board_title;
	}
	public String getBoard_contents() {
		return board_contents;
	}
	public void setBoard_contents(String board_contents) {
		this.board_contents = board_contents;
	}
	public int getHit_cnt() {
		return hit_cnt;
	}
	public void setHit_cnt(int hit_cnt) {
		this.hit_cnt = hit_cnt;
	}
	public Data getCrea_date() {
		return crea_date;
	}
	public void setCrea_date(Data crea_date) {
		this.crea_date = crea_date;
	}
	public int getParent_idx() {
		return parent_idx;
	}
	public void setParent_idx(int parent_idx) {
		this.parent_idx = parent_idx;
	}

	public BoardVO getParent_board() {
		return parent_board;
	}
	public void setParent_board(BoardVO parent_board) {
		this.parent_board = parent_board;
	}
	
	@Override
	public String toString() {
		return "BoardVO [board_idx=" + board_idx + ", board_title=" + board_title + ", board_contents" + board_contents 
				+"hit_cnt= "+ hit_cnt + "crea_date= "+ crea_date + "parent_idx= " + parent_idx + "board_user" + board_user.toString();
	}
}
