package com.smt.mantis.controller;

//JDK 1.7.0
import java.io.IOException;
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

//m.r 2.0
import com.smt.mantis.config.GlobalConfig;
import com.smt.mantis.procedure.ticket.TicketProcedure;
import com.smt.mantis.procedure.ticket.TicketVO;
import com.smt.mantis.request.RequestProcessor;

/****************************************************************************
 * <b>Title</b>: ReportController.java <p/>
 * <b>Project</b>: MantisReport <p/>
 * Acts as the mediator between the data(model) and the display(view). 
 * Makes any necessary calls or processing required between the two.
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 2.0
 * @since March 5, 2015
 ************************************************************************/

@WebServlet("/Report")
public class ReportController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected ServletContext scxt = null;
	private DataSource ds = null;
	private RequestProcessor reqProc = null;
	private ArrayList<TicketVO> ticketList;
	private String allParams;
	private HashMap<String, String[]> requestMap;

	private static Logger log = Logger.getLogger(ReportController.class);

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		try {
			super.init(config);
			scxt = config.getServletContext();

			Context initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup(GlobalConfig.JAVA_COMP_ENV);
			ds = (DataSource) envContext.lookup(GlobalConfig.DATA_SOURCE_LOOKUP);
			reqProc = new RequestProcessor();

		} catch (NamingException e) {
			e.printStackTrace();
		}
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
        
		String type = request.getParameter("type") == null ? GlobalConfig.MANTIS
				: request.getParameter("type");

		//
		if (!type.equals("export")) {

			// Retrieve any request parameters
			this.requestMap = reqProc.getAllParameters(request);
			this.allParams = reqProc.buildAllParams(requestMap, true);
			request.setAttribute("allParams", this.allParams);

			// create list of vo's
			
			//REFACTOR: This may be causing initial blank page when first loaded
			if (type.equals(GlobalConfig.MANTIS)) {
				TicketProcedure ticketMod = new TicketProcedure(ds);
				ArrayList<TicketVO> ticketList = ticketMod
						.selectQuery(requestMap);
				this.ticketList = ticketList;
			}

			//type equals export
		} else {
			// set all incoming parameters to request??
			this.allParams = reqProc.buildAllParams(requestMap, false);
			request.setAttribute("allParams", this.allParams);
		}

		// forward list of ticketVOs to specific jsp
		log.debug("Params are " + allParams);
		request.setAttribute("ticketList", ticketList);
		request.getRequestDispatcher(GlobalConfig.BASE_PATH + type + ".jsp")
				.forward(request, response);
	}
}
