package com.siliconmtn.controller;

//JDK 1.7.0
import java.io.IOException;
import java.util.ArrayList;
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

//log4j 1.2.15
import org.apache.log4j.Logger;

import com.siliconmtn.helper.Constants;
import com.siliconmtn.helper.Helper;
import com.siliconmtn.model.TicketModel;
import com.siliconmtn.pojo.TicketVO;

/**
 * Servlet implementation class MantisController
 */
@WebServlet("/Mantis")
public class MantisController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected ServletContext scxt = null;
	private DataSource ds = null;
	private ArrayList<TicketVO> ticketList;
	private String[] params;
	private Helper hlp;
	
	private static Logger log = Logger.getLogger(MantisController.class);
	
	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		try {
			super.init(config);
			scxt = config.getServletContext();
		
			Context initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			ds = (DataSource) envContext.lookup(Constants.DATA_SOURCE_LOOKUP);
			hlp = new Helper();

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
		String type = request.getParameter("type") == null ? Constants.MANTIS
				: request.getParameter("type");

		//check request parameters
		HashMap<String, String[]> requestMap = hlp.getAllParameters(request);
		
		if(hlp.getParameter(request, Constants.FIELD_NAME).length > 0){
			this.params = hlp.getParameter(request, Constants.FIELD_NAME);
		}

		// create list of vo's
		if (type.equals(Constants.MANTIS)) {
			TicketModel ticketMod = new TicketModel(ds);
			ArrayList<TicketVO> tckList = ticketMod.runQuery(requestMap);
			this.ticketList = tckList;
		}
		
		request.setAttribute("ticketList", ticketList);
		request.setAttribute("fieldParam", this.params);
		log.debug("Logging from controller");
		
		if(type.equals("export")) this.params = null;
		request.getRequestDispatcher(Constants.BASE_PATH + type + ".jsp")
				.forward(request, response);
	}
}
