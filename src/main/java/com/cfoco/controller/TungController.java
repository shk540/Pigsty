package com.cfoco.controller;

import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.cfoco.entity.Tung;
import com.cfoco.service.TungService;
import com.cfoco.util.ResponseUtil;
import net.sf.json.JSONArray;

@Controller
@RequestMapping("/tung")
public class TungController {
	@Resource
	private TungService tungService;
	
	@RequestMapping("/list")
	public String list(HttpServletResponse response)throws Exception{		
		List<Tung> tungList=tungService.list();
		JSONArray jsonArray=JSONArray.fromObject(tungList);
		ResponseUtil.write(response,jsonArray);
		return null;
	}
}
