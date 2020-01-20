package com.cfoco.service;

import java.util.List;
import java.util.Map;

import com.cfoco.entity.Vaccine;

public interface VaccineService {
	
	public List<Vaccine> list(Map<String,Object> map);
	
	public Long getTotal(Map<String,Object> map);
	
	public int add(Vaccine Vaccine);
	
	public int update(Vaccine Vaccine);
	
	public int del(Integer breid);
	
}
