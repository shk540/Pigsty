package com.cfoco.dao;

import java.util.List;
import java.util.Map;



import com.cfoco.entity.Pigsty;

public interface PigstyDao {
	
	public int update(Pigsty pigsty);
	
	public List<Pigsty> list(Map<String,Object> map);
	
	public Long getTotal(Map<String,Object> map);
	
	public int add(Pigsty pigstyigsty);
	
	public int del(Integer psid);
	
	public Pigsty findByNo(String psno);
	
	public List<Pigsty> findstock(Map<String,Object> map);	
	
}
