package com.cfoco.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.cfoco.dao.PigsbreDao;
import com.cfoco.entity.Pigsbre;
import com.cfoco.service.PigsbreService;

@Service("pigsbreService")
public class PigsbreServiceImpl implements PigsbreService{
	
	@Resource
	private PigsbreDao pigsbreDao;
	
	@Override
	public List<Pigsbre> list(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigsbreDao.list(map);
	}

	@Override
	public Long getTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigsbreDao.getTotal(map);
	}

	@Override
	public Pigsbre findByno(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigsbreDao.findByno(map);
	}

	@Override
	public int add(Pigsbre pigsbre) {
		// TODO Auto-generated method stub
		return pigsbreDao.add(pigsbre);
	}

	@Override
	public int update(Integer id) {
		// TODO Auto-generated method stub
		return pigsbreDao.update(id);
	}

	@Override
	public List<Pigsbre> psnoCountList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigsbreDao.psnoCountList(map);
	}

	@Override
	public List<Pigsbre> usernameCountList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigsbreDao.usernameCountList(map);
	}

	@Override
	public List<Pigsbre> psnousername(String psno) {
		// TODO Auto-generated method stub
		return pigsbreDao.psnousername(psno);
	}

	@Override
	public int del(Integer breid) {
		// TODO Auto-generated method stub
		return pigsbreDao.del(breid);
	}
}