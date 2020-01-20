package com.cfoco.controller;

import static org.hamcrest.CoreMatchers.nullValue;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.crypto.Data;

import org.aspectj.weaver.AjAttribute.PrivilegedAttribute;
import org.aspectj.weaver.ast.And;
import org.springframework.beans.factory.support.ReplaceOverride;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cfoco.entity.Pigstyflow;
import com.cfoco.entity.PageBean;
import com.cfoco.entity.Pigsty;
import com.cfoco.service.FlowtypeService;
import com.cfoco.service.PigsbreService;
import com.cfoco.service.PigstyService;
import com.cfoco.service.PigstyflowService;
import com.cfoco.util.DateUtil;
import com.cfoco.util.MaptoEntity;
import com.cfoco.util.ResponseUtil;
import com.cfoco.util.StringUtil;

import net.sf.ezmorph.primitive.AbstractIntegerMorpher;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@Controller
@RequestMapping("/pigstyflow")
public class PigstyflowController{

	@Resource
	private PigstyflowService pigstyflowService;
	
	@Resource 
	private FlowtypeService flowtypeService;
	
	@Resource
	private PigstyService pigstyService;
	
	@Resource
	private PigsbreService pigsbreService;
	
	@InitBinder
	 public void initBinder(WebDataBinder binder) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));   //true:允许输入空值，false:不能为空值
	}
	
	@RequestMapping("/list")
	public String list(@RequestParam(value="page",required=false)String page,@RequestParam(value="rows",required=false)String rows,Pigstyflow s_pigstyflow,HttpServletResponse response)throws Exception{
		
		PageBean pageBean=new PageBean(Integer.parseInt(page),Integer.parseInt(rows));
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("psno",s_pigstyflow.getPsno());	
		map.put("typeno",s_pigstyflow.getTypeno());	
		map.put("if_check",s_pigstyflow.getIf_check());
		map.put("is_bat",s_pigstyflow.getIs_bat());
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<Pigstyflow> pigstyflowList=pigstyflowService.list(map);	
		Long total=pigstyflowService.getTotal(map);		
		JSONObject result=new JSONObject();	 		
		JsonConfig jsonConfig=new JsonConfig();
		jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd hh:mm:ss"));
		JSONArray jsonArray=JSONArray.fromObject(pigstyflowList,jsonConfig);
		result.put("rows", jsonArray);
		result.put("total", total);		
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/listbat")
	public String listbat(String tuno,@RequestParam(value="typeno",required=false)String typeno,@RequestParam(value="begin_time",required=false)String begin_time,@RequestParam(value="end_time",required=false)String end_time,HttpServletResponse response)throws Exception{
		
		//动态生成列头
		Map<String,Object> map_bat=new HashMap<String,Object>();
		Map<String,Object> map_tu=new HashMap<String,Object>();
		Map<String,Object> map_data=new HashMap<String,Object>();
		LinkedHashMap<String,String> map_title=new LinkedHashMap<String,String>();				
		List<Pigstyflow> flowList=new ArrayList<>();
		List<Pigsty> pigsList=new ArrayList<>();
		List<Map<String,Object>> list_data=new ArrayList<Map<String, Object>>();
		JSONObject result=new JSONObject();	
		int total=0;
		
		map_bat.put("is_bat","1");
		
		map_tu.clear();
		map_title.clear();
		list_data.clear();
		map_data.clear();
		
		map_tu.put("tuno",tuno);			
		pigsList=pigstyService.list(map_tu);
		map_bat.put("tuno",tuno);
		map_bat.put("typeno",typeno);
		map_bat.put("begin_time",begin_time);
		map_bat.put("end_time",end_time +" 23:59:59");
		flowList=pigstyflowService.listbat(map_bat);
		
		for(Pigsty pigsty:pigsList) {
			map_title.put("create_time","日期");
			map_title.put("typeno","流转类型");
			map_title.put("typename","流转类型");
			map_title.put(pigsty.getPsno(),pigsty.getPsno());	
		}
		
		for(int j=0;j<flowList.size();j++) {			
			if(j==0) {
				//获取归属时间
				String dateStr=flowList.get(j).getFlowid().substring(0,8);
				String dateStrf=dateStr.substring(0,4)+"-"+dateStr.substring(4,6)+"-"+dateStr.substring(6);
				Date ownday=DateUtil.formatString(dateStrf,"yyyy-MM-dd");
				map_data.put("create_time",ownday);
				map_data.put("typeno",flowList.get(j).getTypeno());
				map_data.put("typename",flowList.get(j).getTypename());
				map_data.put("flowid",flowList.get(j).getFlowid());
				for(Pigsty pigsty:pigsList) {
					map_data.put(pigsty.getPsno(),null);	
				}
				map_data.put(flowList.get(j).getPsno(),flowList.get(j).getAmount());
				
			}else if(!(flowList.get(j).getTypename().equals((flowList.get(j-1).getTypename()))) || !(flowList.get(j).getFlowid().substring(0,8).equals(flowList.get(j-1).getFlowid().substring(0,8)))) {	
				/* //判断是否存在同一天的元素
				boolean if_exist=false;
				Integer ii=0;
				for(int i=0;i<list_data.size();i++) {
					
					String fflowid=flowList.get(j).getFlowid().substring(0,8);
					String lflowid=list_data.get(i).get("flowid").toString().substring(0,8);
					
					if(fflowid.equals(lflowid) && flowList.get(j).getTypename().equals(list_data.get(i).get("typename"))){
						if_exist=true;
						ii=i;
						break;
					}else {
						if_exist=false;
					}						
				}					
				 if(if_exist) {	
					 list_data.get(ii).put(flowList.get(j).getPsno(),flowList.get(j).getAmount());					 
				 }else {*/
					 Map<String,Object> dis = new HashMap<>();
					 dis.putAll(map_data);//对象拷贝
					 list_data.add(dis);
					 map_data.clear();
					 String dateStr=flowList.get(j).getFlowid().substring(0,8);
					 String dateStrf=dateStr.substring(0,4)+"-"+dateStr.substring(4,6)+"-"+dateStr.substring(6);
					 Date ownday=DateUtil.formatString(dateStrf,"yyyy-MM-dd");
					 map_data.put("create_time",ownday);
					 map_data.put("typeno",flowList.get(j).getTypeno());
					 map_data.put("typename",flowList.get(j).getTypename());	
					 map_data.put("flowid",flowList.get(j).getFlowid());
					 for(Pigsty pigsty:pigsList) {
						 map_data.put(pigsty.getPsno(),null);
					 }	
					 map_data.put(flowList.get(j).getPsno(),flowList.get(j).getAmount());
				 //}
			}else{
				  map_data.put(flowList.get(j).getPsno(),flowList.get(j).getAmount());
			}
		}
		list_data.add(map_data);
		
		if(list_data!=null && !list_data.isEmpty() && map_data.size()>0)
		{
			total=list_data.size();
		}
		else {
			total=0;
			list_data.clear();
		}
		/*List<Map<String,Object>> list=new ArrayList<Map<String,Object>>();
		if(pageBean.getStart()+pageBean.getPageSize()>total && total>0) {
			list=list_data.subList(pageBean.getStart(),total);
		}else {
			list=list_data.subList(pageBean.getStart(),pageBean.getPageSize());				
		}*/
		result.put("title",map_title);	
		JsonConfig jsonConfig=new JsonConfig();
		jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd"));
		JSONArray jsonArray=JSONArray.fromObject(list_data,jsonConfig);	
		result.put("rows",jsonArray);			
		
		//jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd hh:mm:ss"));
		//JSONArray jsonArray=JSONArray.fromObject(pigstyflowList,jsonConfig);		
		result.put("total",total);		
		ResponseUtil.write(response,result);
		return null;
	}
	@RequestMapping("/listdays")
	public String listdays(HttpServletRequest request,HttpServletResponse response)throws Exception{
		
		//动态生成列头
		String params=request.getParameter("select");
		String paramss="["+request.getParameter("select")+"]";
		String tuno=request.getParameter("tuno");
		List<Map<String,Object>> flowList=new ArrayList<Map<String,Object>>();
		
		if(params!=null && params.length()>2) {
		   flowList=getbatlist(paramss);
		
	    //校验数据
		    List<Pigstyflow> pigsflowList=new ArrayList<Pigstyflow>();
			
			String flowids="";	
		    for(Map<String,Object> flow:flowList){
		    	flowids+=flow.get("flowid")+",";
		    }
		    if(flowids!=null) {
		    	flowids=flowids.substring(0,flowids.length()-1);		    	
		    }else {
		        return null;
		    }
		    pigsflowList=pigstyflowService.listdays(flowids);			    
		    
	    //生成数据
			Map<String,Object> map_tu=new HashMap<String,Object>();
			Map<String,Object> map_data=new HashMap<String,Object>();
			LinkedHashMap<String,String> map_title=new LinkedHashMap<String,String>();				
			List<Pigsty> pigsList=new ArrayList<>();
			List<Map<String,Object>> list_data=new ArrayList<Map<String, Object>>();
			JSONObject result=new JSONObject();	
			int total=0;
			
			map_tu.clear();
			map_title.clear();
			list_data.clear();
			map_data.clear();
			
			map_tu.put("tuno",tuno);			
			pigsList=pigstyService.list(map_tu);
			
			for(Pigsty pigsty:pigsList) {
				map_title.put("item","分项");
				map_title.put(pigsty.getPsno(),pigsty.getPsno());	
			}
			
			//生成批次号
			map_data.put("item","批次号");
			for(Pigsty pigsty:pigsList) {
				map_data.put(pigsty.getPsno(),null);	
			}
			for(int j=0;j<pigsflowList.size();j++) {				
				map_data.put(pigsflowList.get(j).getPsno(),pigsflowList.get(j).getBatno());						
			}
			
			Map<String,Object> dis = new HashMap<>();
			dis.putAll(map_data);//对象拷贝
			list_data.add(dis);
			map_data.clear();
			
			map_data.put("item","日龄");
			for(Pigsty pigsty:pigsList) {
				map_data.put(pigsty.getPsno(),null);	
			}
			for(int j=0;j<pigsflowList.size();j++) {					
  			  map_data.put(pigsflowList.get(j).getPsno(),pigsflowList.get(j).getDays());						
		    }
			 
			list_data.add(map_data);
			result.put("title",map_title);	
			result.put("rows",list_data);
			ResponseUtil.write(response,result);
		}		
		return null;
	}
	
	@RequestMapping("/listflow")
	public String listflow(@RequestParam(value="page",required=false)String page,@RequestParam(value="rows",required=false)String rows,Pigstyflow s_pigstyflow,
			@RequestParam(value="begin_time",required=false)String begin_time,@RequestParam(value="end_time",required=false)String end_time,
			HttpServletResponse response)throws Exception{
		PageBean pageBean=new PageBean(Integer.parseInt(page),Integer.parseInt(rows));
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("begin_time",begin_time);
		
		if(StringUtil.isNotEmpty(end_time)) {
			map.put("end_time",end_time+" 23:59:59");
		}else {
			map.put("end_time",end_time);
		}
		map.put("typeno",s_pigstyflow.getTypeno());
		map.put("tuno",s_pigstyflow.getTuno());
		map.put("psno",s_pigstyflow.getPsno());
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		List<Pigstyflow> flowList=pigstyflowService.flowlist(map);	
		Long total=pigstyflowService.flowcount(map);
		JSONObject result=new JSONObject();	 		
		//JsonConfig jsonConfig=new JsonConfig();
		//jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd hh:mm:ss"));
		JSONArray jsonArray=JSONArray.fromObject(flowList);
		result.put("rows", jsonArray);
		result.put("total", total);		
		ResponseUtil.write(response, result);
		return null;
	}
	@RequestMapping("/listflowbyno")
	public String listflow(@RequestParam(value="begin_time",required=false)String begin_time,@RequestParam(value="end_time",required=false)String end_time,HttpServletResponse response)throws Exception{
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("begin_time",begin_time);	
		map.put("end_time",end_time);
		List<Pigstyflow> flowbypsnoList=pigstyflowService.flowbypsno(map);		
		String json=JSONArray.fromObject(flowbypsnoList).toString();
		ResponseUtil.write(response, json);
		return null;
	}
	
	@RequestMapping("/save")
	public String save(Pigstyflow pigstyflow,HttpServletResponse response,@RequestParam(value="flowids",required=false)String flowids)throws Exception{
		int resultTotal=0; // 操作的记录条数
		String error="异常，请核实！";
		pigstyflow.setIs_bat(0);
		Map<String,Object> map_psno=new HashMap<String,Object>();
		map_psno.put("psno",pigstyflow.getPsno());
		map_psno.put("flowid",pigstyflow.getFlowid());		
		Integer cn=pigstyflowService.findpsno(map_psno);
		
		if(pigstyflow.getFlowid()==null && flowids==null){			
			error=saveflow(pigstyflow,cn);
			if(error.length()<=5){
				resultTotal=pigstyflowService.insert(pigstyflow);
			}
		}	
		else if (pigstyflow.getFlowid()!=null && flowids==null) {			
			error=updateflow(pigstyflow,cn);
			if(error.length()<=5){
				resultTotal=pigstyflowService.update(pigstyflow);
			}
		}
		else if(pigstyflow.getFlowid()==null && flowids!=null) {				
			error=delflow(pigstyflow,cn,flowids);
			if(error.length()<=5){
				resultTotal=1;
			}
		}
		
		JSONObject result=new JSONObject();
			if(resultTotal>0){ // 执行成功
				result.put("success", true);
			}else {
				result.put("error",error);
		}
		ResponseUtil.write(response, result);
		return null;
	}
	
	@RequestMapping("/updatebat")
	public String save(HttpServletRequest request,HttpServletResponse response) throws Exception 
	{
		String params=request.getParameter("updated");
		String detail=request.getParameter("detail");
		
		List<Map<String,Object>> flowList=new ArrayList<Map<String,Object>>();
		
    	if(params!=null)
	    {
    		flowList=getbatlist(params);
    		 
    	//增加批次号和日龄
    		if(detail!=null) {
    			String flowid="";
    			JSONArray detailArray=JSONArray.fromObject(detail);
    			//获取明细更新流水号
    			for(int i=0;i<detailArray.size();i++){
    				  JSONObject job = detailArray.getJSONObject(i);
    				   if(job.get("item").equals("流水号")){
    					  flowid=job.get("flowid").toString(); 
    					  break;
    				   }
    			}
    			
    			for(Map<String,Object> map:flowList) {    				
    				String psno=(String)map.get("psno");
    				Integer lastindex=map.get("flowid").toString().indexOf("F");
    				String flowid1=map.get("flowid").toString().substring(0,lastindex);
    				if(flowid!=null && !("".equals(flowid)) && flowid.equals(flowid1))
				    {
	    				for(int i=0;i<detailArray.size();i++){
	    				    JSONObject job = detailArray.getJSONObject(i);  // 遍历 jsonarray 数组，把每一个对象转成 json 对象
		    				    if(job.get("item").equals("批次号")) {
		    				    	map.put("batno",job.get(psno));
		    				    	
		    				    }else if(job.get("item").equals("日龄")){
		    				    	if(job.get(psno)!=null && !("".equals(job.get(psno)))) {
		    				    		map.put("days",Integer.parseInt(job.get(psno).toString()));    				    		
		    				    	}
		    			}    
    				   }
    				 }
    				
    			}
    		}
    		
	    //校验数据
		    List<Pigstyflow> pigsList=new ArrayList<Pigstyflow>();
			Map<String,Object> map=new HashMap<String,Object>();
			
			String flowids="";	
		    for(Map<String,Object> flow:flowList){
		    	flowids+=flow.get("flowid")+",";
		    }
		    if(flowids!=null) {
		    	flowids=flowids.substring(0,flowids.length()-1);		    	
		    }else {
		        return null;
		    }
		    map.put("flowids",flowids);    
		    pigsList=pigstyflowService.listbat(map);
		    
		    flowids="";
		    for(Pigstyflow flow:pigsList) {
		      flowids+=flow.getFlowid()+",";	      
		    }
		    if(flowids.length()>0) {
		     	flowids=flowids.substring(0,flowids.length()-1);
		    }else {
		    	flowids="";
		    }
	    //库内处理结束
	    
	    Map<String,Object> map_psno=new HashMap<String,Object>();
	    List<Pigstyflow> insertList=new ArrayList<Pigstyflow>();
	    List<Pigstyflow> updateList=new ArrayList<Pigstyflow>();
	    
		Integer cn=0;
		int total=0;
		String error=null;
		
	    //生成新增与更新的数据
	    for(Map<String,Object> flow:flowList){
	    	Pigstyflow pigstyflow=new Pigstyflow();
	       	if(!("").equals(flowids) && flowids.contains(flow.get("flowid").toString())) {
	       		pigstyflow=MaptoEntity.map2Object(flow,Pigstyflow.class);
	       		map_psno.put("psno",pigstyflow.getPsno());
	       		map_psno.put("flowid",pigstyflow.getFlowid());	
	       		cn=pigstyflowService.findpsno(map_psno);//查询未审核的数据
	       		error=updateflow(pigstyflow,cn);
	       		if(error.length()<=5) {
	       			updateList.add(pigstyflow);
	       		}else {
	       			break;
	       		}
	       	}else {
	       		pigstyflow=MaptoEntity.map2Object(flow,Pigstyflow.class);
	       		map_psno.put("psno",pigstyflow.getPsno());
	       		map_psno.put("flowid",pigstyflow.getFlowid());	
	       		cn=pigstyflowService.findpsno(map_psno);
	       		error=saveflow(pigstyflow,cn);
	       		if(error.length()<=5) {
	       			insertList.add(pigstyflow);
	       		}else {
	       			break;
	       		}
	       	}
	    }
	    //更新数据，先新增后更新
	    if(error.length()<=5) {
	    	Pigsty pigsty=new Pigsty();
	    	if(insertList.size()>0) {
		       total=pigstyflowService.insertbat(insertList);	       
		       for(Pigstyflow pigstyflow:insertList) {
		    	   pigsty.setPsno(pigstyflow.getPsno());
		    	   pigsty.setPsstock(pigstyflow.getStock());
		    	   pigsty.setRemark("check");
		    	   pigstyService.update(pigsty);	    	   
		       }
	    	}
		    for(Pigstyflow pigstyflow:updateList) {		    	
		    	if(pigstyflow.getIf_update()==0) {
		    		continue;
		    	}else if (pigstyflow.getIf_update()==1) {
		    		total+=pigstyflowService.update(pigstyflow);//如果更新批次号和日龄，不更新库存				
				}else{
					total+=pigstyflowService.update(pigstyflow);
				    pigsty.setPsno(pigstyflow.getPsno());
				    pigsty.setPsstock(pigstyflow.getStock());
				    pigsty.setRemark("check");
				    pigstyService.update(pigsty);	  
		    	}
		    }
	    }
	    
	    JSONObject result=new JSONObject();
		if(total>0){ // 执行成功
			result.put("success",true);
		}else {
			result.put("error",error);
		}
		ResponseUtil.write(response,result);
	}
	return null;
	}
	
	@RequestMapping("/deletebat")
	public String deletebat(HttpServletRequest request,HttpServletResponse response) throws Exception 
	{
		String params=request.getParameter("deleted");
		List<Map<String,Object>> flowList=new ArrayList<Map<String,Object>>();
		
    	if(params!=null)
	    {
    		flowList=getbatlist(params);
    		
	    //校验数据
		    List<Pigstyflow> pigsList=new ArrayList<Pigstyflow>();
			Map<String,Object> map=new HashMap<String,Object>();
			
			String flowids="";	
		    for(Map<String,Object> flow:flowList){
		    	flowids+=flow.get("flowid")+",";
		    }
		    flowids=flowids.substring(0,flowids.length()-1);
		    map.put("flowids",flowids);    
		    pigsList=pigstyflowService.listbat(map);
		    
		    flowids="";
		    for(Pigstyflow flow:pigsList) {
		      flowids+=flow.getFlowid()+",";	      
		    }
		    if(flowids.length()>0) {
		     	flowids=flowids.substring(0,flowids.length()-1);
		    }else {
		    	flowids="";
		    }
	    //库内处理结束
	    
	    Map<String,Object> map_psno=new HashMap<String,Object>();
	    List<Pigstyflow> deleteList=new ArrayList<Pigstyflow>();
	    
		Integer cn=0;
		int total=0;
		String error="";
		
	    for(Map<String,Object> flow:flowList){
	    	Pigstyflow pigstyflow=new Pigstyflow();
	       	if(!("").equals(flowids) && flowids.contains(flow.get("flowid").toString())) {
	       		pigstyflow=MaptoEntity.map2Object(flow,Pigstyflow.class);
	       		map_psno.put("psno",pigstyflow.getPsno());
	       		map_psno.put("flowid",pigstyflow.getFlowid());	
	       		cn=pigstyflowService.findpsno(map_psno);//查询未审核的数据
	       		error=deleteflow(pigstyflow,cn);
	       		if(error.length()<=5) {
	       			deleteList.add(pigstyflow);
	       		}else {
	       			break;
	       	}
	       	}
	    }
	    //更新数据
	    if(error.length()<=5) {
	    	Pigsty pigsty=new Pigsty();	    	
		    for(Pigstyflow pigstyflow:deleteList) {
		    	total+=pigstyflowService.delete(pigstyflow.getFlowid());
			    pigsty.setPsno(pigstyflow.getPsno());
			    pigsty.setPsstock(pigstyflow.getStock());
			    pigsty.setRemark("check");
			    pigstyService.update(pigsty);	    	   
		    }
	    }
	    
	    JSONObject result=new JSONObject();
		if(total>0){ // 执行成功
			result.put("success",true);
		}else {
			result.put("error",error);
		}
		ResponseUtil.write(response,result);
	}
	return null;
	}
	
	public String saveflow(Pigstyflow pigstyflow,Integer cn) throws Exception {
		String error=null;
		Integer afters=0;
		String flowdirect="";
		String psno=pigstyflow.getPsno();
		int is_bat=pigstyflow.getIs_bat();		
		Integer stock=pigstyService.findByNo(pigstyflow.getPsno()).getPsstock();
		if(stock==null) {
			stock=0;
		}
		if(is_bat==0) {
			pigstyflow.setFlowid(DateUtil.getCurrentDateStr());		
			Map<String,Object> map=new HashMap<String,Object>();
			map.put("typeno",pigstyflow.getTypeno());
			flowdirect=flowtypeService.list(map).get(0).getFlowdirect();
			pigstyflow.setFlowdirect(flowdirect);			
		}else {
			flowdirect=pigstyflow.getFlowdirect();
		}
		if("-".equals(flowdirect)) {
			afters=stock-pigstyflow.getAmount();
		}else {
			afters=stock+pigstyflow.getAmount();
		}
		pigstyflow.setStock(afters);
		if(is_bat==0) {
			pigstyflow.setIf_check("N");				
		}else {
			pigstyflow.setIf_check("Y");
		}
		if(afters<0) {
			error="更新后"+psno+"库存量将小于0，请核实！";
			return error;
		}else if(cn>0) {
			error=psno+"猪舍存在未审核的数据，请审核数据！";	
			return error;
		}else {	
			return "1";
		}
	}
	
	public String updateflow(Pigstyflow pigstyflow,Integer cn) {
		String error=null;
		int amount=pigstyflowService.findflowid(pigstyflow.getFlowid()).getAmount();
		int diff=amount-pigstyflow.getAmount();
		Date create_time=pigstyflowService.findflowid(pigstyflow.getFlowid()).getCreate_time();
		int is_bat=pigstyflow.getIs_bat();
		Integer afters=0;			
		String flowdirect="";
		String psno=pigstyflow.getPsno();		
		Integer stock=pigstyService.findByNo(pigstyflow.getPsno()).getPsstock();
		if(stock==null) {
			stock=0;
		}
		
		if(is_bat==0) {
			Map<String,Object> map=new HashMap<String,Object>();
			map.put("typeno",pigstyflow.getTypeno());
			flowdirect=flowtypeService.list(map).get(0).getFlowdirect();
			pigstyflow.setFlowdirect(flowdirect);			
		}else {
			flowdirect=pigstyflow.getFlowdirect();			
		}
		if(diff!=0) {
			if("-".equals(flowdirect)) {
				if(is_bat==0) {
				  afters=stock-pigstyflow.getAmount();
				}else {
				  afters=stock-pigstyflow.getAmount()+amount;
				}
			}else {
				if(is_bat==0) {
				  afters=stock+pigstyflow.getAmount();
				}else {
				  afters=stock+pigstyflow.getAmount()-amount;
				}
			}
		}else if(diff==0 && (!(("").equals(pigstyflow.getBatno()) || pigstyflow.getBatno()==null) || pigstyflow.getDays()!=null)) {
			afters=pigstyflowService.findflowid(pigstyflow.getFlowid()).getStock();
			pigstyflow.setIf_update(1);
		}
		else {
			afters=pigstyflowService.findflowid(pigstyflow.getFlowid()).getStock();
			pigstyflow.setIf_update(0);//不需要更新数据
		}
		pigstyflow.setStock(afters);
		pigstyflow.setCreate_time(create_time);
		if(is_bat==0) {
			pigstyflow.setIf_check("N");				
		}else {
			pigstyflow.setIf_check("Y");
		}
		if(afters<0) {
			error="更新后"+psno+"库存量将小于0，请核实！";
			return error;
		}else if(cn>0) {
			error=psno+"猪舍存在未审核的数据，请审核数据！";
			return error;
		}else {
			return "1";
		}
	}
	public String deleteflow(Pigstyflow pigstyflow,Integer cn) {
		String error=null;
		int is_bat=pigstyflow.getIs_bat();
		Integer afters=0;		
		String flowdirect="";
		String psno=pigstyflow.getPsno();	
		int amount=pigstyflowService.findflowid(pigstyflow.getFlowid()).getAmount();
		Integer stock=pigstyService.findByNo(pigstyflow.getPsno()).getPsstock();
		if(stock==null) {
			stock=0;
		}
		
		if(is_bat==0) {
			Map<String,Object> map=new HashMap<String,Object>();
			map.put("typeno",pigstyflow.getTypeno());
			flowdirect=flowtypeService.list(map).get(0).getFlowdirect();
			pigstyflow.setFlowdirect(flowdirect);		
		}else {
			flowdirect=pigstyflow.getFlowdirect();			
		}			
		if("-".equals(flowdirect)) {
			  afters=stock+amount;
		}else {
			  afters=stock-amount;
		}
		pigstyflow.setStock(afters);
		pigstyflow.setAmount(amount);
		
		if(afters<0) {
			error="更新后"+psno+"库存量将小于0，请核实！";
			return error;
		}else if(cn>0) {
			error=psno+"猪舍存在未审核的数据，请审核数据！";
			return error;
		}else {
			return "1";
		}
	}
	
	public String delflow(Pigstyflow pigstyflow,Integer cn,String flowids) {
		String error=null;
		int resultTotal=0;
		String []idsStr=flowids.split(",");
		Pigsty pigsty=new Pigsty();
		for(int i=0;i<idsStr.length;i++){
			
			Pigstyflow pigstyflow2=pigstyflowService.findflowid(idsStr[i]);				
			Integer stock=pigstyService.findByNo(pigstyflow2.getPsno()).getPsstock();
			if(stock==null) {
				stock=0;
			}
			Integer afters=0;			
			Map<String,Object> map=new HashMap<String,Object>();
			map.put("typeno",pigstyflow2.getTypeno());
			String flowdirect=flowtypeService.list(map).get(0).getFlowdirect();
			pigstyflow.setFlowdirect(flowdirect);			
			if("-".equals(flowdirect)) {
				afters=stock-pigstyflow2.getAmount();
			}else {
				afters=stock+pigstyflow2.getAmount();
			}
			if(afters<0) 
			{
				error="库存量小于0，请核实！";	
				resultTotal=-1;
				break;
			}else if(pigstyflow2.getIf_check().equals(String.valueOf('Y'))) 
			{
				error="选择了已审核流水，请注意！";
				resultTotal=-1;
				break;
			}else {
				pigstyflow2.setIf_check(String.valueOf('Y'));
				pigsty.setPsno(pigstyflow2.getPsno());
				pigsty.setPsstock(afters);
				pigsty.setRemark("check");
				pigstyService.update(pigsty);
				resultTotal=pigstyflowService.update(pigstyflow2);
			}			
		}
		if(resultTotal<0) {
			return error;
		}else {
			return Integer.toString(resultTotal);	
		}
	}
	
	public List<Map<String,Object>> getbatlist(String params){
		
		List<Map<String,Object>> flowList=new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> updateList = (List<Map<String,Object>>)com.alibaba.fastjson.JSONArray.parse(params);
	
	    for(Map<String,Object> mapList:updateList){
	   	 String time=(String) mapList.get("create_time");
	   	 String flowtime=time.replace("-","");   	 
	        String typename=(String) mapList.get("typename");
	        String typeno=flowtypeService.findbyname(typename).getTypeno();
	        String flowdirect=flowtypeService.findbyname(typename).getFlowdirect();
	        
	        for (Map.Entry entry: mapList.entrySet()){	        	 
	           System.out.println(entry.getKey()+"  "+entry.getValue());	            
	           String key=(String)entry.getKey();
	           Object value=entry.getValue();
	           if(value==null || value.equals("")) {
	           	continue;
	           }
	           if(key.contains("F")){
	              String flowid=flowtime+typeno+key;
	              //获取饲养员编号
	              String username=null;
	              Map<String,Object> map=new HashMap<String,Object>();
	              map.put("psno",key);
	              username=pigsbreService.findByno(map).getUsername();
	              Map<String,Object> map_flow=new HashMap<String,Object>();
	              map_flow.put("flowid",flowid);
	              map_flow.put("create_time",time);
	              map_flow.put("psno",key);
	              map_flow.put("amount",Integer.parseInt(value.toString()));
	              map_flow.put("typeno",typeno);
	              map_flow.put("flowdirect",flowdirect);
	              map_flow.put("if_check","Y");
	              map_flow.put("is_bat",1);
	              map_flow.put("username",username);             
	              flowList.add(map_flow);
	           }            
	        }
	    }
	    return flowList;
	}
}