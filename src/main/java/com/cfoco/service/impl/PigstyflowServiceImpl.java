package com.cfoco.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.cfoco.dao.PigstyflowDao;
import com.cfoco.entity.Pigstyflow;
import com.cfoco.service.PigstyflowService;

@Service("pigstyflowService")
public class PigstyflowServiceImpl implements PigstyflowService{
	
	@Resource
	PigstyflowDao pigstyflowDao;
	
	@Override
	public List<Pigstyflow> list(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigstyflowDao.list(map);
	}

	@Override
	public Long getTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigstyflowDao.getTotal(map);
	}

	@Override
	public int insert(Pigstyflow pigstyflow) {
		// TODO Auto-generated method stub
		return pigstyflowDao.insert(pigstyflow);
	}

	@Override
	public int update(Pigstyflow pigstyflow) {
		// TODO Auto-generated method stub
		return pigstyflowDao.update(pigstyflow);
	}

	@Override
	public Pigstyflow findflowid(String flowid) {
		// TODO Auto-generated method stub
		return pigstyflowDao.findflowid(flowid);
	}

	@Override
	public int findpsno(Map<String,Object> map) {
		// TODO Auto-generated method stub
		return pigstyflowDao.findpsno(map);
	}

	@Override
	public List<Pigstyflow> flowlist(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigstyflowDao.flowlist(map);
	}

	@Override
	public Long flowcount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigstyflowDao.flowcount(map);
	}

	@Override
	public List<Pigstyflow> flowbypsno(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigstyflowDao.flowbypsno(map);
	}

	@Override
	public List<Pigstyflow> listbat(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pigstyflowDao.listbat(map);
	}

	@Override
	public int insertbat(List<Pigstyflow> list) {
		// TODO Auto-generated method stub
		return pigstyflowDao.insertbat(list);
	}

	@Override
	public int delete(String flowid) {
		// TODO Auto-generated method stub
		return pigstyflowDao.delete(flowid);
	}

	@Override
	public List<Pigstyflow> listdays(String flowids) {
		// TODO Auto-generated method stub
		return pigstyflowDao.listdays(flowids);
	}

}
