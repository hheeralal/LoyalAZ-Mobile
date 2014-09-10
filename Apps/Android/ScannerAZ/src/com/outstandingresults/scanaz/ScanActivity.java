package com.outstandingresults.scanaz;

import com.outstandingresults.scanaz.DataObjects.Coupon;
import com.outstandingresults.scanaz.Helpers.ApplicationScanAZ;
import com.outstandingresults.scanaz.Helpers.BusinessLayer;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class ScanActivity extends Activity {

	private ProgressDialog progressDialog;
	Coupon cpn = null;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.scanactivity);
		TextView textComName = (TextView)findViewById(R.id.textViewCompanyName);
		textComName.setText(ApplicationScanAZ.scanaz.companyname);

		
        Button buttonScan = (Button)findViewById(R.id.buttonScan);
        buttonScan.setOnClickListener(new View.OnClickListener() {
		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		StartScanProcess();
			}
		});
        
        Button buttonLogout = (Button)findViewById(R.id.buttonLogout);
        buttonLogout.setOnClickListener(new View.OnClickListener() {
		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		Intent in = new Intent();
        		setResult(1,in);
        		finish();
			}
		});
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
	    switch (keyCode) {
	    case KeyEvent.KEYCODE_BACK:
	      return true;

	    default:
	      return false;
	    }
	  }// end onKeyDown
	
    private void StartScanProcess()
    {
    	Intent intent = new Intent("com.google.zxing.client.android.SCAN");
    	intent.putExtra("SCAN_MODE", "QR_CODE_MODE");
    	startActivityForResult(intent, 0);
    }
    
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) 
    {
    	   if (requestCode == 0) 
    	   {
    	      if (resultCode == RESULT_OK) 
    	      {
    	         String contents = intent.getStringExtra("SCAN_RESULT");
    	         ParseScanString(contents);
    	         //String format = intent.getStringExtra("SCAN_RESULT_FORMAT");
    	         //Toast.makeText(this, contents, 500).show();
    	         // Handle successful scan
    	      } else if (resultCode == RESULT_CANCELED) 
    	      {
    	         // Handle cancel
    	      }
    	   }
    	   else
    	   {
//    		   Session.getActiveSession().onActivityResult(this, requestCode, resultCode, intent);
    	   }
    }
    
    
    private void ParseScanString(String resultString)
    {
    	
    	System.out.println(resultString);
    	
    	String[] codeValues = resultString.split("\\+");
    	if(codeValues.length==4)
    	{
    		cpn = new Coupon();
    		cpn.uid = codeValues[0];
    		cpn.id = codeValues[1];
    		cpn.guid = codeValues[2];
    		
    		AsyncValidateCoupon validateCouponTask = new AsyncValidateCoupon();
    		validateCouponTask.execute(null);    		
    	}
    }
    
    private void ShowAlertMessage(String msg)
    {
    	AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
    	 
    	alertDialogBuilder.setTitle("ScanAZ");

    	// set dialog message
    	alertDialogBuilder
    		.setMessage(msg)
    		.setCancelable(false)
    		.setNegativeButton("OK",new DialogInterface.OnClickListener() {
    			public void onClick(DialogInterface dialog,int id) {
    				dialog.cancel();
    			}
    		});
    		AlertDialog alertDialog = alertDialogBuilder.create();
    		alertDialog.show();
    }
    
    ////////////////AsyncValidateCoupon
    
    private class AsyncValidateCoupon extends AsyncTask<Void,Void,String> 
    {

    	
    	@Override

    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	      progressDialog = ProgressDialog.show(ScanActivity.this, "", "Validating...");
    	      //displayProgressBar("Downloading...");
    	   }

    	
    	@Override
    	protected String doInBackground(Void... params) {
    		// TODO Auto-generated method stub
        	BusinessLayer businessObject = new BusinessLayer();
        	String s = "";
        	s = businessObject.ValidateCoupon(cpn);
    		return s;
    	}
    	
    	@Override
    	protected void onPostExecute(String result) 
    	{
    	    super.onPostExecute(result);
        	progressDialog.dismiss();
        	
        	//result = anyType{status=4; companyid=false; companyname=false; } //RAW RESPONSE FROM WEB-SERVICE
//        	result = result.replace("anyType", "");
//        	result = result.replace("{", "");
//        	result = result.replace("}", "");
//        	String strValues[] = result.split("; ");
//        	System.out.println(result);
//        	
//        	String strStatus = strValues[0].split("=")[1];
        	
        	String strStatus = result;
        	
        	System.out.println("VALIDATE STATUS="+strStatus);
//        	Toast.makeText(ScanActivity.this, "VALIDATE="+result, 800).show();
        	
        	if(strStatus.equals("2"))
        	{
        		ShowAlertMessage("System Error.");
        	}
        	else if(strStatus.equals("3"))
        	{
        		ShowAlertMessage("coupon expired.");
        	}
        	else if(strStatus.equals("4"))
        	{
        		ShowAlertMessage("coupon redemption exceeds its limitation.");
        	}
        	else if(strStatus.equals("5"))
        	{
        		ShowAlertMessage("user has already redeemed the same coupon.");
        	}
        	else if(strStatus.equals("6"))
        	{
        		ShowAlertMessage("guid has already been used.");
        	}
        	else if(strStatus.equals("7"))
        	{
        		ShowAlertMessage("Not allowed to scan other company's coupon.");
        	}
        	else if(strStatus.equals("1"))
        	{
        		
        		AsyncRedeemCoupon redeemCouponTask = new AsyncRedeemCoupon();
        		redeemCouponTask.execute(null);    		
        		
//        		System.out.println("VALID USER!!!");
//    	    	String strComId = strValues[1].split("=")[1];
//    	    	String strComName = strValues[2].split("=")[1];
//    	    	ApplicationScanAZ.scanaz.companyid = strComId;
//    	    	ApplicationScanAZ.scanaz.companyname = strComName;
        	}
    	}
    }
    ///////////////////////////////////
    
    
    
    ////////////////AsyncRedeemCoupon
    private class AsyncRedeemCoupon extends AsyncTask<Void,Void,String> 
    {

    	
    	@Override

    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	      progressDialog = ProgressDialog.show(ScanActivity.this, "", "Validating...");
    	      //displayProgressBar("Downloading...");
    	   }

    	
    	@Override
    	protected String doInBackground(Void... params) {
    		// TODO Auto-generated method stub
        	BusinessLayer businessObject = new BusinessLayer();
        	String s = "";
        	s = businessObject.RedeemCoupon(cpn);
    		return s;
    	}
    	
    	@Override
    	protected void onPostExecute(String result) 
    	{
    	    super.onPostExecute(result);
        	progressDialog.dismiss();
        	
//        	//result = anyType{status=4; companyid=false; companyname=false; } //RAW RESPONSE FROM WEB-SERVICE
//        	result = result.replace("anyType", "");
//        	result = result.replace("{", "");
//        	result = result.replace("}", "");
//        	String strValues[] = result.split("; ");
//        	System.out.println(result);
//        	
//        	String strStatus = strValues[0].split("=")[1];
        	String strStatus = result;
        	System.out.println("REDEEM STATUS="+strStatus);
//        	Toast.makeText(ScanActivity.this, "REDEEM="+result, 800).show();
        	
        	if(strStatus.equals("0"))
        	{
        		ShowAlertMessage("System Error.");
        	}
        	else if(strStatus.equals("1"))
        	{
        		ShowAlertMessage("Coupon redeemed successfully.");
        	}
    	}
    }
    /////////////////////////////////

}
