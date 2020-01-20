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

<script src="${pageContext.request.contextPath}/static/js/echarts.min.js"></script>	    
<style type="text/css">
      .subtotal { font-weight: bold; }/*合计单元格样式*/
</style>
<script type="text/javascript">

$(function(){	
	var myChart;
	initChart(null);
	loaddg();	
});

function loaddg(){
 $('#dg').datagrid({
	                singleSelect: true,
	                onLoadSuccess: compute,//加载完毕后执行计算
	                url: "${pageContext.request.contextPath}/pigsty/liststock.do",
	                title: '猪舍库存量',
	                width: '300px',
					fitColumns:"true",
					rownumbers:"true",
					striped:"true",
					showFooter:"true",
					fit:true,
	                columns: [[
					 { field: 'psno', width: 80, align: 'center', title: '猪舍编码' },
	                 { field: 'psname', width: 100,  align: 'center', title: '猪舍名称' },
	                 { field: 'psstock', width: 80, align: 'center', title: '数量(头)' }
	                 ]]
	            });
};
function compute() {//计算函数
	            var rows = $('#dg').datagrid('getRows')//获取当前的数据行
	            var ptotal = 0//计算listprice的总和
	            for (var i = 0; i < rows.length; i++) {
	                ptotal += rows[i]['psstock'];
	            }
	            //新增一行显示统计信息
	            $('#dg').datagrid('appendRow', { psno: '<b>合计：</b>', psstock: ptotal});
	        };

function searchpigstock(){
	$("#dg").datagrid('load',{"create_time":$("#s_createtime").datebox("getValue")
	});	
	
	create_time=$("#s_createtime").datebox("getValue");
	initChart(create_time);
}
;
function chart1(result){	
	if (result) {
	    var psname=[];  
	    var stock=[]; 
	    //var dataObj=eval("("+result+")");
	    $.each(result,function(key,values){
	    	                      psname.push(values.psname);
	    	                      var obj = new Object();
	    	                      obj.name = values.psname;
	    	                      obj.value = values.psstock;
	    	                      stock.push(obj);
	    	                   });
	    
    	myChart = echarts.init(document.getElementById('pie'));
    	
    	option={
    	backgroundColor: 'white',
    	title: {
            x: 'left'
        },
        legend:{
        	orient:'vertical',
        	x:'left',
        	y:"center"
        },
        tooltip: {
            formatter: "{a} <br/>{b} : {c} ({d}%)"
        },
        color: ['#CD5C5C', '#00CED1', '#9ACD32', '#FFC0CB','#DC143C','#9400D3','#4169E1','#8FBC8F','#008000','#FFD700','#A52A2A'],
        stillShowZeroSum: false,
        series: [
            {   name:'库存量:',
                type: 'pie',
                radius: '80%',
                center: ['50%', '50%'],
                data: stock,            
                itemStyle: {
                    emphasis: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(128, 128, 128, 0.5)'
                    }
                },
                labelLine: {
                    normal: {
                      show: false   // show设置线是否显示，默认为true，可选值：true ¦ false
                    }
                  },
             // 设置值域的标签
              label: {
                  normal: {
                    position: 'outer',  // 设置标签位置，默认在饼状图外 可选值：'outer' ¦ 'inner（饼状图上）'
                    // formatter: '{a} {b} : {c}个 ({d}%)'   设置标签显示内容 ，默认显示{b}
                    // {a}指series.name  {b}指series.data的name
                    // {c}指series.data的value  {d}%指这一部分占总数的百分比
                    formatter: '{b}:{c}'
                  }
                }
            }
        ] 
    };
    	    
    	    myChart.showLoading();    	    
    	    myChart.setOption(option);
            myChart.hideLoading();    //隐藏加载动画          
 }
};

function initChart(create_time){
	$.ajax({
	    type : "post",
	    async : true,            //异步请求（同步请求将会锁住浏览器，用户其他操作必须等待请求完成才可以执行）
	    url : "${pageContext.request.contextPath}/pigsty/liststock.do",    //请求发送到TestServlet处
	    data : {"create_time":create_time},
	    dataType : "json",        //返回数据形式为json
	    success : function(result) {   
	    	chart1(result);
	   }/* ,
	    error : function(errorMsg) {
	        //请求失败时执行该函数
	    alert("图表请求数据失败!");
	    myChart.hideLoading();
	    } */
	});
    
};

$(window).resize(function() {
    setTimeout(function(){
        myChart.resize();
    },100)
    
});
</script>
</head>
<body style="margin:1px;" class="easyui-layout">

	<div data-options="region:'west'" style="width:400px">
		<table id="dg" toolbar="#tb">
	 <thead>
	 	<tr>
	 		<th field="psno" width="30" align="center" >猪舍编码</th>
	 		<th field="psname" width="30" align="center" >猪舍名称</th>	 			 		
	 		<th field="psstock" width="30" align="center" >数量(头)</th>
	 	</tr>
	 </thead>
	</table>
	</div>
	
	<div id="tb">		
		<div>			
			&nbsp;日期&nbsp;<input type="text" id="s_createtime" class="easyui-datebox" editable="true">
			&nbsp;<a href="javascript:searchpigstock()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
		</div>
	</div>
		
	<div data-options="region:'center'" id="pie" title="猪舍库存占比图" style="width:100%">
	</div>
	  <%-- <jsp:include page="echart.jsp">
	  <jsp:param value="${begin_time}" name="begin_time"/>	 
	  <jsp:param value="${end_time}" name="end_time"/>
	   </jsp:include> --%>     
</body>
</html>