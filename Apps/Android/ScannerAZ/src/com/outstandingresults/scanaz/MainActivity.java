package com.outstandingresults.scanaz;


import com.outstandingresults.scanaz.DataObjects.ScanAZ;
import com.outstandingresults.scanaz.Helpers.ApplicationScanAZ;
import com.outstandingresults.scanaz.Helpers.BusinessLayer;

import android.inputmethodservice.Keyboard;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;

public class MainActivity extends Activity {

	private ProgressDialog progressDialog;
	private EditText textUsername;
	private EditText textPassword;

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		ApplicationScanAZ.WebServiceURL = "http://www.loyalaz.com/setup/";
		
        
        
        textUsername = (EditText)findViewById(R.id.textUsername);
        textPassword = (EditText)findViewById(R.id.textPassword);
        Button buttonLogin = (Button)findViewById(R.id.buttonLogin);
        buttonLogin.setOnClickListener(new View.OnClickListener() {
		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
//				StartScanProcess();
        		InputMethodManager imm = (InputMethodManager)getSystemService(
        			      Context.INPUT_METHOD_SERVICE);
        			imm.hideSoftInputFromWindow(textPassword.getWindowToken(), 0);        		
        		
        		AsyncLogin loginTask = new AsyncLogin();
        		loginTask.execute(null);
			}
		});
	}
	
	private void NavigateToScanActivity()
	{
    	//Intent intent = new Intent("com.outstandingresultscompany.scanaz.SCANACTIVITY");
    	//startActivity(intent);
    	startActivityForResult(new Intent("com.outstandingresultscompany.scanaz.SCANACTIVITY"),1);
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent intent) 
	{
		   if (requestCode == 1) 
		   {
			   textPassword.setText("");
			   textUsername.setText("");
		   }
	}
	
	
	private void ShowLoginErrorMessage(String errorMessage)
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		 
		alertDialogBuilder.setTitle("ScanAZ");

		// set dialog message
		alertDialogBuilder
			.setMessage(errorMessage)
			.setCancelable(false)
			.setNegativeButton("OK",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.cancel();
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
	}
	
	private class AsyncLogin extends AsyncTask<Void,Void,String> 
	{

		
		@Override

		   protected void onPreExecute() {
		      super.onPreExecute();
		      progressDialog = ProgressDialog.show(MainActivity.this, "", "Loading...");
		      //displayProgressBar("Downloading...");
		   }

		
		@Override
		protected String doInBackground(Void... params) {
			// TODO Auto-generated method stub
	    	BusinessLayer businessObject = new BusinessLayer();
	    	String s = "";
	    	String sUsername = textUsername.getText().toString();
	    	String sPassword = textPassword.getText().toString();
	    	s = businessObject.AuthenticateUser(sUsername,sPassword);
	    	System.out.println("LOGIN="+s);
			return s;
		}
		
		@Override
		protected void onPostExecute(String result) 
		{
		    super.onPostExecute(result);
	    	progressDialog.dismiss();
	    	
	    	//result = anyType{status=4; companyid=false; companyname=false; } //RAW RESPONSE FROM WEB-SERVICE
	    	result = result.replace("anyType", "");
	    	result = result.replace("{", "");
	    	result = result.replace("}", "");
	    	String strValues[] = result.split("; ");
	    	System.out.println(result);
	    	
	    	String strStatus = strValues[0].split("=")[1];
	    	
	    	System.out.println("LOGIN STATUS="+strStatus);
	    	
	    	if(strStatus.equals("2"))
	    	{
	    		ShowLoginErrorMessage("System Error.");
	    	}
	    	else if(strStatus.equals("3"))
	    	{
	    		ShowLoginErrorMessage("UnAuthorized User.");
	    	}
	    	else if(strStatus.equals("4"))
	    	{
	    		ShowLoginErrorMessage("Incorrect username.");
	    	}
	    	else if(strStatus.equals("5"))
	    	{
	    		ShowLoginErrorMessage("Incorrect password.");
	    	}
	    	else if(strStatus.equals("1"))
	    	{
	    		System.out.println("VALID USER!!!");
		    	String strComId = strValues[1].split("=")[1];
		    	String strComName = strValues[2].split("=")[1];
		    	ApplicationScanAZ.scanaz = new ScanAZ();
		    	
		    	ApplicationScanAZ.scanaz.companyid = strComId;
		    	ApplicationScanAZ.scanaz.companyname = strComName;
		    	NavigateToScanActivity();
	    	}
		}

		
	}


}
