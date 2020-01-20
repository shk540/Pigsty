<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.7.0/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.7.0/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.7.0/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.7.0/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.7.0/locale/easyui-lang-zh_CN.js"></script>

<script src="${pageContext.request.contextPath}/static/js/echarts.min.js"></script>	    

<script type="text/javascript">

$(function(){	
	var myChart
	initChart(null,null);
});


function searchpigsflow(){
	$("#dg").datagrid('load',{		
		"begin_time":$("#s_begintime").datebox("getValue"),
		"end_time":$("#s_endtime").datebox("getValue")
	});	
	begin_time=$("#s_begintime").datebox("getValue");
	end_time=$("#s_endtime").datebox("getValue");
	initChart(begin_time,end_time);
}
;
function chart1(result){	
	if (result) {
	    var psname=[];  
	    var inamount=[]; 
	    var outamount=[];
	    
        for(var i=0;i<result.length;i++){       
        	psname.push(result[i].psname);
         }
        for(var i=0;i<result.length;i++){       
            inamount.push(result[i].inamount);
          }
        for(var i=0;i<result.length;i++){       
            outamount.push(-result[i].outamount);
          }
    	myChart = echarts.init(document.getElementById('bar'));
    	
    	option={
    	        title: {
    	            text: ''
    	        },
    	        tooltip: {},
    	        legend: {
    	            data:['增加','减少'],
    	            right:43
    	        },
    	        xAxis: {
    	        	data: psname,
                    axisLabel: {  
                    	   interval:0,  
                    	   rotate:40  
                    	},
    	            axisTick: { //坐标轴相关配置
    	                show: true, //是否显示坐标轴刻度
    	                inside: true //坐标轴刻度朝向，true为朝内，false朝外，默认false
    	            },
    	            axisLine: {
    	                lineStyle: {
    	                    color: "#aaa", //x轴坐标轴轴线颜色
    	                }
    	            },
    	            axisLabel:{
    	                color:"#666",   //刻度标签的文字颜色
    	            }
    	        },
    	        yAxis: {splitLine: { //坐标轴在grid区域中的分割线
    	            show: true, //显示分割线
    	        },    	        
    	        axisLabel:{
    	            color:"#666",   //刻度标签的文字颜色
    	        }},
    	        series: [{
    	            name: '增加',
    	            type: 'bar',
    	            itemStyle: {   
        	            //通常情况下：
        	            normal:{  
        	                color: function (params){
        	                    var colorList = ['rgb(164,205,238)','rgb(42,170,227)','rgb(25,46,94)','rgb(195,229,235)'];
        	                    return colorList[params.dataIndex];
        	                }
        	            },
        	            emphasis: {
        	                    shadowBlur: 10,
        	                    shadowOffsetX: 0,
        	                    shadowColor: 'rgba(0, 0, 0, 0.5)'
        	            }
        	        },
    	            data: inamount
    	        },
    	        {
    	            name: '减少',
    	            type: 'bar',
    	            itemStyle: {   
        	            //通常情况下：
        	            normal:{  
        	                color: function (params){
        	                    var colorList = ['rgb(164,205,238)','rgb(42,170,227)','rgb(25,46,94)','rgb(195,229,235)'];
        	                    return colorList[params.dataIndex];
        	                }
        	            },
        	            emphasis: {
        	                    shadowBlur: 10,
        	                    shadowOffsetX: 0,
        	                    shadowColor: 'rgba(0, 0, 0, 0.5)'
        	            }
        	        },
    	            data: outamount
    	        }]
    	        
    	    };
    	    
    	    myChart.showLoading();    	    
    	    myChart.setOption(option);
            myChart.hideLoading();    //隐藏加载动画          
 }
};

function initChart(begin_time,end_time){
	$.ajax({
	    type : "post",
	    async : true,            //异步请求（同步请求将会锁住浏览器，用户其他操作必须等待请求完成才可以执行）
	    url : "${pageContext.request.contextPath}/pigstyflow/listflowbyno.do",    //请求发送到TestServlet处
	    data : {"begin_time":begin_time,"end_time":end_time},
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

	<div data-options="region:'north'" style="height:400px">
		<table id="dg" title="当月猪舍流水" class="easyui-datagrid"
	 fitColumns="true" width="auto" pagination="true" rownumbers="true" striped="true" singleSelect="true" showFooter="true"	 
	 url="${pageContext.request.contextPath}/pigstyflow/listflow.do" fit="true" style="width: 100%;" toolbar="#tb" style="font-size:14px;">
	 <thead>
	 	<tr>
	 		<th field="psno" width="30" align="center" >猪舍编码</th>
	 		<th field="psname" width="30" align="center" >猪舍名称</th>	 			 		
	 		<th field="typeno" width="30" align="center" >流转编码</th>
	 		<th field="typename" width="30" align="center" >流转类型</th>
	 		<th field="amount" width="30" align="center" >流转数量</th>
	 	</tr>
	 </thead>
	</table>
	</div>
	
	<div id="tb">		
		<div>			
			&nbsp;开始日期&nbsp;<input type="text" id="s_begintime" class="easyui-datebox" editable="true">
			&nbsp;结束日期&nbsp;<input type="text" id="s_endtime" class="easyui-datebox" editable="true">
			&nbsp;<a href="javascript:searchpigsflow()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
		</div>
	</div>
		
	<div data-options="region:'center'" id="bar" title="猪舍流转分布图" style="width:100%">
	</div>
	  <%-- <jsp:include page="echart.jsp">
	  <jsp:param value="${begin_time}" name="begin_time"/>	 
	  <jsp:param value="${end_time}" name="end_time"/>
	   </jsp:include> --%>     
</body>
</html>