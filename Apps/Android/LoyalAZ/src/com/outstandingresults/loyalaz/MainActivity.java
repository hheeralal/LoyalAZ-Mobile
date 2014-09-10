package com.outstandingresults.loyalaz;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;


import com.bugsense.trace.BugSenseHandler;
import com.outstandingresults.DataObjects.Advertisement;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.BusinessLayer;
import com.outstandingresults.Helpers.FBCommunication;
import com.outstandingresults.Helpers.Helper;

import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.Signature;
import android.text.Html;
import android.text.TextUtils;
import android.text.format.DateFormat;
import android.util.Base64;
import android.util.Log;
import android.widget.EditText;
import android.widget.Toast;


public class MainActivity extends Activity {
	
/*	private static String SOAP_ACTION1 = "find_moreprogs";
    private static String NAMESPACE = "";
    private static String METHOD_NAME1 = "find_moreprogs";
*/    	
	private ProgressDialog progressDialog;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
    	
    	// 2013-06-27 10:48:11 PM
    	
//		try {
//	    PackageInfo info = getPackageManager().getPackageInfo(
//	            getPackageName(), 
//	            PackageManager.GET_SIGNATURES);
//	    for (Signature signature : info.signatures) {
//	        MessageDigest md = MessageDigest.getInstance("SHA");
//	        md.update(signature.toByteArray());
//	        Log.d("TAG", "Hash to copy ==> "+ Base64.encodeToString(md.digest(), Base64.DEFAULT));
//	        }
//	} catch (NameNotFoundException e) {
//
//	} 
//	catch (NoSuchAlgorithmException e) {
//
//	}
    	
///////////////////////////////////////////////////////////////////
//    	AsyncFBGraph asFB = new AsyncFBGraph();
//    	try {
//			asFB.execute(null).get();
//		} catch (InterruptedException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (ExecutionException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
///////////////////////////////////////////////////////////////////
    	
    	ApplicationLoyalAZ.advertObject = new Advertisement();
    	
    	ApplicationLoyalAZ.WebServiceURL = "http://www.loyalaz.com/setup/";
    	ApplicationLoyalAZ.appContext = this.getApplicationContext();
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.main);
        
        ApplicationLoyalAZ.loyalaz = Helper.GetApplicationObjectFromDB();
        
        if(ApplicationLoyalAZ.loyalaz!=null)
        {
	        if(ApplicationLoyalAZ.loyalaz.User.uid.length()!=0)
	        {
	        	Log.d("UserId", ApplicationLoyalAZ.loyalaz.User.uid);

	        	
	        	if(ApplicationLoyalAZ.loyalaz.User.mobilephone.length()==0)
	        	{
	        		startActivityForResult(new Intent("com.outstandingresultscompany.action.REGISTERUSERSTEP2"), 2);
	        	}
	        	else
	        	{
	                if(Helper.IsNetworkAvailable())
	                {
		                AsyncSyncDB syncTask = new AsyncSyncDB();
//		                try {
		                	//syncTask.execute(null).get();
		        			syncTask.execute(null);
//		        		} catch (InterruptedException e) {
//		        			// TODO Auto-generated catch block
//		        			e.printStackTrace();
//		        		} catch (ExecutionException e) {
//		        			// TODO Auto-generated catch block
//		        			e.printStackTrace();
//		        		}
	                }
	                else
	                {
	                	startActivityForResult(new Intent("com.outstandingresultscompany.action.HOME"),4);
	                }
	        		
	        		
	        	}
	        }
        }
        else
        {
//        	startActivityForResult(new Intent("com.outstandingresultscompany.action.REGISTERUSERSTEP1"), 1);
        	startActivityForResult(new Intent("com.outstandingresultscompany.action.TUTORIAL"), 9);
        }
   }
    
	public final void launchFacebook() {
        final String urlFb = "fb://profile/426253597411506";
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(urlFb));

        // If a Facebook app is installed, use it. Otherwise, launch
        // a browser
        final PackageManager packageManager = getPackageManager();
        List<ResolveInfo> list =
            packageManager.queryIntentActivities(intent,
            PackageManager.MATCH_DEFAULT_ONLY);
        if (list.size() == 0) {
//    		Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://"+strFBURL));
//    		startActivity(browserIntent);

            final String urlBrowser = "http://"+"http://www.facebook.com/SundownerSaloon";
            intent.setData(Uri.parse(urlBrowser));
        }

        startActivity(intent);
    }	
    
    
    
    private void ShowConnectionError()
    {
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		alertDialogBuilder.setTitle("LoyalAZ");
		alertDialogBuilder
		.setMessage("Can't connect to LoyalAZ Web Server. Please try again later.")
		.setCancelable(false)
		.setPositiveButton("Verified",new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog,int id) {
				dialog.cancel();
			}
		});
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) 
    {
    	//Log.d("CheckStartActivity","onActivityResult and resultCode = "+resultCode);
    	// TODO Auto-generated method stub
    	super.onActivityResult(requestCode, resultCode, data);
    	if(resultCode==1) // User registered successfully.
    	{
    		startActivityForResult(new Intent("com.outstandingresultscompany.action.REGISTERUSERSTEP2"), 2);
    	}
    	else if(resultCode==2) //Second step completed successfully.
    	{
    		ApplicationLoyalAZ.loyalaz = Helper.GetApplicationObjectFromDB();
    		startActivity(new Intent("com.outstandingresultscompany.action.HOME"));
    	}
    	else if(resultCode==-1)
    	{
    		startActivityForResult(new Intent("com.outstandingresultscompany.action.RECOVERDATA"), 3);
    	}
    	else if(resultCode==-2)
    	{
    		startActivityForResult(new Intent("com.outstandingresultscompany.action.REGISTERUSERSTEP1"), 1);
    	}
    	else if(resultCode==4)
    	{
    		startActivityForResult(new Intent("com.outstandingresultscompany.action.REGISTERUSERSTEP1"), 1);
    	}
    	else if(resultCode==9)
    	{
    		startActivityForResult(new Intent("com.outstandingresultscompany.action.REGISTERUSERSTEP1"), 1);
    	}
    }
    
    
    
    private class AsyncSyncDB extends AsyncTask<Void,Void,Void> 
    {

    	
    	@Override

    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	      progressDialog = ProgressDialog.show(MainActivity.this, "", "Sync in progress...");
    	   }

    	
		@Override
		protected Void doInBackground(Void... params) {
			// TODO Auto-generated method stub
	    	BusinessLayer businessObject = new BusinessLayer();
	    	businessObject.SyncDB();
	    	return null;
		}
		
		@Override
		protected void onPostExecute(Void result) 
		{
		    super.onPostExecute(result);
		    progressDialog.dismiss();
		    startActivityForResult(new Intent("com.outstandingresultscompany.action.HOME"),4);
		}
    }
    
    
    
    
}