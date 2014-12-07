package com.outstandingresults.Helpers;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;

import com.outstandingresults.DataObjects.Advertisement;
import com.outstandingresults.DataObjects.Coupon;
import com.outstandingresults.DataObjects.LoyalAZ;
import com.outstandingresults.DataObjects.MoreCoupons;
import com.outstandingresults.DataObjects.MorePrograms;
import com.outstandingresults.DataObjects.Program;
import com.outstandingresults.DataObjects.ReferBusiness;
import com.outstandingresults.DataObjects.User;
import com.outstandingresults.Managers.CommunicationManager;

import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.util.Log;

import com.thoughtworks.xstream.XStream;


public class BusinessLayer {

	
	private boolean isSyncTask;
	private boolean isRecoveryTask;
	
	public String RegisterUserStep1()
	{
		CommunicationManager comMgr = new CommunicationManager();
		XStream xt = Helper.ConfigureObjectAttributes();
		String xml = xt.toXML(ApplicationLoyalAZ.loyalaz);
		xml = xml.replace("\n", "");
		System.out.println(xml);
		byte[] bytes = xml.getBytes();
		String base64XML = Base64.encodeToString(bytes, Base64.DEFAULT);
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        soap_params.put("xml_base64", base64XML);
        String s= comMgr.SendSOAPRequest("register_user", soap_params);
//        s = Helper.GetElementValue(s, "return");
//        Helper.GetElementValue(responseXML, "return");
        
		return s;
	}
	
	public void GetAdData()
	{
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        
        soap_params.put("uid", ApplicationLoyalAZ.loyalaz.User.uid);
        soap_params.put("device", "Android");
        try
        {
        	String s= comMgr.SendSOAPRequest("get_ads", soap_params);
        	System.out.println("ADS==="+s);
        	if(s.equals("0")==false)
        	{
            	s = s.replace("anyType{", "");
            	s = s.replace("}","");
            	
            	String[] elements = s.split(";");
            	ApplicationLoyalAZ.advertObject.imageURL= elements[0].replace("image=","");
            	ApplicationLoyalAZ.advertObject.linkURL= elements[1].replace(" link=","").trim();
            	ApplicationLoyalAZ.advertObject.duration= Integer.parseInt(elements[2].replace(" duration=", "").trim());

        	}
        	 
        	
        }
        catch(Exception ex)
        {
        	System.out.println(ex.getMessage());
        }

	}
	
	public void SyncDB()
	{
        try {
    		isSyncTask = true;
    		CommunicationManager comMgr = new CommunicationManager();
    		XStream xt = Helper.ConfigureObjectAttributes();
    		
    		if(ApplicationLoyalAZ.loyalaz.programs==null)
    			ApplicationLoyalAZ.loyalaz.programs = new ArrayList<Program>();
    		
    		if(ApplicationLoyalAZ.loyalaz.coupons==null)
    			ApplicationLoyalAZ.loyalaz.coupons = new ArrayList<Coupon>();		
    		
    		String xml = xt.toXML(ApplicationLoyalAZ.loyalaz);
    		xml = xml.replace("\n", "");
//    		System.out.println("SYNC_XML_SENT="+xml);
    		byte[] bytes = xml.getBytes();
    		String base64XML = Base64.encodeToString(bytes, Base64.DEFAULT);
            LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
            soap_params.put("xml_base64", base64XML);
            String s= comMgr.SendSOAPRequest("sync_xmldb", soap_params,true);
            System.out.println("SYNC_RECD="+s);
            ApplicationLoyalAZ.loyalaz = (LoyalAZ) xt.fromXML(s);
			Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			Log.d("Exception","SyncDB exception");
			e.printStackTrace();
		}
        
        DownloadImagesData();
        //Update program images
	}
	
	public String DeleteAccount()
	{
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        
        soap_params.put("uid", ApplicationLoyalAZ.loyalaz.User.uid);
        try
        {
        	String s= comMgr.SendSOAPRequest("deactivate_user", soap_params);
        	Log.d("DEL_RETURN", s);
        	return s;
        }
        catch(Exception ex)
        {
        	System.out.println(ex.getMessage());
        }
		return "";
	}
	
	public boolean ValidateScanFrequency(Program prg)
	{
		boolean valid = false;
		
		int i = 0;
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if(prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
			{
				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				break;
			}
		}		
		
	    Calendar c = Calendar.getInstance();
	    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss a");
	    String currentDate = df.format(c.getTime());
	    Date d = null;
	    Date d1 = null;
		try {
			d = df.parse(prg.s_dt);
			//d1 = df.parse("2013-06-27 10:59:11 PM");
			d1 = df.parse(currentDate);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    long d2 = d1.getTime() - d.getTime();
	    d2 = d2/1000;
		if(d2>Long.parseLong(prg.rt))
		{
			valid = true;
		}
		
		return valid;
	}
	
	public String SaveReferBusiness(ReferBusiness refBusiness)
	{
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        
        soap_params.put("rec_cname", refBusiness.rec_cname);
        soap_params.put("rec_phone", refBusiness.rec_phone);
        soap_params.put("rec_email", refBusiness.rec_email);
        soap_params.put("rec_mgrfname", refBusiness.rec_mgrfname);
        soap_params.put("rec_mgrlname", refBusiness.rec_mgrlname);
        soap_params.put("rec_whyinvited", refBusiness.rec_whyinvited);
        soap_params.put("rec_address", refBusiness.rec_address);
        //soap_params.put("com_id", refBusiness.com_id); // parameter removed on 05/June/13
        soap_params.put("lat", refBusiness.lat);
        soap_params.put("lng", refBusiness.lng);
        
        
        try
        {
        	String s= comMgr.SendSOAPRequest("recommend_company", soap_params);
        	Log.d("REF_RETURN", s);
        }
        catch(Exception ex)
        {
        	System.out.println(ex.getMessage());
        }
		return "";
	}
	
	public void FindPrograms(String lat, String lng)
	{
		CommunicationManager comMgr = new CommunicationManager();
		XStream xt = Helper.ConfigureObjectAttributesMorePrograms();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        //soap_params.put("lat", lat);
        //soap_params.put("lng", lng);
        
        soap_params.put("uid", ApplicationLoyalAZ.loyalaz.User.uid);
        soap_params.put("lat", lat);
        soap_params.put("lng", lng);
        System.out.println(soap_params);
        
        String xmlResponse= comMgr.SendSOAPRequest("find_moreprogs", soap_params,true);
        System.out.println(xmlResponse);
        
        ApplicationLoyalAZ.morePrograms = (MorePrograms) xt.fromXML(xmlResponse);
        //return ApplicationLoyalAZ.morePrograms;
        //System.out.println("Total items:"+ApplicationLoyalAZ.morePrograms.MPrograms.size());
	}
	
	public void FindCoupons(String lat, String lng)
	{
		CommunicationManager comMgr = new CommunicationManager();
		XStream xt = Helper.ConfigureObjectAttributesMoreCoupons();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        
        soap_params.put("uid", ApplicationLoyalAZ.loyalaz.User.uid);
        soap_params.put("lat", lat);
        soap_params.put("lng", lng);
        System.out.println(soap_params);
        
        String xmlResponse= comMgr.SendSOAPRequest("find_morecoupons", soap_params,true);
        System.out.println(xmlResponse);
        
        ApplicationLoyalAZ.moreCoupons = (MoreCoupons) xt.fromXML(xmlResponse);
        //return ApplicationLoyalAZ.morePrograms;
        //System.out.println("Total items:"+ApplicationLoyalAZ.morePrograms.MPrograms.size());
	}
	
	public void RemoveUserCoupon(String uid, String couponId)
	{
		CommunicationManager comMgr = new CommunicationManager();
		XStream xt = Helper.ConfigureObjectAttributesMoreCoupons();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        
        soap_params.put("uid", uid);
        soap_params.put("id", couponId);
        System.out.println(soap_params);
        
        String xmlResponse= comMgr.SendSOAPRequest("remove_usercoupon", soap_params);
        System.out.println(xmlResponse);
        
        //ApplicationLoyalAZ.moreCoupons = (MoreCoupons) xt.fromXML(xmlResponse);
        //return ApplicationLoyalAZ.morePrograms;
        //System.out.println("Total items:"+ApplicationLoyalAZ.morePrograms.MPrograms.size());
	}	
	
	
	public String RemoveUserProgram(String uid, String programId)
	{
		CommunicationManager comMgr = new CommunicationManager();
		XStream xt = Helper.ConfigureObjectAttributesMoreCoupons();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        
        soap_params.put("uid", uid);
        soap_params.put("id", programId);
//        System.out.println(soap_params);
        
        String xmlResponse= comMgr.SendSOAPRequest("remove_userprogram", soap_params);
//        System.out.println(xmlResponse);
        
        return xmlResponse;
        
        //ApplicationLoyalAZ.moreCoupons = (MoreCoupons) xt.fromXML(xmlResponse);
        //return ApplicationLoyalAZ.morePrograms;
        //System.out.println("Total items:"+ApplicationLoyalAZ.morePrograms.MPrograms.size());
	}	
	
	public void RemoveUserProgramInOffline(String pid)
	{
		int i = 0;
		Program prg;
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if(pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
			{
				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				prg.active = "0";
				ApplicationLoyalAZ.loyalaz.programs.set(i,prg);
			}
		}
		
		try {
			Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

	}
	
	
	public boolean IsCouponExists(Coupon cpn)
	{
		if(ApplicationLoyalAZ.loyalaz.coupons==null)
			return false;
		
		if(ApplicationLoyalAZ.loyalaz.coupons.contains(cpn))
			return true;
		else
			return false;
	}	
	
	public String ValidateEmail(String emailId)
	{
		String retValue = "";
		//boolean exists = true;
		String base64Email = "";
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        byte[] bytes = emailId.getBytes();
        byte[] base64Bytes = Base64.encode(bytes, Base64.DEFAULT);
        try {
			base64Email = new String(base64Bytes,"UTF8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        soap_params.put("email", base64Email);
        String xmlResponse= comMgr.SendSOAPRequest("validate_email", soap_params);
        System.out.println(xmlResponse);
        
//        String strExists = Helper.GetElementValue(xmlResponse, "exists");
//        String strActive = Helper.GetElementValue(xmlResponse, "active");
//        retValue = strExists + "_" + strActive;
        
        String[] strArray =  xmlResponse.split(";"); //split entire response code on;
        //String strTemp = strArray[0];
        String strExists = strArray[0].replace("anyType{exists=", "");
        System.out.println("exists="+strExists);
        String strActive = strArray[1].replace(" active=","");
        System.out.println("ADD CPN RESPONSE="+strActive);
        
        retValue = strExists + "_" + strActive;
        retValue = retValue.replace(" ","");
        
//        if(xmlResponse.equals("false"))
//        	exists=false;
//        else
//        	exists=true;
        
        //exists = false;
        
		return retValue;
	}
	
	public boolean SendSecurityTokenEmail(String emailId)
	{
		boolean sent = true;
		String base64Email = "";
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        byte[] bytes = emailId.getBytes();
        byte[] base64Bytes = Base64.encode(bytes, Base64.DEFAULT);
        try {
			base64Email = new String(base64Bytes,"UTF8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        soap_params.put("email", base64Email);
        String xmlResponse= comMgr.SendSOAPRequest("send_email", soap_params);
        if(xmlResponse.equals("false"))
        	sent=false;
        else
        	sent=true;
        
		return sent;
	}	
	
	public boolean ValidateSecurityToken(String securityToken)
	{
		boolean validST = false;
		String base64ST = "";
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        byte[] bytes = securityToken.getBytes();
        byte[] base64Bytes = Base64.encode(bytes, Base64.DEFAULT);
        try {
			base64ST = new String(base64Bytes,"UTF8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        soap_params.put("token", base64ST);
        String xmlResponse= comMgr.SendSOAPRequest("xmldb_recovery", soap_params);
        //System.out.println(xmlResponse);
        if(xmlResponse.equals("0") || xmlResponse.equals("false")) // Invalid ST entered.
        	validST=false;
        else
        {
        	// ST is valid and call has returned Base64 encoded previous data.
        	validST=true;
        	
        	byte[] bytesArray = Base64.decode(xmlResponse, Base64.DEFAULT);
        	try {
				xmlResponse = new String(bytesArray,"UTF-8");
				System.out.println(xmlResponse);
			} catch (UnsupportedEncodingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
        	
        	
        	XStream xt = Helper.ConfigureEntireObjectSchema();
        	
			ApplicationLoyalAZ.loyalaz =(LoyalAZ) xt.fromXML(xmlResponse); // Convert XML back to LoyalAZ object.
			try {
				isRecoveryTask = true;
				DownloadImagesData();
				Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz); //Save the Application object.
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        	
        }
        
		return validST;
	}
	
	public String GetBaseURL()
	{
		try
		{
			CommunicationManager comMgr = new CommunicationManager();
	        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
	        String baseURL= comMgr.SendSOAPRequest("get_baseurl", soap_params,true);
	        ApplicationLoyalAZ.baseURLSet=true;
	        return baseURL;
		}
		catch(Exception e)
		{
			return "";
		}

	}
	
	public String GetCouponNumber(Program prg)
	{
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        soap_params.put("id", prg.id);
        soap_params.put("uid", ApplicationLoyalAZ.loyalaz.User.uid);
        //soap_params.put("uid", "169");
        soap_params.put("pt_balance", prg.pt_balance);
        soap_params.put("pt_target", prg.pt_target);
        soap_params.put("com_id", prg.com_id);
        System.out.println("COUPON_PARAMS="+soap_params);
        String couponNumber= comMgr.SendSOAPRequest("process_coupon", soap_params);
        System.out.println("COUPON_NUMBER="+couponNumber);
        return couponNumber;
	}
	
	public String ProcessRedeem(Program prg)
	{
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        soap_params.put("id", prg.id);
        soap_params.put("uid", ApplicationLoyalAZ.loyalaz.User.uid);
        soap_params.put("pt_balance", prg.pt_balance);
        soap_params.put("coupon", prg.coupon_no);
        //soap_params.put("com_id", prg.com_id);
        String redemptionResponse= comMgr.SendSOAPRequest("process_redemption", soap_params);
        System.out.println("REDEMP_RESPONSE==="+redemptionResponse);
        return redemptionResponse;
	}
	
	public boolean IsRedeemPending()
	{
		boolean redeem_pending = false;
		
		if(ApplicationLoyalAZ.loyalaz.programs != null)
		{
			for(int i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
			{
				if(ApplicationLoyalAZ.loyalaz.programs.get(i).act.equals("1"))
				{
					redeem_pending = true;
					break;
				}
			}
		}
		return redeem_pending;
	}
	
	public void UpdateProgramRedeemed(Program prg)
	{
		for(int i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if(ApplicationLoyalAZ.loyalaz.programs.get(i).equals(prg))
			{
				ApplicationLoyalAZ.loyalaz.programs.get(i).act="";
				if(prg.type.equals("1")==true || prg.type.equals("2")==true)
				{
					ApplicationLoyalAZ.loyalaz.programs.get(i).pt_balance="0";
					ApplicationLoyalAZ.loyalaz.programs.get(i).pt_loc_balance="0";
				}
				else if(prg.type.equals("4")==true)
				{
					if(prg.pt_balance.equals(prg.pt_target)==true)
					{
						ApplicationLoyalAZ.loyalaz.programs.get(i).pt_balance="0";
						ApplicationLoyalAZ.loyalaz.programs.get(i).pt_loc_balance="0";
					}
				}
				ApplicationLoyalAZ.loyalaz.programs.get(i).coupon_no="";
				try {
					Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				break;
			}
		}
	}
	
	public void UpdateProgramActState(Program prg)
	{
		for(int i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if(ApplicationLoyalAZ.loyalaz.programs.get(i).equals(prg))
			{
				ApplicationLoyalAZ.loyalaz.programs.get(i).act="1";
				try {
					Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				break;
			}
		}
	}	
	
	public boolean IsProgramPendingToRedeem(Program prg)
	{
		boolean pending = false;
		for(int i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if(ApplicationLoyalAZ.loyalaz.programs.get(i).act.equals("1"))
			{
				pending = true;
				break;
			}
		}
		return pending;
	}
	
	
	public boolean IsProgramExists(Program prg)
	{
		if(ApplicationLoyalAZ.loyalaz.programs==null)
			return false;
		
		if(ApplicationLoyalAZ.loyalaz.programs.contains(prg))
			return true;
		else
			return false;
	}
	
	public boolean IsProgramWithLocationExists(Program prg)
	{
		if(ApplicationLoyalAZ.loyalaz.programs==null)
			return false;
		
		int i=0;
		boolean exists = false;
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if((prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid)) && (prg.com_id.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).com_id)))
			{
				exists = true;
				break;
			}
		}
		
		return exists;
		
//		if(ApplicationLoyalAZ.loyalaz.programs.contains(prg))
//			return true;
//		else
//			return false;
	}	
	
	
	public void AddProgram(Program prg, Boolean fromFind)
	{
		if(ApplicationLoyalAZ.loyalaz.programs==null)
			ApplicationLoyalAZ.loyalaz.programs = new ArrayList<Program>();
		
		if(Helper.IsNetworkAvailable())
		{
			prg = DownloadProgramImages(prg);
		}
		else
		{
			prg.d = "1";
		}
		

		
		int i=0;
		int loc_balance =0;
		int balance = 0;
		int target = 0;
//		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
//		{
//			if((prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid)) && (prg.com_id.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).com_id)))
//			{
//				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
//				
//				if(prg.pt_loc_balance.equals(""))
//					prg.pt_loc_balance = prg.pt_balance;
//				
//				loc_balance = Integer.parseInt(prg.pt_loc_balance);
//				loc_balance++;
//				prg.pt_loc_balance = Integer.toString(loc_balance);
//				ApplicationLoyalAZ.loyalaz.programs.set(i, prg);
//				break;
//			}
//		}
		if(prg.type.equals("1")==true || prg.type.equals("2")==true || prg.type.equals("4")==true) // if the program is per item program type
		{
			ApplicationLoyalAZ.loyalaz.programs.add(prg);
			
			for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
			{
				if(prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
				{
					prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
					if(prg.pt_loc_balance!="")
						balance += Integer.parseInt(prg.pt_loc_balance);
				}
			} 
			
			for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
			{
				if(prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
				{
					prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
					prg.pt_balance=Integer.toString(balance);
					ApplicationLoyalAZ.loyalaz.programs.set(i, prg);
					//balance += Integer.parseInt(prg.pt_balance);
				}
			}
			
			
			try {
				Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
				
				if(prg.type.equals("4")==true)
				{
					this.SyncDB();
				}

			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			

		}
		else // if the program is savings type
		{
			if(fromFind)
			{
				prg.pt_balance = "0";
				prg.pt_loc_balance = "0";
			}
			else
			{
				prg.pt_balance = prg.pt_target;
				prg.pt_loc_balance = prg.pt_target;
			}

			
			int current_balance = 0;
			int total_target = 0;
			
			ApplicationLoyalAZ.loyalaz.programs.add(prg);
			
			for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
			{
				if(prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
				{
					prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
					
					current_balance = current_balance + Integer.parseInt(prg.pt_loc_balance);
					total_target += Integer.parseInt(prg.pt_target);
				}
			}
			
			int temp_balance =Math.abs(total_target - current_balance);
			
			
			for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
			{
				if(prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
				{
					prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
					
					current_balance = Integer.parseInt(prg.pt_target)-temp_balance;
					
					prg.pt_balance=Integer.toString(current_balance);
					ApplicationLoyalAZ.loyalaz.programs.set(i, prg);
				}
			}
			
			
			try {
				Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		

	}
	
	public String GetProgramBalance(Program prg)
	{
		int balance = 0;
		int i = 0;
		
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if(prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
			{
				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				balance += Integer.parseInt(prg.pt_loc_balance);
			}
		}
		return Integer.toString(balance);

	}
	
	public String AddCoupon(Coupon cpn)
	{
		if(ApplicationLoyalAZ.loyalaz.coupons==null)
			ApplicationLoyalAZ.loyalaz.coupons = new ArrayList<Coupon>();
		
		if(Helper.IsNetworkAvailable())
		{
			
			CommunicationManager comMgr = new CommunicationManager();
	        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
	        soap_params.put("uid", ApplicationLoyalAZ.loyalaz.User.uid);
	        soap_params.put("id", cpn.id);
	        soap_params.put("guid", cpn.guid);
	        soap_params.put("coupontype", cpn.typename);
	        soap_params.put("com_id", cpn.com_id);
	        String response= comMgr.SendSOAPRequest("add_usercoupon", soap_params);
	        System.out.println("RESPONSE==="+response);
	        
	        
	        String[] strArray =  response.split(";"); //split entire response code on;
	        String strTemp = strArray[0];
	        String strQRURL = strArray[1].replace("pic_qrcode=", "");
	        System.out.println("QRURL="+strQRURL);
	        strArray = strTemp.split("\\{"); //split the first value on "{";
	        strTemp = strArray[1];
	        strArray = strTemp.split("="); //split the first value on "status=2";
	        strTemp = strArray[1];
	        System.out.println("ADD CPN RESPONSE="+strTemp);
	        
			if(strTemp.equals("1"))
			{
				cpn.pic_qrcode = strQRURL;
				cpn = DownloadCouponImages(cpn);
				ApplicationLoyalAZ.loyalaz.coupons.add(cpn);
				
				try {
					Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
					return "1";
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else
				return "0";
		}
		return "0";
	}

	public boolean IsProgramRechargeLevelReached(Program prg)
	{
		boolean rechargeRequired = false;
		int i = 0;
		int balance = 0;
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if((prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid)) && (prg.com_id.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).com_id)))
			{
				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				
				balance = Integer.parseInt(prg.pt_balance);
				if(balance==0)
				{
					rechargeRequired = true;
					break;
				}
				
			}
		}
		return rechargeRequired;
		
	}
	
	public Program DecrementProgramBalance(Program prg)
	{
		int balance =0,target =0;
		int loc_balance = 0;
		int i = 0;
		String spt = prg.spt;
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if((prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid)) && (prg.com_id.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).com_id)))
			{
				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				
				balance = Integer.parseInt(prg.pt_balance);
				if(balance>0)
				{
					loc_balance = Integer.parseInt(prg.pt_loc_balance); // get current loc balance
//					loc_balance--; 										// decrease the current loc balance by 1;
					loc_balance = loc_balance - Integer.parseInt(spt); 	// decrease the current loc balance by 1;
					prg.pt_loc_balance = Integer.toString(loc_balance); // update the program current loc balance
					ApplicationLoyalAZ.loyalaz.programs.set(i, prg);	// set the updated program back in collection
				}
				break;
			}
		}
		int current_balance = 0;
		int total_target = 0;
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if(prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
			{
				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				
				current_balance = current_balance + Integer.parseInt(prg.pt_loc_balance);
				total_target += Integer.parseInt(prg.pt_target);
			}
		}
		
		int temp_balance =Math.abs(total_target - current_balance);
		
		
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if(prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
			{
				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				current_balance = Integer.parseInt(prg.pt_target)-temp_balance;
				
				prg.pt_balance=Integer.toString(current_balance);
				ApplicationLoyalAZ.loyalaz.programs.set(i, prg);
			}
		}
		
		
		try {
			Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return prg;
	}
	
	public Program IncrementProgramBalance(Program prg)
	{
		int balance =0,target =0;
		int loc_balance = 0;
		int i = 0;
		String spt = prg.spt;
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if((prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid)) && (prg.com_id.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).com_id)))
			{
				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				
				if(prg.pt_loc_balance.equals(""))
					prg.pt_loc_balance = prg.pt_balance;
				
				loc_balance = Integer.parseInt(prg.pt_loc_balance);
//				loc_balance++;
				loc_balance = loc_balance + Integer.parseInt(spt);
				prg.pt_loc_balance = Integer.toString(loc_balance);
				ApplicationLoyalAZ.loyalaz.programs.set(i, prg);
				break;
			}
		}
		
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if(prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
			{
				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				balance += Integer.parseInt(prg.pt_loc_balance);
			}
		}
		
		
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if(prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid))
			{
				prg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				prg.pt_balance=Integer.toString(balance);
				ApplicationLoyalAZ.loyalaz.programs.set(i, prg);
				//balance += Integer.parseInt(prg.pt_balance);
			}
		}
		
//		balance = Integer.parseInt(prg.pt_balance);
//		target = Integer.parseInt(prg.pt_target);
		
		
		
//		if(balance<target)
//			balance++;
		
//		
		
		
		try {
			Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return prg;
	}
	
	private void DownloadImagesData()
	{
		for(int i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			Program tProgram = ApplicationLoyalAZ.loyalaz.programs.get(i);
			if(isRecoveryTask==true || tProgram.u.equals("1")  || tProgram.d.equals("1"))
			{
				tProgram = DownloadProgramImages(tProgram);
				if(tProgram.d.equals("1"))
				{
					tProgram.d = "";
				}
				
				if(tProgram.u.equals("1"))
				{
					tProgram.u = "";
				}
				
				ApplicationLoyalAZ.loyalaz.programs.set(i, tProgram);
			}
		}
		
		for(int i=0;i<ApplicationLoyalAZ.loyalaz.coupons.size();i++)
		{
			Coupon tCoupon = ApplicationLoyalAZ.loyalaz.coupons.get(i);
			if(isRecoveryTask==true)
			{
				tCoupon = DownloadCouponImages(tCoupon);
				
				ApplicationLoyalAZ.loyalaz.coupons.set(i, tCoupon);
			}
		}
	}
	
	private Program DownloadProgramImages(Program prg)
	{
		prg.pic_logo = DownloadImageFromURL(prg.pic_logo);
		prg.pic_front = DownloadImageFromURL(prg.pic_front);
		prg.pic_back = DownloadImageFromURL(prg.pic_back);
		return prg;
	}
		
	public String GetProgramAccumulationLevels(Program prg)
	{
		String levels = "";
		for(int i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			Program tProgram = ApplicationLoyalAZ.loyalaz.programs.get(i);
			if(tProgram.pid.equals(prg.pid))
			{
//				System.out.println("ACCUM="+);
				levels =levels + "," + tProgram.accum_points;
//				break;
			}
		}
//		System.out.println("LEVELS="+levels);
		return levels;
	}
	
	private Coupon DownloadCouponImages(Coupon cpn)
	{
		cpn.pic_logo = DownloadImageFromURL(cpn.pic_logo);
		cpn.pic_front = DownloadImageFromURL(cpn.pic_front);
		cpn.pic_back = DownloadImageFromURL(cpn.pic_back);
		cpn.pic_qrcode = DownloadImageFromURL(cpn.pic_qrcode);
		System.out.println(cpn.pic_qrcode);
		return cpn;
	}
	
	private String DownloadImageFromURL(String imageURL)
	{
		
		System.out.println("URL===="+imageURL);
		String savedFileName = "";
		String extension = "";
		String imageName = "";
		
		imageName = GetImageFileNameFromURL(imageURL);
		
		String[] temp = imageName.split("\\.");
		extension = temp[temp.length-1].toLowerCase();
		imageName = temp[0];
		
		//savedFileName = ApplicationLoyalAZ.appContext.getFilesDir().getAbsolutePath() + "/" + prefix + "_" + pid + "." + extension;
		savedFileName = ApplicationLoyalAZ.appContext.getFilesDir().getAbsolutePath() + "/" + imageName + "." + extension;
		// code to download the image from url here.
		Bitmap bmp = null;
		try {
			URL url = new URL(imageURL);
			bmp = BitmapFactory.decodeStream(url.openConnection().getInputStream());
			
			File imgFile = new File(savedFileName);
			if(imgFile.exists()) 
			{
				imgFile.delete();
			}
			imgFile.createNewFile();
			FileOutputStream out = new FileOutputStream(imgFile, false); 
			if(extension.equals("jpg")||extension.equals("jpeg"))
				bmp.compress(CompressFormat.JPEG, 90, out);
			else if(extension.equals("png"))
				bmp.compress(CompressFormat.PNG, 90, out);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("IMAGE_FILE="+savedFileName);
		return savedFileName;
	}
	
	private String GetImageFileNameFromURL(String imageURL)
	{
    	//String strURL = "http://loyalaz.com/test/images/uploads/programs/back/1142012183826-972AF.jpg";
    	String[] temp = imageURL.split("/");
    	String imageName = temp[temp.length - 1];
    	//temp = imageName.split("\\.");
    	//String extension = temp[temp.length - 1];
    	//imageName = temp[0];
    	return imageName;
	}
	
	public void DeleteAllFiles()
	{
		String path = ApplicationLoyalAZ.appContext.getFilesDir().getAbsolutePath();
		File f = new File(path);
		File[] fNames =  f.listFiles();
		for(int i=0;i<fNames.length;i++)
		{
			Log.d("FILE::", fNames[i].getName());
			fNames[i].delete();
		}
		
//		ApplicationLoyalAZ.loyalaz.User = null;
//		ApplicationLoyalAZ.loyalaz.programs.clear();
//		ApplicationLoyalAZ.loyalaz.coupons.clear();
//		
//		try {
//			Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
	}
	
	public String RechargeSavingTypeProgram(Program prg)
	{
		int i = 0;
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if((prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid)) && (prg.com_id.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).com_id)))
			{
				Program tPrg = ApplicationLoyalAZ.loyalaz.programs.get(i);
				tPrg.pt_balance = prg.pt_target;
				tPrg.pt_loc_balance = prg.pt_target;
				ApplicationLoyalAZ.loyalaz.programs.set(i, tPrg);
			}
		}
		try {
			Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return prg.pt_target;
	}
	
	public String GetProgramPins(Program prg)
	{
		int i = 0;
		String pins = "";
		for(i=0;i<ApplicationLoyalAZ.loyalaz.programs.size();i++)
		{
			if((prg.pid.equals(ApplicationLoyalAZ.loyalaz.programs.get(i).pid)))
			{
				if(pins=="")
				{
					pins = prg.pins;
				}
				else
				{
					pins = pins + "," + prg.pins;
				}
			}
		}
		return pins;
	}
	
}
