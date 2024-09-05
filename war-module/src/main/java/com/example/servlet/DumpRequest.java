package com.example.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

import java.io.*;
import java.util.*;

@WebServlet(urlPatterns = "/dumprequest", name = "DumpRequest")
public class DumpRequest extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public DumpRequest() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();
		out.append("Served at: ").append(request.getContextPath());
		Enumeration enames;
		Map<String, String> map;
		String title;

		// Print generic request info
		map = new TreeMap<String, String>();
		map.put("RequestURL", request.getRequestURI());
		map.put("PathInfo", request.getPathInfo());
		map.put("QueryString", request.getQueryString());
		map.put("ServerName", request.getServerName());
		map.put("RemoteUser", request.getRemoteUser());
		map.put("RemoteAddr", request.getRemoteAddr());
		map.put("RemoteHost", request.getRemoteHost());
		map.put("AuthType", request.getAuthType());
		session.getServletContext().log(createTextTable(map, "Request Info"));
		out.println(createHTMLTable(map, "Request Info"));

		// RequestDispatcher rd = request.getRequestDispatcher();

		// Print the request headers

		map = new TreeMap();
		enames = request.getHeaderNames();
		while (enames.hasMoreElements()) {
			String name = (String) enames.nextElement();
			String value = request.getHeader(name);
			map.put(name, value);
		}
		session.getServletContext().log(createTextTable(map, "Request Headers"));
		out.println(createHTMLTable(map, "Request Headers"));

		// Print the session attributes

		map = new TreeMap();
		enames = session.getAttributeNames();
		while (enames.hasMoreElements()) {
			String name = (String) enames.nextElement();
			String value = "" + session.getAttribute(name);
			map.put(name, value);
		}
		session.getServletContext().log(createTextTable(map, "Session Attributes"));
		out.println(createHTMLTable(map, "Session Attributes"));

		// Print Cookies
		map = new TreeMap();
		for (Cookie cookie : request.getCookies()) {
			map.put(cookie.getName(), cookie.getValue());
		}
		session.getServletContext().log(createTextTable(map, "Cookies"));
		// out.println(createTextTable(map, "Session Attributes"));

	}

	private static String createHTMLTable(Map map, String title) {
		StringBuffer sb = new StringBuffer();

		// Generate the header lines

		sb.append("<table border='1' cellpadding='3'>");
		sb.append("<tr>");
		sb.append("<th colspan='2'>");
		sb.append(title);
		sb.append("</th>");
		sb.append("</tr>");

		// Generate the table rows

		Iterator imap = map.entrySet().iterator();
		while (imap.hasNext()) {
			Map.Entry entry = (Map.Entry) imap.next();
			String key = (String) entry.getKey();
			String value = (String) entry.getValue();
			sb.append("<tr>");
			sb.append("<td>");
			sb.append(key);
			sb.append("</td>");
			sb.append("<td>");
			sb.append(value);
			sb.append("</td>");
			sb.append("</tr>");
		}

		// Generate the footer lines

		sb.append("</table><p></p>");

		// Return the generated HTML

		return sb.toString();
	}

	private static String createTextTable(Map map, String title) {
		StringBuffer sb = new StringBuffer();

		// Generate the header lines

		// Generate the table rows

		Iterator imap = map.entrySet().iterator();
		sb.append("\n");
		while (imap.hasNext()) {
			Map.Entry entry = (Map.Entry) imap.next();
			String key = (String) entry.getKey();
			String value = (String) entry.getValue();
			sb.append("||*");
			sb.append(key);
			sb.append("*||");
			sb.append(value);
			sb.append("||\n");
		}

		return sb.toString();
	}

}
