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

//是否从登陆界面过来的，如果是的话，需要记录session begin-->
Object userIdFromRequest = request.getParameter("userId");
if(userIdFromRequest!=null&&userIdFromRequest.toString().length()>0){
	System.out.println(userIdFromRequest);
	session.setAttribute("userId", userIdFromRequest);
	
}
//是否从登陆界面过来的，如果是的话，需要记录session end<--

//判断session，记录userId
Object userIdinSession = session.getAttribute("userId");
String userId = null;
if(userIdinSession!=null){
	userId = userIdinSession.toString();
}else{
	response.sendRedirect("login.jsp");
}

//-----获取代办任务列表 开始-->
EnumSet<EntityConstants.TASK_STATE> stateSet = EnumSet.noneOf(EntityConstants.TASK_STATE.class);  
stateSet.add(EntityConstants.TASK_STATE.NOT_STARTED);  
stateSet.add(EntityConstants.TASK_STATE.RUNNING);
List<TaskInstance> taskList = runBPMService.listTaskInstanceByUserIdAndState(userId, stateSet);
//-----获取代办任务列表 结束<-- 

//----以下是 判断接受任务、接受任务、转到任务处理界面的逻辑
String taskInstanceId = request.getParameter("taskInstanceId");
String isSubmit = request.getParameter("isSubmit")+"";
boolean showClaimTask = false;
boolean sendRedirect=false;//是否转到任务界面
if(isSubmit!=null&&isSubmit.trim().equals("1")){
	TaskInstance taskInstance = runBPMService.loadTaskInstance(Long.parseLong(taskInstanceId));
	if(taskInstance.getState().equals(EntityConstants.TASK_STATE.NOT_STARTED)){
		//需要显示接受任务界面
		showClaimTask = true;
	}else if(taskInstance.getState().equals(EntityConstants.TASK_STATE.RUNNING)){
		//需要转发到处理任务界面
		sendRedirect=true;
	}
}
String isClaim = request.getParameter("isClaim")+"";
if(isClaim!=null&&isClaim.trim().equals("1")){
	//处理任务（抢任务），将该任务置于我的名下，任务状态从“未开始”转化为“运行中”
	runBPMService.claimUserTask(Long.parseLong(taskInstanceId));
	sendRedirect=true;
}

//转发到任务处理界面 开始-->
if(sendRedirect){
	TaskInstance taskInstance = runBPMService.loadTaskInstance(Long.parseLong(taskInstanceId));
	ProcessModel processModel =runBPMService.loadProcessModelByModelId(taskInstance.getProcessModelId());
	ActivityDefinition activityDefinition = processModel.getProcessDefinition().getActivity(taskInstance.getActivityDefinitionId());
	ExtensionElements extensionElements = activityDefinition.getExtensionElements();
	Map templateMap = extensionElements.getExtensionPropsMap("runBPM_ApplicationTemplate_Definition");
	
	
	String url = null;
	if(templateMap!=null){
		if("appliation_operation".equals(templateMap.get("type").toString())){
			String applicationMapString = templateMap.get("applicationMap").toString();
			 StringTokenizer st = new StringTokenizer(applicationMapString,",");
			 int i =0;
		     while (st.hasMoreTokens()) {
		    	 	st.nextToken();
		         i++;
		     } 
		     if(i==1){
		    	 	url="listApplicationTemplate1.jsp"+"?taskInstanceId="+taskInstanceId; 
		     }else if(i==2){
		    	 	url="listApplicationTemplate2.jsp"+"?taskInstanceId="+taskInstanceId; 
		     }
		}
	}else{
		 url = extensionElements.getPropertyValue("application")+"?taskInstanceId="+taskInstanceId;
	}
	
	
	response.sendRedirect(url);
}
//转发到任务处理界面 结束<--

//是否由提交任务界面过来，如果是的话，需要显示处理成功的提示 begin-->
boolean completeTask = false;
String isCompleteTask = request.getParameter("isCompleteTask")+"";
if(isCompleteTask!=null&&isCompleteTask.trim().equals("1")){
	completeTask = true;
}
//是否由提交任务界面过来，如果是的话，需要显示处理成功的提示 end<--


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
	            <i class="fa fa-table"></i> <span>流程管理</span>
	            <i class="fa fa-angle-left pull-right"></i>
	          </a>
	          <ul class="treeview-menu">
	          	<li><a href="deployProcessDefinition.jsp"><i class="fa fa-circle-o"></i> 导入流程</a></li>
	          	<li><a href="listProcessModel.jsp"><i class="fa fa-circle-o"></i> 创建流程</a></li>
	          </ul>
	        </li>
	        
	        <li class="active"><a href="listMyTask.jsp"><i class="fa fa-book"></i> <span>代办任务</span></a></li>
	        
	         <li class="treeview">
	          <a href="#">
	            <i class="fa   fa-star-half-o"></i> <span>未结束流程</span>
	            <i class="fa fa-angle-left pull-right"></i>
	          </a>
	          <ul class="treeview-menu">
	            <li><a href="listMyProcess.jsp"><i class="fa fa-circle-o"></i> 已建流程</a></li>
	            <li><a href="listMyTaskCompleted.jsp"><i class="fa fa-circle-o"></i> 已办任务</a></li>
	          </ul>
	        </li>
	        
	         <li class="treeview">
	          <a href="#">
	            <i class="fa  fa-star"></i> <span>已结束流程</span>
	            <i class="fa fa-angle-left pull-right"></i>
	          </a>
	          <ul class="treeview-menu">
	          <li><a href="listMyProcessHistory.jsp"><i class="fa fa-circle-o"></i> 已建流程</a></li>
	            <li><a href="listMyTaskHistory.jsp"><i class="fa fa-circle-o"></i> 已办任务</a></li>
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
        代办任务
        <small>需要本人经手，且流程未结束的工作项</small>
      </h1>
      <ol class="breadcrumb" style="display:none">
        <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
        <li class="active">Here</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
       <div class="box" >
            <div class="box-header" style="display:none">
              <h3 class="box-title"></h3>

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
            <div class="box-body table-responsive no-padding">
               <table class="table table-hover">
                <tr>
                  <th>工作项实例ID</th>
                  <th>名称</th>
                  <th>执行者</th>
                  <th>流程实例ID</th>
                  <th>流程定义</th>
                  <th>状态</th>
                  <th>创建时间</th>
                </tr>
                <%
                for(TaskInstance taskInstance : taskList){
                	
                %>
                <tr>
                  <td><%=taskInstance.getId() %></td>
                  <td><a href="listMyTask.jsp?isSubmit=1&taskInstanceId=<%=taskInstance.getId() %>"><%=taskInstance.getName() %></a></td>
                  <td><%=taskInstance.getUserId() %></td>
                  <td><%=taskInstance.getProcessInstanceId() %></td>
                  <td><%=taskInstance.getProcessDefinitionId() %></td>
                  <td><%=ConstantsUtil.getStateString(taskInstance.getState()) %></td>
                  <td><%=taskInstance.getCreateDate() %></td>
                </tr>
                <%
                }
                %>
              </table>
            </div>
            <!-- /.box-body -->
          </div>
          <!-- /.box -->
          
          <!-- Modal -->
              <div class="modal fade" id="hiddenModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                      <h4 class="modal-title" id="deployResultModal">接受任务</h4>
                     
                    </div>
                    <div class="modal-body">
                      是否接受任务？
                    </div>
                    <div class="modal-footer">
                    	  <button type="button" id="claimTask" class="btn btn-primary">接受</button>
                      <button type="button" class="btn btn-default"  data-dismiss="modal">取消</button>
                      <form id="submit_form" method="post"></form>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="modal fade" id="infoModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                      <h4 class="modal-title" id="deployResultModal">成功提交任务</h4>
                    </div>
                    <div class="modal-body">
                      已经成功提交任务。
                    </div>
                    <div class="modal-footer">
                      <button type="button" class="btn btn-primary"  data-dismiss="modal">关闭</button>
                      <form id="submit_form" method="post"></form>
                    </div>
                  </div>
                </div>
              </div>
              <!--//Modal-->

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

<script>

$(document).ready(function() {
	<%
	if(showClaimTask){
		out.println("$('#hiddenModal').modal({keyboard: true});");
	}
	if(completeTask){
		out.println("$('#infoModal').modal({keyboard: true});");
	}
	%>
	
	
	 $("#claimTask").on('click',function (e) {
		    
		    var action = 'listMyTask.jsp?isClaim=1&taskInstanceId='+<%=taskInstanceId%>;
		    $('#submit_form').attr('action', action);
		    $("#submit_form").submit();
		    
		    
	});
});


</script>
</body>
</html>
