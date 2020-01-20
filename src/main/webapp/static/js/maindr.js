function getflowtype(){
	$.ajax({
		   url:"${pageContext.request.contextPath}/flowtype/findflowtype.do",	
		   type:"GET",
		   dataType:"json",
           async:false,
		   success:function(data){	
			   result=data;
		   },
		   error:function(e){
			   alert("error","请求数据出错!",'error');
	       }
		});
   return result;
}