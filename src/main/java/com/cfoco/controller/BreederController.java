package com.cfoco.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cfoco.entity.Breeder;
import com.cfoco.entity.PageBean;
import com.cfoco.service.BreederService;
import com.cfoco.service.FlowtypeService;
import com.cfoco.util.ResponseUtil;
import com.cfoco.util.StringUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@Controller
@RequestMapping("/breeder")
public class BreederController {

	@Resource
	private BreederService breederService;
	
	@Resource FlowtypeService flowtypeService;
	
	@RequestMapping("/login")
	public String login(Breeder breeder,HttpServletRequest request){
		
		Breeder resultbreeder=breederService.login(breeder);
		
		if(resultbreeder==null){
			request.setAttribute("currentBreeder",breeder);
			request.setAttribute("errorMsg", "用户名或密码不正确！");
			return "login";
		}else{
			HttpSession session=request.getSession();
			ServletContext application= request.getSession().getServletContext();
			application.setAttribute("currentBreederapp",resultbreeder);
			
			//RequestContextUtils.getWebApplicationContext(request).getServletContext();
			session.setAttribute("currentBreeder",resultbreeder);
			session.setMaxInactiveInterval(-1);
			return "redirect:/main.jsp";
		}
	}
	
	@RequestMapping("/modifypass")
	public String modifyPassword(Breeder breeder,HttpServletResponse response)throws Exception{
		int resultTotal=breederService.update(breeder);
		JSONObject result=new JSONObject();
		if(resultTotal>0){ // 执行成功
			result.put("success", true);
		}else{
			result.put("success", false);
		}
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session)throws Exception{
		session.invalidate();
		return "redirect:/login.jsp";
	}
	
	@RequestMapping("/list")
	public String list(@RequestParam(value="page",required=false)String page,@RequestParam(value="rows",required=false)String rows,Breeder s_breeder,HttpServletResponse response)throws Exception{
		PageBean pageBean=new PageBean(Integer.parseInt(page),Integer.parseInt(rows));
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("brename", StringUtil.formatLike(s_breeder.getBrename()));
		map.put("cardno", StringUtil.formatLike(s_breeder.getCardno()));
		map.put("if_valid",s_breeder.getIf_valid());
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<Breeder> breederList=breederService.list(map);
		Long total=breederService.getTotal(map);
		JSONObject result=new JSONObject();	 		
		JsonConfig jsonConfig=new JsonConfig();
		jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd hh:mm:ss"));
		JSONArray jsonArray=JSONArray.fromObject(breederList,jsonConfig);
		result.put("rows", jsonArray);
		result.put("rows", jsonArray);
		result.put("total", total);
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/save")
	public String save(Breeder breeder,HttpServletResponse response)throws Exception{
		int resultTotal=0; // 操作的记录条数
		if(breeder.getBreid()==null){
			resultTotal=breederService.add(breeder);
		}else{
			resultTotal=breederService.update(breeder);
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
			breederService.del(Integer.parseInt(idsStr[i]));
		}
		result.put("success", true);
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/findbreeder")
	public String breederComboList(@RequestParam(value="if_valid",required=false)String if_valid,HttpServletResponse response)throws Exception{
		JSONArray jsonArray=new JSONArray();
		Map<String,Object> map=new HashMap<String,Object>();
		if(if_valid==null){
			map.put("if_valid",1);
		}else {
			map.put("if_valid",Integer.parseInt(if_valid));
		}
		List<Breeder> breederList=breederService.list(map);
		JSONArray rows=JSONArray.fromObject(breederList);
		jsonArray.addAll(rows);
		ResponseUtil.write(response, jsonArray);
		return null;
	}
	
	@RequestMapping("/findbrename")
	public String brenameList(@RequestParam(value="username",required=false)String username,HttpServletResponse response)throws Exception{
		Breeder breeder=breederService.findByNo(username);
		JSONObject json=JSONObject.fromObject(breeder);
		ResponseUtil.write(response,json);
		return null;
	}
}
