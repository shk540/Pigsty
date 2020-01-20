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
	
	function deleteFlowtype(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			$.messager.alert("系统提示","请选择要删除的数据！","warning");
			return;
		}
		var strIds=[];
		for(var i=0;i<selectedRows.length;i++){
			strIds.push(selectedRows[i].typeid);
		}
		var ids=strIds.join(",");
		$.messager.confirm("系统提示","您确认要删除这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
			if(r){
				$.post("${pageContext.request.contextPath}/flowtype/delete.do",{ids:ids},function(result){
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
	
	function openFlowtypeAddDialog(){
		$("#dlg").dialog("open").dialog("setTitle","新建类型");
		url="${pageContext.request.contextPath}/flowtype/save.do";
	}
	
	function saveFlowtype(){
		$("#fm").form("submit",{
			url:url,
			onSubmit:function(){
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
					$.messager.alert("系统提示","保存失败");
					return;
				}
			}
		});
	}
	
	function openFlowtyperModifyDialog(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length!=1){
			$.messager.alert("系统提示","请选择一条要编辑的数据！","warning");
			return;
		}
		var row=selectedRows[0];
		$("#dlg").dialog("open").dialog("setTitle","编辑类型");
		$('#fm').form('load',row);
		url="${pageContext.request.contextPath}/flowtype/save.do?typeid="+row.typeid;
	}
	
	function resetValue(){
		$("#typeno").val("");
		$("#typename").val("");
		$("[name='flowdirect'][value='-']").attr("checked","checked").prop("checked", true).trigger("change");
	}
	
	function closeFlowtypeDialog(){
		$("#dlg").dialog("close");
		resetValue();
	}	

</script>
</head>
<body style="margin:1px;">
	<table id="dg" class="easyui-datagrid"
	 fitColumns="true" pagination="true" rownumbers="true"
	 url="${pageContext.request.contextPath}/flowtype/list.do" fit="true" toolbar="#tb">
	 <thead>
	 	<tr>
	 		<th field="cb" checkbox="true" align="center"></th>
	 		<th field="typeid" width="20" align="center" hidden="true">编号</th>
	 		<th field="typeno" width="30" align="center">类型编码</th>
	 		<th field="typename" width="30" align="center">类型名称</th>
	 		<th field="flowdirect" width="30" align="center">流转方向</th>
	 	</tr>
	 </thead>
	</table>
	<div id="tb">
		<div>
			<a href="javascript:openFlowtypeAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">新建</a>
			<a href="javascript:openFlowtyperModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
			<a href="javascript:deleteFlowtype()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
		</div>		
	</div>
	
	<div id="dlg" class="easyui-dialog" style="width: 620px;height:150px;padding: 10px 20px" closed="true" buttons="#dlg-buttons" data-options="onClose:function(){resetValue()}">
	 	<form id="fm" method="post">
	 		<table cellspacing="8px">
	 			<tr>
	 				<td>类型编号：</td>
	 				<td><input type="text" id="typeno" name=typeno class="easyui-validatebox" required="true"/></td>
	 				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	 				<td>类型名称：</td>
	 				<td><input type="text" id="typename" name="typename" class="easyui-validatebox" required="true"/></td>
	 				
	 			</tr>
	 			<tr>
	 			<td>流转方向</td>
	 			<td>
	 			   <input name="flowdirect" type="radio" value="+" />+(增加)<input name="flowdirect" type="radio" value="-"/>-(减少)
				</td>	 
			    </tr>			
	 		</table>
	 	</form>
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:saveFlowtype()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeFlowtypeDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
</body>
</html>