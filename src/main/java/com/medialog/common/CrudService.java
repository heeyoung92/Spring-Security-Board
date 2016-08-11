package com.medialog.common;

public interface CrudService<T, Key> {

	public T findOne(Key id);
	
	public boolean create(T entity);
	
	public boolean update(T entity);

	public boolean exists(Key id);

	public boolean delete(Key id);

}
