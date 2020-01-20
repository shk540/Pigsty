package com.cfoco.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.cfoco.dao.TungDao;
import com.cfoco.entity.Tung;
import com.cfoco.service.TungService;

@Service("tungService")
public class TungServiceImpl implements TungService{
	
	@Resource
	private TungDao tungDao;
	@Override
	public List<Tung> list() {
		// TODO Auto-generated method stub
		return tungDao.list();
	}

}
