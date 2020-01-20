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
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.1/jquery.edatagrid.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/date.js"></script>

<script type="text/javascript">
    var typeno;
    var begin_time;
    var end_time;
    
	function searchPigstyflow(){
		$('#'+tuno).datagrid('loadData',{total:0,rows:[]});		
		typeno=$("#s_typeno").combobox("getValue");	
		begin_time=$("#s_begintime").datebox("getValue"); // 设置上个月日期
		end_time=$("#s_endtime").datebox("getValue"); // 设置当前日期		
		inittuno();
	}
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
	//获取表格数据
	function getdata(){
		$.ajax({
		   url:"${pageContext.request.contextPath}/pigstyflow/listbat.do",	
		   type:"POST",
		   async:false,
		   dataType:"json",
		   data:{tuno:tuno,typeno:typeno,begin_time:begin_time,end_time:end_time},		   
		   success:function(data){
			  datas=data;
		   },
		   error:function(e){
	            alert("error","请求数据出错!",'error');
	       }
		});
	}
 
   //生成表格的列头 
   function getfield(title){	
	columns=[];
	var col;
	sum="";
	for(var item in title){		
		if(item=="typename"){
		  col = {field:item,title:title[item],width:50,align:"center",editor:{type:'combobox',options:{panelHeight:'auto',valueField:'typename',textField:'typename',data:result,required:true}}};
		}else if(item=="create_time"){
		  col = {field:item,title:title[item],width:50,align:"center",editor:{type:'datebox'}};
		}else if(item=="typeno"){
		  col = {field:item,title:title[item],width:10,align:"center",editor:{type:'datebox'},hidden:true};
		}else{
		  col = {field:item,title:title[item],width:50,align:"center",editor:{type:'numberspinner',options:{min:0,max:5000}}};
		}		
		columns.push(col);
	}
	col={field:"sum",title:"合计",width:50,align:"center",disabled:true,formatter:function(val,row)
			{
		    var fields=$("#"+tuno).datagrid('getColumnFields');
		    var vald=0;
		    var total=0
		    for(var i=3;i<fields.length-1;i++)
		    {
		      vald=eval("row."+fields[i]);
		      if(vald==null){
		    	  vald=0;
		      }		
		      total=total+Number(vald);
		    }
			return "<strong>"+total+"</strong>";},editor:{type:'validatebox'}};
	columns.push(col);
  }

   //初始化表格
   function initdr(){
	   $('#'+tuno).datagrid({
		   columns:[columns]}).datagrid("loadData",datas.rows.slice(0,10));
	   	   var pager=$('#'+tuno).datagrid("getPager");
	   	   pager.pagination({
	   		   total:datas.total,
	   		   layout:['list','sep','first','prev','links','next','last','manual'],
	   		   onSelectPage:function(pageNo,pageSize)
	             {
	   			  var start=(pageNo-1)*pageSize;
	              var end=start+pageSize;
	              $('#'+tuno).datagrid("loadData",datas.rows.slice(start, end));
	              pager.pagination('refresh',{total:datas.total,pageNumber:pageNo});
              	 },
              	 onRefresh(pageNumber,pageSize){$('#'+tuno).datagrid("load");}
		   }); 
   }
   
   //初始化加载一栋数据
   function inittuno(){
	var tab=$('#tung').tabs('getSelected');
	tuno="T"+($('#tung').tabs('getTabIndex',tab)+1);
	getdata(tuno);
   	var title=datas.title;
   	getfield(title);
   	initdr();
   }

	//初始化页面
	$(function(){
		
		$("#s_begintime").datebox("setValue",genLastMonthDayStr()); // 设置上个月日期
		$("#s_endtime").datebox("setValue",genTodayStr()); // 设置当前日期
		
		getflowtype();		
	  
		inittuno();
		
	     $('#tung').tabs({
	    	    selected:0,
	    	    onSelect:function(title,index){	    	    	
	    	    	tuno="T"+(index+1);
	    	    	getdata(tuno);
	    	    	var title=datas.title;
	    	    	getfield(title);
	    	    	initdr();
	    	    	editIndex = undefined;
	    	    	editind=undefined;
	    	    	$('#detail').datagrid('loadData', { total: 0, rows: [] });  
	    	    }
	     });
	     
	   $('#s_typeno').combobox({
		    valueField:'typeno',
			textField:'typename',
			data:result
	   });
	})	
	
    var editIndex = undefined;
    
    function endEditing(){
        if (editIndex == undefined){return true}
        if ($('#'+tuno).datagrid('validateRow',editIndex)){
            $('#'+tuno).datagrid('endEdit',editIndex);
            editIndex = undefined;
            return true;
        } else {
            return false;
        }
    }
    var select=new Object();
    function onDblClickRow(index,field){
        if (editIndex != index){
            if (endEditing()){
                $('#'+tuno).datagrid('selectRow',index).datagrid('beginEdit',index);
                var ed=$('#'+tuno).datagrid('getEditor', {index:index,field:field});
                if (ed){
                    ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
                }
                console.log('begin...');
                
                editIndex = index;
    			select["select"]=JSON.stringify(field);
    			select["tuno"]=tuno;
    			getdetaildata();
    			var detitle=detaildatas.title;
    			getdetailfield(detitle);
    			initdetail();
    			editind=undefined;
            } else {
            	console.log("timeout");
                setTimeout(function(){
                    $('#'+tuno).datagrid('selectRow',editIndex);
                },0);
            }
        }
    }
    
    function append(){
        if (endEditing()){
			$('#'+tuno).datagrid('unselectAll');
            $('#'+tuno).datagrid('appendRow',{create_time:genTodayStr()});
            editIndex = $('#'+tuno).datagrid('getRows').length-1;
            $('#'+tuno).datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
            //明细表
            initcols();
            initrows();
			$('#detail').datagrid({columns:[cols]}).datagrid('loadData',rows);
        }else {
            $.messager.alert('警告','尚有未编辑完成单元，请继续编辑','warning');
        }
    }
    
    function removeit(){    	
    	var rows = $('#'+tuno).datagrid('getSelections');
    	var editrows = $('#'+tuno).datagrid('getChanges');
        if(rows==undefined){
        	rows=0;
        }              	
        if (editIndex == undefined && rows.length==0){	        
	        $.messager.alert("系统提示",rows.length+' rows are choiced!',"info");        	
        	return;        	
        }
        if(editrows>=1){
        	$.messager.alert("系统提示","请先撤消未提交的编辑，再选择删除！","info");
        	return;
        }
        var effectRow=new Object();
        if(rows.length>=1){
       
        effectRow["deleted"]=JSON.stringify(rows);       
        
          $.messager.confirm("系统提示","您确认要删除这<font color=red>"+rows.length+"</font>条数据吗？",function(r){
		 if(r){ 
				 $.post("${pageContext.request.contextPath}/pigstyflow/deletebat.do",effectRow,function(data){
					if(data.success){ 
	        	    	   $('#'+tuno).datagrid('cancelEdit',editIndex).datagrid('deleteRow',editIndex);
	        	    	   $.messager.show({title:"系统提示",msg:rows.length+' rows are changed!',showType:"show",timeout:1000/* ,style:{
	                             right:'',
	                             top:document.body.scrollTop+document.documentElement.scrollTop,
	                             bottom:''
	                         } */});
	        	    	   inittuno(tuno);	
	        	    	   //$('#'+tuno).datagrid('getChanges');
	        	           editIndex = undefined;         
	        	           editind = undefined;
	        	       }else{
	        	    	 $.messager.alert("系统提示",data.error,"error");
	        	       }
				},"json"); 
			}
		 });        
        }else{
        	 $.messager.alert("系统提示","请选择一条数据！","warning");
        } 
    }
    
    function endEdit(index,row){
       /*  var ed=$('#'+tuno).datagrid('getEditor',{index: index,field: 'typename'});
        row.typename=$(ed.target).combobox('getText');        
        $('#'+tuno).datagrid("endEdit",index); */
    }
    function accept(){
        if (endEditing()){
        	saverows();
        }
    }
    function reject(){
        $('#'+tuno).datagrid('rejectChanges');
        editIndex = undefined;
        editind = undefined;
        inittuno(tuno);	
    }
    function getChanges(){
        var rows = $('#'+tuno).datagrid('getChanges');
        if(rows==undefined){
        	rows=0;
        }
        $.messager.alert("系统提示",rows.length+' rows are changed!',"info");
    }
    function saverows(){
    	console.log('save...');
        var rows = $('#'+tuno).datagrid('getChanges');
        console.log(rows);
        
        if(rows.length){
        	var updated=$('#'+tuno).datagrid('getChanges',updated); 
        	var detail=$('#detail').datagrid('getChanges','updated');
        	var effectRow=new Object();
        	//增加明细面索引值
        	var row=$('#'+tuno).datagrid('getSelected');
        	if(detail.length){
        	  //row.create_time.replace("-","");
        	  var typeno;
        	  for(var i in result){
        		  if(result[i].typename=row.typename){
        			  typeno=result[i].typeno;
        			  break;
        		  }
        	  }
        	  var reg = new RegExp('-',"g" )        	
        	  if(row.flowid==undefined){
        		detail.push({"flowid":row.create_time.replace(reg,"")+typeno,"item":"流水号"});  
        	  }else{
        	    detail.push({"flowid":row.flowid.slice(0,row.flowid.indexOf("F")),"item":"流水号"});		  
        	  }
        	  effectRow["detail"]=JSON.stringify(detail);
        	}
        	
             if (updated.length)
            { 
                effectRow["updated"]=JSON.stringify(updated);                
            }          
           
            $.post("${pageContext.request.contextPath}/pigstyflow/updatebat.do",effectRow
            		,function(data) 
            		 { 
            	       if(data.success){ 
            	         $('#'+tuno).datagrid('acceptChanges');
            	         $('#detail').datagrid('acceptChanges');
            	         $.messager.show({title:"系统提示",msg:rows.length+' rows are changed!',showType:"show",timeout:1000/* ,style:{
                             right:'',
                             top:document.body.scrollTop+document.documentElement.scrollTop,
                             bottom:''
                         } */});
            	       }else{
            	    	 $.messager.alert("系统提示",data.error,"error");
            	       }
            	     }
                   ,"json");
        }else{
        	$.messager.alert("系统提示","没有待更新的数据！","info");
        }
    }  
        
</script>

</head>

<body class="easyui-layout" style="margin: 1px">
<div region="north" style="height: 350px;">
	<div id="tung" class="easyui-tabs" style="margin-top:5px;border="false" tools="#toolbar" tabPosition="top" toolPosition="right"  data-options="fit:true,plain:true,pill:true" >
		<div title="&nbsp;&nbsp;一&nbsp;&nbsp;栋&nbsp;&nbsp;  ">
			<table id="T1" class="easyui-datagrid" 
			data-options="fitColumns:true,fit:true,pagination:true,rownumbers:true,striped:true,singleSelect:true,
			onClickRow:onDblClickRow,onEndEdit:endEdit,loadMsg:'loading...'" >
	 		<thead>
	 		<tr>	 			 				
	 		</tr>
	 		</thead>
			</table>
		</div>		
		<div title="&nbsp;&nbsp;二&nbsp;&nbsp;栋&nbsp;&nbsp;" >
			<table id="T2" class="easyui-datagrid" 
			data-options="fitColumns:true,fit:true,pagination:true,rownumbers:true,striped:true,singleSelect:true,
			onClickRow:onDblClickRow,onEndEdit:endEdit,loadMsg:'loading...'">
	 		<thead>
	 		<tr>	 			 				
	 		</tr>
	 		</thead>
			</table>
		</div>
		<div title="&nbsp;&nbsp;三&nbsp;&nbsp;栋&nbsp;&nbsp;">
			<table id="T3" class="easyui-datagrid" 
			data-options="fitColumns:true,fit:true,pagination:true,rownumbers:true,striped:true,singleSelect:true,
			onClickRow:onDblClickRow,onEndEdit:endEdit,loadMsg:'loading...'">
	 		<thead>
	 		<tr>	 			 				
	 		</tr>
	 		</thead>
			</table>
		</div>
		<div title="&nbsp;&nbsp;四&nbsp;&nbsp;栋&nbsp;&nbsp;">
			<table id="T4" class="easyui-datagrid" 
			data-options="fitColumns:true,fit:true,pagination:true,rownumbers:true,striped:true,singleSelect:true,
			onClickRow:onDblClickRow,onEndEdit:endEdit,loadMsg:'loading...'">
	 		<thead>
	 		<tr>	 			 				
	 		</tr>
	 		</thead>
			</table>
		</div>
	</div>
	
    <div id="toolbar" style="height:auto">
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">添加</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">删除</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="accept()">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true" onclick="reject()">刷新</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="getChanges()">获取变化行数</a>
        |
        &nbsp;<font size="1.5" style="padding:2px">开始日期</font>&nbsp;<input type="text" id="s_begintime" class="easyui-datebox" editable="true" style="width:100px">
		&nbsp;<font size="1.5" style="padding:2px">结束日期</font>&nbsp;<input type="text" id="s_endtime" class="easyui-datebox" editable="true" style="width:100px">
		&nbsp;<font size="1.5" style="padding:2px">流转类型</font>:&nbsp;
		<input class="easyui-combobox" id="s_typeno" name="s_typeno" data-options="width:100,panelHeight:'auto',editable:true,valueField:'typeno',textField:'typename'"/>
				
		&nbsp;<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" plain="true" onclick="searchPigstyflow()">搜索</a>
    </div>
</div>
<div region="center" style="margin-top: 10px;">
  
  <table id="detail" title="明细项" class="easyui-datagrid" rownumbers=true border=false 
  rownumbers=true singleSelect=true
  data-options="fitColumns:true,fit:true,rowStyler:function(index,row){return 'color:red;';},onClickRow:editrow">	   
  <thead>
	   	<tr>	   		
	   	</tr>
	   </thead>
  </table>
</div>

<script type="text/javascript">

    var detaildatas={title:[],total:0,rows:[]};
	//获取表格数据
	function getdetaildata(){
		$.ajax({
		   url:"${pageContext.request.contextPath}/pigstyflow/listdays.do",	
		   type:"POST",
		   async:false,
		   dataType:"json",
		   data:select,		   
		   success:function(data){
			  detaildatas=data;
		   },
		   error:function(e){
	            alert("error","请求数据出错!",'error');
	       }
		});
	}
	
	//生成表格的列头 
	function getdetailfield(detitle){	 
		detailcolumns=[];
		var col;
		
		for(var item in detitle){
			if(item=="分项"){
			  col = {field:item,title:detitle[item],width:50,align:"center",editor:{type:'validatebox',options:{required:true}}};		  
			}else{
			  col = {field:item,title:detitle[item],width:50,align:"center",editor:{type:'validatebox'}};
			}			
			detailcolumns.push(col);
		}
	}
	
	//初始化表格
	function initdetail(){
	   $('#detail').datagrid({
		   columns:[detailcolumns]}).datagrid("loadData",detaildatas.rows);
	}
    var editind = undefined;
    
    function endEdit(){
        if (editind == undefined){return true}
        if ($('#detail').datagrid('validateRow',editind)){
            $('#detail').datagrid('endEdit',editind);
            editind=undefined;
            return true;
        } else {
            return false;
        }
    }
    
    function editrow(index,field){
    	
        if (editind != index){
            if (endEdit()){
                $('#detail').datagrid('selectRow',index).datagrid('beginEdit',index);
                var ed=$('#detail').datagrid('getEditor', {index:index,field:field});
                if (ed){
                    ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
                }
                editind = index;    			
            } else {
                setTimeout(function(){
                    $('#detail').datagrid('selectRow',editind);
                },0);
            }
        }
    }
        
    function getdetailChanges(){
        var rows = $('#detail').datagrid('getChanges');
        if(rows==undefined){
        	rows=0;
        }
        $.messager.alert("系统提示",rows.length+' rows are changed!',"info");
    }
    
    function initcols(){
		cols=[];
		var fields=$("#"+tuno).datagrid('getColumnFields');
		var col;	
		col = {field:'item',title:'分项',width:100,align:"center",editor:{type:'validatebox',options:{required:true}}};
		cols.push(col);
		
		for(var i=3;i<fields.length-1;i++){			  		  
			col = {field:fields[i],title:fields[i],width:50,align:"center",editor:{type:'validatebox'}};
			cols.push(col);
		}
	}
    
    function initrows(){
		rows=[];
		var fields=$("#"+tuno).datagrid('getColumnFields');
		var row={};	
		row["item"]="批次号";		
		for(var i=3;i<fields.length-1;i++){
			row[fields[i]]=null;
		}
		rows.push(row);
		row={};//清空
		row["item"]="日龄";		
		for(var i=3;i<fields.length-1;i++){
			row[fields[i]]=null;
		}
		rows.push(row);
	}
    
</script>
</body>
</html>