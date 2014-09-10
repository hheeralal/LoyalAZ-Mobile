package com.outstandingresults.loyalaz;

import java.io.IOException;
import java.util.concurrent.ExecutionException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.DataObjects.LoyalAZ;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.BusinessLayer;
import com.outstandingresults.Helpers.Helper;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class RegisterUserStep1Activity extends Activity {

	private EditText textFirstName;
	private EditText textLastName;
	private EditText textEmailId;
	private CheckBox checkBoxAgree;
	private ProgressDialog progressDialog;
	
	@Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.registeruserstep1);
        Button buttonNext = (Button)findViewById(R.id.buttonRegUserStep1Next);
        
        
        BindControls();
        
        buttonNext.setOnClickListener(new View.OnClickListener() {
			
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if(ValidateData())
				{
					
					if(Helper.IsNetworkAvailable())
					{
						RegisterUser();
					}
					else
					{
						ShowInternetErrorMessage();
					}
				}
			}
		});
    }
	
	private void ShowInternetErrorMessage()
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");

		// set dialog message
		alertDialogBuilder
			.setMessage("Internet connection is required to register. Please try when internet connection is available.")
			.setCancelable(false)
			.setNegativeButton("OK",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.cancel();
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
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
	
	
    private void BindControls()
    {
    	textFirstName = (EditText)findViewById(R.id.textFirstName);
    	textLastName = (EditText)findViewById(R.id.textLastName);
    	textEmailId = (EditText)findViewById(R.id.textEmail);
    	checkBoxAgree = (CheckBox)findViewById(R.id.checkBoxAgree);
    	
        Button buttonHintFirstName = (Button)findViewById(R.id.buttonHintFirstName);
        buttonHintFirstName.setOnClickListener(new View.OnClickListener() {
			
        	@Override
			public void onClick(View v) {
        		Toast toast=Toast.makeText(RegisterUserStep1Activity.this, "Your Reward Cards will be personalised so that only you can use it.", Toast.LENGTH_LONG);
        		int yOffset = getAbsolutePositionY(textFirstName) - 10;
        		toast.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL, 0, yOffset);
        		toast.show();
        	}
        });
        
        
        Button buttonHintLastName = (Button)findViewById(R.id.buttonHintLastName);
        buttonHintLastName.setOnClickListener(new View.OnClickListener() {
			
        	@Override
			public void onClick(View v) {
        		Toast toast=Toast.makeText(RegisterUserStep1Activity.this, "You will be protected from an identity theft.", Toast.LENGTH_LONG);
        		int yOffset = getAbsolutePositionY(textLastName) - 10;
        		toast.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL, 0, yOffset);
        		toast.show();
        	}
        });        
        
        Button buttonHintEmail = (Button)findViewById(R.id.buttonHintEmail);
        buttonHintEmail.setOnClickListener(new View.OnClickListener() {
			
        	@Override
			public void onClick(View v) {
        		Toast toast=Toast.makeText(RegisterUserStep1Activity.this, "You can always recover ALL your Reward Cards or Coupons and its data, even if you lost your phone or accidentally deleted this app Ð the LoyalAZ will email to you ÔrestoreÕ info and you can continue using all your loyalty cards and can redeem all accumulated rewards. Your Privacy is Safe with LoyalAZ.comÕ", Toast.LENGTH_LONG);
        		int yOffset = getAbsolutePositionY(textEmailId) - 10;
        		toast.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL, 0, yOffset);
        		toast.show();
        	}
        });
        
        TextView tvTOC = (TextView)findViewById(R.id.textViewTOC);
        tvTOC.setOnClickListener(new View.OnClickListener() {
        	@Override
			public void onClick(View v) {
        		Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.loyalaz.com/mobileTOC.htm"));
        		startActivity(browserIntent);
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
    
    private int getAbsolutePositionY(View v)
    {
        if(v==v.getRootView())
        {
            return v.getTop();
        }
        else
        {
            return v.getTop()+ getAbsolutePositionY((View) v.getParent());
        }
    }
    
    private void RegisterUser()
    {
    	String response = "";
    	final Intent in = new Intent();
    	AsyncRegister register = new AsyncRegister();
    	try {
			response = register.execute().get();
			
			if(response.equals("-1"))
			{
	    		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	    	     
    			alertDialogBuilder.setTitle("Validation");
     
    			// set dialog message
    			alertDialogBuilder
    				.setMessage("This email is already registered in the database.Do you want to recover your existing data?")
    				.setCancelable(false)
    				.setPositiveButton("Yes",new DialogInterface.OnClickListener() {
    					public void onClick(DialogInterface dialog,int id) {
    						
    						AsyncSendEmail taskSendEmail = new AsyncSendEmail();
    						taskSendEmail.execute(null);
    						dialog.dismiss();
    					}
    				})
    				.setNegativeButton("No",new DialogInterface.OnClickListener() {
    					public void onClick(DialogInterface dialog,int id) {
    						dialog.cancel();
    					}
    				});
    				AlertDialog alertDialog = alertDialogBuilder.create();
    				alertDialog.show();
    				
			}
			else if(response.equals("-2"))
			{
	    		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	    	     
    			alertDialogBuilder.setTitle("Validation");
     
    			// set dialog message
    			alertDialogBuilder
    				.setMessage("This email is already registered in the database. Please use a different email.")
    				.setCancelable(false)
    				.setNegativeButton("No",new DialogInterface.OnClickListener() {
    					public void onClick(DialogInterface dialog,int id) {
    						dialog.cancel();
    					}
    				});
    				AlertDialog alertDialog = alertDialogBuilder.create();
    				alertDialog.show();
			}
				
			else if(response.length()>0)
			{
				ApplicationLoyalAZ.loyalaz.User.uid = response;
				try {
					Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				setResult(1,in);
				finish();
			}
			else
			{
	    		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
    			alertDialogBuilder.setTitle("LoyalAZ");
    			alertDialogBuilder
    				.setMessage("Some error has occurred while registration. Please try again.")
    				.setCancelable(false)
    				.setNegativeButton("OK",new DialogInterface.OnClickListener() {
    					public void onClick(DialogInterface dialog,int id) {
    						dialog.cancel();
    					}
    				});
    				AlertDialog alertDialog = alertDialogBuilder.create();
    				alertDialog.show();
			}
	    	
	    	
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    private boolean ValidateData()
    {
    	boolean valid=false;
    	ApplicationLoyalAZ.loyalaz = new LoyalAZ();
    	ApplicationLoyalAZ.loyalaz.User.firstname = textFirstName.getText().toString();
    	ApplicationLoyalAZ.loyalaz.User.lastname = textLastName.getText().toString();
    	ApplicationLoyalAZ.loyalaz.User.email = textEmailId.getText().toString();
    	StringBuilder sb = new StringBuilder();
    	
    	if(ApplicationLoyalAZ.loyalaz.User.firstname.length()==0)
    	{
    		valid = false;
    		//Toast.makeText(this, "First name can't be blank.", 500).show();
    		sb.append("First name can't be blank.");
    	}
    	else if(ApplicationLoyalAZ.loyalaz.User.lastname.length()==0)
    	{
    		valid = false;
    		sb.append("Last name can't be blank.");
    	}
    	else if(ApplicationLoyalAZ.loyalaz.User.email.length()==0)
    	{
    		valid = false;
    		sb.append("Email can't be blank.");
    	}
    	else if(checkBoxAgree.isChecked()==false)
    	{
    		valid = false;
    		sb.append("You must agree to terms and conditions before proceeding.");
    	}
    	else if(ApplicationLoyalAZ.loyalaz.User.email.length()>0)
    	{
    		Pattern pattern;
    		Matcher matcher;
    		
    		String EMAIL_PATTERN = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
    		pattern = Pattern.compile(EMAIL_PATTERN);
    		matcher = pattern.matcher(ApplicationLoyalAZ.loyalaz.User.email);
    		valid = matcher.matches();
    		if(valid==false)
    			sb.append("Email Id should be valid.");
    	}
    	else
    		valid=true;
    	
    	
    	if(valid==false)
    	{
    		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
     
    			alertDialogBuilder.setTitle("Validation");
     
    			// set dialog message
    			alertDialogBuilder
    				.setMessage(sb.toString())
    				.setCancelable(false)
    				.setNegativeButton("OK",new DialogInterface.OnClickListener() {
    					public void onClick(DialogInterface dialog,int id) {
    						// if this button is clicked, just close
    						// the dialog box and do nothing
    						dialog.cancel();
    					}
    				});
     
    				// create alert dialog
    				AlertDialog alertDialog = alertDialogBuilder.create();
     
    				// show it
    				alertDialog.show();
    	}
    	
    	return valid;
    }
    
    private class AsyncRegister extends AsyncTask<Void,Void,String> 
    {

    	
    	@Override

    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	      progressDialog = ProgressDialog.show(RegisterUserStep1Activity.this, "", "Loading...");
    	      //displayProgressBar("Downloading...");
    	   }

    	
		@Override
		protected String doInBackground(Void... params) {
			// TODO Auto-generated method stub
	    	BusinessLayer businessObject = new BusinessLayer();
	    	String s = businessObject.ValidateEmail(ApplicationLoyalAZ.loyalaz.User.email);
	    	String sArray[] = s.split("_");
	    	
	    	if(sArray[0].equals("0") && sArray[1].equals("0"))
	    	{
	    		s = businessObject.RegisterUserStep1();
	    		
	    	}
	    	else if(sArray[0].equals("1") && sArray[1].equals("0"))
	    	{
	    		s = "-2";
	    	}
	    	else if(sArray[0].equals("1") && sArray[1].equals("1"))
	    	{
	    		s = "-1";
	    	}
	    	
			return s;
		}
		
		@Override
		protected void onPostExecute(String result) 
		{
		    super.onPostExecute(result);
	    	progressDialog.dismiss();
		}

    	
    }

    
    private class AsyncSendEmail extends AsyncTask<Void,Void,String> 
    {

    	boolean sent = false;
    	
    	@Override
    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	      progressDialog = ProgressDialog.show(RegisterUserStep1Activity.this, "", "Sending Security Token...");
    	      //displayProgressBar("Downloading...");
    	   }

    	
    	@Override
    	protected String doInBackground(Void... params) {
    		// TODO Auto-generated method stub
        	BusinessLayer businessObject = new BusinessLayer();
        	String s = "";
        	if(businessObject.SendSecurityTokenEmail(ApplicationLoyalAZ.loyalaz.User.email))
        	{
        		s= "A Security Token has been sent to your registered email id.";
        		sent = true;
        	}
        	else
        	{
        		sent = false;
        		s= "Unable to send Security Token to your email id.";
        	}
        	
    		return s;
    	}
    	
    	@Override
    	protected void onPostExecute(final String result) 
    	{
    	    super.onPostExecute(result);
        	progressDialog.dismiss();
    		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(RegisterUserStep1Activity.this);
         
    		alertDialogBuilder.setTitle("LoyalAZ");

    		// set dialog message
    		alertDialogBuilder
    			.setMessage(result)
    			.setCancelable(false)
    			.setNegativeButton("OK",new DialogInterface.OnClickListener() {
    				public void onClick(DialogInterface dialog,int id) {
    					// if this button is clicked, just close
    					// the dialog box and do nothing
    					
    					if(sent==true)
    					{
    						Intent in = new Intent();
    						setResult(-1,in);
    						finish();
    					}
    					
    					dialog.cancel();
    				}
    			});

    			// create alert dialog
    			AlertDialog alertDialog = alertDialogBuilder.create();

    			// show it
    			alertDialog.show();
        	
    	}
    }
}
