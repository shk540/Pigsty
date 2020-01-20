<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>中粮猪舍管理系统主页</title>
<link rel="icon" href="${pageContext.request.contextPath}/static/images/favicon.ico" mce_href="${pageContext.request.contextPath}/static/images/favicon.ico" type="image/x-icon"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/themes/ui-pepper-grinder/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.easyui.theme.v1.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">

	var url;
	
	function openTab(text,url,iconCls){
		if($("#tabs").tabs("exists",text)){
			$("#tabs").tabs("select",text);
		}else{
			if(url.indexOf("cpt")>0)
			{
				var content="<iframe frameborder=0 scrolling='auto' style='width:100%;height:100%' src='../../Pigsty/decision/view/report?viewlet=/"+url+"&op=write'></iframe>";
				$("#tabs").tabs("add",{
					title:text,
					iconCls:iconCls,
					closable:true,
					content:content
				});				
			}
			else{
				var content="<iframe frameborder=0 scrolling='auto' style='width:100%;height:100%' src='${pageContext.request.contextPath}/page/"+url+"'></iframe>";
				$("#tabs").tabs("add",{
					title:text,
					iconCls:iconCls,
					closable:true,
					content:content
				});
			}
		}
	}
	
	function openPasswordModifyDialog(){
		$("#dlg").dialog("open").dialog("setTitle","修改密码");
		url="${pageContext.request.contextPath}/breeder/modifypass.do?breid=${currentBreeder.breid}";
	}
	
	function closePasswordModifyDialog(){
		$("#dlg").dialog("close");
		$("#oldPassword").val("");
		$("#newPassword").val("");
		$("#newPassword2").val("");
	}
	
	function modifyPassword(){
		$("#fm").form("submit",{
			url:url,
			onSubmit:function(){
				var oldPassword=$("#oldPassword").val();
				var newPassword=$("#newPassword").val();
				var newPassword2=$("#newPassword2").val();
				if(!$(this).form("validate")){
					return false;
				}
				if(oldPassword!='${currentBreeder.password}'){
					$.messager.alert("系统提示","用户密码输入错误！");
					return false;
				}
				if(newPassword!=newPassword2){
					$.messager.alert("系统提示","确认密码输入错误！");
					return false;
				}
				return true;
			},
			success:function(result){
				var result=eval('('+result+')');
				if(result.success){
					$.messager.alert("系统提示","密码修改成功，下一次登录生效！");
					closePasswordModifyDialog();
				}else{
					$.messager.alert("系统提示","密码修改失败");
					return;
				}
			}
		});
	}
	
	function logout(){
		$.messager.confirm("系统提示","您确定要退出系统吗",function(r){
			if(r){
				window.location.href="${pageContext.request.contextPath}/breeder/logout.do";
			}
		});
	}
</script>
</head>
<body class="easyui-layout">
<div region="north" style="height: 78px;background-color: #ECEADF">
	<table style="padding: 5px" width="100%">
		<tr>
			<td width="50%">
				<img src="${pageContext.request.contextPath}/static/images/logo.png" style="height:60px"/>
			</td>
			<td width="50%" style="font-family:微软雅黑;" valign="bottom">
				<span ><font size="2" color="green"><strong>欢迎：${currentBreeder.username}:${currentBreeder.brename}</strong></font></span>
			</td>
		</tr>
	</table>
</div>
<div region="center">
	<div class="easyui-tabs" fit="true" border="false" id="tabs">
		<div title="首页" data-options="iconCls:'icon-home'">
			<div align="center" style="padding:100px">
			  <img src="${pageContext.request.contextPath}/static/images/pig_home.png" style="width:50%;height:50%;opacity:0.3;vertical-align:middle;"  />
			</div>
		</div>
	</div>
</div>
<div region="west" style="width: 200px" title="导航菜单" split="true">
	<div class="easyui-accordion" data-options="fit:true,border:false,iconCls:'icon-yxgl'">
		<div title="资料管理" data-options="iconCls:'icon-yxgl'" style="padding: 10px">
			<a href="javascript:openTab('饲养员定义','breederManage.jsp','icon-yxjhgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-yxjhgl'" style="width: 150px;">饲养员定义</a>
			<a href="javascript:openTab('猪舍定义','pigstyManage.jsp','icon-khkfjh')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khkfjh'" style="width: 150px;">猪舍定义</a>
			<a href="javascript:openTab('流转类型定义','flowtypeManage.jsp','icon-sjzdgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-sjzdgl'" style="width: 150px;">流转类型定义</a>
		</div>			
		<div title="进销管理"  data-options="selected:true,iconCls:'icon-khgl'" style="padding:10px;">
			<a href="javascript:openTab('猪舍分配管理','pigsbreManage.jsp','icon-khxxgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khxxgl'" style="width: 150px;">猪舍分配管理</a>
			<a href="javascript:openTab('猪舍流水管理(S)','pigstyflowManage.jsp','icon-khlsgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khlsgl'" style="width: 150px;">猪舍流水管理(S)</a>
			<a href="javascript:openTab('猪舍流水管理(M)','flowbatManage.jsp','icon-khlsgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khlsgl'" style="width: 150px;">猪舍流水管理(M)</a>
			<a href="javascript:openTab('猪舍疫苗计划','vaccineManage.jsp','icon-khxxgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khxxgl'" style="width: 150px;">猪舍疫苗计划</a>
		</div>		
		<div title="统计分析"  data-options="iconCls:'icon-tjbb'" style="padding:10px">
			<a href="javascript:openTab('猪舍构成分析','pigstyQuery.jsp','icon-khgcfx')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khgcfx'" style="width: 150px;">猪舍构成分析</a>
			<a href="javascript:openTab('猪舍进销分析','pigsflowQuery.jsp','icon-khfwfx')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khfwfx'" style="width: 150px;">猪舍进销分析</a>
			<a href="javascript:openTab('猪舍分配查询','pigsbreQuery.jsp','icon-khlsfx')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khlsfx'" style="width: 150px;">猪舍分配查询</a>
			<a href="javascript:openTab('猪舍统计汇总','pigsty.cpt','icon-khlsfx')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khlsfx'" style="width: 150px;">猪舍汇总统计</a>
		</div>
		
		<div title="系统管理"  data-options="iconCls:'icon-item'" style="padding:10px">
			<a href="javascript:openPasswordModifyDialog()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-modifyPassword'" style="width: 150px;">修改密码</a>
			<a href="javascript:logout()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-exit'" style="width: 150px;">安全退出</a>
		</div>
	</div>
</div>
<div region="south" style="height: 25px;padding: 5px;" align="center">
	中粮集团版权所有  <a href="http://www.pigsty.com" target="_blank">http://www.pigsty.com</a> (2019-2020)
</div>


<div id="dlg" class="easyui-dialog" style="width: 400px;height:250px;padding: 10px 20px"
  closed="true" buttons="#dlg-buttons">
 	<form id="fm" method="post">
 		<table cellspacing="8px">
 			<tr>
 				<td>用户名：</td>
 				<td><input type="text" id="username" name="username" value="${currentBreeder.username }" disabled="true" style="width: 200px"/></td>
 			</tr>
 			<tr>
 				<td>原密码：</td>
 				<td><input type="password" id="oldPassword" class="easyui-validatebox" required="true" style="width: 200px"/></td>
 			</tr>
 			<tr>
 				<td>新密码：</td>
 				<td><input type="password" id="newPassword" name="password" class="easyui-validatebox" required="true" style="width: 200px"/></td>
 			</tr>
 			<tr>
 				<td>确认新密码：</td>
 				<td><input type="password" id="newPassword2"  class="easyui-validatebox" required="true" style="width: 200px"/></td>
 			</tr>
 		</table>
 	</form>
</div>

<div id="dlg-buttons">
	<a href="javascript:modifyPassword()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
	<a href="javascript:closePasswordModifyDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
</div>

</body>
</html>