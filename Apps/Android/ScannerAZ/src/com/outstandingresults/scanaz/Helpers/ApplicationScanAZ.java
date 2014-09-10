package com.outstandingresults.scanaz.Helpers;

import android.content.Context;

import com.outstandingresults.scanaz.DataObjects.ScanAZ;

public class ApplicationScanAZ 
{
	   private static ApplicationScanAZ instance = null;
	   public static ScanAZ scanaz;
	   public static Context appContext;
	   public static String WebServiceURL;
	   public static boolean baseURLSet;
	   protected ApplicationScanAZ() 
	   {
	      // Exists only to defeat instantiation.
	   }
	   
	   public static ApplicationScanAZ getInstance() 
	   {
	      if(instance == null) 
	      {
	         instance = new ApplicationScanAZ();
	      }
	      return instance;
	   }
	   
}