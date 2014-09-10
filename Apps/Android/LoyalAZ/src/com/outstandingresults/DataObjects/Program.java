package com.outstandingresults.DataObjects;

import java.io.Serializable;


public class Program implements Serializable{

	public String id;
	public String pid;
	public String act;
	public String name;
	public String tagline;
	public String type;
	public String pt_balance;
	public String pt_target;
	public String pic_logo;
	public String pic_front;
	public String pic_back;
	public String com_id;
	public String com_name;
	public String com_web1;
	public String com_web2;
	public String com_phone;
	public String coupon_no;
	public String u;	
	public String com_email;
	public String d;
	public String rt;
	public String c;
	public String s_dt;
	public String pt_loc_balance;
	public String active;
	public String fbstatus;
	public String pins;
	public String spt;
	
	public Program()
	{
		id = "" ;
		pid = "" ;
		act = "" ;
		name = "" ;
		tagline = "" ;
		type = "" ;
		pt_balance = "" ;
		pt_target = "" ;
		pic_logo = "" ;
		pic_front = "" ;
		pic_back = "" ;
		com_id = "" ;
		com_name = "" ;
		com_web1 = "" ;
		com_web2 = "" ;
		com_phone = "" ;
		coupon_no = "" ;
		u = "" ;		
		com_email = "";
		d = "";
		rt = "";
		c = "";
		s_dt = "";
		pt_loc_balance = "";
		active = "";
		fbstatus = "";
		pins = "";
		spt = "";
	}
	
	@Override
    public boolean equals(Object obj)
    {
        boolean isEqual = false;
        if (this.getClass() == obj.getClass())
        {
            Program myValueObject = (Program) obj;
            if ((myValueObject.id).equals(this.id) &&
                    (myValueObject.pid).equals(this.pid))
            {
                isEqual = true;
            }
        }
 
        return isEqual;
    }
	
}
