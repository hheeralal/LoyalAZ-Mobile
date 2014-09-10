package com.outstandingresults.scanaz.Managers;

import java.io.UnsupportedEncodingException;
import java.util.LinkedHashMap;
import java.util.Iterator;
import java.util.Map;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;
import org.xmlpull.v1.XmlSerializer;

import com.outstandingresults.scanaz.Helpers.ApplicationScanAZ;

import android.util.Base64;
import android.util.Log;



public class CommunicationManager  {
	
	//private static String URL = "http://loyalaz.com/test/p/server.php";
	
	private static String URL = "";
	
	
	public String SendSOAPRequest(String pMethodName,LinkedHashMap<String, String>params,Boolean decodedString)
	{
		String result = SendSOAPRequest(pMethodName,params);
        byte[] bytes = Base64.decode(result, Base64.DEFAULT);
        String st="";
		try {
			st = new String(bytes,"UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return st;
	}
	
	private void setBaseURL()
	{
        LinkedHashMap<String, String>params = new LinkedHashMap<String, String>();
        
    	URL = ApplicationScanAZ.WebServiceURL;
    	System.out.println("BASE_URL_HIT==="+URL);
        String NAMESPACE = "http://schemas.xmlsoap.org/soap/envelope/";
        String SOAP_ACTION = "get_baseurl";
        String METHOD_NAME = "get_baseurl";

        String result = null;
        Object resultRequestSOAP = null;

        SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);
        params.put("d", "2"); //0 = Production;;	1=Testing; 2 = DEMO
        Iterator it = params.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pairs = (Map.Entry)it.next();
            request.addProperty(pairs.getKey().toString(), pairs.getValue());
            it.remove(); // avoids a ConcurrentModificationException
        }
        
        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
                        SoapEnvelope.VER11);

        envelope.dotNet = false;
        envelope.setOutputSoapObject(request);
        

        HttpTransportSE androidHttpTransport = new HttpTransportSE(URL);
        androidHttpTransport.debug = true;
        String st="";
        try {
        	System.out.println(request);
        	
            androidHttpTransport.call(SOAP_ACTION, envelope);
            resultRequestSOAP = envelope.getResponse(); // Output received
            result = resultRequestSOAP.toString(); // Result string
            byte[] bytes = Base64.decode(result, Base64.DEFAULT);
            
    		try {
    			st = new String(bytes,"UTF-8");
    		} catch (UnsupportedEncodingException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
    		ApplicationScanAZ.baseURLSet=true;
    		ApplicationScanAZ.WebServiceURL = st;
        } catch (Exception e) {
            e.printStackTrace();
            //Log.e("SendSOAPRequest_EXCEPTION", e.getMessage());
        }
	}
	
	
    public String SendSOAPRequest(String pMethodName,LinkedHashMap<String, String>params)
    {
    	
    	if(ApplicationScanAZ.baseURLSet==false)
    	{
    		// Set the base URL call first.
    		setBaseURL();
    	}
    	
    	URL = ApplicationScanAZ.WebServiceURL;
    	System.out.println("ACUTAL_URL_HIT==="+URL);
        String NAMESPACE = "http://schemas.xmlsoap.org/soap/envelope/";
        String SOAP_ACTION = pMethodName;
        String METHOD_NAME = pMethodName;

        String result = null;
        Object resultRequestSOAP = null;

        SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

        Iterator it = params.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pairs = (Map.Entry)it.next();
            Log.d(pairs.getKey().toString(), pairs.getValue().toString());
            request.addProperty(pairs.getKey().toString(), pairs.getValue().toString());
            it.remove(); // avoids a ConcurrentModificationException
        }
        
        
        
        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
                        SoapEnvelope.VER11);

        envelope.dotNet = false;
        envelope.setOutputSoapObject(request);
        

        HttpTransportSE androidHttpTransport = new HttpTransportSE(URL);
        androidHttpTransport.debug = true;

        try {
        	System.out.println(request);
        	
            androidHttpTransport.call(SOAP_ACTION, envelope);
            resultRequestSOAP = envelope.getResponse(); // Output received
            result = resultRequestSOAP.toString(); // Result string
            return result;
            
        } catch (Exception e) {
            e.printStackTrace();
            //Log.e("SendSOAPRequest_EXCEPTION", e.getMessage());
        }
        return result;
    }

}