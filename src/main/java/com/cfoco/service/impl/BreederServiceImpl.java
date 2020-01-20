package com.cfoco.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.cfoco.dao.BreederDao;
import com.cfoco.entity.Breeder;
import com.cfoco.service.BreederService;

@Service("breederService")
public class BreederServiceImpl implements BreederService{
	
	@Resource
	private BreederDao breederDao;
	
	@Override
	public Breeder login(Breeder breeder) {
		// TODO Auto-generated method stub
		return breederDao.login(breeder);
	}

	@Override
	public int update(Breeder breeder) {
		// TODO Auto-generated method stub
		return breederDao.update(breeder);
	}

	@Override
	public List<Breeder> list(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return breederDao.list(map);
	}

	@Override
	public Long getTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return breederDao.getTotal(map);
	}

	@Override
	public int add(Breeder breeder) {
		// TODO Auto-generated method stub
		return breederDao.add(breeder);
	}

	@Override
	public int del(Integer breid) {
		// TODO Auto-generated method stub
		return breederDao.del(breid);
	}

	@Override
	public Breeder findByNo(String username) {
		// TODO Auto-generated method stub
		return breederDao.findByNo(username);
	}

}
