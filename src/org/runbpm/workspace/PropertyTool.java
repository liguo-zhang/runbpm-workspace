package org.runbpm.workspace;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties; 

public class PropertyTool {
    public static void main(String[] args) { 
        System.out.println(PropertyTool.getPropertyMap());
    } 
    
    public static Map getPropertyMap() {
    		Map map = new HashMap();
    		Properties prop = new Properties();     
        try{
            //读取属性文件a.properties
        	InputStreamReader in = new InputStreamReader(PropertyTool.class.getClassLoader().getResourceAsStream("applicationTemplate.properties"),"UTF-8");  

            prop.load(in);     ///加载属性列表
            Iterator<String> it=prop.stringPropertyNames().iterator();
            while(it.hasNext()){
                String key=it.next();
                map.put(key, prop.getProperty(key));
            }
            in.close();
        }
        catch(Exception e){
        		e.printStackTrace();
            System.out.println(e);
        }
        return map;
    }
}
