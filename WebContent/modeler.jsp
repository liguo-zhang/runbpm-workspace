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
<%@ page import="org.runbpm.service.RunBPMService" %>
<%@ page import="org.runbpm.workspace.Upload" %>

<%
RunBPMService runBPMService = Configuration.getContext().getRunBPMService();
List<ProcessModel> processModelist = runBPMService.loadProcessModels();
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
  
  <link rel="stylesheet" href="modeler/css/diagram-js.css" />
  <link rel="stylesheet" href="modeler/vendor/bpmn-font/css/bpmn-embedded.css" />
  <link rel="stylesheet" href="modeler/css/app.css" />
  <style>
	pre{
	  	border-top:0 solid;
	  	background-color:white;
	}
  	pre.prettyprint{
		width: auto;
		overflow: auto;
		max-height: 500px
	}
  </style>
  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
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
        <li class="header"></li>
        
	          <li class="treeview active">
	          <a href="#">
	            <i class="fa fa-table"></i> <span>流程定义管理</span>
	            <i class="fa fa-angle-left pull-right"></i>
	          </a>
	          <ul class="treeview-menu">
	          	<li  class="active"><a href="modeler.jsp"><i class="fa fa-circle-o"></i> 定义流程</a></li>
	          	<li><a href="deployProcessDefinition.jsp"><i class="fa fa-circle-o"></i> 部署流程定义</a></li>
	          	<li><a href="listProcessModel.jsp"><i class="fa fa-circle-o"></i> 创建流程</a></li>
	          </ul>
	        </li>
	        
	        <li><a href="listMyTask.jsp"><i class="fa fa-book"></i> <span>本人代办流程</span></a></li>
	        
	         <li class="treeview">
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
	                    	
  		  <section class="content" style="padding-top:5px">
                  <ul class="nav nav-tabs">
                    <li class="active"><a data-toggle="tab" href="#draw_tab">画板</a></li>
                    <li><a data-toggle="tab" href="#bpmn_tab">XML源文件</a></li>
                    <li class="pull-right">
                    		<div class="btn-group">
	                    		<input type="file" class="btn btn-default" id="diagram_file" value="选择本地文件"/>
	                    		<button type="button" id="selectProcessDefinitionInEngine" class="btn  btn-default">选择已部署定义</button>
	                    	</div>
	                    	<button type="button" id="deployProcessDefinition" class="btn btn-success">部署到流程引擎</button>
                    </li>
                  </ul>
                  <div class="tab-content">
                    <div id="draw_tab" class="tab-pane fade in active">
                      <div class="content with-diagram nopadding" id="js-drop-zone" >
                         <div class="row">
                            <div class="col-xs-7 col-sm-6 col-lg-8 nopadding">
                                  <div class="canvas" id="js-canvas"></div>
                                </div>
                                <div class="col-xs-5 col-sm-6 col-lg-4 nopadding">
                                  <div id="js-properties-panel"></div>
                                </div>
                           </div>
                          </div>
                     </div>
                      <div id="bpmn_tab" class="tab-pane fade">
                        <div id="bpmn_tab_source"></div>
                        <div>
                         <ul class="buttons">
                          <li>
                            下载
                          </li>
                          <li>
                            <a id="js-download-diagram" href title="download BPMN diagram">
                              XML源文件
                            </a>
                          </li>
                          <li>
                            <a id="js-download-svg" href title="download as SVG image">
                              SVG图片
                            </a>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>   
              </section>
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

 			<!-- Modal -->
              <div class="modal fade" id="allProcessListModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body">
                    			
							<table class="table table-hover tree">
								                <tr>
								                  <th>ID</th>
								                  <th nowrap>流程定义</th>
								                  <th nowrap>版本</th>
								                  <th nowrap>名称</th>
								                  <th nowrap></th>
								                </tr>
								                <%
								                int i = 0;
								                for(ProcessModel pm : processModelist){
								                		i++;
								                %>
										                <tr class="treegrid-A<%=i%>">
										                  <td><%=pm.getId() %></td>
										                  
										                  <td nowrap><%=pm.getProcessDefinition().getId() %></td>
										                  <td nowrap><%=pm.getVersion() %> </td>
										                  <td><%=pm.getName() %></td>
										                  
										                  <td>
											                  <button id="choose_process_<%=pm.getId() %>"  modelId='<%=pm.getId() %>' type="button" class="btn btn-info btn-sm">选择</button>
										                  </td>
										                </tr>
										        <%   
										             List<ProcessModel> subList = runBPMService.loadProcessModelsByProcessDefinitionId(pm.getProcessDefinitionId());
								                		for(ProcessModel subPM : subList){
								                	%>		
								                			<tr class="treegrid-<%=subPM.getId() %> treegrid-parent-A<%=i%>">
										                  <td nowrap><%=subPM.getId() %></td>
										                  <td nowrap><%=subPM.getProcessDefinition().getId() %></td>
										                  <td nowrap><%=subPM.getVersion() %></td>
										                  <td><%=subPM.getName() %></td>
										                  <td>
											                  <button id="choose_process_<%=subPM.getId() %>" modelId='<%=subPM.getId() %>' type="button" class="btn btn-default btn-sm">选择</button>
										                  </td>
										                </tr>
								                <%			
								                		}
								                }
								                %>
								              </table>
                     
                    </div>
                    <div class="modal-footer" style="display:none">
                      <button type="button" class="btn btn-primary"  data-dismiss="modal" >关闭</button>
                    </div>
                  </div>
                </div>
              </div>
              <!--//Modal-->
              
               <!-- Modal -->
              <div class="modal fade" id="deployResultModal" tabindex="-1" role="dialog" aria-labelledby="deployResultModal">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                      <h4 class="modal-title" id="modalTitleText">
                     
                      </h4>
                    </div>
                    <div class="modal-body" id="modalBodyText">
                      
                    </div>
                    <div class="modal-footer">
                      <button type="button" class="btn btn-primary"  data-dismiss="modal">关闭</button>
                    </div>
                  </div>
                </div>
              </div>
              <!--//Modal-->


<!-- REQUIRED JS SCRIPTS -->

<!-- jQuery 2.2.0 -->
<script src="ui/plugins/jQuery/jQuery-2.2.0.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="ui/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="ui/dist/js/app.min.js"></script>
<script src="ui/plugins/treegrid/jquery.treegrid.js"></script>
<script src="ui/plugins/treegrid/jquery.treegrid.bootstrap3.js"></script>

<script src="modeler/index.js"></script>
<script>
$(document).ready(function() {
	
	$("svg").height($(".content-wrapper").height()-50);
	$("#bpmn_tab").height($(".content-wrapper").height()-50);
	
	$("#selectProcessDefinitionInEngine").on('click',function (e) {
		$('#allProcessListModal').modal({keyboard: true});
	});
	
	 $('.tree').treegrid({
	        treeColumn: 2,
	        initialState:"collapsed"
	});
	
});

function choose_process_back(){
	$('#allProcessListModal').modal('hide');
}

function deployProcessDefinition_back(data){
	if(data.code=='0'){
		$('#modalTitleText').html("部署成功");
	}else{
		$('#modalTitleText').html("部署失败");
	}  
	$('#modalBodyText').html(data.msg);
	$('#deployResultModal').modal({keyboard: true});
	
}

</script>


<!-- Optionally, you can add Slimscroll and FastClick plugins.
     Both of these plugins are recommended to enhance the
     user experience. Slimscroll is required when using the
     fixed layout. -->
</body>
</html>
