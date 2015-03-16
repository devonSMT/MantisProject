package com.smt.mantis.procedure.user;

import java.util.ArrayList;
import java.util.HashMap;

import javax.sql.DataSource;

import com.smt.mantis.procedure.ProcedureBase;

/****************************************************************************
 * Title: UserProcedure.java <p/>
 * Project: MantisReport <p/>
 * Copyright: Copyright (c) 2015<p/>
 * Company: Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 1.0
 * @since Mar 15, 2015
 ****************************************************************************/

public class UserProcedure extends ProcedureBase {

	/**
	 * @param ds
	 */
	public UserProcedure(DataSource ds) {
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
