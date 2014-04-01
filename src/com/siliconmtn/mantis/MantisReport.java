package com.siliconmtn.mantis;

import java.io.IOException;

import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/*
 * Class should be a javabean that will send request either to it's jsp or
 * to an excel file/cvs file
 */


//create local variables equal to the same fields I need to pull from database

//Determine those fields from database

//Query database in this class assign to variables and put in a scope

//Access those variables in a list through jsp for view


public class MantisReport extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected ServletContext sctext = null;
	private static final String JSP_PATH = "/WEB-INF/mantis.jsp";
	private static final String EXCEL_CONTENT_TYPE = "application/vnd.ms-excel";
	private static final String CSV_CONTENT_TYPE = "text/csv";
	
	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		sctext = config.getServletContext();

	}

	/**
	 * Handles any GET request that are sent from client
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		// need to place anything into request scope so jsp can access it

		request.getRequestDispatcher(JSP_PATH).forward(request,
				response);
	}

	/**
	 * Handles any POST request that are sent from client
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {


		// check if they hit excel button
		if (request.getParameter("name").equals("excel")) {

			response.setContentType(EXCEL_CONTENT_TYPE);


			// check if they hit csv button
		} else if (request.getParameter("name").equals("csv")) {

			response.setContentType(CSV_CONTENT_TYPE);


		} else {


			request.getRequestDispatcher(JSP_PATH).forward(
					request, response);

		}

	}

}
