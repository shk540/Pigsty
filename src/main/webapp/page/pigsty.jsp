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
function setframeHeight(){  
        var reportFrame = document.getElementById('reportFrame');  

                var tools=$(reportFrame).contents().find("div[class=ui-state-enabled fr-panel fr-layout-border-panel fr-layout-border-panel-north]");
                var content=$(reportFrame).contents().find("div[class=pageContentDIV]");
                var sheet=$(reportFrame).contents().find("div[class=sheet-container]");
        var height = 30;  
                if(content.length>0)
                {
                   height+=content[0].offsetHeight;
                }

                if(sheet.length>0)
                {
                   height+=sheet[0].offsetHeight;
                }

                for(var i=0;i< tools.length;i++)
                {
                   height+=tools[i].offsetHeight;
                }
        reportFrame.height = height;   
        }
</script>
</head>
<body>
 <!-- <iframe id="reportFrame" frameborder=0 scrolling='auto' style='width:100%' src="../../Pigsty/decision/view/report?viewlet=/pigsty.cpt"></iframe> -->
 
</html>