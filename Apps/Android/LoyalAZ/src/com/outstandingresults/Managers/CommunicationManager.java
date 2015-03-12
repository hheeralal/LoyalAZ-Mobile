package com.outstandingresults.Managers;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.ksoap2.HeaderProperty;
import org.ksoap2.SoapEnvelope;
import org.ksoap2.SoapFault;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;
import org.ksoap2.transport.HttpsTransportSE;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlSerializer;

import com.outstandingresults.Helpers.ApplicationLoyalAZ;

import android.util.Base64;
import android.util.Log;



public class CommunicationManager  {
	
	//private static String URL = "http://loyalaz.com/test/p/server.php";
	
	private static String URL = "";
	
	
	public String SendSOAPRequest(String pMethodName,LinkedHashMap<String, String>params,Boolean decodedString)
	{
		String st="";
		try {
			String result = SendSOAPRequest(pMethodName,params);
	        byte[] bytes = Base64.decode(result, Base64.DEFAULT);
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
        
        
    	URL = ApplicationLoyalAZ.WebServiceURL;
    	System.out.println("BASE_URL_HIT==="+URL);
        String NAMESPACE = "http://schemas.xmlsoap.org/soap/envelope/";
        String SOAP_ACTION = "get_baseurl";
        String METHOD_NAME = "get_baseurl";

        String result = null;
        Object resultRequestSOAP = null;

        
        SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);
        params.put("d", "1");		// 0 = PRODUCTION;;	1= TESTING; 2= DEMO
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
        
        HttpTransportSE androidHttpTransport = new HttpTransportSE(URL,30000);
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
        		ApplicationLoyalAZ.baseURLSet=true;
        		ApplicationLoyalAZ.WebServiceURL = st;
    		} catch (UnsupportedEncodingException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}

        } 
        catch (IOException ioe)
        {
        	ioe.printStackTrace();
        }
        catch (Exception e) {
            e.printStackTrace();
            //Log.e("SendSOAPRequest_EXCEPTION", e.getMessage());
        }
	}
	
	
    public String SendSOAPRequest(String pMethodName,LinkedHashMap<String, String>params)
    {
    	String result = null;

    	ApplicationLoyalAZ.baseURLSet = false;
        	if(ApplicationLoyalAZ.baseURLSet==false)
        	{
        		// Set the base URL call first.
        		setBaseURL();
        	}
        	
        	URL = ApplicationLoyalAZ.WebServiceURL;
        	System.out.println("ACUTAL_URL_HIT==="+URL);
            String NAMESPACE = "http://schemas.xmlsoap.org/soap/envelope/";
            String SOAP_ACTION = pMethodName;
            String METHOD_NAME = pMethodName;

            
            Object resultRequestSOAP = null;

            SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

            Iterator it = params.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry pairs = (Map.Entry)it.next();
                //Log.d(pairs.getKey().toString(), pairs.getValue().toString());
                request.addProperty(pairs.getKey().toString(), pairs.getValue().toString());
                it.remove(); // avoids a ConcurrentModificationException
            }
            
            
            
            SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
                            SoapEnvelope.VER11);

            envelope.dotNet = false;
            envelope.setOutputSoapObject(request);
            
//            ArrayList<HeaderProperty> headerPropertyArrayList = new ArrayList<HeaderProperty>();
//            headerPropertyArrayList.add(new HeaderProperty("Connection", "close"));
            
            HttpTransportSE androidHttpTransport = new HttpTransportSE(URL,30000);
            androidHttpTransport.debug = true;
            try {
				androidHttpTransport.call(SOAP_ACTION, envelope);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (XmlPullParserException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			try {
				resultRequestSOAP = envelope.getResponse();
			} catch (SoapFault e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            result = resultRequestSOAP.toString(); // Result string
            return result;
            
    }

}