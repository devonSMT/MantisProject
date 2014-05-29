package com.siliconmtn.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.siliconmtn.model.TicketModel;
import com.siliconmtn.pojo.TicketVO;

/**
 * Servlet implementation class MantisController
 */
@WebServlet("/Mantis")
public class MantisController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected ServletContext scxt = null;
	private String basePath = "WEB-INF/include/";
	private DataSource ds = null;

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		try {
			super.init(config);
			scxt = config.getServletContext();

			Context initContext = new InitialContext();

			Context envContext = (Context) initContext.lookup("java:/comp/env");
			ds = (DataSource) envContext.lookup("jdbc/mantisdb");

		} catch (NamingException e) {
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		this.doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String type = request.getParameter("type") == null ? "mantis" : request
				.getParameter("type");
		
		//get any request parameters
		HashMap<String, String[]> requestMap = new HashMap<String, String[]>();
		Enumeration<String> em = request.getParameterNames();

		while (em.hasMoreElements()) {
			String key = (String) em.nextElement();
			String[] values = request.getParameterValues(key);
			requestMap.put(key, values);
		}
		
		//pass to model
			
		TicketModel myModel = new TicketModel(ds);
		
		ArrayList<TicketVO> ticketList = myModel.runQuery(requestMap);

		request.setAttribute("ticketList", ticketList);
		
		request.getRequestDispatcher(basePath + type + ".jsp").forward(request,
				response);

	}

}
