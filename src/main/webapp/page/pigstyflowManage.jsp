<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
/* 
$(function(){
	formatrow();
}); */
	var url;
	
	function searchPigstyflow(){
		$("#dg").datagrid('load',{
			"psno":$("#s_psno").val(),
			"typeno":$("#s_typeno").combobox("getValue"),
			"if_check":$("input[name='s_check']:checked").val()
		});
	}
	
	function closeBreederDialog(){
		$("#dlg").dialog("close");
		resetValue();
	}
	
	function formatFlowdirect(val,row){
		if(val=='+'){
			return "增加";
		}else{
			return "减少";
		}
	}
	
	function formatIfcheck(val,row){
		if(val=='Y'){
			return "已审核";
		}else{
			return "未审核";
		}
	}	
	
	function formatAmount(val,row){
		if(row.flowdirect=='-'){
			return "-"+row.amount;
		}else{
			return row.amount;
		}
	}
	
	function formatrow(){
		$('#dg').datagrid({
			rowStyler:function(index,row){
				if (row.if_check=='N'){
					return 'background-color:pink;color:black;';
				}
			}
		});
	}
	function openPigstyflowAddDialog(){
		$("#dlg").dialog("open").dialog("setTitle","猪舍流转");
		resetValue();
		url="${pageContext.request.contextPath}/pigstyflow/save.do";
	}
	
	
	function savePigstyflow(){
		$("#fm").form("submit",{
			url:url,
			onSubmit:function(){
				if($("#psno").combobox("getValue")==""){
					$.messager.alert("系统提示","请选择猪舍名称");
					return false;
				}
				if($("#typeno").combobox("getValue")==""){
					$.messager.alert("系统提示","请选择流转类型");
					return false;
				}	
				if($("#username").combobox("getValue")==""){
					$.messager.alert("系统提示","请选择饲养员");
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
					$("#dg").datagrid("reload");
					return;
				}
			}
		});
	}
	
	function openPigstyflowModifyDialog(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length!=1){
			$.messager.alert("系统提示","请选择一条要修改的数据！");
			return;
		}
		var row=selectedRows[0];
		if(row.if_check=="Y"){
			$.messager.alert("系统提示","不允许修改已审核数据！");
			return;
		}
		$("#dlg").dialog("open").dialog("setTitle","编辑猪舍流水信息");
		$("#username").attr("disabled",true);
		$('#fm').form('load',row);		
		url="${pageContext.request.contextPath}/pigstyflow/save.do?flowid="+row.flowid;
	}
	
	function resetValue(){
		$("#typeno").combobox("setValue","");
		$("#psno").combobox("setValue","");
		$("#amount").numberbox("clear");
		$("#batno").val("");
		$("#username").combobox("setValue","");
		$("#days").numberbox("clear");
	}
	
	function closePigstyflowDialog(){
		$("#dlg").dialog("close");
		resetValue();
	}
	$('.panel-tool-close').click(function(){
	 	$('.panel.window.messager-window').find('div:last').find('a').click();
	});
	
	function checkPigstyflow(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			$.messager.alert("系统提示","请选择要审核的数据！");
			return;
		}
		var strIds=[];
		for(var i=0;i<selectedRows.length;i++){
			strIds.push(selectedRows[i].flowid);
		}
		var flowids=strIds.join(",");
		$.messager.confirm("系统提示","您确认要审核这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
			if(r){
				$.post("${pageContext.request.contextPath}/pigstyflow/save.do",{flowids:flowids},function(result){
					if(result.success){
						$.messager.alert("系统提示","审核通过！");
						$("#dg").datagrid("reload");
						formatrow();
					}else{
						$.messager.alert("系统提示",result.error);
						$("#dg").datagrid("reload");
					}
				},"json");
			}
		});
		
	}	
</script>
</head>
<body style="margin:1px;">
	<table id="dg"  class="easyui-datagrid"
	 fitColumns="true" pagination="true" rownumbers="true"
	 url="${pageContext.request.contextPath}/pigstyflow/list.do?is_bat=0" fit="true" toolbar="#tb" rowStyler="formatrow">
	 <thead>
	 	<tr>
	 		<th field="cb" checkbox="true" align="center"></th>
	 		<th field="flowid" width="20" align="center">流水号</th>
	 		<th field="psno" width="20" align="center">猪舍编号</th>
	 		<th field="psname" width="20" align="center">猪舍名称</th>
	 		<th field="create_time" width="20" align="center">生成时间</th>
	 		<th field="typename" width="20" align="center">流转类型</th>
	 		<th field="batno" width="20" align="center">批次号</th>
	 		<th field="days" width="20" align="center">日龄</th>
	 		<th field="flowdirect" width="20" align="center" formatter="formatFlowdirect" hidden="true">流转方向</th>
	 		<th field="amount" width="20" align="center"formatter="formatAmount">流转数量</th>
	 		<th field="stock" width="20" align="center">流转后库存</th>	 
	 		<th field="brename" width="20" align="center">饲养员</th>
	 		<th field="if_check" width="20" align="center" formatter="formatIfcheck">是否审核</th>
	 	</tr>
	 </thead>
	</table>
	<div id="tb">
		<div>
			<a href="javascript:openPigstyflowAddDialog()" class="easyui-linkbutton" iconCls="icon-reload" plain="true">流转</a>
			→
			<a href="javascript:openPigstyflowModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
			→
			<a href="javascript:checkPigstyflow()" class="easyui-linkbutton" iconCls="icon-ok" plain="true">审核</a>
		</div>
		<div>
			&nbsp;猪舍编码:&nbsp;<input type="text" id="s_psno" size="20" onkeydown="if(event.keyCode==13) searchPigstyflow()"/>
			&nbsp;流转类型:&nbsp;
			<input class="easyui-combobox" id="s_typeno" name="s_typeno"  data-options="width:'100',panelHeight:'auto',editable:true,valueField:'typeno',textField:'typename',url:'${pageContext.request.contextPath}/flowtype/findflowtype.do'"/>
			&nbsp;是否审核:<input name="s_check" type="radio" value="N"/>否<input name="s_check" type="radio" value="Y"/>是
			<a href="javascript:searchPigstyflow()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
		</div>
	</div>
	
	<div id="dlg" class="easyui-dialog" style="width: 620px;height:200px;padding: 10px 30px" closed="true" buttons="#dlg-buttons" data-options="onClose:function(){resetValue()}">
	 	<form id="fm" method="post">
	 	<table cellspacing="8px">	 			
	 			<tr>
	 				<td>猪舍名称:</td>
	 				<td>
	 					<input class="easyui-combobox" id="psno" name="psno"  
	 					data-options="panelHeight:'300',editable:false,valueField:'psno',textField:'psname',
	 					url:'${pageContext.request.contextPath}/pigsty/findpigsty.do',
	 					onChange: function(newValue,oldValue){
						            $('#username').combobox({
						            url:'${pageContext.request.contextPath}/pigsbre/find_brename.do?psno='+newValue,                   
						            valueField:'username',
						            textField:'brename'
						            })
						            }
						            "/>&nbsp;<font color="red">*</font>
	 				</td>
	 				<td>饲养员:</td>
	 				<td>
	 					<input class="easyui-combobox" id="username" name="username"  data-options="panelHeight:'auto',editable:false,valueField:'username',textField:'brename'
	 					,url:'${pageContext.request.contextPath}/breeder/findbreeder.do'
	 					,onLoadSuccess: function () { //加载完成后,默认选中第一项
					         var val = $(this).combobox('getData');					        
					         if(val.length>0){					          		 
					          		 $(this).combobox('select',val[0].username);		                 
					         }			             
					        }"/>&nbsp;<font color="red">*</font>
	 				</td>
	 								
	 			</tr>
	 			<tr>
	 				<td>批次号:</td>
	 				<td>
	 					<input type="text" id="batno" name="batno" class="easyui-validatebox"/></td>
	 				</td>
	 				<td>日龄:</td>
	 				<td>
	 				    <input type="text" id="days" name="days" class="easyui-numberbox"/></td>
	 				</td>	 				
	 			</tr>
	 			<tr>
	 			   <td>流转类型:</td>
	 				<td>
	 				  <input class="easyui-combobox" id="typeno" name="typeno"  data-options="panelHeight:'auto',editable:false,valueField:'typeno',textField:'typename',url:'${pageContext.request.contextPath}/flowtype/findflowtype.do'"/>&nbsp;<font color="red">*</font>
	 				</td>	 
	 			   <td>流转数量:</td>
		 		   <td>
		 			   <input type="text" id="amount" name="amount" class="easyui-numberbox"/>&nbsp;<font color="red">*</font></td>
		 		   </td>
	 			</tr> 			
	 	</table>	 		
	 	</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:savePigstyflow()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closePigstyflowDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
</body>
</html>