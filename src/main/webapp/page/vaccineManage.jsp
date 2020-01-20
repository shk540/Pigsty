<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.edatagrid.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/datagrid-export.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/date.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/print.js"></script>
<script type="text/javascript">

	 $(function(){		 
		 $('#dg').edatagrid({
            url: '${pageContext.request.contextPath}/vaccine/list.do',
            saveUrl: '${pageContext.request.contextPath}/vaccine/save.do',
            updateUrl: '${pageContext.request.contextPath}/vaccine/save.do',
            destroyUrl: '${pageContext.request.contextPath}/vaccine/delete.do'
        });
	  $("#s_begintime").datebox("setValue",genLastMonthDayStr()); // 设置上个月日期
	  $("#s_endtime").datebox("setValue",genTodayStr()); // 设置当前日期
     });
	 
	 function getprintresult(bool){
		 
		 if(bool){
			 //更新打印日期字段
			 rows=$('#dg').datagrid('getRows');
			 var strIds=[];
			 for(var i=0;i<rows.length;i++){
				strIds.push(rows[i].id);
			 }
			 var ids=strIds.join(",");
			 $.messager.confirm("系统提示","您确认要更新这<font color=red>"+rows.length+"</font>条数据吗？",function(r){
					if(r){
						$.post("${pageContext.request.contextPath}/vaccine/update.do",{ids:ids},function(result){
							if(result.success){
								$.messager.alert("系统提示","数据已成功更新！","info");
								$("#dg").datagrid("reload");
							}else{
								$.messager.alert("系统提示","数据更新失败！","error");
							}
						},"json");
					}
			});
		 }
	 }
	 
</script>
</head>
<body style="margin:5px;">
<table id="dg" class="easyui-datagrid" data-options="fitColumns:true,fit:true,pagination:true,rownumbers:true,striped:true,singleSelect:true" toolbar="#toolbar">
    <thead>
        <tr>
            <th field="id" width="50" align="center" hidden="true" >编号</th>
            <th field="vacname" width="100" editor="{type:'validatebox',options:{required:true}}" align="center" >疫苗名称</th>
            <th field="psno" width="50" align="center"  editor="{type:'combobox',  
                options:{  
                    valueField:'psno',  
                    textField:'psno',  
                    required:true,
                    panelHeight:'300',
                    url:'${pageContext.request.contextPath}/pigsty/findpigsty.do'
                } }">猪舍编号</th>
            <th field="planage" width="100" align="center"  editor="{type:'numberbox',options:{validType:'number'}}">计划日龄</th>
            <th field="plandate" width="100" align="center"  editor="{type:'datebox'}">计划日期</th>
            <th field="realdate" width="100" align="center"  editor="{type:'datebox'}">实际日期</th>
            <th field="username" width="100" align="center" >操作人</th>
        </tr>
    </thead>
</table>
	    
<div id="toolbar">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addrow()">添加</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="javascript:$('#dg').edatagrid('destroyRow')">删除</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="javascript:$('#dg').edatagrid('saveRow');$('#dg').datagrid('reload')">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="javascript:$('#dg').edatagrid('cancelRow');$('#dg').datagrid('reload')">撤销行</a>
    |
    &nbsp;<font size="1.5" style="padding:2px">开始日期</font>&nbsp;<input type="text" id="s_begintime" class="easyui-datebox" editable="true" style="width:100px">
	&nbsp;<font size="1.5" style="padding:2px">结束日期</font>&nbsp;<input type="text" id="s_endtime" class="easyui-datebox" editable="true" style="width:100px">
	&nbsp;<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" plain="true" onclick="searchvaccine()">搜索</a>	
	<div style="float:right">
	<a href="javascript:void(0);" class="easyui-linkbutton" iconCls="icon-print" plain="true" onclick="printdr()">打印表格</a>
	<a href="javascript:void(0);" class="easyui-linkbutton" iconCls="icon-export" plain="true" onclick="exportdr()">导出表格</a>
	</div>
	
</div>

<script type="text/javascript">
  function addrow(){
	  $('#dg').edatagrid('appendRow',{plandate:genTodayStr()});
  }
  
  function searchvaccine(){
	  $("#dg").datagrid('load',{
			"begin_time":$("#s_begintime").datebox("getValue"),
			"end_time":$("#s_endtime").datebox("getValue")
	  });
	}
  
  var a;
  
  function printdr(){
	  //$('#dg').datagrid('print',{title:'猪舍疫苗计划'});	
	  
	  a=CreateFormPage('datagrid',$('#dg'));
	  window.open("print.html","表格打印","height=200px, width=300px, menubar=yes, scrollbars=yes, toolbar=yes, status=yes");	  
  }
  
  function exportdr(){
	  $('#dg').datagrid('toExcel',{filename:'vaccine_plan.xls'});	// export to excel

  }
</script>
	
</body>
</html>