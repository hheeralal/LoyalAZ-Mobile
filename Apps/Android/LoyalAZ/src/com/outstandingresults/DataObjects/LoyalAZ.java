package com.outstandingresults.DataObjects;



import java.util.List;

public class LoyalAZ {

public String sync;
public User User;
public List<Program> programs;
public String find_enable;
public String enableFBPost;
public List<Coupon> coupons;
public String ads_enable;
	public LoyalAZ()
	{
		sync = "";
		find_enable = "";
		enableFBPost = "";
		User = new User();
		ads_enable = "";
	}
	
}
