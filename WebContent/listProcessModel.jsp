<%
//判断session，记录userId. begin-->
Object userIdinSession = session.getAttribute("userId");
String userId = null;
if(userIdinSession!=null){
	userId = userIdinSession.toString();
}else{
	response.sendRedirect("login.jsp");
}
//判断session，记录userId. end-->
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>   
<%@ page import="java.io.*" %>
   
<%@ page import="org.runbpm.context.*" %>   
<%@ page import="org.runbpm.entity.*" %>   
<%@ page import="org.runbpm.service.RunBPMService" %>
<%
RunBPMService runBPMService = Configuration.getContext().getRunBPMService();
List<ProcessModel> processModelist = runBPMService.loadProcessModels(true);

//判断是否需要提交
String isSubmit = request.getParameter("isSubmit")+"";
String code = null;
String result = null;
System.out.println("isSubmit----"+isSubmit);

if(isSubmit!=null&&isSubmit.trim().equals("1")){
	String modelId = request.getParameter("modelId")+"";
	
	ProcessInstance processInstance = runBPMService.createAndStartProcessInstance(Long.parseLong(modelId), userId);
	
	code = "0";
	result =  "创建并启动成功。流程实例ID为["+processInstance.getId()+"],流程名称为["+processInstance.getName()+"]";
	System.out.println(result);
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
        
	         <li class="treeview active">
	          <a href="#">
	            <i class="fa fa-table"></i> <span>流程管理</span>
	            <i class="fa fa-angle-left pull-right"></i>
	          </a>
	          <ul class="treeview-menu">
	          	<li><a href="deployProcessDefinition.jsp"><i class="fa fa-circle-o"></i> 导入流程</a></li>
	          	<li  class="active"><a href="listProcessModel.jsp"><i class="fa fa-circle-o"></i> 创建流程</a></li>
	          </ul>
	        </li>
	        
	        <li><a href="listMyTask.jsp"><i class="fa fa-book"></i> <span>代办任务</span></a></li>
	        
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
    <section class="content-header" style="display:none">
      <h1>
        Page Header
        <small>Optional description</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
        <li class="active">Here</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
       <div class="box">
            <div class="box-header">
              <h3 class="box-title">流程模板列表</h3>

              <div class="box-tools" style="display:none">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name=" 	" class="form-control pull-right" placeholder="Search">

                  <div class="input-group-btn">
                    <button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
                  </div>
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <form id="listForm" name="listForm"  method="post">
            		
            </form>
            
	            <div class="box-body table-responsive no-padding">
	              <table class="table table-hover">
	                <tr>
	                  <th>模板ID</th>
	                  <th>流程定义</th>
	                  <th>流程定义版本</th>
	                  <th>名称</th>
	                  <th>描述</th>
	                  <th>创建时间</th>
	                  <th>操作</th>
	                </tr>
	                <%
	                for(ProcessModel pm : processModelist){
	                	
	                %>
	                <tr>
	                  <td><%=pm.getId() %></td>
	                  <td><%=pm.getProcessDefinition().getId() %></td>
	                  <td><%=pm.getVersion() %></td>
	                  <td><%=pm.getName() %></td>
	                  <td><%=pm.getProcessDefinition().getDocumentation() %></td>
	                  <td><%=pm.getCreateDate() %></td>
	                  <td><button id="create_process_<%=pm.getId() %>" modelId='<%=pm.getId() %>' type="button" class="btn btn-info btn-sm">创建流程</button></td>
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
              <div class="modal fade" id="deployResultModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                      <h4 class="modal-title" id="deployResultModal">
                      <%
                      if("0".equals(code)){
                    	  out.println("创建流程成功");
                      }else{
                    	  out.println("创建流程失败["+result+"]");
                      }
                      %>
                      </h4>
                    </div>
                    <div class="modal-body">
                      <% 
                      
                    	out.println(result);
                      
                      %>
                    </div>
                    <div class="modal-footer">
                      <button type="button" class="btn btn-primary"  data-dismiss="modal">关闭</button>
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
	if(isSubmit!=null&&isSubmit.trim().equals("1")){
		out.println("$('#deployResultModal').modal({keyboard: true});");
	}
	%>
	
	
	$("button[id^='create_process']").each(function(i){
		
		 $(this).on('click',function (e) {
		    
		    var modelIdValue = $(this).attr('modelId');
		    
		    $('#listForm').attr('action', 'listProcessModel.jsp?isSubmit=1&modelId='+modelIdValue);
		    
		    $("#listForm").submit();
		    
		    
		});
	});
    
});

</script>
</body>
</html>
