package com.cfoco.service;

import java.util.List;
import java.util.Map;

import com.cfoco.entity.Breeder;

public interface BreederService {
	
	public Breeder login(Breeder breeder);
	
	public int update(Breeder breeder);
	
	public List<Breeder> list(Map<String,Object> map);
	
	public Long getTotal(Map<String,Object> map);
	
	public int add(Breeder breeder);
	
	public int del(Integer breid);
	
	public Breeder findByNo(String username);

}
