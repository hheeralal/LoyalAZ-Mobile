package com.outstandingresults.DataObjects;



public class Country {

	public String code;
	public String name;
	
	public Country()
	{
		code = "";
		name = "";
	}
	
	@Override
    public boolean equals(Object obj)
    {
        boolean isEqual = false;
        if (this.getClass() == obj.getClass())
        {
            Country myValueObject = (Country) obj;
            if ((myValueObject.code).equals(this.code) &&
                    (myValueObject.name).equals(this.name))
            {
                isEqual = true;
            }
        }
 
        return isEqual;
    }
	

	
}
