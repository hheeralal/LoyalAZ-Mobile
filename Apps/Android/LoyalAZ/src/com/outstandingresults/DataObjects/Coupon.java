package com.outstandingresults.DataObjects;

import java.io.Serializable;

public class Coupon  implements Serializable
{

	public String id;
	public String guid;
	public String name;
	public String typeid;
	public String typename;
	public String xdate;
	public String description;
	public String pic_logo;
	public String pic_front;
	public String pic_back;
	public String com_id;
	public String com_name;
	public String com_web1;
	public String com_web2;
	public String com_phone;
	public String com_street;
	public String com_suburb;
	public String com_city;
	public String lat;
	public String lng;
	public String distance;
	public String pic_qrcode;
	public String used;
	public String c;
	
    
    public Coupon()
    {
    	 id = "" ;
    	 guid = "" ;
    	 name = "" ;
    	 typeid = "" ;
    	 typename = "" ;
    	 xdate = "" ;
    	 description = "" ;
    	 pic_logo = "" ;
    	 pic_front = "" ;
    	 pic_back = "" ;
    	 com_id = "" ;
    	 com_name = "" ;
    	 com_web1 = "" ;
    	 com_web2 = "" ;
    	 com_phone = "" ;
    	 com_street = "" ;
    	 com_suburb = "" ;
    	 com_city = "" ;
    	 lat = "" ;
    	 lng = "" ;
    	 distance = "" ;
    	 pic_qrcode = "" ;
    	 used = "";
    	 c = "";
    }
    
	@Override
    public boolean equals(Object obj)
    {
        boolean isEqual = false;
        if (this.getClass() == obj.getClass())
        {
            Coupon myValueObject = (Coupon) obj;
            if ((myValueObject.id).equals(this.id) &&
                    (myValueObject.id).equals(this.id))
            {
                isEqual = true;
            }
        }
 
        return isEqual;
    }    
}
