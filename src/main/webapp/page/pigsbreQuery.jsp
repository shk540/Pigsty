<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/themes/ui-pepper-grinder/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.easyui.theme.v1.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script type="text/javascript">
function alertColumn(sort,order){ 
	$("#dg").datagrid("reload");
	}
</script>
</head>
<body style="margin:1px;" class="easyui-layout">
<%-- 
 <div class="easyui-panel"  style="height:400px;width:auto">
   <jsp:include page="pigsbreQuery_psno.jsp"></jsp:include>
 </div>
 
 <div class="easyui-panel"  style="height:400px;width:auto">
   <jsp:include page="pigsbreQuery_username.jsp"></jsp:include>
 </div>	 --%>

	<div data-options="region:'north'" style="height:350px">
		<table id="dg" title="按饲养员查询" class="easyui-datagrid"
	 fitColumns="true" width="auto" pagination="true" rownumbers="true" striped="true" singleSelect="true" showFooter="true"	 
	 url="${pageContext.request.contextPath}/pigsbre/list_username.do" fit="true" style="width: 100%;" toolbar="#tb">
	 <thead>
	 	<tr>
	 		<th field="username" width="30" align="center">饲养员编码</th>
	 		<th field="brename" width="30" align="center" >饲养员姓名</th>
	 		<th field="pscn" width="30" align="center" sortable="true" >猪舍个数</th>
	 		<th field="psno" width="30" align="center" >猪舍编码</th>
	 		<th field="psname" width="30" align="center" >猪舍名称</th>	 			 		
	 		<th field="psstock" width="30" align="center" sortable="true" >饲养数量(头)</th>
	 	</tr>
	 </thead>
	</table>
	</div>
	<div data-options="region:'center'">
		<table id="dg" title="按猪舍查询" class="easyui-datagrid"
	 fitColumns="true" pagination="true" rownumbers="true"  striped="true" singleSelect="true"
	 url="${pageContext.request.contextPath}/pigsbre/list_psno.do" fit="true" style="width: 100%;" toolbar="#tb">
	 <thead>
	 	<tr>
	 		<th field="psno" width="30" align="center" >猪舍编码</th>
	 		<th field="psname" width="30" align="center" >猪舍名称</th>
	 		<th field="usercn" width="30" align="center" sortable="true" >饲养员人数</th>
	 		<th field="username" width="30" align="center">饲养员编码</th>
	 		<th field="brename" width="30" align="center" >饲养员姓名</th>
	 	</tr>
	 </thead>
	</table>
	</div>
     
</body>
</html>