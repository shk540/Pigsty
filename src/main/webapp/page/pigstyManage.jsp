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
	
	function searchPigsty(){
		$("#dg").datagrid('load',{
			"psno":$("#s_psno").val()
		});
	}
	
	function deletePigsty(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			$.messager.alert("系统提示","请选择要删除的数据！");
			return;
		}
		var strIds=[];
		for(var i=0;i<selectedRows.length;i++){
			strIds.push(selectedRows[i].psid);
		}
		var ids=strIds.join(",");
		$.messager.confirm("系统提示","您确认要删除这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
			if(r){
				$.post("${pageContext.request.contextPath}/pigsty/delete.do",{ids:ids},function(result){
					if(result.success){
						$.messager.alert("系统提示","数据已成功删除！");
						$("#dg").datagrid("reload");
					}else{
						$.messager.alert("系统提示","数据删除失败！");
					}
				},"json");
			}
		});
		
	}	
	
	function openPigstyAddDialog(){
		$("#dlg").dialog("open").dialog("setTitle","新建猪舍");
		url="${pageContext.request.contextPath}/pigsty/save.do";
	}
	
	function savePigsty(){
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
	
	function openPigstyrModifyDialog(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length!=1){
			$.messager.alert("系统提示","请选择一条要编辑的数据！");
			return;
		}
		var row=selectedRows[0];
		$("#dlg").dialog("open").dialog("setTitle","编辑猪舍信息");
		$( "#psno").attr("disabled",true);
		$('#fm').form('load',row);
		url="${pageContext.request.contextPath}/pigsty/save.do?psno="+row.psno+"&psid="+row.psid;
	}
	
	function resetValue(){
		//$("#psname").val("");
		$("#psno").val("");
		$("#psstock").val("");
		$("#remark").val("");	
		$("#psno").attr("disabled",false);
		$("#tuno").combobox("setValue","");
		//$("[name='is_manager']").val("0");
		//$("[name='if_valid']").val("1");
	}
	
	function closePigstyDialog(){
		$("#dlg").dialog("close");
		resetValue();
	}	
	
	/* function formatDate(val,row){
		var date=FormatTime("yyyy-MM-dd hh:mm:ss",value,val.create_time);
		return date;
	} */
</script>
</head>
<body style="margin:1px;">
	<table id="dg" class="easyui-datagrid"
	 fitColumns="true" pagination="true" rownumbers="true"
	 url="${pageContext.request.contextPath}/pigsty/list.do" fit="true" toolbar="#tb" showFooter="true">
	 <thead>
	 	<tr>
	 		<th field="cb" checkbox="true" align="center"></th>
	 		<th field="psid" width="20" align="center" hidden="true">编号</th>
	 		<th field="psno" width="30" align="center">猪舍编码</th>
	 		<th field="psname" width="30" align="center" hidden="true">猪舍名称</th>
	 		<th field="psstock" width="30" align="center">库存量</th>
	 		<th field="tuname" width="30" align="center">所属栋</th>
	 		<th field="remark" width="30" align="center">备注</th>	 				 		
	 	</tr>
	 </thead>
	</table>
	<div id="tb">
		<div>
			<a href="javascript:openPigstyAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">新建</a>
			<a href="javascript:openPigstyrModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
			<a href="javascript:deletePigsty()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
		</div>
		<div>
			&nbsp;猪舍编号：&nbsp;<input type="text" id="s_psno" size="20" onkeydown="if(event.keyCode==13) searchPigsty()"/>			
			<a href="javascript:searchPigsty()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
		</div>
	</div>
	
	<div id="dlg" class="easyui-dialog" style="width: 600px;height:250px;padding: 10px 10px" closed="true" buttons="#dlg-buttons" data-options="onClose:function(){resetValue()}">
	 	<form id="fm" method="post">
	 		<table cellspacing="8px">
	 		    <tr>
	 		    <td>猪舍编码：</td>
	 				<td><input type="text" id="psno" name="psno" class="easyui-validatebox" required="true"/></td>
	 				<td>所属栋：</td>
	 				<td>
	 				  <input class="easyui-combobox" id="tuno" name="tuno" required="true" data-options="panelHeight:'auto',editable:false,valueField:'tuno',textField:'tuname',url:'${pageContext.request.contextPath}/tung/list.do'"/>&nbsp;<font color="red">*</font>
	 				</td>
	 		    </tr>
	 			<!-- <tr>
	 				<td>猪舍名称：</td>
	 				<td><input type="text" id="psname" name="psname" class="easyui-validatebox" required="true"/></td>	 					 				
	 			</tr> -->
	 			<tr>
	 				<td valign="top">备注：</td>
	 				<td colspan="4">
	 					<textarea rows="5" cols="50" id="remark" name="remark"></textarea>
	 				</td>	 				
	 			</tr> 
	 					
	 		</table>
	 	</form>
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:savePigsty()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closePigstyDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
</body>
</html>