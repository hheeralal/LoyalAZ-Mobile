package com.outstandingresults.Helpers;

import java.io.IOException;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;
import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;

import android.util.Log;

public class FBCommunication {

	
    public String SendSOAPRequest(String pageName)
    {
    	
    	String URL = "https://graph.facebook.com/shemrockites";
    	
        String NAMESPACE = "http://schemas.xmlsoap.org/soap/envelope/";
        String SOAP_ACTION = "";
//        String METHOD_NAME = pMethodName;

        String result = null;
        Object resultRequestSOAP = null;

        SoapObject request = new SoapObject(NAMESPACE, "");

//        Iterator it = params.entrySet().iterator();
//        while (it.hasNext()) {
//            Map.Entry pairs = (Map.Entry)it.next();
//            Log.d(pairs.getKey().toString(), pairs.getValue().toString());
//            request.addProperty(pairs.getKey().toString(), pairs.getValue().toString());
//            it.remove(); // avoids a ConcurrentModificationException
//        }
        
        
        
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
            //e.printStackTrace();
            Log.e("SendSOAPRequest_EXCEPTION", e.getMessage());
        }
        return result;
    }
    
    public String GetPageId(String pageName)
    {
    	String fbPageId = "";
    	String URL = "https://graph.facebook.com/"+pageName;
    	HttpClient Client = new DefaultHttpClient();
    	HttpGet httpget = new HttpGet(URL);
        ResponseHandler<String> responseHandler = new BasicResponseHandler();
        try {
			String responseString  = Client.execute(httpget, responseHandler);
			System.out.println(responseString);
			try {
				JSONObject jsonObject = new JSONObject(responseString);
				fbPageId = jsonObject.getString("id");
				System.out.println(fbPageId);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			 
		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}    	
        System.out.println("call ended.");
        return fbPageId;
    }
}
