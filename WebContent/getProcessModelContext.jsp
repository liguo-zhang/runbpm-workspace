<%@ page contentType="text/xml" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="org.runbpm.context.*" %>
<%@ page import="org.runbpm.entity.*" %>
<%@ page import="org.runbpm.service.RunBPMService" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%
RunBPMService runBPMService = Configuration.getContext().getRunBPMService();

String isChoose = request.getParameter("isChoose")+"";
String processModelId = request.getParameter("processModelId")+"";
String xmlContent = null;
if(isChoose!=null&&isChoose.trim().equals("1")){
	ProcessModel selectedProcessModel= runBPMService.loadProcessModelByModelId(Long.parseLong(processModelId));
	xmlContent = selectedProcessModel.getXmlContent();
	out.print(xmlContent.trim());
}

%>