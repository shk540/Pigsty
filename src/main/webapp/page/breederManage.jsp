<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title><link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/themes/ui-pepper-grinder/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.easyui.theme.v1.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script type="text/javascript">
		
	$(function(){	
		console.log($("#dg").datagrid("options").frozenColumns);
	});
	
	var url;
	
	function searchBreeder(){
		$("#dg").datagrid('load',{
			"brename":$("#s_brename").val(),
			"cardno":null,
			"if_valid":$("#s_valid").combobox("getValue")
		});
	}
	
	function deleteBreeder(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			 $.messager.alert("系统提示","请选择要删除的数据！","warning");
			 /* $.messager.show({
	                title:'系统提示',
	                msg:'请选择要删除的数据！',
	                showType:'slide',
	                style:{
	                    right:'',
	                    top:document.body.scrollTop+document.documentElement.scrollTop,
	                    bottom:'',
	                    icon:'warning'
	                }
	            }); */
			return;
		}
		var strIds=[];
		for(var i=0;i<selectedRows.length;i++){
			strIds.push(selectedRows[i].breid);
		}
		var ids=strIds.join(",");
		$.messager.confirm("系统提示","您确认要删除这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
			if(r){
				$.post("${pageContext.request.contextPath}/breeder/delete.do",{ids:ids},function(result){
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
	
	function openBreederAddDialog(){
		$("#dlg").dialog("open").dialog("setTitle","新建饲养员");
		resetValue();
		url="${pageContext.request.contextPath}/breeder/save.do";
	}
	
	function saveBreeder(){
		$("#fm").form("submit",{
			url:url,
			onSubmit:function(){
				return $(this).form("validate");
			},
			success:function(result){
				var result=eval('('+result+')');
				if(result.success){
					$.messager.alert("系统提示","保存成功","info");
					resetValue();
					$("#dlg").dialog("close");
					$("#dg").datagrid("reload");
				}else{
					$.messager.alert("系统提示","保存失败","error");
					return;
				}
			}
		});
	}
	
	function openBreederModifyDialog(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length!=1){
			$.messager.alert("系统提示","请选择一条要编辑的数据！");
			return;
		}
		var row=selectedRows[0];
		$("#dlg").dialog("open").dialog("setTitle","编辑饲养员信息");		 
		$('#fm').form('load',row);
		$('#username').attr('readonly',true);
		//$('#username')。textbox('textbox').css('background','#ccc');
		//document.getElementById("#username").style.backgroundColor = "#00FF00";
		$("#username").next('span').children('.combo-text').first().css('background-color','red');
		url="${pageContext.request.contextPath}/breeder/save.do?breid="+row.breid;
	}
	
	function resetValue(){
		$("#brename").val("");
		$("#username").val("");
		$("[name='sex'][value=1]").attr("checked","checked").prop("checked", true).trigger("change");
		//$("#cardno").val("");
		$("#phone").val("");	
		$("[name='is_manager'][value=0]").attr("checked","checked").prop("checked", true).trigger("change");
		$("[name='if_valid'][value=1]").attr("checked","checked").prop("checked", true).trigger("change");
		$("#create_time").val("");
		$('#username').attr('readonly',false);
	}
	
	function closeBreederDialog(){
		$("#dlg").dialog("close");
		resetValue();
	}
	
	function formatvalid(val,row){
		if(val==1){
			return "有效";
		}else{
			return "失效";
		}
	}
	
	function formatManager(val,row){
		if(val==1){
			return "是";
		}else{
			return "否";
		}
	}
	
	function formatSex(val,row){
		if(val==1){
			return "男";
		}else{
			return "女";
		}
	}
	
	/* function formatDate(val,row){
		var date=FormatTime("yyyy-MM-dd hh:mm:ss",value,val.create_time);
		return date;
	} */
</script>
</head>
<body style="margin:1px;">
	<table id="dg" class="easyui-datagrid"
	 fitColumns="true" pagination="true" rownumbers="true" resizeHandle="both"
	 url="${pageContext.request.contextPath}/breeder/list.do" fit="true" toolbar="#tb" >
	 <thead>
	 	<tr>
	 		<th field="cb" checkbox="true" align="center" ></th>
	 		<th field="breid" width="20" align="center" hidden="true">编号</th>
	 		<th field="username" width="20" align="center" >用户名</th>
	 		<th field="brename" width="30" align="center">姓名</th>
	 		<th field="sex" width="30" align="center" formatter="formatSex">性别</th>
	 		<th field="cardno" width="50" align="center" hidden="true">身份证号</th>
	 		<th field="phone" width="50" align="center">联系电话</th>	 		
	 		<th field="password" width="20" align="center" hidden="true">密码</th>
	 		<th field="is_manager" width="20" align="center" formatter="formatManager">是否管理员</th>
	 		<th field="if_valid" width="20" align="center" formatter="formatvalid">是否有效</th>
	 		<th field="create_time" width="50" align="center">创建时间</th>	 		
	 	</tr>
	 </thead>
	</table>
	<div id="tb">
		<div>
			<a href="javascript:openBreederAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">新建</a>
			<a href="javascript:openBreederModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
			<a href="javascript:deleteBreeder()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
		</div>
		<div>
			&nbsp;姓名：&nbsp;<input type="text" id="s_brename" size="20" onkeydown="if(event.keyCode==13) searchBreeder()"/>
			<!-- &nbsp;身份证号：&nbsp;<input type="text" id="s_cardno" size="20" onkeydown="if(event.keyCode==13) searchBreeder()"/> -->
			&nbsp;是否有效：&nbsp;<select class="easyui-combobox" id="s_valid"  editable="false" panelHeight="auto">
								    <option value="">请选择...</option>
									<option value="0">失效</option>
									<option value="1">有效</option>
								</select>&nbsp;
			<a href="javascript:searchBreeder()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
		</div>
	</div>
	
	<div id="dlg" class="easyui-dialog" style="width: 600px;height:230px;padding: 10px 12px" closed="true" buttons="#dlg-buttons" data-options="onClose:function(){resetValue()}">
	 	<form id="fm" method="post">
	 		<table cellspacing="8px">
	 		    <tr>
	 		        <td>用户名：</td>
	 				<td><input type="text" id="username" name="username" class="easyui-validatebox" required="true"/></td>
	 		    </tr>
	 			<tr>
	 				<td>姓名：</td>
	 				<td><input type="text" id="brename" name="brename" class="easyui-validatebox" required="true"/></td>
	 				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	 				<td>性别：</td>
	 				<td>
	 				   <input name="sex" type="radio" value="0" />女<input name="sex" type="radio" value="1"/>男
				    </td>
	 			</tr>
	 			<tr>
	 				<!-- <td>身份证号：</td>
	 				<td><input type="text" id="cardno" name="cardno" /></td>
	 				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td> -->
	 				<td>联系电话：</td>
	 				<td><input type="text" id="phone" name="phone" /></td>
	 			</tr> 
	 			<tr>	 				
	 				<td>是否管理员：</td>
	 				<td>
	 				   <input name="is_manager" type="radio" value="0"/>否<input name="is_manager" type="radio" value="1"/>是
				    </td>
				    <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    <td>是否有效：</td>
	 				<td>
	 				   <input name="if_valid" type="radio" value="0" />失效<input name="if_valid" type="radio" value="1"/>有效
				    </td>
	 			</tr>			
	 		</table>
	 	</form>
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:saveBreeder()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeBreederDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
</body>
</html>