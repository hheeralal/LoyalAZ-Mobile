package com.outstandingresults.loyalaz;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Timer;
import java.util.TimerTask;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.BusinessLayer;
import com.outstandingresults.Helpers.Helper;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.View;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;

public class HomeActivity extends Activity {
	
	
	public Timer timer;
	public TimerTask timerTask;
	public boolean timerScheduled = false;
	final Handler handler = new Handler();
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event)  {

	       if (keyCode == KeyEvent.KEYCODE_BACK)  //Override Keyback to do nothing in this case.
	       {
	    	   moveTaskToBack(true);
	           //return true;
	       }
	       return super.onKeyDown(keyCode, event);  //-->All others key will work as usual
	   }
		
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.home);
      ImageView imgViewAds = (ImageView)findViewById(R.id.imgViewAds);
      imgViewAds.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
        		Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(ApplicationLoyalAZ.advertObject.linkURL));
        		startActivity(browserIntent);
			}

		});
        
                
        
//        if(ApplicationLoyalAZ.showTutorial==true)
//        	LoadTutorial();
        
        LoadAd();
        
        //webViewAds.loadUrl("http://loyalaz.com/test/images/uploads/adverts/1152014-938B3.png");
        
        ShowPendingRedeemMessage();
        
        ImageView imageButtonMyPrograms = (ImageView)findViewById(R.id.imageButtonMyPrograms);
        
        imageButtonMyPrograms.setOnClickListener(new View.OnClickListener() {
		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		Intent in = new Intent("com.outstandingresultscompany.action.MYPROGRAMS");
        		startActivity(in);
				//TestScan();
			}
		});
        
        ImageView imageButtonMyCoupons = (ImageView)findViewById(R.id.imageButtonMyCoupons);
        
        imageButtonMyCoupons.setOnClickListener(new View.OnClickListener() {
		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		Intent in = new Intent("com.outstandingresultscompany.action.MYCOUPONS");
        		startActivity(in);
				//TestScan();
			}
		});
        
        ImageView imageButtonFindCoupons = (ImageView)findViewById(R.id.imageButtonFindCoupons);
        
        imageButtonFindCoupons.setOnClickListener(new View.OnClickListener() {
		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		
        		if(Helper.IsNetworkAvailable())
        		{
            		Intent in = new Intent("com.outstandingresultscompany.action.FINDCOUPONS");
            		startActivity(in);
        		}
				else
				{
					ShowInternetErrorMessage("Internet connection is required to use Find Coupons feature to work.");
				}

				//TestScan();
			}
		});
        
        
        ImageView buttonScan = (ImageView)findViewById(R.id.imageButtonScan);
        
        buttonScan.setOnClickListener(new View.OnClickListener() {
		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				StartScanProcess();
			}
		});
        
        
        ImageView buttonSetup = (ImageView)findViewById(R.id.imageButtonSetup);
        
        buttonSetup.setOnClickListener(new View.OnClickListener() {
			
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				startActivityForResult(new Intent("com.outstandingresultscompany.action.SETUP"),4);
			}
		});
        
        
        //ImageButton buttonFindPrograms = (ImageButton)findViewById(R.id.imageButtonFindPrograms);
        ImageView buttonFindPrograms = (ImageView)findViewById(R.id.imageButtonFindPrograms);
        
        buttonFindPrograms.setOnClickListener(new View.OnClickListener() {
			
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if(Helper.IsNetworkAvailable())
				{
					startActivityForResult(new Intent("com.outstandingresultscompany.action.FINDPROGRAMS"),1);
				}
				else
				{
					ShowInternetErrorMessage("Internet connection is required to use Find Programs feature to work.");
				}
				
			}
		});
    }
    
    private void LoadAd()
    {
    	if(Helper.IsNetworkAvailable())
    	{
        	if(ApplicationLoyalAZ.loyalaz.ads_enable.equals("1"))
        	{
            	AsyncLoadAd adTask = new AsyncLoadAd();
            	adTask.execute(null);
        	}
    	}
    	
//        ImageView imgViewAds = (ImageView)findViewById(R.id.imgViewAds);
//        Uri imgURI = Uri.parse("http://loyalaz.com/test/images/uploads/adverts/1152014-938B3.png");
//        imgViewAds.setImageURI(imgURI);
    }
    
    
    private void LoadTutorial()
    {
    	startActivity(new Intent("com.outstandingresultscompany.action.TUTORIAL"));
    }
    
	private void ShowInternetErrorMessage(String message)
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");

		// set dialog message
		alertDialogBuilder
			.setMessage(message)
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
	
    
    private void StartScanProcess()
    {
		Intent in = new Intent("com.outstandingresultscompany.action.MYPROGRAMS");
		in.putExtra("START_SCAN", "1");
		startActivity(in);
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) 
    {
    	//Log.d("CheckStartActivity","onActivityResult and resultCode = "+resultCode);
    	// TODO Auto-generated method stub
    	super.onActivityResult(requestCode, resultCode, data);
    	if(resultCode==4)
    	{
    		Intent in = new Intent();
    		setResult(4,in);
    		finish();
    	}
    	else if(resultCode==5) // Program added from FindPrograms Activity.
    	{
    		startActivity(new Intent("com.outstandingresultscompany.action.MYPROGRAMS"));
    	}
    	else if(resultCode==6)
    	{
    		StartScanProcess();
    	}
    	if(resultCode==9)
    	{
    		LoadTutorial();
    	}

    }
    
    private void ShowPendingRedeemMessage()
    {
    	BusinessLayer businessObject = new BusinessLayer();
    	if(businessObject.IsRedeemPending())
    	{
    		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
    		alertDialogBuilder.setTitle("LoyalAZ");
    		alertDialogBuilder
    		.setMessage("You have a program pending for redemption, please check my programs to redeem.")
    		.setCancelable(false)
    		.setPositiveButton("OK",new DialogInterface.OnClickListener() {
    			public void onClick(DialogInterface dialog,int id) {
    				dialog.cancel();
    			}
    		});
    		
			AlertDialog alertDialog = alertDialogBuilder.create();

			// show it
			alertDialog.show();
    	}
    }
    
    private class AsyncLoadAd extends AsyncTask<Void,Void,Void>
    {

		@Override
		protected Void doInBackground(Void... arg0) {
			// TODO Auto-generated method stub
			BusinessLayer businessObject = new BusinessLayer();
			businessObject.GetAdData();
			return null;
		}
    	
		
    	@Override

 	   protected void onPreExecute() {
 	      super.onPreExecute();
 	      //progressDialog = ProgressDialog.show(HomeActivity.this, "", "Deleting...");
 	      //displayProgressBar("Downloading...");
 	   }
    	
		@Override
		protected void onPostExecute(Void result) 
		{
		    super.onPostExecute(result);
	        ImageView imgViewAds = (ImageView)findViewById(R.id.imgViewAds);
	        System.out.println("IMGURL="+ApplicationLoyalAZ.advertObject.imageURL);
	        if(ApplicationLoyalAZ.advertObject.imageURL!=null)
	        {
		        AsyncLoadAdImage adImageTask = new AsyncLoadAdImage();
		        adImageTask.execute(imgViewAds);
	        }
//	        Uri imgURI = Uri.parse(ApplicationLoyalAZ.advertObject.imageURL);
//	        imgViewAds.setImageURI(imgURI);
		}

    }
    
    private class AsyncLoadAdImage extends AsyncTask<ImageView,Void,Bitmap>
    {
    	ImageView targetIV;
    	@Override
    	protected void onPreExecute() {
    		super.onPreExecute();
    	}


    	@Override
    	protected Bitmap doInBackground(ImageView... params) {
    		URL url = null;
    		try {
    			String adImageUrl = ApplicationLoyalAZ.advertObject.imageURL;
    			this.targetIV = params[0];
    			url = new URL(adImageUrl);
    		} catch (MalformedURLException e1) {
    			// TODO Auto-generated catch block
    			e1.printStackTrace();
    		}
    		Bitmap bmp = null;
    		try {
    			bmp = BitmapFactory.decodeStream(url.openConnection().getInputStream());
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}

    		return bmp;
    		// TODO Auto-generated method stub
    	}

    	@Override
    	protected void onPostExecute(Bitmap result) 
    	{
    		System.out.println("image loaded.");
    		super.onPostExecute(result);
    		targetIV.setImageBitmap(result);
    		
	        timer = new Timer(false);
	        timerTask = new TimerTask() {
	            @Override
	            public void run() {
	                handler.post(new Runnable() {
	                    @Override
	                    public void run() {
	                        // Do whatever you want
	                    	LoadAd();
	                    }
	                });
	            }
	        };
	        timer.schedule(timerTask, ApplicationLoyalAZ.advertObject.duration * 1000); // 1000 = 1 second.
    		
    	}
    }

}
