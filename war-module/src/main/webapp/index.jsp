<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page import="java.util.*,java.text.*,javax.servlet.jsp.*,java.io.*" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
 <head>
  <title>Sample JSP (snoop)</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <style type="text/css">
    /*<![CDATA[*/
html,body{margin:0;padding:0}
body{font-family:arial,sans-serif;text-align:left}
.title{padding:4;background-color:#8FBC8F}
.row{padding:4;background-color:#FAFAD2}
.roweven{padding:4;background-color:#FAFAD2}
.rowodd{padding:4;}
     /*]]>*/
   </style>
  </head>
<%!
public void printSection(JspWriter out, String title, Map<String, Object> elements) throws IOException {
	out.println("<tr class=\"title\">");
	out.println("<td colspan=\"2\">" + title + "</td>");
	out.println("</tr>");

	int index = 0;
	for (String key : elements.keySet()) {
		out.println("<tr class=\"" + (index % 2 == 0 ? "roweven" : "rowodd") + "\">");
		out.println("<td>" + key + "</td>");
		out.println("<td>" + elements.get(key) + "</td>");
		out.println("</tr>");
		index++;
	}
}

public void printSortedSection(JspWriter out, String title, Map<String, Object> elements) throws IOException {
	out.println("<tr class=\"title\">");
	out.println("<td colspan=\"2\">" + title + "</td>");
	out.println("</tr>");
	
	SortedSet<String> keys = new TreeSet<String>(elements.keySet());
	
	int index = 0;
	for (String key : keys) {
		out.println("<tr class=\"" + (index % 2 == 0 ? "roweven" : "rowodd") + "\">");
		out.println("<td>" + key + "</td>");
		out.println("<td>" + elements.get(key) + "</td>");
		out.println("</tr>");
		index++;
	}
}
%>
  <body>
   <center>
    <h1>Snoop</h1>
    <table>
<%
    session.setAttribute("user", "A001");

    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
    out.println("<p>" + formatter.format(new Date()) + "</p>");

	Map<String, Object> elements = new HashMap<String, Object>();

	for (Enumeration e = application.getInitParameterNames(); e.hasMoreElements();) {
		String name = (String) e.nextElement();		
		elements.put(name, application.getInitParameter(name));
	}
	printSortedSection(out, "Context Init Parameter", elements);

	elements.clear();
	for (Enumeration e = config.getInitParameterNames(); e.hasMoreElements();) {
		String name = (String) e.nextElement();		
		elements.put(name, config.getInitParameter(name));
	}
	printSortedSection(out, "Servlet Init Parameter", elements);

	elements.clear();
	elements.put("Request URL", request.getRequestURL());
	elements.put("Scheme", request.getScheme());
	elements.put("Request method", request.getMethod());
	elements.put("Request protocol", request.getProtocol()); 
	elements.put("Request URI", request.getRequestURI()); 
	elements.put("Context path", request.getContextPath()); 
	elements.put("Servlet path", request.getServletPath()); 
	elements.put("Path info", request.getPathInfo()); 
	elements.put("Path translated", request.getPathTranslated()); 
	elements.put("Query string", request.getQueryString()); 
	elements.put("Content length", Integer.toString(request.getContentLength())); 
	elements.put("Content type", request.getContentType()); 
	elements.put("Server name", request.getServerName()); 
	elements.put("Server port", Integer.toString(request.getServerPort())); 
	elements.put("Remote user", request.getRemoteUser()); 
	elements.put("Remote address", request.getRemoteAddr()); 
	elements.put("Remote host", request.getRemoteHost()); 
	elements.put("Authorization scheme", request.getAuthType()); 
	elements.put("Character Encoding", request.getCharacterEncoding()); 
	elements.put("Locale", request.getLocale()); 
	elements.put("User Principal", request.getUserPrincipal()); 
	elements.put("Is Secure", Boolean.toString(request.isSecure()));
	elements.put("Requested session ID", request.getRequestedSessionId());
	elements.put("Session id is valid?", Boolean.toString(request.isRequestedSessionIdValid()));
	elements.put("Is session ID from cookie?", Boolean.toString(request.isRequestedSessionIdFromCookie()));
	elements.put("Is session ID from URL?", Boolean.toString(request.isRequestedSessionIdFromURL()));
	printSection(out, "Request Data", elements);

	elements.clear();
	for (Enumeration e = request.getHeaderNames(); e.hasMoreElements();) {
		String name = (String) e.nextElement();		
		elements.put(name, request.getHeader(name));
	}
	printSortedSection(out, "Header Data", elements);

	elements.clear();
	Cookie[] cookies = request.getCookies();

	if (cookies != null) {
		for (int index = 0; index < cookies.length; index++) {
			Cookie cookie = cookies[index];
			elements.put(cookie.getName(), cookie.getValue());
			elements.put(cookie.getName() + ":comment", cookie.getComment());
			elements.put(cookie.getName() + ":domain", cookie.getDomain());
			elements.put(cookie.getName() + ":max-age", Integer.toString(cookie.getMaxAge()));
			elements.put(cookie.getName() + ":path", cookie.getPath());
			elements.put(cookie.getName() + ":secure", Boolean.toString(cookie.getSecure()));
			elements.put(cookie.getName() + ":version", Integer.toString(cookie.getVersion()));
		}

		printSortedSection(out, "Cookie Data", elements);
	}

	elements.clear();
	for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
		String name = (String) e.nextElement();		
		elements.put(name, request.getParameter(name));
	}
	printSortedSection(out, "Request Parameters", elements);

	elements.clear();
	elements.put("ID", session.getId());
	elements.put("Is new?", Boolean.toString(session.isNew()));
	elements.put("Creation time", new Date(session.getCreationTime()));
	elements.put("Last accessed time", new Date(session.getLastAccessedTime()));
	elements.put("Max inactive interval", Integer.toString(session.getMaxInactiveInterval()));
	printSection(out, "Session Data", elements);

	elements.clear();
	for (Enumeration e = session.getAttributeNames(); e.hasMoreElements();) {
		String name = (String) e.nextElement();		
		elements.put(name, session.getAttribute(name));
	}
	printSortedSection(out, "Session Attributes", elements);

	elements.clear();
	for (Enumeration e = request.getAttributeNames(); e.hasMoreElements();) {
		String name = (String) e.nextElement();		
		elements.put(name, request.getAttribute(name));
	}
	printSortedSection(out, "Request Attributes", elements);

	elements.clear();
	for (Enumeration e = application.getAttributeNames(); e.hasMoreElements();) {
		String name = (String) e.nextElement();		
		elements.put(name, application.getAttribute(name));
	}
	printSortedSection(out, "Application Attributes", elements);

	elements.clear();
	elements.put("Servlet name", config.getServletName());
	elements.put("Server info", application.getServerInfo());
	elements.put("Servlet context name", application.getServletContextName());
	elements.put("Servlet specification", application.getMajorVersion() + "." + application.getMinorVersion());
	printSection(out, "Container Configuration", elements);

	elements.clear();
	Properties system = System.getProperties();
	for (Enumeration e = system.propertyNames(); e.hasMoreElements();) {
		String name = (String) e.nextElement();		
		elements.put(name, system.getProperty(name));
	}
	printSortedSection(out, "System Properties", elements);

%>
    </table>
   </center>
 </body>
</html>
