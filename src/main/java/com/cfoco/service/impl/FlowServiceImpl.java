package com.cfoco.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.cfoco.dao.FlowDao;
import com.cfoco.entity.Flow;
import com.cfoco.service.FlowService;

public class FlowServiceImpl implements FlowService{
	
	@Resource
	private FlowDao flowDao;
	
	@Override
	public List<Flow> flowlist(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return flowDao.flowlist(map);
	}	
}