// ��ȡ��ǰ����ʱ��
function getCurrentDateTime(){
	 var date=new Date();
	 var year=date.getFullYear();
	 var month=date.getMonth()+1;
	 var day=date.getDate();
	 var hours=date.getHours();
	 var minutes=date.getMinutes();
	 var seconds=date.getSeconds();
	 return year+"-"+formatZero(month)+"-"+formatZero(day)+" "+formatZero(hours)+":"+formatZero(minutes)+":"+formatZero(seconds);
 }

// ��ȡ��ǰ����
function getCurrentDate(){
	 var date=new Date();
	 var year=date.getFullYear();
	 var month=date.getMonth()+1;
	 var day=date.getDate();
	 return year+"-"+formatZero(month)+"-"+formatZero(day);
}


 function formatZero(n){
	 if(n>=0&&n<=9){
		 return "0"+n;
	 }else{
		 return n;
	 }
 }

 /*
  * #合并单元格
 tableID:表格的ID
 colList：需要合并的列，如果有多个，可以以,分开
 */

 
//底部求和
//列表数据初始化
 function queryDetails(tableid){
 	/*var startTime = $.trim($("#startTime").val());
 	var endTime = $.trim($("#endTime").val());
 	
 	if(startTime == "undefine" || startTime == null || startTime == ''){
 		$.walk.alert("请输入交接开始时间！", "info");
 		return;
 	}
 	if(endTime == "undefine" || endTime == null || endTime == ''){
 		$.walk.alert("请输入交接结束时间！", "info");
 		return;
 	}*/
 	
 	$("#"+tableid).datagrid({
 		url : baseUrl + "/logisticsStatus/qryLogistcsDeliverDay",
 		/*queryParams : {
 			startTime:startTime,
 			endTime:endTime
 		},*/
 		pageNumber:1,
 		pageSize:5,
 		nowrap:false,
 		pageList:[30,50,100,200,300],
 		pagination: true,
 		loadMsg: "数据加载中....",
 		collapsible: true,
// 		onClickCell:function (rowIndex, field, value){
// 			setTimeout(function(){
// 				reckon();
// 			},1);
// 		},
 		onCheck:function (rowIndex, rowData){
 			setTimeout(function(){//延时执行自己体会效果
 				debugger;
 				reckon();
 			},0.001);
 		},
 		onUncheck:function (rowIndex, rowData){
 			setTimeout(function(){
 				reckon();
 			},0.001);
 		},
 		onLoadSuccess: onLoad
 	});
 }
  
 //计算总计
 function onLoad(){
 	//给全选复选框绑定click事件
 	$(".datagrid-header-check").children('input').bind("click",function(){
 		setTimeout(function(){
 			reckon();
 		},0.001);
 	});
 	
 	//初始化添加总计行
 	addTotalRow();
 }
 //初始化添加总计行
 function addTotalRow(){
 	//添加“合计”列-[添加统计行]
 	$('#datagridTable').datagrid('appendRow',{
 		TRADE_ID: '<span id="span_font_item">合&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;计:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + '共&nbsp;' + sumTotal() + '&nbsp;单</span>',
 		PAGE_NUM: '<span id="span_font_item">' + compute("PAGE_NUM") + '</span>',
 		COMMDITY_NUM: '<span id="span_font_item">' + compute("COMMDITY_NUM") + '</span>',
 		WEIGHT: '<span id="span_font_item">' + compute("WEIGHT").toFixed(3) + '</span>',
 		FIRST_WEIGHT_FEE: '<span id="span_font_item">' + compute("FIRST_WEIGHT_FEE").toFixed(2) + '</span>',
 		FEIGHT_FEE: '<span id="span_font_item">' + compute("FEIGHT_FEE").toFixed(2) + '</span>',
 		PROT_ORGFEE: '<span id="span_font_item">' + compute("PROT_ORGFEE").toFixed(2) + '</span>',
 		PROT_FEE: '<span id="span_font_item">' + compute("PROT_FEE").toFixed(2) + '</span>',
 		FEIGHT_FEE_TOTAL: '<span id="span_font_item">' + compute("FEIGHT_FEE_TOTAL").toFixed(2) + '</span>'
      });
 	
 	//合并单元格
 	var rowsTotal = $('#datagridTable').datagrid('getRows');//获取最新的所有行
 	$('#datagridTable').datagrid('mergeCells',{
 		index: rowsTotal.length - 1,
 		field: 'TRADE_ID',
 		colspan:8
 	});
 	
 	//设置添加行的复选框不可见)
 	$(".datagrid-cell-check").children('input')[rowsTotal.length - 1].style.visibility="hidden";
 	
 	//设置增加过总计标识
 	isExt = true;
 }
  
 //总计计算
 function reckon(){
 	//删除统计行，如果存在统计行则删除后重新添加
 	if(isExt){
 		var rows = $('#datagridTable').datagrid('getRows');
 		$('#datagridTable').datagrid('deleteRow', rows.length - 1);
 	}
 	
 	addTotalRow();
 }
  
 //总选中条数
 function sumTotal(){
 	 var rows = $('#datagridTable').datagrid('getSelections');
      return rows.length;
 }
  
 //指定列求和
 function compute(colName) {
 	debugger;
      var rows = $('#datagridTable').datagrid('getSelections');
      var total = 0;
      for (var i = 0; i < rows.length; i++) {
          total += parseFloat(rows[i][colName]);
      }
      return total;
  }
