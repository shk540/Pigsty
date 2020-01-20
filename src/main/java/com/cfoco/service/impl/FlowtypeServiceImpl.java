package com.cfoco.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.cfoco.dao.FlowtypeDao;
import com.cfoco.entity.Flowtype;
import com.cfoco.service.FlowtypeService;


@Service("flowtypeService")
public class FlowtypeServiceImpl implements FlowtypeService{
	
	@Resource
	FlowtypeDao flowtypeDao;
	
	@Override
	public int update(Flowtype flowtype) {
		// TODO Auto-generated method stub
		return flowtypeDao.update(flowtype);
	}

	@Override
	public List<Flowtype> list(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return flowtypeDao.list(map);
	}

	@Override
	public Long getTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return flowtypeDao.getTotal(map);
	}

	@Override
	public int add(Flowtype flowtype) {
		// TODO Auto-generated method stub
		return flowtypeDao.add(flowtype);
	}

	@Override
	public int del(Integer psid) {
		// TODO Auto-generated method stub
		return flowtypeDao.del(psid);
	}

	@Override
	public Flowtype findbyname(String typename) {
		// TODO Auto-generated method stub
		return flowtypeDao.findbyname(typename);
	}

}
