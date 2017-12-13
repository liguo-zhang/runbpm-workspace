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
<%@ page import="org.runbpm.bpmn.definition.*" %>   
<%@ page import="org.runbpm.service.RunBPMService" %>
<%@ page import="org.runbpm.workspace.WorkspaceUtils" %>
<%@ page import="com.alibaba.fastjson.JSON" %>


<%
RunBPMService runBPMService = Configuration.getContext().getRunBPMService();

//------------------------------------------------------------部署流程定义：从设计器部署，或者导入XML定义文件
String isDeployProcessDefinition = request.getParameter("isDeployProcessDefinition")+"";
if(isDeployProcessDefinition!=null&&isDeployProcessDefinition.trim().equals("1")){
	String deployXmlContent = request.getParameter("deployXmlContent")+"";
	Map resultMap = new HashMap();
	try{
		ProcessModel newProcessModel = runBPMService.deployProcessDefinitionFromString(deployXmlContent);
		resultMap.put("code","0");
		resultMap.put("msg","部署成功。流程定义ID为["+newProcessModel.getProcessDefinitionId()+"],流程定义名称为["+newProcessModel.getName()+"],生成的流程模板ID为["+newProcessModel.getId()+"]。");
	}catch(Throwable t){
		t.printStackTrace();
		resultMap.put("code","1");
		resultMap.put("msg",WorkspaceUtils.getRootCauseMessage(t));
	}
	out.print(JSON.toJSON(resultMap));
}


//------------------------------------------------------------创建流程实例
String isCreateAndStartProcessInstance = request.getParameter("isCreateAndStartProcessInstance")+"";
if(isCreateAndStartProcessInstance!=null&&isCreateAndStartProcessInstance.trim().equals("1")){
	String modelId = request.getParameter("modelId")+"";
	
	Map resultMap = new HashMap();
	try{
		ProcessInstance processInstance = runBPMService.createAndStartProcessInstance(Long.parseLong(modelId), userId);
		resultMap.put("id",processInstance.getId());
		resultMap.put("name",processInstance.getName());
		resultMap.put("code","0");
	}catch(Throwable t){
		t.printStackTrace();
		resultMap.put("code","1");
		resultMap.put("msg",WorkspaceUtils.getRootCauseMessage(t));
	}
	out.print(JSON.toJSON(resultMap));
	
}
//

//------------------------------------------------------------接受任务
String isClaim = request.getParameter("isClaim")+"";
if(isClaim!=null&&isClaim.trim().equals("1")){
	String taskInstanceId = request.getParameter("taskInstanceId")+"";
	//处理任务（抢任务），将该任务置于我的名下，任务状态从“未开始”转化为“运行中”
	runBPMService.claimUserTask(Long.parseLong(taskInstanceId));
	 //sendRedirect=true;
}

String isFowardToApplicationTemplate = request.getParameter("isFowardToApplicationTemplate")+"";
//刚刚接受任务，或者已经接受的，需要进行转发
if((isClaim!=null&&isClaim.trim().equals("1")) || isFowardToApplicationTemplate!=null&&isFowardToApplicationTemplate.trim().equals("1")){
	String taskInstanceId = request.getParameter("taskInstanceId")+"";
	
	TaskInstance taskInstance = runBPMService.loadTaskInstance(Long.parseLong(taskInstanceId));
	ProcessModel processModel =runBPMService.loadProcessModelByModelId(taskInstance.getProcessModelId());
	ActivityDefinition activityDefinition = processModel.getProcessDefinition().getActivity(taskInstance.getActivityDefinitionId());
	ExtensionElements extensionElements = activityDefinition.getExtensionElements();
	Map templateMap = extensionElements.getExtensionPropsMap("runBPM_ApplicationTemplate_Definition");
	
	String url = null;
	if(templateMap!=null){
		if("appliation_operation".equals(templateMap.get("type").toString())){
		    	 url="listApplicationTemplate.jsp"+"?taskInstanceId="+taskInstanceId;
		}
	}else{
		 url = extensionElements.getPropertyValue("application")+"?taskInstanceId="+taskInstanceId;
	}
	
	response.sendRedirect(url);
}


%>