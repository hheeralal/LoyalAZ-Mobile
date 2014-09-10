package com.outstandingresults.Helpers;

import android.content.Context;

import com.outstandingresults.DataObjects.Advertisement;
import com.outstandingresults.DataObjects.LoyalAZ;
import com.outstandingresults.DataObjects.MoreCoupons;
import com.outstandingresults.DataObjects.MorePrograms;

public class ApplicationLoyalAZ 
{
	   private static ApplicationLoyalAZ instance = null;
	   public static LoyalAZ loyalaz;
	   public static Context appContext;
	   public static MorePrograms morePrograms;
	   public static MoreCoupons moreCoupons;
	   public static String WebServiceURL;
	   public static boolean baseURLSet;
	   public static String fbMessage;
	   public static boolean showTutorial;
	   public static boolean cachePrograms;
	   public static boolean cacheCoupons;
	   public static Advertisement advertObject;
	   protected ApplicationLoyalAZ() 
	   {
	      // Exists only to defeat instantiation.
	   }
	   
	   public static ApplicationLoyalAZ getInstance() 
	   {
	      if(instance == null) 
	      {
	    	  showTutorial = false;
	    	  cachePrograms = false;
	    	  cacheCoupons = false;
//	    	  advertObject = new Advertisement();
	         instance = new ApplicationLoyalAZ();
	      }
	      return instance;
	   }
	   
}