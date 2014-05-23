package com.siliconmtn.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

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

import com.siliconmtn.pojo.TicketVO;
import com.siliconmtn.sql.SQLBuilder;

/**
 * Servlet implementation class MantisController
 */
@WebServlet("/Mantis")
public class MantisController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected ServletContext scxt = null;
	private String mantisJsp = "WEB-INF/include/mantis.jsp";
	private DataSource ds = null;
	private PreparedStatement prstmt = null;
	private SQLBuilder sqlBuild = null;

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		try {
			super.init(config);
			scxt = config.getServletContext();

			// Get DataSource from context.xml
			Context initContext = new InitialContext();

			Context envContext = (Context) initContext.lookup("java:/comp/env");
			ds = (DataSource) envContext.lookup("jdbc/mantisdb");

		} catch (NamingException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Returns a connection from a data source pool
	 * 
	 * @return
	 * @throws SQLException
	 */
	private Connection getConnection() throws SQLException {
		return ds.getConnection();

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

		HashMap<String, String[]> requestMap = new HashMap<String, String[]>();
		Enumeration<String> em = request.getParameterNames();

		while (em.hasMoreElements()) {
			String key = (String) em.nextElement();
			String[] values = request.getParameterValues(key);
			requestMap.put(key, values);
		}

		Connection conn = null;
		ResultSet rs = null;
		try {

			conn = this.getConnection();

			// build SQL query
			sqlBuild = new SQLBuilder(requestMap);

			String sql = sqlBuild.buildQuery();;

			prstmt = conn.prepareStatement(sql);
			rs = prstmt.executeQuery();

			List<TicketVO> ticketList = new ArrayList<TicketVO>();

			int previousID = -1;

			while (rs.next()) {
				int ticketID = rs.getInt("mbt.id");

				if (ticketID != previousID) {
					ticketList.add(new TicketVO(rs));

				} else {
					ticketList
							.get(0)
							.getCustomFields()
							.put(rs.getString("customNames"),
									rs.getString("cfs.value"));
				}
				previousID = ticketID;

			}

			request.setAttribute("ticketList", ticketList);

		} catch (SQLException | ParseException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}

		request.getRequestDispatcher(mantisJsp).forward(request,
				response);

	}

}
