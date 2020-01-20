package com.cfoco.dao;

import java.util.List;
import java.util.Map;

import com.cfoco.entity.Flow;

public interface FlowDao {
	
	public List<Flow> flowlist(Map<String,Object> map);

}
