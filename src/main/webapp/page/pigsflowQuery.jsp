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

function searchpigsflow(){
	
	var begin=$("#s_begintime").datebox("getValue");
	var end=$("#s_endtime").datebox("getValue");
	
	if(begin=="" && end==""){
		$.messager.alert("系统提示","请选择开始或结束时间！","warning");
		return;
	}
	
	$("#dg").datagrid('load',{		
		"begin_time":$("#s_begintime").datebox("getValue"),
		"end_time":$("#s_endtime").datebox("getValue"),
		"typeno":$("#s_typeno").combobox("getValue"),
		"tuno":$("#s_tuno").combobox("getValue"),
		"psno":$("#s_psno").combobox("getValue")
	});
};

function mergeCellsByField(tableID, colList) {
    var ColArray = colList.split(",");
    var tTable = $("#" + tableID);
    var TableRowCnts = tTable.datagrid("getRows").length;
    var tmpA;
    var tmpB;
    var PerTxt = "";
    var CurTxt = "";
    var buyprocode = "";
    var newbuyprocode = "";
    var alertStr = "";
    for (j = ColArray.length - 1; j >= 0; j--) {
        PerTxt = "";
        buyprocode = "";
        tmpA = 1;
        tmpB = 0;

        for (i = 0; i <= TableRowCnts; i++) {
            if (i == TableRowCnts) {
                CurTxt = "";
                newbuyprocode = "";
            }
            else {
                CurTxt = tTable.datagrid("getRows")[i][ColArray[j]];
                newbuyprocode = tTable.datagrid("getRows")[i]["buyprojectCode"];
            }
            if (PerTxt == CurTxt && buyprocode == newbuyprocode) {
                tmpA += 1;
            }
            else {
                tmpB += tmpA;

                tTable.datagrid("mergeCells", {
                    index: i - tmpA,
                    field: ColArray[j],　　//合并字段
                    rowspan: tmpA,
                    colspan: null
                });
                tTable.datagrid("mergeCells", { //根据ColArray[j]进行合并
                    index: i - tmpA,
                    field: "Ideparture",
                    rowspan: tmpA,
                    colspan: null
                });

                tmpA = 1;
            }
            PerTxt = CurTxt;
            buyprocode = newbuyprocode;
        }
    }
}

</script>
</head>
<body>
    <table id="dg" title="当月猪舍流水" class="easyui-datagrid"
	 fitColumns="true" fit="true" width="auto" pagination="true" rownumbers="true" striped="true" singleSelect="true" showFooter="true"	 
	 url="${pageContext.request.contextPath}/pigstyflow/listflow.do" style="width: 100%;" toolbar="#tb" style="font-size:14px;"
	 data-options="onLoadSuccess:function(data){
	 if (data.rows.length > 0) {
	   mergeCellsByField('dg','tuname,psno,psname',0);
	 }
	 }">
	 <thead>
	 	<tr>
	 		<th field="tuname" width="30" align="center" >所属栋</th>
	 		<th field="psno" width="30" align="center" >猪舍编码</th>
	 		<th field="psname" width="30" align="center" hidden="true">猪舍名称</th>	 			 		
	 		<th field="typeno" width="30" align="center" >流转编码</th>
	 		<th field="typename" width="30" align="center" >流转类型</th>
	 		<th field="amount" width="30" align="center" >流转数量</th>
	 	</tr>
	 </thead>
	</table>
	
	<div id="tb">		
			&nbsp;开始日期&nbsp;<input type="text" id="s_begintime" class="easyui-datebox" editable="true">
			&nbsp;结束日期&nbsp;<input type="text" id="s_endtime" class="easyui-datebox" editable="true">
			&nbsp;流转类型:&nbsp;
			<input class="easyui-combobox" id="s_typeno" name="s_typeno"  data-options="width:'20%',panelHeight:'auto',editable:true,valueField:'typeno',textField:'typename',url:'${pageContext.request.contextPath}/flowtype/findflowtype.do'
			"/>
			&nbsp;所属栋:&nbsp;
			<input class="easyui-combobox" id="s_tuno" name="s_tuno" data-options="panelHeight:'auto',editable:true,valueField:'tuno',textField:'tuname'
			,url:'${pageContext.request.contextPath}/tung/list.do'
			,onSelect:function(rec){
			  $('#s_psno').combobox('clear');
			  var url='${pageContext.request.contextPath}/pigsty/findpigsty.do?tuno='+rec.tuno;
			  $('#s_psno').combobox('reload',url);
			}"/>
			&nbsp;猪舍名称:&nbsp;
			<input class="easyui-combobox" id="s_psno" name="s_psno" data-options="panelHeight:'auto',editable:true,valueField:'psno',textField:'psname'"/>
			&nbsp;<a href="javascript:searchpigsflow()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
    </div>
</body>
</html>