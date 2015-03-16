package com.smt.mantis.procedure.project;

import java.util.ArrayList;
import java.util.HashMap;

import javax.sql.DataSource;

import com.smt.mantis.procedure.ProcedureBase;

/****************************************************************************
 * Title: ProjectProcedure.java <p/>
 * Project: MantisReport <p/>
 * Copyright: Copyright (c) 2015<p/>
 * Company: Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 1.0
 * @since Mar 9, 2015
 ****************************************************************************/

public class ProjectProcedure extends ProcedureBase {

	/**
	 * @param ds
	 */
	public ProjectProcedure(DataSource ds) {
		super(ds);
		// TODO Auto-generated constructor stub
	}

	/* (non-Javadoc)
	 * @see com.smt.mantis.procedure.ProcedureBase#selectQuery(java.util.HashMap)
	 */
	@Override
	public ArrayList<?> selectQuery(HashMap<String, String[]> requestMap) {
		// TODO Auto-generated method stub
		return null;
	}

}
