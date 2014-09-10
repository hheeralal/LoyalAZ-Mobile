package com.outstandingresults.Managers;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.ServiceConnection;
import org.ksoap2.transport.Transport;
import org.xmlpull.v1.XmlPullParserException;

public class MyHttpTransportSE extends Transport {

//	@Override
	public int getContentLength(SoapSerializationEnvelope envelope)
	{
		try {
			byte[] requestData = createRequestData(envelope);
			return requestData.length;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public List call(String arg0, SoapEnvelope arg1, List arg2)
			throws IOException, XmlPullParserException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List call(String arg0, SoapEnvelope arg1, List arg2, File arg3)
			throws IOException, XmlPullParserException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ServiceConnection getServiceConnection() throws IOException {
		// TODO Auto-generated method stub
		return null;
	}
	


}
