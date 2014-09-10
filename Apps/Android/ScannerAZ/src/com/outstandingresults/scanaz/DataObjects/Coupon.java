package com.outstandingresults.scanaz.DataObjects;

import java.io.Serializable;

public class Coupon  implements Serializable
{

	public String id;
	public String uid;
	public String guid;
	public String type;
    
    public Coupon()
    {
    	 id = "" ;
    	 guid = "" ;
    	 uid = "" ;
    	 type = "" ;
    }
}
