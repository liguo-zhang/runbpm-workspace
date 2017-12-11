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

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>   
   
<%@ page import="org.runbpm.context.*" %>   
<%@ page import="org.runbpm.entity.*" %>   
<%@ page import="org.runbpm.bpmn.definition.*" %>   
<%@ page import="org.runbpm.workspace.*" %>
<%@ page import="org.runbpm.service.RunBPMService" %>
<%

RunBPMService runBPMService = Configuration.getContext().getRunBPMService();
String taskInstanceId = request.getParameter("taskInstanceId")+"";

TaskInstance taskInstance = runBPMService.loadTaskInstance(Long.parseLong(taskInstanceId));
long processInstId = taskInstance.getProcessInstanceId();

ProcessModel processModel =runBPMService.loadProcessModelByModelId(taskInstance.getProcessModelId());
ProcessDefinition processDefinition = processModel.getProcessDefinition();
String activityDefinitionId = taskInstance.getActivityDefinitionId();
ActivityDefinition activityDefinition = processDefinition.getActivity(activityDefinitionId);
ExtensionElements extensionElements = activityDefinition.getExtensionElements();
Map templateMap = extensionElements.getExtensionPropsMap("runBPM_ApplicationTemplate_Definition");


List operationList = null;
List applicationListList = new ArrayList();

if(templateMap!=null){
	
	
	if("appliation_operation".equals(templateMap.get("type").toString())){
		
		String applicationListString = templateMap.get("applicationList").toString();
		
		
		StringTokenizer st = new StringTokenizer(applicationListString,",");
	     while (st.hasMoreTokens()) {
	    	 	String applicationMapName = st.nextToken();
	    	 	
	    	 	List applicationlist = extensionElements.getExtensionPropsList(applicationMapName);
	    	 	applicationListList.add(applicationlist);
	     }
	     
	     String operationListString = templateMap.get("operationList").toString();
	     
	     operationList  = extensionElements.getExtensionPropsList(operationListString);
	}
}

%>


<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>RunBPM工作台</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="ui/bootstrap/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="ui/css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="ui/css/ionicons.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="ui/dist/css/AdminLTE.min.css">
  <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
        page. However, you can choose any other skin. Make sure you
        apply the skin class to the body tag so the changes take effect.
  -->
  <link rel="stylesheet" href="ui/dist/css/skins/skin-blue.min.css">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="ui/https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="ui/https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>
<!--
BODY TAG OPTIONS:
=================
Apply one or more of the following classes to get the
desired effect
|---------------------------------------------------------|
| SKINS         | skin-blue                               |
|               | skin-black                              |
|               | skin-purple                             |
|               | skin-yellow                             |
|               | skin-red                                |
|               | skin-green                              |
|---------------------------------------------------------|
|LAYOUT OPTIONS | fixed                                   |
|               | layout-boxed                            |
|               | layout-top-nav                          |
|               | sidebar-collapse                        |
|               | sidebar-mini                            |
|---------------------------------------------------------|
-->
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  <!-- Main Header -->
  <header class="main-header">

    <!-- Logo -->
    <a href="index2.html" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini">R</span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><img src="ui/images/runbpm-logo-workspace.png"></span>
    </a>

    <!-- Header Navbar -->
    <nav class="navbar navbar-static-top" role="navigation">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>
      <!-- Navbar Right Menu -->
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
          <!-- User Account Menu -->
          <li class="dropdown user user-menu">
            <!-- Menu Toggle Button -->
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <!-- The user image in the navbar-->
              <i class="fa fa-user"></i> 
              <!-- hidden-xs hides the username on small devices so only the image appears. -->
              <span class="hidden-xs"><%=userId%></span>
            </a>
            <ul class="dropdown-menu">
              <!-- The user image in the menu -->
              <li class="user-header">
                <img style="display:none" src="ui/images/runbpm-logo-workspace.png" alt="User Image">
                <p>
                  RunBPM工作台用户
                  <small>RunBPM v1.0 @ 2018</small>
                </p>
              </li>
              <!-- Menu Body -->
              <li class="user-body" style="display:none">
                <div class="row">
                  <div class="col-xs-4 text-center">
                    <a href="#">Followers</a>
                  </div>
                  <div class="col-xs-4 text-center">
                    <a href="#">Sales</a>
                  </div>
                  <div class="col-xs-4 text-center">
                    <a href="#">Friends</a>
                  </div>
                </div>
                <!-- /.row -->
              </li>
              <!-- Menu Footer-->
              <li class="user-footer">
                <div class="pull-left" style="display:none">
                  <a href="#" class="btn btn-default btn-flat">Profile</a>
                </div>
                <div class="pull-right">
                  <a href="login.jsp" class="btn btn-default btn-flat">Sign out</a>
                </div>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">

    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
  
      <!-- Sidebar Menu -->
      <ul class="sidebar-menu">
        <li class="header">
        
	         <li class="treeview">
	          <a href="#">
	            <i class="fa fa-table"></i> <span>流程定义管理</span>
	            <i class="fa fa-angle-left pull-right"></i>
	          </a>
	          <ul class="treeview-menu">
	          	<li><a href="modeler.jsp"><i class="fa fa-circle-o"></i> 定义流程</a></li>
	          	<li><a href="deployProcessDefinition.jsp"><i class="fa fa-circle-o"></i> 导入流程定义</a></li>
	          	<li><a href="listProcessModel.jsp"><i class="fa fa-circle-o"></i> 创建流程</a></li>
	          </ul>
	        </li>
	        
	        <li class="active"><a href="listMyTask.jsp"><i class="fa fa-book"></i> <span>本人代办流程</span></a></li>
	        
	         <li class="treeview ">
	          <a href="#">
	            <i class="fa   fa-star-half-o"></i> <span>本人未结束流程</span>
	            <i class="fa fa-angle-left pull-right"></i>
	          </a>
	          <ul class="treeview-menu">
	             <li><a href="listMyProcess.jsp"><i class="fa fa-circle-o"></i> 本人已建流程</a></li>
	            <li><a href="listMyTaskCompleted.jsp"><i class="fa fa-circle-o"></i> 本人已办任务</a></li>
	          </ul>
	        </li>
	        
	         <li class="treeview">
	          <a href="#">
	            <i class="fa  fa-star"></i> <span>本人已结束流程</span>
	            <i class="fa fa-angle-left pull-right"></i>
	          </a>
	          <ul class="treeview-menu">
	          <li><a href="listMyProcessHistory.jsp"><i class="fa fa-circle-o"></i> 本人已建流程</a></li>
	            <li><a href="listMyTaskHistory.jsp"><i class="fa fa-circle-o"></i> 本人已办任务</a></li>
	          </ul>
	        </li>
	        
	        <li class="treeview">
	          <a href="#">
	            <i class="fa fa-bar-chart"></i> <span>流程监控</span>
	            <i class="fa fa-angle-left pull-right"></i>
	          </a>
	          <ul class="treeview-menu">
	          	<li><a href="listAllProcess.jsp"><i class="fa fa-circle-o"></i> 流程实例列表</a></li>
	          	<li><a href="listAllProcessHistory.jsp"><i class="fa fa-circle-o"></i> 流程历史列表</a></li>
	          </ul>
	        </li>
          
        </li>
      </ul>
      <!-- /.sidebar-menu -->
    </section>
    <!-- /.sidebar -->
  </aside>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        任务处理详情
        <small>该任务有两组应用和一组操作</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="listMyTask.jsp"><i class="fa fa-dashboard"></i> 本人代办流程</a></li>
        <li class="active">任务处理详情</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
       <div class="box">
            <div class="box-header"  style="display:none">
              <h3 class="box-title">流程模板列表</h3>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name=" 	" class="form-control pull-right" placeholder="Search">

                  <div class="input-group-btn">
                    <button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
                  </div>
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <%
            for(int i = 0;i<applicationListList.size();i++){
            		List applicationList = (List)applicationListList.get(i);
            %>
	            <div class="box-body table-responsive no-padding">
			              <table class="table table-hover">
			                <tr>
			                  <th>应用名称</th>
			                  <th>应用地址</th>
			                </tr>
			                <%
			                Iterator keyIt = applicationList.iterator();
			                while(keyIt.hasNext()){
			                		String id = keyIt.next().toString();
			                		String applicationURL = PropertyTool.getPropertyMap().get("application."+id+".url").toString();
			                		String applicationName = PropertyTool.getPropertyMap().get("application."+id+".name").toString();
			                %>
			                <tr>
			                  <td><%=applicationName %></td>
			                  <td><a href="<%=applicationURL %>?taskInstanceId=<%=taskInstanceId%>"><%=applicationURL %></a></td>
			                  
			                </tr>
			                <%
			                }
			                %>
			              </table>
	            </div>
	        <%}%>
            <!-- /.box-body -->
            <div class="box-footer">
           		<div style="float:right;">
           		
            				<%
		                Iterator keyMapIt = operationList.iterator();
		                while(keyMapIt.hasNext()){
		                		String id = keyMapIt.next().toString();
		                		String operationURL = PropertyTool.getPropertyMap().get("operation."+id+".url").toString();
		                		String operationName = PropertyTool.getPropertyMap().get("operation."+id+".name").toString();
		                		
		                %>
                				<button type="button" id="<%=operationURL%>" class="btn btn-info"><%=operationName%></button>
                			<%
		                }
                			%>
                	</div>
              </div>
          </div>
          <!-- /.box -->

    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

  <!-- Main Footer -->
  <footer class="main-footer">
    <!-- To the right -->
    <div class="pull-right hidden-xs">
      
    </div>
    <!-- Default to the left -->
    <strong>Copyright &copy; 2016 <a href="http://runbpm.org" target="_blank">Runbpm</a>.</strong> All rights reserved.
  </footer>

  
  <!-- /.control-sidebar -->
  <!-- Add the sidebar's background. This div must be placed
       immediately after the control sidebar -->
  <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->

<!-- REQUIRED JS SCRIPTS -->

<!-- jQuery 2.2.0 -->
<script src="ui/plugins/jQuery/jQuery-2.2.0.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="ui/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="ui/dist/js/app.min.js"></script>

<!-- Optionally, you can add Slimscroll and FastClick plugins.
     Both of these plugins are recommended to enhance the
     user experience. Slimscroll is required when using the
     fixed layout. -->
<form id="submit_form" method="post"></form>
<!-- Modal -->
              <div class="modal fade" id="taskCompleteModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                      <h4 class="modal-title" id="deployResultModal">提交任务</h4>
                     
                    </div>
                    <div class="modal-body">
                      是否提交任务？
                    </div>
                    <div class="modal-footer">
                    	  <button type="button" id="taskCompleteSubmit" class="btn btn-primary">确认</button>
                      <button type="button" class="btn btn-default"  data-dismiss="modal">取消</button>
                    </div>
                  </div>
                </div>
              </div>
              
              
              <div class="modal fade" id="taskPutBackModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                      <h4 class="modal-title" id="deployResultModal">放回任务</h4>
                     
                    </div>
                    <div class="modal-body">
                      是否放回任务？工作流引擎将重新分配任务。
                    </div>
                    <div class="modal-footer">
                    	  <button type="button" id="taskPutBackSubmit" class="btn btn-primary">确认</button>
                      <button type="button" class="btn btn-default"  data-dismiss="modal">取消</button>
                    </div>
                  </div>
                </div>
              </div>
              
              
              <div class="modal fade" id="taskTerminateForBackModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                      <h4 class="modal-title" id="deployResultModal">退回任务</h4>
                     
                    </div>
                    <div class="modal-body">
                      是否退回到上一步？
                    </div>
                    <div class="modal-footer">
                    	  <button type="button" id="taskTerminateForBackSubmit" class="btn btn-primary">确认</button>
                      <button type="button" class="btn btn-default"  data-dismiss="modal">取消</button>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="modal fade" id="taskTerminateForJumpModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                      <h4 class="modal-title" id="deployResultModal">跳转任务</h4>
                    </div>
                    <div class="modal-body">
                      	选择要跳转的节点：
      						<div class="form-group has-feedback">
      							<select class="form-control" name="targetActivityDefinitionId" id="targetActivityDefinitionId">
      							
                      	<form>
                      	<%
	                      	Set<ActivityDefinition> set = processDefinition.listReachableActivitySet(activityDefinition);
	                      	Iterator<ActivityDefinition> it = set.iterator();
	                      	String definitionId = null;
	                      	String definitionName = null;
	                      	while(it.hasNext()){
	                      		ActivityDefinition at = it.next();
	                      		//如果是人工活动，而且不是自己
	                      		if(at instanceof UserTask && at.getId()!=activityDefinitionId){
	                      			definitionId = at.getId();
	                      			definitionName = at.getName();
                      	%>
                  					<option value="<%=definitionId%>"><%=definitionName%></option>
                  		<%
	                      		}
	                      	}
                  		%>			
                  					
                  				</select>
                  			</div>
                  		</form>		
                    </div>
                    <div class="modal-footer">
                       <button type="button" id="taskTerminateForJumpSubmit" class="btn btn-primary">确认</button>
                      <button type="button" class="btn btn-primary"  data-dismiss="modal">关闭</button>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="modal fade" id="taskSetAssigneeModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                      <h4 class="modal-title" id="deployResultModal">跳转任务</h4>
                    </div>
                    <div class="modal-body">
                      	选择要重新分配的执行人：
      						<div class="form-group has-feedback">
      							<select class="form-control" name="assigneeUserId" id="assigneeUserId">
      							
                      			<form>
                  					<option value="user1">user1</option>
                  					<option value="user2">user2</option>
                  					<option value="user3">user3</option>
                  					<option value="user4">user4</option>
                  					<option value="user5">user5</option>
                  					<option value="user6">user6</option>
                  					<option value="user7">user7</option>
                  					<option value="user8">user8</option>
                  					<option value="user9">user9</option>
                  				</select>
                  			</div>
                  		</form>		
                    </div>
                    <div class="modal-footer">
                       <button type="button" id="taskSetAssigneeSubmit" class="btn btn-primary">确认</button>
                      <button type="button" class="btn btn-primary"  data-dismiss="modal">关闭</button>
                    </div>
                  </div>
                </div>
              </div>
              
              
              <div class="modal fade" id="taskTerminateForBackWithSelectionModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                      <h4 class="modal-title" id="deployResultModal">退回任务</h4>
                    </div>
                    <div class="modal-body">
                      	选择要退回的节点：
      						<div class="form-group has-feedback">
      							<select class="form-control" name="targetActivityDefinitionIdForBack" id="targetActivityDefinitionIdForBack">
      							
                      	<form>
                      	<%
	                      	Set<ActivityDefinition> backSet = processDefinition.listBackableActivitySet(activityDefinition);
	                      	Iterator<ActivityDefinition> backIt = backSet.iterator();
	                      	while(backIt.hasNext()){
	                      		ActivityDefinition at = backIt.next();
	                      		//如果是人工活动，而且不是自己
	                      		if(at instanceof UserTask && at.getId()!=activityDefinitionId){
	                      			//曾经运行过
	                      			if(runBPMService.listActivityInstanceByActivityDefId(processInstId, at.getId()).size()>0){
	                      				definitionId = at.getId();
	                      				definitionName = at.getName();
                      	%>
                  						<option value="<%=definitionId%>"><%=definitionName%></option>
                  		<%
	                      			}
	                      			
	                      		}
	                      	}
                  		%>			
                  					
                  				</select>
                  			</div>
                  		</form>		
                    </div>
                    <div class="modal-footer">
                       <button type="button" id="taskTerminateForBackWithSelectionSubmit" class="btn btn-primary">确认</button>
                      <button type="button" class="btn btn-primary"  data-dismiss="modal">关闭</button>
                    </div>
                  </div>
                </div>
              </div>
              <!--//Modal-->

<script>

$(document).ready(function() {
	//----提交（完成）任务
	 $("#taskComplete").on('click',function (e) {
		 $('#taskCompleteModal').modal({keyboard: true});
	});
	 $("#taskCompleteSubmit").on('click',function (e) {
	    var action = 'executeTask.jsp?executeTask=taskComplete&taskInstanceId='+<%=taskInstanceId%>;
	    $('#submit_form').attr('action', action);
	    $("#submit_form").submit(); 
	});
	 
	//----跳转任务
	 $("#taskTerminateForJump").on('click',function (e) {
		 $('#taskTerminateForJumpModal').modal({keyboard: true});
	});
	 $("#taskTerminateForJumpSubmit").on('click',function (e) {
		 var targetActivityDefinitionId = $('#targetActivityDefinitionId').val();
		 var action = 'executeTask.jsp?executeTask=taskTerminateForJump&taskInstanceId='+<%=taskInstanceId%>+'&targetActivityDefinitionId='+targetActivityDefinitionId;
		 $('#submit_form').attr('action', action);
		 $("#submit_form").submit();  
	 });
	 
	//----退回任务（到上一步），假设当前活动实例只有一个输入连接弧，且输入连接弧的头节点是人工活动。
	 $("#taskTerminateForBack").on('click',function (e) {
		 $('#taskTerminateForBackModal').modal({keyboard: true});
	 });
	 $("#taskTerminateForBackSubmit").on('click',function (e) {
		 var action = 'executeTask.jsp?executeTask=taskTerminateForBack&taskInstanceId='+<%=taskInstanceId%>;
		 $('#submit_form').attr('action', action);
		 $("#submit_form").submit();  
	 });
	 
	//----放回任务
	 $("#taskPutBack").on('click',function (e) {
		 $('#taskPutBackModal').modal({keyboard: true});
	 });
	 $("#taskPutBackSubmit").on('click',function (e) {
		 var action = 'executeTask.jsp?executeTask=taskPutBack&taskInstanceId='+<%=taskInstanceId%>;
		 $('#submit_form').attr('action', action);
		 $("#submit_form").submit(); 
	 });
	 
	//----退回任务到指定的一步
	 $("#taskTerminateForBackWithSelection").on('click',function (e) {
		 $('#taskTerminateForBackWithSelectionModal').modal({keyboard: true});
	 });
	 $("#taskTerminateForBackWithSelectionSubmit").on('click',function (e) {
		 var targetActivityDefinitionId = $('#targetActivityDefinitionIdForBack').val();
		 
		 var action = 'executeTask.jsp?executeTask=taskTerminateForBackWithSelection&taskInstanceId='+<%=taskInstanceId%>+'&targetActivityDefinitionId='+targetActivityDefinitionId;
		 $('#submit_form').attr('action', action);
		 $("#submit_form").submit();  
	 });
	 
	//----重新分配执行人
	 $("#taskSetAssignee").on('click',function (e) {
		 $('#taskSetAssigneeModal').modal({keyboard: true});
	 });
	 $("#taskSetAssigneeSubmit").on('click',function (e) {
		 var assigneeUserId = $('#assigneeUserId').val();
		 var action = 'executeTask.jsp?executeTask=taskSetAssignee&taskInstanceId='+<%=taskInstanceId%>+'&assigneeUserId='+assigneeUserId;
		 $('#submit_form').attr('action', action);
		 $("#submit_form").submit();  
	 });
	 
});



</script>
</body>
</html>
