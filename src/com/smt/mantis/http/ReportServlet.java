package com.smt.mantis.http;

//JDK 1.7.0
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;


//Javax 1.7.X
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


//log4j 1.2.15
import org.apache.log4j.Logger;

import com.mysql.jdbc.Connection;
//M.R. 2.0
import com.smt.mantis.config.GlobalConfig;
import com.smt.mantis.procedure.ticket.TicketProcedure;
import com.smt.mantis.procedure.ticket.TicketVO;

/****************************************************************************
 * <b>Title</b>: ReportServlet.java <p/>
 * <b>Project</b>: MantisReport <p/>
 * Acts as the bridge between the data(model) and the display(view). 
 * Makes any necessary calls or processing required between the two.
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 2.0
 * @since March 5, 2015
 ************************************************************************/

@WebServlet("/Report")
public class ReportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected ServletContext scxt = null;
	private DataSource ds = null;
	private RequestProcessor reqProc = null;
	private ArrayList<TicketVO> ticketList;
	private String allParams;
	private HashMap<String, String[]> requestMap;

	//define the logger
	private static Logger log = Logger.getLogger(ReportServlet.class);

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
	
			//initialize super class
			super.init(config);
			
			//get the context
			scxt = config.getServletContext();

			//initialize the request processor 
			reqProc = new RequestProcessor();
			
			//Use the datasource to get a connection
			
			//set the connection to base class
	}

	/**
	 * Handles incoming GET request
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//send GET request to post handler method
		this.doPost(request, response);
	}

	/**
	 * Handles incoming POST request
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		log.debug("Processing Request...");
		String type = request.getParameter("type") == null ? GlobalConfig.MANTIS
				: request.getParameter("type");

		if (!type.equals("export")) {
			// Retrieve any request parameters
			this.requestMap = reqProc.getAllParameters(request);
			this.allParams = reqProc.buildAllParams(requestMap, true);
			request.setAttribute("allParams", this.allParams);
			
			//REFACTOR: This may be causing initial blank page when first loaded
			if (type.equals(GlobalConfig.MANTIS)) {
				TicketProcedure ticketProc = new TicketProcedure();
				ArrayList<TicketVO> ticketList = ticketProc
						.selectQuery(requestMap);
				this.ticketList = ticketList;
			}

			//type does equal export then
		} else {
			log.debug("Exporting to excel");
			// set all incoming parameters to request??
			this.allParams = reqProc.buildAllParams(requestMap, false);
			request.setAttribute("allParams", this.allParams);
		}

		// forward list of ticketVOs to corresponding jsp
		log.debug("Param values are " + allParams);
		request.setAttribute("ticketList", ticketList);
		log.debug("Sending list to approriate view");
		request.getRequestDispatcher(GlobalConfig.BASE_PATH + type + ".jsp")
				.forward(request, response);
	}
	
	/**
	 * Handles request for both GET and POST request received
	 */
	public void processRequest(HttpServletRequest request,
			HttpServletResponse response)throws ServletException, IOException{
		
	}
	
	/**
	 * Attempts to get a db connection using the datasource configured in
	 * the context
	 */
	public Connection getDBConnection(){
		Connection conn = null;
		try {
			//lookup the datasource from the context
			Context initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup(GlobalConfig.JAVA_COMP_ENV);
			ds = (DataSource) envContext.lookup(GlobalConfig.MANTIS_DATA_SOURCE);
			//Get the connection to the database
			conn = (Connection) ds.getConnection();
		} catch (NamingException | SQLException e) {
			e.printStackTrace();
		}
		
		return conn;
		
	}
}