package com.cfoco.service;

import java.util.List;
import java.util.Map;

import com.cfoco.entity.Pigstyflow;

public interface PigstyflowService {
	
	public List<Pigstyflow> list(Map<String,Object> map);
	
	public Long getTotal(Map<String,Object> map);
	
	public int insert(Pigstyflow pigstyflow);
	
	public int update(Pigstyflow pigstyflow);
	
	public Pigstyflow findflowid(String flowid);
	
	public int findpsno(Map<String,Object> map);
	
	public List<Pigstyflow> flowlist(Map<String,Object> map);
	
	public Long flowcount(Map<String,Object> map);
	
	public List<Pigstyflow> flowbypsno(Map<String,Object> map);
	
	public List<Pigstyflow> listbat(Map<String,Object> map);
	
	public int insertbat(List<Pigstyflow> list);
	
	public int delete(String flowid);
	
	public List<Pigstyflow> listdays(String flowids);

}
