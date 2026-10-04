package com.bakery.util;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

/**
 * Embedded Tomcat server launcher for Bakery Platform.
 * Runs on port 8085 (or $PORT).
 */
public class Main {
    public static void main(String[] args) throws Exception {
        int port = 8085;
        String portProp = System.getProperty("server.port");
        if (portProp == null) {
            portProp = System.getenv("PORT");
        }
        if (portProp != null && !portProp.trim().isEmpty()) {
            try {
                port = Integer.parseInt(portProp.trim());
            } catch (NumberFormatException ignored) {}
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.setBaseDir("target/tomcat");

        // Initialize connector
        tomcat.getConnector();

        String webappDir = new File("src/main/webapp").getAbsolutePath();
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDir);
        ctx.setParentClassLoader(Main.class.getClassLoader());

        // Mount compiled classes to WEB-INF/classes
        File classesDir = new File("target/classes");
        if (classesDir.exists()) {
            WebResourceRoot resources = new StandardRoot(ctx);
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    classesDir.getAbsolutePath(), "/"));
            ctx.setResources(resources);
        }

        System.out.println("===============================================================");
        System.out.println("  🍰 Bakery Order & Custom Cake Booking Platform Started!  ");
        System.out.println("  Access URL: http://localhost:" + port + "/");
        System.out.println("  Admin Portal: http://localhost:" + port + "/staff/login");
        System.out.println("===============================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}

