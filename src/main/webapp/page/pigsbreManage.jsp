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

	var url;
	function searchPigsbre(){
		$("#dg").datagrid('load',{
			"psno":$("#s_psno").val(),
			"username":$("#s_username").val(),
			"if_valid":$("#s_valid").combobox("getValue")
		});
	}
	//减少人员
	function delPigsbre(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			$.messager.alert("系统提示","请选择要减少的数据！");
			return;
		}
		var strIds=[];
		for(var i=0;i<selectedRows.length;i++){
			strIds.push(selectedRows[i].id);
		}
		var ids=strIds.join(",");
		$.messager.confirm("系统提示","您确认要减少这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
			if(r){
				$.post("${pageContext.request.contextPath}/pigsbre/modify.do",{ids:ids},function(result){
					if(result.success){
						$.messager.alert("系统提示","人员减少成功！");
						$("#dg").datagrid("reload");
					}else{
						$.messager.alert("系统提示","人员减少失败！");
					}
				},"json");
			}
		});
		
	}
	//删除记录
	function deletePigsbre(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			 $.messager.alert("系统提示","请选择要删除的数据！","warning");			
			return;
		}
		var strIds=[];
		for(var i=0;i<selectedRows.length;i++){
			strIds.push(selectedRows[i].id);
		}
		var ids=strIds.join(",");
		$.messager.confirm("系统提示","您确认要删除这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
			if(r){
				$.post("${pageContext.request.contextPath}/pigsbre/delete.do",{ids:ids},function(result){
					if(result.success){
						$.messager.alert("系统提示","数据已成功删除！","info");
						$("#dg").datagrid("reload");
					}else{
						$.messager.alert("系统提示","数据删除失败！","error");
					}
				},"json");
			}
		});
		
	}	
	function openPigsbreAddDialog(){
		$("#dlg").dialog("open").dialog("setTitle","增加人员");
		url="${pageContext.request.contextPath}/pigsbre/save.do";
	}
	function savePigsbre(){
		$("#fm").form("submit",{
			url:url,
			onSubmit:function(){
				if($("#psno").combobox("getValue")==""){
					$.messager.alert("系统提示","请选择猪舍编号");
					return false;
				}
				if($("#username").combobox("getValue")==""){
					$.messager.alert("系统提示","请选择饲养员姓名");
					return false;
				}				
				return $(this).form("validate");
			},
			success:function(result){
				var result=eval('('+result+')');
				if(result.success){
					$.messager.alert("系统提示","保存成功");
					resetValue();
					$("#dlg").dialog("close");
					$("#dg").datagrid("reload");
				}else{
					$.messager.alert("系统提示",result.error);
					return;
				}
			}
		});
	}
	
	function resetValue(){
		$("#psno").combobox("setValue","");
		$("#username").combobox("setValue","");
		$("#begin_date").datebox("setValue","");
		$("#end_date").datebox("setValue","");
	}
	
	function closePigsbreDialog(){
		$("#dlg").dialog("close");
		resetValue();
	}
</script>
</head>
<body style="margin:1px;">
	<table id="dg"  class="easyui-datagrid"
	 fitColumns="true" pagination="true" rownumbers="true"
	 url="${pageContext.request.contextPath}/pigsbre/list.do" fit="true" toolbar="#tb">
	 <thead>
	 	<tr>
	 		<th field="cb" checkbox="true" align="center"></th>
	 		<th field="id" width="20" align="center" hidden="true">编号</th>
	 		<th field="psno" width="30" align="center" >猪舍编码</th>
	 		<th field="psname" width="30" align="center" hidden="true" >猪舍名称</th>
	 		<th field="username" width="30" align="center">饲养员编码</th>
	 		<th field="brename" width="30" align="center" >饲养员姓名</th>
	 		<th field="begin_date" width="30" align="center">开始日期</th>
	 		<th field="end_date" width="30" align="center">结束日期</th>
	 		<th field="days" width="30" align="center">饲养天数</th>
	 	</tr>
	 </thead>
	</table>
		
     <div id="tb">
		<div>
			<a href="javascript:openPigsbreAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">增加人员</a>
			<a href="javascript:delPigsbre()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">减少人员</a>
			<a href="javascript:deletePigsbre()" class="easyui-linkbutton" iconCls="icon-cut" plain="true" style="float:right">删除记录</a>
		</div>
		<div>
			&nbsp;猪舍编码：&nbsp;<input type="text" id="s_psno" size="20" onkeydown="if(event.keyCode==13) searchPigsbre()"/>
			&nbsp;饲养员编码：&nbsp;<input type="text" id="s_username" size="20" onkeydown="if(event.keyCode==13) searchPigsbre()"/>	
			&nbsp;是否有效：&nbsp;<select class="easyui-combobox" id="s_valid"  editable="false" panelHeight="auto">
								    <option value="">请选择...</option>
									<option value="0">失效</option>
									<option value="1">有效</option>
								</select>&nbsp;	
			<a href="javascript:searchPigsbre()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
		</div>
	</div>	
	
	<div id="dlg" class="easyui-dialog" style="width: 600px;height:170px;padding: 10px 20px" closed="true" buttons="#dlg-buttons" data-options="onClose:function(){resetValue()}">
	 	<form id="fm" method="post">
	 	<table cellspacing="8px">	 			
	 			<tr>
	 				<td>猪舍编号：</td>
	 				<td>
	 					<input class="easyui-combobox" id="psno" name="psno"  data-options="panelHeight:'300',editable:false,valueField:'psno',textField:'psno',url:'${pageContext.request.contextPath}/pigsty/findpigsty.do'"/>&nbsp;<font color="red">*</font>
	 				</td>
	 				<td>饲养员姓名：</td>
	 				<td>
	 					<input class="easyui-combobox" id="username" name="username"  data-options="panelHeight:'300',editable:false,valueField:'username',textField:'brename',url:'${pageContext.request.contextPath}/breeder/findbreeder.do?if_valid=1'"/>&nbsp;<font color="red">*</font>
	 				</td>
	 			</tr>
	 			<tr>
	 			   <td>开始日期：</td>
	 			   <td><input type="text" id="begin_date" name="begin_date" class="easyui-datebox" editable="false" required="true"/>&nbsp;<font color="red">*</font></td>
	 			   <td>结束日期：</td>
	 			   <td><input type="text" id="end_date" name="end_date" class="easyui-datebox" editable="true"/></td>
	 			</tr>
	 	</table>	 		
	 	</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:savePigsbre()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closePigsbreDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
</body>
</html>