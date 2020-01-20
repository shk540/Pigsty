package com.cfoco.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


import com.cfoco.entity.Flowtype;
import com.cfoco.entity.PageBean;
import com.cfoco.service.FlowtypeService;
import com.cfoco.util.ResponseUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/flowtype")
public class FlowtypeController {

	@Resource
	private FlowtypeService flowtypeService;
	
	@RequestMapping("/list")
	public String list(@RequestParam(value="page",required=false)String page,@RequestParam(value="rows",required=false)String rows,HttpServletResponse response)throws Exception{
		PageBean pageBean=new PageBean(Integer.parseInt(page),Integer.parseInt(rows));
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<Flowtype> typeList=flowtypeService.list(map);
		Long total=flowtypeService.getTotal(map);
		JSONObject result=new JSONObject();	 		
		//JsonConfig jsonConfig=new JsonConfig();
		//jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd hh:mm:ss"));
		JSONArray jsonArray=JSONArray.fromObject(typeList);
		result.put("rows", jsonArray);
		result.put("total", total);
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/save")
	public String save(Flowtype flowtype,HttpServletResponse response)throws Exception{
		int resultTotal=0; // 操作的记录条数
		if(flowtype.getTypeid()==null){
			resultTotal=flowtypeService.add(flowtype);
		}else{
			resultTotal=flowtypeService.update(flowtype);
		}
		JSONObject result=new JSONObject();
		if(resultTotal>0){ // 执行成功
			result.put("success", true);
		}else{
			result.put("success", false);
		}
		ResponseUtil.write(response, result);
		return null;
	}	
	
	@RequestMapping("/delete")
	public String delete(@RequestParam(value="ids")String ids,HttpServletResponse response)throws Exception{
		JSONObject result=new JSONObject();
		String []idsStr=ids.split(",");
		for(int i=0;i<idsStr.length;i++){
			flowtypeService.del(Integer.parseInt(idsStr[i]));
		}
		result.put("success", true);
		ResponseUtil.write(response, result);
		return null;
	}	

	public String flowtypeComboList(HttpServletResponse response)throws Exception{
		JSONArray jsonArray=new JSONArray();
		@RequestMapping("/findflowtype")
		List<Flowtype> flowtypeList=flowtypeService.list(null);		
		JSONArray rows=JSONArray.fromObject(flowtypeList);
		jsonArray.addAll(rows);
		ResponseUtil.write(response, jsonArray);
		return null;
	}
}