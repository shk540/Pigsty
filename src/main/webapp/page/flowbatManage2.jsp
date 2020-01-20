<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script type="text/javascript">  
$(function(){
	 $('#tt').tabs({
	 	    onSelect:setmsg
	  });
	 
	 showmsg();
	 setmsg(index);
	 
	 $('#tt').tabs('update',{
		    tab:$('#tt').tabs('getTab','Tab2'),
		    options:{
		        selected:true
		    }
		});
	})

	
	var index;
	
	function showmsg(){	   
	   var pp = $('#tt').tabs('getSelected');
	   index=$('#tt').tabs('getTabIndex',pp)+1;
	   return index;
	}
	
	
	function setmsg(index){		
		console.log(index);
	}

	</script>

</head>

<body style="margin:1px;">

	<div id="tt" class="easyui-tabs"  tools="#tab-tools" fit=true toolPosition="left" tabWidth="200" showHeader=true selected=1 tabPosition="top">
    <div title="Tab1" style="padding:20px;display:none;">
		tab1
    </div>
    <div title="Tab2" data-options="closable:true" style="overflow:auto;padding:20px;display:none;">
		tab2
    </div>
    <div title="Tab3" data-options="iconCls:'icon-reload',closable:true" style="padding:20px;display:none;">
		tab3
    </div>
</div>
<div id="tab-tools">
	<a href="#" class="easyui-linkbutton" plain="true" iconCls="icon-add"></a>
	<a href="#" class="easyui-linkbutton" plain="true" iconCls="icon-save"></a>
</div>
</body>
</html>