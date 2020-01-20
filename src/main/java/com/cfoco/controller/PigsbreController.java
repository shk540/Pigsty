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

import com.cfoco.entity.PageBean;
import com.cfoco.entity.Pigsbre;
import com.cfoco.service.PigsbreService;
import com.cfoco.util.ResponseUtil;
import com.cfoco.util.StringUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@Controller
@RequestMapping("/pigsbre")
public class PigsbreController {

	@Resource
	private PigsbreService pigsbreService;
	
	@InitBinder
	 public void initBinder(WebDataBinder binder) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));   //true:允许输入空值，false:不能为空值
	}
	
	@RequestMapping("/list")
	public String list(@RequestParam(value="page",required=false)String page,@RequestParam(value="rows",required=false)String rows,Pigsbre s_pigsbre,HttpServletResponse response)throws Exception{
		PageBean pageBean=new PageBean(Integer.parseInt(page),Integer.parseInt(rows));
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("psno",StringUtil.formatLike(s_pigsbre.getPsno()));
		map.put("username",StringUtil.formatLike(s_pigsbre.getUsername()));
		map.put("if_valid",s_pigsbre.getIf_valid());
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<Pigsbre> pigsbreList=pigsbreService.list(map);
		Long total=pigsbreService.getTotal(map);
		JSONObject result=new JSONObject();	 		
		JsonConfig jsonConfig=new JsonConfig();
		jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd"));
		JSONArray jsonArray=JSONArray.fromObject(pigsbreList,jsonConfig);
		result.put("rows", jsonArray);
		result.put("total", total);
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/list_psno")
	public String list_psno(@RequestParam(value="page",required=false)String page,@RequestParam(value="rows",required=false)String rows,HttpServletResponse response)throws Exception{
		PageBean pageBean=new PageBean(Integer.parseInt(page),Integer.parseInt(rows));
		Map<String,Object> map=new HashMap<String,Object>();		
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<Pigsbre> psnoList=pigsbreService.psnoCountList(map);
		int total=pigsbreService.psnoCountList(null).size();
		//获取列名
		//List<Query> titleList=pigsbreService.psnoList();
		JSONObject result=new JSONObject();	 		
		//JsonConfig jsonConfig=new JsonConfig();
		//jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd"));
		JSONArray jsonArray=JSONArray.fromObject(psnoList);
		//JSONArray jsonArray_title=JSONArray.fromObject(titleList);
		result.put("rows", jsonArray);
		result.put("total", total);
		//result.put("title",jsonArray_title);
		ResponseUtil.write(response, result);
		return null;
	}
	@RequestMapping("/list_username")
	public String list_username(@RequestParam(value="page",required=false)String page,@RequestParam(value="rows",required=false)String rows,HttpServletResponse response)throws Exception{
		PageBean pageBean=new PageBean(Integer.parseInt(page),Integer.parseInt(rows));
		Map<String,Object> map=new HashMap<String,Object>();		
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<Pigsbre> usernameList=pigsbreService.usernameCountList(map);
		int total=pigsbreService.usernameCountList(null).size();
		JSONObject result=new JSONObject();	 		
		//JsonConfig jsonConfig=new JsonConfig();
		//jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd"));
		JSONArray jsonArray=JSONArray.fromObject(usernameList);
		result.put("rows", jsonArray);
		result.put("total", total);
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/find_brename")
	public String find_brename(@RequestParam(value="psno",required=false)String psno,HttpServletResponse response)throws Exception{		
		List<Pigsbre> brenameListt=pigsbreService.psnousername(psno);		
		JSONArray jsonArray=JSONArray.fromObject(brenameListt);
		ResponseUtil.write(response,jsonArray);
		return null;
	}
	
	@RequestMapping("/save")
	public String save(Pigsbre pigsbre,HttpServletResponse response)throws Exception{
		
		int resultTotal=0;
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("psno",pigsbre.getPsno());
		map.put("username",pigsbre.getUsername());
		JSONObject result=new JSONObject();
		String if_exist=null;
		Pigsbre pigsbre2=pigsbreService.findByno(map);
		
		if(pigsbre2!=null) {
			if_exist=pigsbre2.getPsno();
		}
		
		if(pigsbre.getId()==null){
			if(StringUtil.isEmpty(if_exist)) {
				resultTotal=pigsbreService.add(pigsbre);				
			}else 
			{
				result.put("error","已存在有效分配关系，请核实！");
			}
		}else{
			//resultTotal=pigsbreService.update(pigsbre);
		}
		
		if(resultTotal>0){
			result.put("success",true);
		}else{
			result.put("success",false);	
		}
		
		ResponseUtil.write(response,result);
		return null;
	}	
	
	@RequestMapping("/modify")
	public String delete(@RequestParam(value="ids")String ids,HttpServletResponse response)throws Exception{
		JSONObject result=new JSONObject();
		String []idsStr=ids.split(",");
		for(int i=0;i<idsStr.length;i++){
			pigsbreService.update(Integer.parseInt(idsStr[i]));
		}
		result.put("success", true);
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/delete")
	public String del(@RequestParam(value="ids")String ids,HttpServletResponse response)throws Exception{
		JSONObject result=new JSONObject();
		String []idsStr=ids.split(",");
		for(int i=0;i<idsStr.length;i++){
			pigsbreService.del(Integer.parseInt(idsStr[i]));
		}
		result.put("success", true);
		ResponseUtil.write(response, result);
		return null;
	}
}