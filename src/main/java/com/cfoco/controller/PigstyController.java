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

import com.cfoco.entity.Pigsty;
import com.cfoco.entity.PageBean;
import com.cfoco.service.PigstyService;
import com.cfoco.util.ResponseUtil;
import com.cfoco.util.StringUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/pigsty")
public class PigstyController {

	@Resource
	private PigstyService pigstyService;
	
	@InitBinder
	 public void initBinder(WebDataBinder binder) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));   //true:允许输入空值，false:不能为空值
	}
	
	@RequestMapping("/list")
	public String list(@RequestParam(value="page",required=false)String page,@RequestParam(value="rows",required=false)String rows,Pigsty s_pigsty,HttpServletResponse response)throws Exception{
		PageBean pageBean=new PageBean(Integer.parseInt(page),Integer.parseInt(rows));
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("psno", s_pigsty.getPsno());	
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<Pigsty> pigstyList=pigstyService.list(map);
		Long total=pigstyService.getTotal(map);
		//获取页脚数据(合计与平均数)
		List<Pigsty> pisList=pigstyService.list(null);
		Integer sum=0;
		int avg=0;
		for(Pigsty pigsty:pisList) {
			sum+=pigsty.getPsstock();
		}
		avg=sum/32;
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("psno","Total");
		jsonObject.put("psstock",sum);
		
		JSONArray jsonA=new JSONArray();
		jsonA.add(jsonObject);
		
		jsonObject.clear();
		jsonObject.put("psno","Avg");
		jsonObject.put("psstock",avg);
		jsonA.add(jsonObject);
		
		JSONObject result=new JSONObject();	 		
		//JsonConfig jsonConfig=new JsonConfig();
		//jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd hh:mm:ss"));
		JSONArray jsonArray=JSONArray.fromObject(pigstyList);
		result.put("rows", jsonArray);
		result.put("total", total);
		result.put("footer",jsonA);
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/liststock")
	public String liststock(@RequestParam(value="create_time",required=false)String create_time,HttpServletResponse response)throws Exception{
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("create_time",create_time+" 23:59:59");
		List<Pigsty> stockList=pigstyService.findstock(map);
		JSONArray jsonArray=JSONArray.fromObject(stockList);
		ResponseUtil.write(response, jsonArray);
		return null;
	}
	
	@RequestMapping("/save")
	public String save(Pigsty pigsty,HttpServletResponse response)throws Exception{
		int resultTotal=0; // 操作的记录条数
		if(pigsty.getPsid()==null){
			pigsty.setPsstock(0);
			resultTotal=pigstyService.add(pigsty);
		}else{
			resultTotal=pigstyService.update(pigsty);
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
			pigstyService.del(Integer.parseInt(idsStr[i]));
		}
		result.put("success", true);
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/findpigsty")
	public String pigstyComboList(@RequestParam(value="tuno",required=false)String tuno,HttpServletResponse response)throws Exception{
		JSONArray jsonArray=new JSONArray();
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("tuno",tuno);
		List<Pigsty> pigstyList=pigstyService.list(map);
		JSONArray rows=JSONArray.fromObject(pigstyList);
		jsonArray.addAll(rows);
		ResponseUtil.write(response, jsonArray);
		return null;
	}
}