<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script type="text/javascript">
	$(function(){
	    var tabs = $('#tung').tabs().tabs('tabs');
	    for(var i=0; i<tabs.length; i++){
	        tabs[i].panel('options').tab.unbind().bind('mouseenter',{index:i},function(e){
	            $('#tung').tabs('select', e.data.index);
	        });
	    }
	});
	
	//获取栋数据
	function(tuno){
		$.ajax(
		   url:"${pageContext.request.contextPath}/pigstyflow/listbat.do",	
		   type:"POST",
		   dataType:"json",
		   //data:{tuno:tuno},
		   success:function(data){
			   //处理数据，生成表头与表列数据json串			   
			   columns=initcolumns(data.tuno+"_"+title);
			   console.log("columns");
			   inittable(data,tuno);
		   },
		   error:function(e){
	            msgShow("error","请求数据出错!",'error');
	       }
		);
	};	
	
	function initcolumns(title){
		
		var columns[];
		coulumns.put
		for(var item in titi=le){
			columns.push("{field:"+'"'+item+'",''+title[item]+"},");
		}		
	};
	
	function inittable(data,tuno){
		$('#'+tuno).datagrid(
		   url:"data.json",
		   method:"local",
		   contentType:"application/json",
		   columns:data,
		   queryParams:{params},
		   loadMsg:"loading..."		   
		);
	}
</script>
</script>

</head>

<body style="margin:1px;">

	<div id="tung" class="easyui-tabs" style="width:100%;height:100%;" data-options="fit:true,tabWidth:112">
	
		<div title="一栋" style="padding:10px;">
			<table id="T1" class="easyui-datagrid" data-options="fitColumns:true,fit:true,pagination:true,rownumbers:true" >
	 		<thead>
	 		<tr>	 			 				
	 		</tr>
	 		</thead>
			</table>
		</div>
		
		<div title="二栋" style="padding:10px;">
			Second Tab
		</div>
		<div title="三栋" style="padding:10px;">
			Third Tab
		</div>
		<div title="四栋" style="padding:10px;">
			Third Tab
		</div>
	</div>
	
</body>
</html>