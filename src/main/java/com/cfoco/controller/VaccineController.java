package com.cfoco.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.alibaba.druid.sql.visitor.functions.Now;
import com.cfoco.entity.PageBean;
import com.cfoco.entity.Vaccine;
import com.cfoco.service.VaccineService;
import com.cfoco.util.ResponseUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@Controller
@RequestMapping("/vaccine")
public class VaccineController {

	@Resource
	private VaccineService vaccineService;
	
	@InitBinder
	 public void initBinder(WebDataBinder binder) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));   //true:允许输入空值，false:不能为空值
	}
	
	@RequestMapping("/list")
	public String list(@RequestParam(value="page",required=false)String page,@RequestParam(value="rows",required=false)String rows,HttpServletResponse response,@RequestParam(value="begin_time",required=false)String begin_time,@RequestParam(value="end_time",required=false)String end_time)throws Exception{
		Map<String,Object> map=new HashMap<String,Object>();
		PageBean pageBean=new PageBean(Integer.parseInt(page),Integer.parseInt(rows));
		
		map.put("begin_time",begin_time);
		map.put("end_time",end_time);
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		
		List<Vaccine> vaccineList=vaccineService.list(map);
		Long total;
		total=vaccineService.getTotal(map);
		
		JSONObject result=new JSONObject();
		JsonConfig jsonConfig=new JsonConfig();
		jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd"));
		JSONArray jsonArray=JSONArray.fromObject(vaccineList,jsonConfig);
		
		result.put("rows", jsonArray);
		result.put("total",total);
		
		ResponseUtil.write(response, result);
		return null;
	}	
	
	@RequestMapping("/save")
	public String save(Vaccine vaccine,HttpServletResponse response)throws Exception{
		int resultTotal=0; // 操作的记录条数
		if(vaccine.getId()==null){
			resultTotal=vaccineService.add(vaccine);
		}else{
			resultTotal=vaccineService.update(vaccine);
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
	public String delete(@RequestParam(value="id")String id,HttpServletResponse response)throws Exception{
		vaccineService.del(Integer.parseInt(id));
		JSONObject result=new JSONObject();
		result.put("success", true);
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/update")
	public String update(@RequestParam(value="ids")String ids,HttpServletResponse response)throws Exception{
		JSONObject result=new JSONObject();
		String []idsStr=ids.split(",");
		Vaccine vaccine=new Vaccine();
		
		for(int i=0;i<idsStr.length;i++){
			vaccine.setId(Integer.parseInt(idsStr[i]));
			vaccine.setUsername("zhangxl");
			vaccineService.update(vaccine);
		}
		result.put("success", true);
		ResponseUtil.write(response, result);
		return null;
	}
}
