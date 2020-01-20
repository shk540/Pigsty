<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE html>
<html>
<head>
<link rel="icon" href="${pageContext.request.contextPath}/static/images/favicon.ico" mce_href="${pageContext.request.contextPath}/static/images/favicon.ico" type="image/x-icon"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-3.4.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/bootstrap.min.css"></link>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">

	$(function(){
			$('#myModal').modal('show');
	});
	
	function checkForm(){
		var username=$("#username").val();
		var password=$("#password").val();
		if(username==null||username==""){
			$("#error").html("用户名不能为空！");
			return false;
		}
		if(password==null||password==""){
			$("#error").html("密码不能为空！");
			return false;
		}
		return true;
	}
</script>

<style>
  span{
      color:red;
      font-size:small;      
  }
</style>
</head>
<body style="background:url(${pageContext.request.contextPath}/static/images/pig_login.jpg);background-size:100%">

<div class="modal fade" id="myModal" style="top:50%;position: absolute;margin-top:-200px;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			</div>
			<div class="modal-body">
				<h4 class="modal-title" align="center"><strong>中粮猪舍管理系统</strong></h4>
				<br/>
				<form class="form-horizontal" role="form" onsubmit="return checkForm()" action="${pageContext.request.contextPath}/breeder/login.do">
					<div class="form-group">
						<label for="username" class="col-sm-offset-2 col-sm-2 control-label">账号</label>
						<div class="col-sm-5">
							<input type="text" class="form-control" id="username" name="username" value="${currentBreeder.username }" placeholder="请输您的入账号">
						</div>
					</div>
					<div class="form-group">
						<label for="password" class="col-sm-offset-2 col-sm-2 control-label">密码</label>
						<div class="col-sm-5">
							<input type="password" class="form-control" id="password" name="password" value="${currentBreeder.password }" placeholder="请输入您的密码">
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-offset-4 col-sm-5">
							<button id="submitBtn" type="submit" class="btn btn-default btn-block btn-primary">登录</button>
							<span><font color="red" id="error">${errorMsg}</font></span>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->
</body>
</html>