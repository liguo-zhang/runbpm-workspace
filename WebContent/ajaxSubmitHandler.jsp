<%
//判断session，记录userId. begin-->
Object userIdinSession = session.getAttribute("userId");
String userId = null;
if(userIdinSession!=null){
	userId = userIdinSession.toString();
}else{
	if(session.getAttribute("party")== null){
		if(null != request.getQueryString()){
			session.setAttribute("redirectUrl", request.getRequestURL().append("?").append(request.getQueryString()).toString());
		}else{
			session.setAttribute("redirectUrl", request.getRequestURL().toString());
		}
		response.sendRedirect("login.jsp");
	}
}
//判断session，记录userId. end-->
%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>   
<%@ page import="org.runbpm.context.*" %>   
<%@ page import="org.runbpm.entity.*" %>   
<%@ page import="org.runbpm.service.RunBPMService" %>
<%@ page import="org.runbpm.workspace.Upload" %>
<%@ page import="org.runbpm.workspace.ResultBean" %>
<%@ page import="com.alibaba.fastjson.JSON" %>

<%
RunBPMService runBPMService = Configuration.getContext().getRunBPMService();

String isDeployProcessDefinition = request.getParameter("isDeployProcessDefinition")+"";
String deployXmlContent = request.getParameter("deployXmlContent")+"";

if(isDeployProcessDefinition!=null&&isDeployProcessDefinition.trim().equals("1")){
	ProcessModel newProcessModel = runBPMService.deployProcessDefinitionFromString(deployXmlContent);
	Map resultMap = new HashMap();
	resultMap.put("id",newProcessModel.getId());
	resultMap.put("name",newProcessModel.getName());
	out.print(JSON.toJSON(resultMap));
}

%>