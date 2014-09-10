package com.outstandingresults.loyalaz;

import java.util.concurrent.ExecutionException;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.DataObjects.ReferBusiness;
import com.outstandingresults.Helpers.BusinessLayer;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class ReferBusinessActivity  extends Activity {
	
	private EditText textRefCompanyName;
	private EditText textRefCompanyPhone;
	private EditText textRefCompanyEmail;
	private EditText textRefCompanyMgrFirstName;
	private EditText textRefCompanyMgrLastName;
	private EditText textRefCompanyReason;
	private EditText textRefCompanyAddress;
	private ProgressDialog progressDialog;
	private ReferBusiness refBusiness = null;
	@Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.refer_business);
        refBusiness = new ReferBusiness();
    	textRefCompanyName = (EditText)findViewById(R.id.textRefCompanyName);
    	textRefCompanyPhone = (EditText)findViewById(R.id.textRefCompanyPhone);
    	textRefCompanyEmail = (EditText)findViewById(R.id.textRefCompanyEmail);
    	textRefCompanyMgrFirstName = (EditText)findViewById(R.id.textRefCompanyMgrFirstName);
    	textRefCompanyMgrLastName = (EditText)findViewById(R.id.textRefCompanyMgrLastName);
    	textRefCompanyReason = (EditText)findViewById(R.id.textRefCompanyReason);
    	textRefCompanyAddress = (EditText)findViewById(R.id.textRefCompanyAddress);
    	
        String gps_loc = getIntent().getStringExtra("GPS");
        refBusiness.com_id = getIntent().getStringExtra("com_id");
        
        
        if(gps_loc.equals("1"))
        {
        	textRefCompanyAddress.setVisibility(View.GONE);
        	refBusiness.lat = getIntent().getStringExtra("LAT");
        	refBusiness.lng = getIntent().getStringExtra("LNG");
        }
        else
        {
        	refBusiness.lat = "";
        	refBusiness.lng = "";
        }
        
        Button buttonRefBusinessSave = (Button)findViewById(R.id.buttonRefBusinessSave);
        
        buttonRefBusinessSave.setOnClickListener(new View.OnClickListener() {
		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		if(ValidateData())
        		{
        			AsyncRefer taskSaveRefer = new AsyncRefer();
        			taskSaveRefer.execute(null);
//        			try {
//						taskSaveRefer.execute(null);
//						setResult(7);
//						finish();
//					} catch (InterruptedException e) {
//						// TODO Auto-generated catch block
//						e.printStackTrace();
//					} catch (ExecutionException e) {
//						// TODO Auto-generated catch block
//						e.printStackTrace();
//					}
        		}
			}
		});
    }
	
	
    @Override
    public void onStart() {
      super.onStart();
      
      EasyTracker.getInstance().activityStart(this); // Add this method.
    }

    @Override
    public void onStop() {
      super.onStop();
      
      EasyTracker.getInstance().activityStop(this); // Add this method.
    }
	
    private boolean ValidateData()
    {
    	boolean valid = false;
    	
    	refBusiness.rec_cname = textRefCompanyName.getText().toString();
    	refBusiness.rec_phone = textRefCompanyPhone.getText().toString();
    	refBusiness.rec_email = textRefCompanyEmail.getText().toString();
    	refBusiness.rec_mgrfname = textRefCompanyMgrFirstName.getText().toString();
    	refBusiness.rec_mgrlname = textRefCompanyMgrLastName.getText().toString();
    	refBusiness.rec_whyinvited = textRefCompanyReason.getText().toString();
    	refBusiness.rec_address = textRefCompanyAddress.getText().toString();
    	String alertMessage = "";
    	    	
    	
    	if(refBusiness.rec_cname.trim().length()==0)
    	{
    		alertMessage = "Company name is required.";
    	}
    	else if(refBusiness.rec_phone.trim().length()==0)
    	{
    		alertMessage = "Company Phone is required.";
    	}
    	else if(refBusiness.rec_email.trim().length()==0)
    	{
    		alertMessage = "Company Email is required.";
    	}
    	else if(refBusiness.rec_mgrfname.trim().length()==0)
    	{
    		alertMessage = "Manager First name is required.";
    	}
    	else if(refBusiness.rec_mgrlname.trim().length()==0)
    	{
    		alertMessage = "Manager Last name is required.";
    	}
    	else if(refBusiness.rec_address.trim().length()==0 && textRefCompanyAddress.getVisibility()!=8)
    	{
    		alertMessage = "Company address is required.";
    	}
    	else
    	{
    		valid = true;
    	}
    	
    	if(alertMessage.length()>0)
    	{
    		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
    		alertDialogBuilder.setTitle("LoyalAZ");
    		alertDialogBuilder
    		.setMessage(alertMessage)
    		.setCancelable(false)
    		.setNegativeButton("OK",new DialogInterface.OnClickListener() {
    			public void onClick(DialogInterface dialog,int id) {
    				dialog.cancel();
    			}
    		});
    		AlertDialog alertDialog = alertDialogBuilder.create();
    		alertDialog.show();
    	}
		return valid;
    }
    
    private class AsyncRefer extends AsyncTask<Void,Void,Void> 
    {

    	
    	@Override

    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	      progressDialog = ProgressDialog.show(ReferBusinessActivity.this, "", "Saving...");
    	      //displayProgressBar("Downloading...");
    	   }

    	
		@Override
		protected Void doInBackground(Void... params) {
			// TODO Auto-generated method stub
	    	BusinessLayer businessObject = new BusinessLayer();
	    	businessObject.SaveReferBusiness(refBusiness);
	    	return null;
		}
		
		@Override
		protected void onPostExecute(Void result) 
		{
		    super.onPostExecute(result);
	    	progressDialog.dismiss();
			setResult(7);
			finish();
		}
    }

}
