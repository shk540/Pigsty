package com.cfoco.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.cfoco.dao.PigstyDao;
import com.cfoco.entity.Pigsty;
import com.cfoco.service.PigstyService;


@Service("pigstyService")
public class PigstyServiceImpl implements PigstyService{
	
	@Resource
	PigstyDao pigstyDao;
	
	@Override
	public int update(Pigsty pigsty) {
		// TODO Auto-generated method stub
		return pigstyDao.update(pigsty);
	}

	@Override
	public List<Pigsty> list(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigstyDao.list(map);
	}

	@Override
	public Long getTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigstyDao.getTotal(map);
	}

	@Override
	public int add(Pigsty pigsty) {
		// TODO Auto-generated method stub
		return pigstyDao.add(pigsty);
	}

	@Override
	public int del(Integer psid) {
		// TODO Auto-generated method stub
		return pigstyDao.del(psid);
	}

	@Override
	public Pigsty findByNo(String psno) {
		// TODO Auto-generated method stub
		return pigstyDao.findByNo(psno);
	}

	@Override
	public List<Pigsty> findstock(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigstyDao.findstock(map);
	}

}
