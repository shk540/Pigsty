package com.cfoco.service;

import java.util.List;
import java.util.Map;
import com.cfoco.entity.Pigsbre;

public interface PigsbreService {
	
	public List<Pigsbre> list(Map<String,Object> map);
	
	public Long getTotal(Map<String,Object> map);
	
	public Pigsbre findByno(Map<String,Object> map);
	
	public int add(Pigsbre pigsbre);
	
	public int update(Integer id);	
	
	public List<Pigsbre> psnoCountList(Map<String,Object> map);
	
	public List<Pigsbre> usernameCountList(Map<String,Object> map);	
	
	public List<Pigsbre> psnousername(String psno);
	
	public int del(Integer breid);
}
