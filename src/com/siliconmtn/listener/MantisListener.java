package com.siliconmtn.listener;


import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.sql.DataSource;

//log4j 1.2.15
import org.apache.log4j.PropertyConfigurator;


/**
 * Application Lifecycle Listener implementation class MantisListener
 *
 */
@WebListener
public class MantisListener implements ServletContextListener {

protected DataSource dataSource;
private String logContextName = "log4jConfig";

    /**
     * Default constructor. 
     */
    public MantisListener() {
        
    }

	/**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent sce) {
    	//Set up logging for entire web app
    	ServletContext sc = sce.getServletContext();
    	String log4jConfig = sc.getInitParameter(logContextName);
    	String actualPath = sc.getRealPath(log4jConfig);
    	
    	PropertyConfigurator.configure(actualPath);
    	
    }

	/**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent arg0) {
    	
    }
}
