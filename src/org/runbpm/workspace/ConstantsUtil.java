package org.runbpm.workspace;

import org.runbpm.entity.EntityConstants.ACTIVITY_STATE;
import org.runbpm.entity.EntityConstants.PROCESS_STATE;
import org.runbpm.entity.EntityConstants.TASK_STATE;

public class ConstantsUtil {

	public static String getStateString(PROCESS_STATE ps) {
		 if(ps==PROCESS_STATE.NOT_STARTED) {
			 return "未开始";
		 }else  if(ps==PROCESS_STATE.RUNNING) {
			 return "运行中";
		 }else  if(ps==PROCESS_STATE.COMPLETED) {
			 return "已结束";
		 }else  if(ps==PROCESS_STATE.SUSPENDED) {
			 return "已挂起";
		 }else  if(ps==PROCESS_STATE.TERMINATED) {
			 return "已终止";
		 }
		 return "";
	 }
	
	 public static String getStateString(ACTIVITY_STATE as) {
		 if(as==ACTIVITY_STATE.NOT_STARTED) {
			 return "未开始";
		 }else  if(as==ACTIVITY_STATE.RUNNING) {
			 return "运行中";
		 }else  if(as==ACTIVITY_STATE.COMPLETED) {
			 return "已结束";
		 }else  if(as==ACTIVITY_STATE.SUSPENDED) {
			 return "已挂起";
		 }else  if(as==ACTIVITY_STATE.TERMINATED) {
			 return "已终止";
		 }
		 return "";
	 }
	 
	 public static String getStateString(TASK_STATE ts) {
		 if(ts==TASK_STATE.NOT_STARTED) {
			 return "未开始";
		 }else  if(ts==TASK_STATE.RUNNING) {
			 return "运行中";
		 }else  if(ts==TASK_STATE.COMPLETED) {
			 return "已结束";
		 }else  if(ts==TASK_STATE.SUSPENDED) {
			 return "已挂起";
		 }else  if(ts==TASK_STATE.TERMINATED) {
			 return "已终止";
		 }else  if(ts==TASK_STATE.CANCELED) {
			 return "已取消";
		 }
		 return "";
	 }
}
