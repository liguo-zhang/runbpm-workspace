package org.runbpm.workspace;

import java.util.ArrayList;
import java.util.List;

public class WorkspaceUtils {
	
	public static List<Throwable> getThrowableList(Throwable throwable) {
		final List<Throwable> list = new ArrayList<Throwable>();
		while (throwable != null && !list.contains(throwable)) {
			list.add(throwable);
			throwable = throwable.getCause();
		}
		return list;
	}
	
	public static Throwable getRootCause(final Throwable throwable) {
		final List<Throwable> list = getThrowableList(throwable);
		return list.size() < 2 ? null : list.get(list.size() - 1);
	}
	
	public static String getRootCauseMessage(final Throwable th) {
		Throwable root = getRootCause(th);
		root = root == null ? th : root;
		return getMessage(root);
	}
	
	public static String getMessage(final Throwable th) {
		if (th == null) {
			return "";
		}
		final String clsName = th.getClass().getName();
		final String msg = th.getMessage();
		return clsName + ": " + msg;
	}

}
