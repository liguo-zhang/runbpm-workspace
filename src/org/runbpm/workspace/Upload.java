package org.runbpm.workspace;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.*;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.runbpm.context.Configuration;
import org.runbpm.entity.ProcessModel;
import org.runbpm.service.RunBPMService;

/**
 *
 */

public class Upload {

    /** */
	private static final long serialVersionUID = 1L;

	
	public ResultBean uploadFileAndImportProcess(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
		    
		    HttpSession session=request.getSession();
		    session.setAttribute("progressBar",0);      //定义指定上传进度的Session变量
		    String error = "";
		    int maxSize=50*1024*1024;        //单个上传文件大小的上限
		    DiskFileItemFactory factory = new DiskFileItemFactory();        //基于磁盘文件项目创建一个工厂对象
		    ServletFileUpload upload = new ServletFileUpload(factory);  //创建一个新的文件上传对象
		    
		    InputStream is= null;
            InputStreamReader inputStreamReader = null;
            BufferedReader bufferedReader = null;
            ProcessModel processModel = null;
		    try {
		        List items = upload.parseRequest(request);// 解析上传请求
		        Iterator itr = items.iterator();// 枚举方法
		        while (itr.hasNext()) {
		            FileItem item = (FileItem) itr.next();  //获取FileItem对象
		            if (!item.isFormField()) {// 判断是否为文件域
		                if (item.getName() != null && !item.getName().equals("")) {// 判断是否选择了文件
		                    long upFileSize=item.getSize();     //上传文件的大小
		                    //System.out.println("上传文件的大小:" + item.getSize());
		                    if(upFileSize>maxSize){
		                        error="您上传的文件太大，请选择不超过50M的文件";
		                        break;
		                    }
		                    StringBuffer sb = new StringBuffer();
		                    
		                    is=item.getInputStream();
		                    inputStreamReader = new InputStreamReader(is);
		                    bufferedReader = new BufferedReader(inputStreamReader);
		                    String line = bufferedReader.readLine(); // 读取第一行
		                    while (line != null) { // 如果 line 为空说明读完了
		                        sb.append(line); // 将读到的内容添加到 buffer 中
		                        sb.append("\n"); // 添加换行符
		                        line = bufferedReader.readLine(); // 读取下一行
		                    }
		                    
		                    //导入流程
		                    RunBPMService runBPMService = Configuration.getContext().getRunBPMService();
		                    processModel = runBPMService.deployProcessDefinitionFromString(sb.toString());
		                } else {
		                    error="没有选择上传文件！";
		                }
		            }
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        error = "上传文件出现错误：" + e.getMessage();
		    }finally{
		    	if(inputStreamReader!=null){
		    		inputStreamReader.close();
		    	}
		    	if(bufferedReader!=null){
		    		bufferedReader.close();
		    	}
		    	if(is!=null){
		    		is.close();
		    	}
		    }
		    
		    ResultBean rb = new ResultBean();
		    
		    if (!"".equals(error)) {
//		    	request.setAttribute("code", "1");
//		        request.setAttribute("result", error);
		    	rb.setCode("1");
		    	rb.setResult(error);
		    }else {
		    	long id = processModel.getId();
		    	String defId = processModel.getProcessDefinition().getId();
		    	String name = processModel.getProcessDefinition().getName();
		    	rb.setCode("0");
		    	rb.setResult("部署成功。流程定义ID为["+defId+"],流程定义名称为["+name+"],生成的流程模板ID为["+id+"]。");
//		    	request.setAttribute("code", "0");
//		        request.setAttribute("result", "部署成功。流程定义ID为["+defId+"],流程定义名称为["+name+"],生成的流程模板ID为["+id+"]。");
		    }
		    
		    return rb;
	}
    
 }
