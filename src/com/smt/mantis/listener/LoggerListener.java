package com.smt.mantis.listener;
//jdk 1.7
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

//log4j 1.2.15
import org.apache.log4j.PropertyConfigurator;
//m.r 2.0
import com.smt.mantis.config.GlobalConfig;

/****************************************************************************
 * Initializes the Log4J via the properties file<p/>
 * There must be a context param entry in the web.xml
 * That matches the GlobalConstants.KEY_LOG4J_FILE_PATH constant<p/>
 *  * Copyright: Copyright (c) 2015<p/>
 * Company: SiliconMountain Technologies<p/>
 * @author Devon Franklin
 * @version 2.0
 * @since March 5, 2015
****************************************************************************/
@WebListener
public class LoggerListener implements ServletContextListener {

    /**
     * Default constructor. 
     */
    public LoggerListener() {
        
    }

	/**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent sce) {
    	//Set up logging for entire web app
    	ServletContext sc = sce.getServletContext();
    	String log4jConfig = sc.getInitParameter(GlobalConfig.KEY_LOG4J_PATH);
    	String actualPath = sc.getRealPath(log4jConfig);
    	
    	//configure logger
    	PropertyConfigurator.configure(actualPath);
    }

	/**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent arg0) {
    	
    }
}
