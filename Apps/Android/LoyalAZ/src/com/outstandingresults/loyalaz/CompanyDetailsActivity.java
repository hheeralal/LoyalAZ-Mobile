package com.outstandingresults.loyalaz;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.ExecutionException;

import com.outstandingresults.DataObjects.MProgram;
import com.outstandingresults.DataObjects.Program;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.FBCommunication;
import com.outstandingresults.Helpers.Helper;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;

public class CompanyDetailsActivity extends Activity {

	private Program prg = null;
	private MProgram mpg = null;
	
	private String strFBURL = "";
	private String strWebURL = "";
	private String strPhone = "";
	private String strEmail = "";
	private String com_id = "";
	private String lat = "", lng = "";
	private String fbPageName = "";
	private ProgressDialog progressDialog;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		BugSenseHandler.initAndStartSession(this, "dffdc98f");
		setContentView(R.layout.companydetails);
		
		//
		
//		Commented on 05/June/13		
//		Button buttonRefBusiness = (Button) findViewById(R.id.buttonCompanyDetailsRefBusiness);
//		
//		buttonRefBusiness.setOnClickListener(new View.OnClickListener() {
//			
//			@Override
//			public void onClick(View v) {
//				// TODO Auto-generated method stub
//				NavigateToReferABusinessActivity();
//
//			}
//		});

		
		Button buttonBack = (Button) findViewById(R.id.buttonCompanyDetailsBack);
		
        buttonBack.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				finish();
			}
		});
		
		String prg_type = getIntent().getStringExtra("PRG_TYPE");
		if(prg_type.equals("1"))
		{
			mpg = (MProgram)getIntent().getSerializableExtra("PRG");
			fbPageName = mpg.com_web1;
			strFBURL = mpg.com_web1;
			strWebURL = mpg.com_web2;
			strPhone = mpg.com_phone;
			strEmail = mpg.com_email;
			com_id = mpg.com_id;
			lat = mpg.lat;
			lng = mpg.lng;
		}
		else if(prg_type.equals("2"))
		{
			prg = (Program)getIntent().getSerializableExtra("PRG");
			fbPageName = prg.com_web1;
			strFBURL = prg.com_web1;
			strWebURL = prg.com_web2;
			strPhone = prg.com_phone;
			strEmail = prg.com_email;
			com_id = prg.com_id;
//			buttonRefBusiness.setVisibility(View.GONE);
		}
		
		ShowInfo();
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
	
	
	private void NavigateToReferABusinessActivity()
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");

		// set dialog message
		alertDialogBuilder
			.setMessage("Recommend Current Location to join LoyalAZ?")
			.setCancelable(false)
			.setPositiveButton("Yes",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.dismiss();
					Intent in = new Intent("com.outstandingresultscompany.action.REFERBUSINESS");
					in.putExtra("GPS", "1");
					in.putExtra("com_id", com_id);
					in.putExtra("LAT", lat);
					in.putExtra("LNG", lng);
					in.putExtra("GPS", "1");
					startActivityForResult(in,7);
				}
			})
			.setNegativeButton("No",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.dismiss();
					Intent in = new Intent("com.outstandingresultscompany.action.REFERBUSINESS");
					in.putExtra("GPS", "0");
					startActivityForResult(in,7);
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
	}
	
	private void ShowInfo()
	{
		TextView tvFBURL = (TextView)findViewById(R.id.textViewFBURL);
		TextView tvWebURL = (TextView)findViewById(R.id.textViewWebURL);
		TextView tvPhone = (TextView)findViewById(R.id.textViewPhone);
		TextView tvEmail = (TextView)findViewById(R.id.textViewEmail);
		
		tvFBURL.setText(strFBURL);
		tvWebURL.setText(strWebURL);
		tvPhone.setText(strPhone);
		tvEmail.setText(strEmail);
		
		
		tvFBURL.setOnClickListener(new View.OnClickListener() {
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		// commented on 10/3/13 to open FB app if installed else open in browser.
//        		Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://"+strFBURL));
//        		startActivity(browserIntent);
//        		launchFacebook();
        		
            	AsyncFBGraph asFB = new AsyncFBGraph();
            	asFB.execute(null);

			}
		});
		
		tvWebURL.setOnClickListener(new View.OnClickListener() {
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://"+strWebURL));
        		startActivity(browserIntent);
			}
		});
		
		//
		
		tvPhone.setOnClickListener(new View.OnClickListener() {
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		ConfirmPhoneCall();
			}
		});
		
		
		
		tvEmail.setOnClickListener(new View.OnClickListener() {
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		Intent intent = new Intent(Intent.ACTION_SEND);
        		intent.setType("plain/text");
        		intent.putExtra(Intent.EXTRA_EMAIL, new String[] { strEmail });
        		startActivity(Intent.createChooser(intent, ""));
			}
		});
		
	}
	
	public final void launchFacebook(String fbPageId) {
        final String urlFb = "fb://profile/"+fbPageId;
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

            final String urlBrowser = "http://www.facebook.com/"+fbPageName;
            intent.setData(Uri.parse(urlBrowser));
        }

        startActivity(intent);

    }	
	
	private void ConfirmPhoneCall()
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");

		// set dialog message
		alertDialogBuilder
			.setMessage("Do you want to call " + strPhone + "?")
			.setCancelable(false)
			.setPositiveButton("YES",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.cancel();
					startActivity(new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + strPhone)));
				}
			})
			.setNegativeButton("NO",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.cancel();
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
	}
	
	
    private class AsyncFBGraph extends AsyncTask<Void,Void,Void>
    {
    	@Override

 	   protected void onPreExecute() {
 	      super.onPreExecute();
 	      progressDialog = ProgressDialog.show(CompanyDetailsActivity.this, "", "Loading");
 	   }

 	
		@Override
		protected Void doInBackground(Void... params) {
			// TODO Auto-generated method stub
	    	FBCommunication fb = new FBCommunication();
	    	String fbPageId = fb.GetPageId(fbPageName);
	    	launchFacebook(fbPageId);
	    	return null;
		}
		
		@Override
		protected void onPostExecute(Void result) 
		{
		    super.onPostExecute(result);
		    progressDialog.dismiss();
//		    startActivityForResult(new Intent("com.outstandingresultscompany.action.HOME"),4);
		}
    }
	
}
