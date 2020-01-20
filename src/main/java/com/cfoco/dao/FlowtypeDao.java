package com.cfoco.dao;

import java.util.List;
import java.util.Map;

import com.cfoco.entity.Flowtype;

public interface FlowtypeDao {
	
	public int update(Flowtype flowtype);
	
	public List<Flowtype> list(Map<String,Object> map);
	
	public Long getTotal(Map<String,Object> map);
	
	public int add(Flowtype flowtype);
	
	public int del(Integer typeid);
	
	public Flowtype findbyname(String typename);
}
