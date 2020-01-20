package com.cfoco.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.cfoco.dao.VaccineDao;
import com.cfoco.entity.Vaccine;
import com.cfoco.service.VaccineService;

@Service("vaccineService")
public class VaccineServiceImpl implements VaccineService{
	
	@Resource
	private VaccineDao vaccineDao;
	
	@Override
	public List<Vaccine> list(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return vaccineDao.list(map);
	}

	@Override
	public Long getTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return vaccineDao.getTotal(map);
	}

	@Override
	public int add(Vaccine Vaccine) {
		// TODO Auto-generated method stub
		return vaccineDao.add(Vaccine);
	}

	@Override
	public int update(Vaccine Vaccine) {
		// TODO Auto-generated method stub
		return vaccineDao.update(Vaccine);
	}

	@Override
	public int del(Integer breid) {
		// TODO Auto-generated method stub
		return vaccineDao.del(breid);
	}
}
