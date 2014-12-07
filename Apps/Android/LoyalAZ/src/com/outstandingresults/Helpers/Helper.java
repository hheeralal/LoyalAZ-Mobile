package com.outstandingresults.Helpers;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import android.content.Context;
import android.content.res.AssetManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;

import com.outstandingresults.DataObjects.Countries;
import com.outstandingresults.DataObjects.Country;
import com.outstandingresults.DataObjects.Coupon;
import com.outstandingresults.DataObjects.LoyalAZ;
import com.outstandingresults.DataObjects.MCoupon;
import com.outstandingresults.DataObjects.MProgram;
import com.outstandingresults.DataObjects.MoreCoupons;
import com.outstandingresults.DataObjects.MorePrograms;
import com.outstandingresults.DataObjects.Program;
import com.outstandingresults.DataObjects.User;
import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;
import com.thoughtworks.xstream.io.xml.XmlFriendlyNameCoder;



public class Helper {
	
	public static LoyalAZ GetApplicationObjectFromDB()
	{
		LoyalAZ loyalaz = null;
	
		File file = ApplicationLoyalAZ.appContext.getFileStreamPath("XMLDB.xml");
		if(file.exists())
		{
	    	XStream xt =null;
	    	xt = ConfigureObjectAttributes();
	    	loyalaz = (LoyalAZ)xt.fromXML(file);
		}
		return loyalaz;
	}
	
	public static boolean IsNetworkAvailable()
	{
		try
		{
		    ConnectivityManager connectivityManager = (ConnectivityManager) ApplicationLoyalAZ.appContext.getSystemService(Context.CONNECTIVITY_SERVICE);
		    NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
		    System.out.println("IsNetworkAvailable completed.");
		    return activeNetworkInfo != null;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return false;
	    
	}
	
	public static Countries GetCountriesFromXML()
	{
		AssetManager am = ApplicationLoyalAZ.appContext.getAssets();
		Countries countries = null;
		try {
			InputStream is = am.open("countries.xml");
			XStream xt = new XStream(new DomDriver("UTF-8", new XmlFriendlyNameCoder("_-", "_")));
			xt.alias("Countries", Countries.class);
			xt.alias("Country", Country.class);
			xt.useAttributeFor(Country.class, "name");
			xt.useAttributeFor(Country.class, "code");
			countries = (Countries)xt.fromXML(is);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return countries;
	}

	public static void SaveApplicationObjectToDB(LoyalAZ loyalaz) throws IOException
	{
		XStream xt = null;
		xt = ConfigureObjectAttributes();
		String xml = xt.toXML(loyalaz);
		
		File file = ApplicationLoyalAZ.appContext.getFileStreamPath("XMLDB.xml");
		FileWriter fw = new FileWriter(file);
	    fw.write(xml);
	    fw.close();
	}
	
	public static XStream ConfigureObjectAttributes()
	{
		XStream xt = new XStream(new DomDriver("UTF-8", new XmlFriendlyNameCoder("_-", "_")));
		xt.alias("LoyalAZ", LoyalAZ.class);
		xt.alias("Program", Program.class);
		xt.alias("Coupon", Coupon.class);
		xt.alias("User", User.class);
		LoyalAZ loyalaz = new LoyalAZ();
		Program prg = new Program();
		User user = new User();
		Coupon cpn = new Coupon();
		
		getObject(loyalaz, xt);
		getObject(prg, xt);
		getObject(cpn, xt);
		getObject(user, xt);
		
		return xt;
	}
	
	public static XStream ConfigureEntireObjectSchema()
	{
		XStream xt = new XStream(new DomDriver("UTF-8", new XmlFriendlyNameCoder("_-", "_")));
		xt.alias("LoyalAZ", LoyalAZ.class);
		xt.alias("Program", Program.class);
		xt.alias("User", User.class);
		xt.alias("MorePrograms", MorePrograms.class);
		xt.alias("MProgram", MProgram.class);
		xt.alias("MoreCoupons", MoreCoupons.class);
		xt.alias("MCoupon", MCoupon.class);
		xt.alias("Coupon", Coupon.class);
		
		
		xt.omitField(LoyalAZ.class, "MorePrograms");
		xt.omitField(LoyalAZ.class, "MoreCoupons");
		xt.omitField(LoyalAZ.class, "methods");

		LoyalAZ loyalaz = new LoyalAZ();
		Program prg = new Program();
		User user = new User();
		Coupon cpn = new Coupon();
		
    	ApplicationLoyalAZ.morePrograms = new MorePrograms();
    	MProgram mpg = new MProgram();
    	
    	ApplicationLoyalAZ.moreCoupons = new MoreCoupons();
    	MCoupon mcpn = new MCoupon();
		
		getObject(ApplicationLoyalAZ.morePrograms, xt);
		getObject(ApplicationLoyalAZ.moreCoupons, xt);
		getObject(mpg, xt);
		getObject(mcpn, xt);
		getObject(loyalaz, xt);
		getObject(prg, xt);
		getObject(cpn,xt);
		getObject(user, xt);
		
		return xt;
	}
	
	public static XStream ConfigureObjectAttributesMorePrograms()
	{
		XStream xt = new XStream(new DomDriver("UTF-8", new XmlFriendlyNameCoder("_-", "_")));
		xt.alias("MorePrograms", MorePrograms.class);
		xt.alias("MProgram", MProgram.class);
    	ApplicationLoyalAZ.morePrograms = new MorePrograms();
    	MProgram mpg = new MProgram();
		
		getObject(ApplicationLoyalAZ.morePrograms, xt);
		getObject(mpg, xt);
		
		XStream xt1 = new XStream(new DomDriver());
		String s = xt1.toXML(mpg);
		// TODO Auto-generated method stub
		//Log.d("XML", s);		
		
		return xt;
	}
	
	
	public static XStream ConfigureObjectAttributesMoreCoupons()
	{
		XStream xt = new XStream(new DomDriver("UTF-8", new XmlFriendlyNameCoder("_-", "_")));
		xt.alias("MoreCoupons", MoreCoupons.class);
		xt.alias("MCoupon", MCoupon.class);
    	ApplicationLoyalAZ.moreCoupons = new MoreCoupons();
    	MCoupon mcpn = new MCoupon();
		
		getObject(ApplicationLoyalAZ.moreCoupons, xt);
		getObject(mcpn, xt);
		
		XStream xt1 = new XStream(new DomDriver());
		String s = xt1.toXML(mcpn);
		// TODO Auto-generated method stub
		//Log.d("XML", s);		
		
		return xt;
	}
	
	
	
	private static int getObject(Object obj,XStream xt) {
	    for (Field field : obj.getClass().getDeclaredFields()) {
	        //System.out.println(field.getName());
	        //xt.useAttributeFor(LoyalAZ.class, "sync");
	        xt.useAttributeFor(obj.getClass(), field.getName());
	    }
	    return 0;
	}
	
	public static String GetApplicationObjectXMLString(LoyalAZ loyalaz)
	{
		XStream xt = null;
		xt = ConfigureObjectAttributes();
		String xml = xt.toXML(loyalaz);
		return xml;
	}
	
	public static String GetElementValue(String xmlSource,String tagName)
	{
		String returnValue = "";
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = null;
		Document doc = null;
		NodeList elem;

		InputStream is = new ByteArrayInputStream(xmlSource.getBytes());
			try {
				db = dbf.newDocumentBuilder();
			} catch (ParserConfigurationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				doc = (Document) db.parse(is);
			} catch (SAXException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			elem = doc.getElementsByTagName(tagName);
			if(elem.getLength()>0)
			{
				returnValue = elem.item(0).getFirstChild().getNodeValue();
			}
		return returnValue;
	}

}
