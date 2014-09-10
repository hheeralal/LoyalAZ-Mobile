package com.outstandingresults.scanaz.Helpers;

import java.util.LinkedHashMap;

import org.kobjects.base64.Base64;

import com.outstandingresults.scanaz.DataObjects.Coupon;
import com.outstandingresults.scanaz.Managers.CommunicationManager;

public class BusinessLayer {
	
	public String AuthenticateUser(String username, String password)
	{
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        
        byte[] bytes = username.getBytes();
        username = Base64.encode(bytes);
        
        bytes = password.getBytes();
        password = Base64.encode(bytes);
        
        soap_params.put("username", username);
        soap_params.put("password", password);
        String s= comMgr.SendSOAPRequest("login_user", soap_params);
		return s;
	}
	
	public String ValidateCoupon(Coupon cpn)
	{
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        soap_params.put("uid", cpn.uid);
        soap_params.put("id", cpn.id);
        soap_params.put("guid", cpn.guid);
        soap_params.put("companyid", ApplicationScanAZ.scanaz.companyid);
        String s= comMgr.SendSOAPRequest("coupon_validation", soap_params);
        return s;
	}
	
	public String RedeemCoupon(Coupon cpn)
	{
		CommunicationManager comMgr = new CommunicationManager();
        LinkedHashMap<String, String>soap_params = new LinkedHashMap<String, String>();
        soap_params.put("uid", cpn.uid);
        soap_params.put("id", cpn.id);
        soap_params.put("guid", cpn.guid);
        soap_params.put("companyid", ApplicationScanAZ.scanaz.companyid);
        String s= comMgr.SendSOAPRequest("coupon_redemption", soap_params);
        return s;
	}

}
