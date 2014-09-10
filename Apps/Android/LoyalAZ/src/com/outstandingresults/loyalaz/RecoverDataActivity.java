package com.outstandingresults.loyalaz;

import java.util.concurrent.ExecutionException;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.Helpers.BusinessLayer;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class RecoverDataActivity extends Activity {
	
	
	private ProgressDialog progressDialog;
	private EditText editTextST ;

	@Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.recoverdata);
        
        
        Button buttonCancel = (Button)findViewById(R.id.buttonRecoverDataCancel);
        
        buttonCancel.setOnClickListener(new View.OnClickListener() {
		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent in = new Intent();
				setResult(-2,in);        		
        		finish();
			}
		});
        
        
        Button buttonDone = (Button)findViewById(R.id.buttonRecoverDataDone);
        editTextST = (EditText)findViewById(R.id.editTextSecurityToken);
        
        buttonDone.setOnClickListener(new View.OnClickListener() {
		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		AsyncRecover recoverObject = new AsyncRecover();
        		String token = editTextST.getText().toString();
				recoverObject.execute(token);
			}
		});
    }
	
	private void RecoverTaskCompleted(Boolean result)
	{
		if(result==false)
		{
			AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(RecoverDataActivity.this);
			alertDialogBuilder.setTitle("Validation");
			alertDialogBuilder
			.setMessage("Security Token entered is invalid.Please try again.")
			.setCancelable(false)
			.setPositiveButton("OK",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.dismiss();
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
		}
		else
		{
			AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(RecoverDataActivity.this);
			alertDialogBuilder.setTitle("LoyalAZ");
			alertDialogBuilder
			.setMessage("Your data has been successfully recovered.")
			.setCancelable(false)
			.setPositiveButton("OK",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					Intent in = new Intent();
					dialog.dismiss();
    				setResult(2,in);
    				finish();
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
		}
		
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
	
	
    private class AsyncRecover extends AsyncTask<String,Void,Boolean> 
    {

    	
    	@Override

    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	      progressDialog = ProgressDialog.show(RecoverDataActivity.this, "", "Wait...");
    	   }

    	
		@Override
		protected Boolean doInBackground(String... params) {
			// TODO Auto-generated method stub
	    	BusinessLayer businessObject = new BusinessLayer();
	    	boolean s = false;
	    	String securityToken = (String) params[0];
	    	s = businessObject.ValidateSecurityToken(securityToken);
			return s;
		}
		
		@Override
		protected void onPostExecute(Boolean result) 
		{
		    super.onPostExecute(result);
	    	progressDialog.dismiss();
	    	RecoverTaskCompleted(result);
		}

    	
    }
}
