package com.outstandingresults.loyalaz;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Array;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.json.JSONException;
import org.json.JSONObject;

import com.outstandingresults.DataObjects.Program;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.BusinessLayer;
import com.outstandingresults.Helpers.Helper;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;

import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;
import android.support.v4.app.FragmentActivity;

import com.bugsense.trace.BugSenseHandler;
import com.facebook.*;
import com.facebook.model.*;
import com.google.analytics.tracking.android.EasyTracker;
//public class MyProgramsActivity extends FragmentActivity implements android.view.GestureDetector.OnGestureListener  {

public class MyProgramsActivity extends FragmentActivity   {
	
	
	private static final int SWIPE_MIN_DISTANCE = 120;
    private static final int SWIPE_MAX_OFF_PATH = 250;
    private static final int SWIPE_THRESHOLD_VELOCITY = 200;

    /** Called when the activity is first created. */
//    private GestureDetector detector = new GestureDetector((android.view.GestureDetector.OnGestureListener) this);
    
//    private GestureDetector detector = new GestureDetector(this);
	
    private String uid;
    private String programId;
    private int programIndex;
    private String pid;
	
	private ProgressDialog progressDialog;
	private ArrayList<Program> programs = null;
	private ProgramsAdapter m_adapter;
	private boolean fbLoginFlag = false;
	private static final List<String> PERMISSIONS = Arrays.asList("publish_actions");
	private static final String PENDING_PUBLISH_KEY = "pendingPublishReauthorization";
	private boolean pendingPublishReauthorization = false;
	private boolean fbPostPendingFlag = false;
	private Bundle postParams = new Bundle();
	private static String fbFeedMessage = "";
	private static String fbFeedCaption = "";
	private boolean rechargeFlag = false;
	
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.myprograms);
        fbFeedMessage = "";
        
//        DateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
//        Date date = new Date();
//        System.out.println(dateFormat.format(date));
        
        if (savedInstanceState != null) {
            pendingPublishReauthorization = 
                savedInstanceState.getBoolean(PENDING_PUBLISH_KEY, false);
        }
        
        
		Button buttonBack = (Button) findViewById(R.id.buttonMyProgramsBack);
		
        buttonBack.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				//MockTest();
				finish();
			}
		});
       
		Button buttonCamera = (Button) findViewById(R.id.buttonMyProgramsCamera);
		
		buttonCamera.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) 
			{
				// TODO Auto-generated method stub
				
				//TestFB();
				
				StartScan(); // commented to test FB Login
			}
		});
        
        
        ListView lv = (ListView)findViewById(R.id.listViewMyPrograms);
        lv.setOnItemClickListener(new OnItemClickListener() {

        	@Override
        	public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				
				Program prg = programs.get(position);
				
				if(prg.act.equals("1"))
				{
					if(prg.coupon_no.equals(""))
					{
	 					if(Helper.IsNetworkAvailable())
	 					{
	 	 		    		AsyncGetCouponNumber taskGetCoupon = new AsyncGetCouponNumber();
	 	 		    		try {
	 							prg.coupon_no = taskGetCoupon.execute(prg).get();
	 							ShowRedeemMessage(prg);
	 						} catch (InterruptedException e) {
	 							// TODO Auto-generated catch block
	 							e.printStackTrace();
	 						} catch (ExecutionException e) {
	 							// TODO Auto-generated catch block
	 							e.printStackTrace();
	 						}
	 					}
	 					else
	 					{
	 						ShowInternetErrorMessage();
	 					}
					}
					else
						ShowRedeemMessage(prg);
				}
				else
				{
					Intent in = new Intent("com.outstandingresultscompany.action.PROGRAMDETAILS");
					in.putExtra("PRG_TYPE", "2");
					in.putExtra("PRG", prg);
					startActivity(in);
				}
				// TODO Auto-generated method stub
//				Toast.makeText(getApplicationContext(),"Selected:",Toast.LENGTH_SHORT).show();
			}
		});        
        
        String start_scan = getIntent().getStringExtra("START_SCAN");
        if(start_scan!=null)
        {
	        if(start_scan.equals("1"))
	        {
	        	//Initiate the scan process from here.
	        	StartScan();
	        }
        }
        
        FillMyProgramsListView();
        
//		lv.setOnTouchListener(new OnTouchListener() {
//
//            public boolean onTouch(View view, MotionEvent e) {
//                detector.onTouchEvent(e);
//                return false;
//            }
//        });
        
        

    }
    
    
    private void TestFB()
    {
    	
		fbFeedMessage=  "I've just collected a reward point at TEST";
		ApplicationLoyalAZ.fbMessage = "I've just collected a reward point at TEST";
    	
		if(ApplicationLoyalAZ.loyalaz.enableFBPost.equals(""))
		{
			fbPostPendingFlag = true;
			PromptFBPosts();
		}
		else if(ApplicationLoyalAZ.loyalaz.enableFBPost.equals("1"))
		{
			fbPostPendingFlag = false;
			//PostToFBWall();
			DoFBLogin();
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
    
    
    private void StartScan()
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
    	   else if(requestCode==1) // result from passcode activity
    	   {
    		   if(resultCode==RESULT_OK)
    		   {
    			   Program prg = (Program) intent.getSerializableExtra("PRG");
    			   this.UpdateSavingTypeProgramBalance(prg);
    		   }
    		   else if(resultCode==RESULT_CANCELED)
    		   {
    			   
    		   }
    	   }
    	   else
    	   {
    		   super.onActivityResult(requestCode, resultCode, intent);
    		   Session.getActiveSession().onActivityResult(this, requestCode, resultCode, intent);
    	   }

    	}
    
    
    private void ParseScanString(String resultString)
    {
    	String[] codeValues = resultString.split("\\+");
    	if(codeValues[0].equals("LAZ"))
    	{
    		Program prg = new Program();
    		prg.id = codeValues[1];
    		prg.pid = codeValues[2];
    		prg.name = codeValues[3];
    		prg.tagline = codeValues[4];
    		//prg. = codeValues[5];
    		prg.type = codeValues[6];
    		
    		prg.pt_target = codeValues[7];
    		prg.pic_logo = codeValues[8];
    		prg.pic_front = codeValues[9];
    		prg.pic_back = codeValues[10];
    		prg.com_id = codeValues[11];
    		prg.com_name = codeValues[12];
    		prg.com_web1 = codeValues[13];
    		prg.com_web2 = codeValues[14];
    		prg.com_phone = codeValues[15];
    		prg.com_email = codeValues[16];
    		prg.c = "";
    		prg.s_dt = "";
    		if(codeValues.length>=20)
    			prg.rt = codeValues[19];
    		else
    			prg.rt = "";
    		
    		if(codeValues.length>=21)
    			prg.fbstatus = codeValues[20];
    		else
    			prg.fbstatus = "";
    		
    		if(codeValues.length>=22)
    			prg.pins = codeValues[21];
    		else
    			prg.pins = "";
    		
    		if(codeValues.length>=23)
    		{
    			prg.spt = codeValues[22];
    		}
    		else
    		{
    			prg.spt = "1";
    		}
    		
//    		Toast.makeText(MyProgramsActivity.this, prg.spt, 500).show();
    		
    		if(prg.type.equals("1")==true || prg.type.equals("2")==true)
    		{
    			this.ProcessPerItemProgramType(prg);
    		}
    		else if(prg.type.equals("3")==true)
    		{
    			this.ProcessSavingProgramType(prg);
    		}
    		else if(prg.type.equals("4")==true)
    		{
    			this.ProcessAccumulatingProgramType(prg);
    		}
    		
 			
 			
 			FillMyProgramsListView();
    	}
    	else
    	{
    		//Show message for invalid qr code scanned.
    	}
    }
    
    private void ProcessPerItemProgramType(Program prg)
    {
			BusinessLayer businessObject = new BusinessLayer();
			//if(businessObject.IsProgramExists(prg)==false)
			if(businessObject.IsProgramWithLocationExists(prg)==false)
			{
				if(prg.rt.length()>0)
				{
	 		    	Calendar c = Calendar.getInstance();
	 		    	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss a");
	 		        String currentDate = df.format(c.getTime());
	 				prg.s_dt = currentDate; 
				}
				
				if(prg.spt.equals("")==false)
				{
					prg.pt_balance = prg.spt;
					prg.pt_loc_balance = prg.spt;
				}
				else
				{
					prg.pt_balance = "1";
					prg.pt_loc_balance = "1";
				}

	    		AsyncAddNewProgram taskAddProgram = new AsyncAddNewProgram();
	    		taskAddProgram.execute(prg);
	    		fbFeedMessage=  "I've just collected a reward point at " + prg.com_name + "," + prg.com_web2 + " using www.LoyalAZ.com";
	    		if(prg.fbstatus.equals(""))
	    			fbFeedCaption = "";
	    		else
	    			fbFeedCaption = prg.fbstatus;
	    		
			//taskAddProgram.execute(prg).get();
			//ShowMessage("1",prg.pt_target);
			}
			else
			{
				
				if(businessObject.IsProgramPendingToRedeem(prg))
				{
					//Program redeem is pending.
//					
					AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
					alertDialogBuilder.setTitle("LoyalAZ");
					alertDialogBuilder
					.setMessage("This program is already pending for redemption. Click this program to redeem.")
					.setCancelable(false)
					.setPositiveButton("Ok",new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog,int id) {
							dialog.dismiss();
							//Save the ACT state.
						}
					});
					AlertDialog alertDialog = alertDialogBuilder.create();
					alertDialog.show();

					return;
				}
				
				if(prg.rt.length()>0)
				{
					if(businessObject.ValidateScanFrequency(prg)==false)
					{
						ShowFrequencyErrorMessage();
						return;
					}
				}
				
				// update the program count.
				prg = businessObject.IncrementProgramBalance(prg);
				if(prg.pt_balance.equals(prg.pt_target))
				{
					
					if(Helper.IsNetworkAvailable())
					{
	 		    		AsyncGetCouponNumber taskGetCoupon = new AsyncGetCouponNumber();
	 		    		try {
							prg.coupon_no = taskGetCoupon.execute(prg).get();
							
							ShowRedeemMessage(prg);
						} catch (InterruptedException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (ExecutionException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					else
					{
						// Show message that internet is required to get Coupon number.
						//BusinessLayer businessObject1 = new BusinessLayer();
						businessObject.UpdateProgramActState(prg);
						ShowInternetErrorMessage();
					}

				}
				else
				{
					fbFeedMessage=  "I've just collected a reward point at " + prg.com_name + "," + prg.com_web2 + " using www.LoyalAZ.com";
	 	    		if(prg.fbstatus.equals(""))
	 	    			fbFeedCaption = "";
	 	    		else
	 	    			fbFeedCaption = prg.fbstatus;
	 	    		
					ApplicationLoyalAZ.fbMessage = "I've just collected a reward point at " + prg.com_name + "," + prg.com_web2 + " using LoyalAZ.com";
					ShowMessage(prg.pt_balance,prg.pt_target);
					//PostToFBWall();
				}
			}
    }
    
    
    private void ProcessAccumulatingProgramType(Program prg)
    {
		BusinessLayer businessObject = new BusinessLayer();
		//if(businessObject.IsProgramExists(prg)==false)
		if(businessObject.IsProgramWithLocationExists(prg)==false)
		{
			if(prg.rt.length()>0)
			{
 		    	Calendar c = Calendar.getInstance();
 		    	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss a");
 		        String currentDate = df.format(c.getTime());
 				prg.s_dt = currentDate; 
			}
			
			if(prg.spt.equals("")==false)
			{
				prg.pt_balance = prg.spt;
				prg.pt_loc_balance = prg.spt;
			}
			else
			{
				prg.pt_balance = "1";
				prg.pt_loc_balance = "1";
			}

			try
			{
	    		AsyncAddNewProgram taskAddProgram = new AsyncAddNewProgram();
	    		taskAddProgram.execute(prg);
	    		fbFeedMessage=  "I've just collected a reward point at " + prg.com_name + "," + prg.com_web2 + " using www.LoyalAZ.com";
	    		if(prg.fbstatus.equals(""))
	    			fbFeedCaption = "";
	    		else
	    			fbFeedCaption = prg.fbstatus;
			}
			catch(Exception e)
			{
				System.out.println("Exception in ProcessAccumulatingProgramType");
				e.printStackTrace();
			}

    		
		//taskAddProgram.execute(prg).get();
		//ShowMessage("1",prg.pt_target);
		}
		else
		{
			
			if(businessObject.IsProgramPendingToRedeem(prg))
			{
				//Program redeem is pending.
//				
				AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
				alertDialogBuilder.setTitle("LoyalAZ");
				alertDialogBuilder
				.setMessage("This program is already pending for redemption. Click this program to redeem.")
				.setCancelable(false)
				.setPositiveButton("Ok",new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog,int id) {
						dialog.dismiss();
						//Save the ACT state.
					}
				});
				AlertDialog alertDialog = alertDialogBuilder.create();
				alertDialog.show();

				return;
			}
			
			if(prg.rt.length()>0)
			{
				if(businessObject.ValidateScanFrequency(prg)==false)
				{
					ShowFrequencyErrorMessage();
					return;
				}
			}
			
			// update the program count.
			prg = businessObject.IncrementProgramBalance(prg);
			String levels[] = prg.accum_points.split(",");
			boolean levelReached = false;
			for(int levelCtr = 0;levelCtr<levels.length;levelCtr++)
			{
				if(prg.pt_balance.equals(levels[levelCtr]))
				{
					levelReached = true;
					if(Helper.IsNetworkAvailable())
					{
	 		    		AsyncGetCouponNumber taskGetCoupon = new AsyncGetCouponNumber();
	 		    		try {
							prg.coupon_no = taskGetCoupon.execute(prg).get();
							
							ShowRedeemMessage(prg);
						} catch (InterruptedException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (ExecutionException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					else
					{
						// Show message that internet is required to get Coupon number.
						//BusinessLayer businessObject1 = new BusinessLayer();
						businessObject.UpdateProgramActState(prg);
						ShowInternetErrorMessage();
					}
					break;
				}
			}
			if(levelReached==false)
			{
				fbFeedMessage=  "I've just collected a reward point at " + prg.com_name + "," + prg.com_web2 + " using www.LoyalAZ.com";
 	    		if(prg.fbstatus.equals(""))
 	    			fbFeedCaption = "";
 	    		else
 	    			fbFeedCaption = prg.fbstatus;
 	    		
				ApplicationLoyalAZ.fbMessage = "I've just collected a reward point at " + prg.com_name + "," + prg.com_web2 + " using LoyalAZ.com";
				ShowMessage(prg.pt_balance,prg.pt_target);
			}
		}
    }
    
    private void ProcessSavingProgramType(final Program prg)
    {
    	BusinessLayer businessObject = new BusinessLayer();
    	
    	if(businessObject.IsProgramExists(prg)==false) // if program does not exists show passcode screen.
    	{
			AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
			alertDialogBuilder.setTitle("LoyalAZ");
			alertDialogBuilder
			.setMessage("To recharge or load your SAVINGS card Ð please show your handset to staff member for validation.")
			.setCancelable(false)
			.setPositiveButton("OK", new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int which) {
					// TODO Auto-generated method stub
					// show activity to ask for passcode.
					dialog.dismiss();
			    	Intent intent = new Intent("com.outstandingresultscompany.action.PASSCODE");
			    	intent.putExtra("PRG",prg);
			    	startActivityForResult(intent, 1);
				}
			})
			.setNegativeButton("Cancel",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.cancel();
				}
			
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
    	}
    	else
    	{
    		this.UpdateSavingTypeProgramBalance(prg);
    	}
		

    }
    
    private void UpdateSavingTypeProgramBalance(Program prg)
    {
    	
    	if(rechargeFlag==true)
    	{
    		rechargeFlag = false;
    		BusinessLayer businessObject = new BusinessLayer();
    		businessObject.RechargeSavingTypeProgram(prg);
    		return;
    	}
    	
    	final Program localPrg = prg;
    	BusinessLayer businessObject = new BusinessLayer();
		//if(businessObject.IsProgramExists(prg)==false)
		if(businessObject.IsProgramWithLocationExists(prg)==false)
		{
			prg.pt_balance = prg.pt_target;
			prg.pt_loc_balance = prg.pt_target;
    		AsyncAddNewProgram taskAddProgram = new AsyncAddNewProgram();
    		taskAddProgram.execute(prg);
//    		fbFeedMessage=  "I've just collected a reward point at " + prg.com_name + "," + prg.com_web2 + " using www.LoyalAZ.com";
//    		if(prg.fbstatus.equals(""))
//    			fbFeedCaption = "";
//    		else
//    			fbFeedCaption = prg.fbstatus;
    		
		//taskAddProgram.execute(prg).get();
		//ShowMessage("1",prg.pt_target);
		}
		else
		{
			// update the program count.
			if(businessObject.IsProgramRechargeLevelReached(prg))
			{
				AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
				alertDialogBuilder.setTitle("LoyalAZ");
				alertDialogBuilder
				.setMessage("To recharge or load your SAVINGS card Ð please show your handset to staff member for validation.")
				.setCancelable(false)
				.setPositiveButton("OK", new DialogInterface.OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						// show activity to ask for passcode.
						dialog.dismiss();
						rechargeFlag = true;
				    	Intent intent = new Intent("com.outstandingresultscompany.action.PASSCODE");
				    	intent.putExtra("PRG",localPrg);
				    	startActivityForResult(intent, 1);
					}
				})
				.setNegativeButton("Cancel",new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog,int id) {
						dialog.cancel();
					}
				
				});
				AlertDialog alertDialog = alertDialogBuilder.create();
				alertDialog.show();
			}
			else
			{
				prg = businessObject.DecrementProgramBalance(prg);				
				AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
				alertDialogBuilder.setTitle("LoyalAZ");
				alertDialogBuilder
				.setMessage("Successfully used " + prg.spt +" savings point.")
				.setCancelable(true)
				.setNegativeButton("OK",new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog,int id) {
						dialog.cancel();
					}
				
				});
				AlertDialog alertDialog = alertDialogBuilder.create();
				alertDialog.show();
			}
		}
    }
    
	private void ShowInternetErrorMessage()
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");

		// set dialog message
		alertDialogBuilder
			.setMessage("Internet connection is required to get the coupon number before redemption. Please click on this program when internet connection is available.")
			.setCancelable(false)
			.setNegativeButton("OK",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.cancel();
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
	}
	
	
	private void ShowFrequencyErrorMessage()
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");

		// set dialog message
		alertDialogBuilder
			.setMessage("Program has been scanned too frequently then the allowed frequency. Please try later.")
			.setCancelable(false)
			.setNegativeButton("OK",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.cancel();
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
	}	
    
    private void ShowRedeemMessage(final Program prg)
    {
		
    	
    	if(ApplicationLoyalAZ.loyalaz.enableFBPost.equals("1"))
		{
    		
    		fbFeedMessage = "I've just received a reward point at " + prg.com_name + "," + prg.com_web2 +" using LoyalAZ.com";
	    		if(prg.fbstatus.equals(""))
 	    			fbFeedCaption = "";
 	    		else
 	    			fbFeedCaption = prg.fbstatus;    		
    		ApplicationLoyalAZ.fbMessage = "I've just received a reward point at " + prg.com_name + "," + prg.com_web2 +" using LoyalAZ.com";
			fbPostPendingFlag = false;
			DoFBLogin();
			//PostToFBWall();
		} 
		   	
    	
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		alertDialogBuilder.setTitle("LoyalAZ");
		alertDialogBuilder
		.setMessage("Congratulation you earned FREE reward at " + prg.com_name + " your coupon number is  " + URLDecoder.decode(prg.coupon_no) + "\nShow staff to redeem now?")
		.setCancelable(false)
		.setPositiveButton("Verified",new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog,int id) {
				dialog.cancel();
				ProcessRedemption(prg);
				//Process Redeem
			}
		})
		.setNegativeButton("Not Now",new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog,int id) {
				dialog.cancel();
				BusinessLayer businessObject = new BusinessLayer();
				businessObject.UpdateProgramActState(prg);
				//Save the ACT state.
			}
		});
		AlertDialog alertDialog = alertDialogBuilder.create();
		alertDialog.show();
    }
    
    
    private void ProcessRedemption(Program prg)
    {
    	AsyncRedeemCoupon taskRedeemCoupon = new AsyncRedeemCoupon();
    	BusinessLayer businessObject = new BusinessLayer();
		String redemptionResponse = "";
		try {
			redemptionResponse = taskRedeemCoupon.execute(prg).get();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if(redemptionResponse.equals("true"))
		{
			businessObject.UpdateProgramRedeemed(prg);
			FillMyProgramsListView();
			AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
			alertDialogBuilder.setTitle("LoyalAZ");
			alertDialogBuilder
			.setMessage("Coupon redeemed successfully.")
			.setCancelable(false)
			.setNegativeButton("OK",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.cancel();
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
		}
		else
		{
			AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
			alertDialogBuilder.setTitle("LoyalAZ");
			alertDialogBuilder
			.setMessage("Some error in redeeming coupon.")
			.setCancelable(false)
			.setNegativeButton("OK",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.cancel();
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
		}
    }
    
	private void ShowMessage(String pt_balance,String pt_target)
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		alertDialogBuilder.setTitle("LoyalAZ");
		alertDialogBuilder
		.setMessage("Congratulations! You now have "+pt_balance +" rewards. Your reward target is "+pt_target)
		.setCancelable(false)
		.setNegativeButton("OK",new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog,int id) {
				
				
				if(ApplicationLoyalAZ.loyalaz.enableFBPost.equals(""))
				{
					fbPostPendingFlag = true;
					PromptFBPosts();
				}
				else if(ApplicationLoyalAZ.loyalaz.enableFBPost.equals("1"))
				{
					fbPostPendingFlag = false;
					//PostToFBWall();
					DoFBLogin();
				}
				
				
				dialog.cancel();
			}
		});
		AlertDialog alertDialog = alertDialogBuilder.create();
		alertDialog.show();
	}
	
	private void onSessionStateChange(Session session, SessionState state, Exception exception) {
	    if (state.isOpened()) {
	        Toast.makeText(MyProgramsActivity.this, "Loggedin", 800).show();
	    } else if (state.isClosed()) {
	    	Toast.makeText(MyProgramsActivity.this, "NOT LOGGED IN", 800).show();
	    }
	}
	
	
	private void DoFBLogin()
	{
		// start Facebook Login
		
		Session.openActiveSession(MyProgramsActivity.this, true, new Session.StatusCallback() 
			{
			// callback when session changes state
			@Override
			public void call(Session session, SessionState state, Exception exception) 
			{ 
				if (session.isOpened()) 
				{
				// make request to the /me API
				Request.executeMeRequestAsync(session, new Request.GraphUserCallback() 
				{
					// callback after Graph API response with user object
					@Override
					public void onCompleted(GraphUser user, Response response) 
					{ 
						if (user != null) 
						{
							fbLoginFlag = true;
							Log.d("User ", "logged in");
							publishStory();
						}
						else
						{
							fbLoginFlag = false;
						}
					}
				} 
			);
			}
		}
		});
		// Facebook login ends here
	}
	
	private boolean isSubsetOf(Collection<String> subset, Collection<String> superset) {
	    for (String string : subset) {
	        if (!superset.contains(string)) {
	            return false;
	        }
	    }
	    return true;
	}
	
	private void publishStory() {
	    Session session = Session.getActiveSession();
	    if (session != null){

	        // Check for publish permissions    
	        List<String> permissions = session.getPermissions();
	        if (!isSubsetOf(PERMISSIONS, permissions)) {
	            pendingPublishReauthorization = true;
	            Session.NewPermissionsRequest newPermissionsRequest = new Session
	                    .NewPermissionsRequest(this, PERMISSIONS);
	        session.requestNewPublishPermissions(newPermissionsRequest);
	            return;
	        }

	        postParams = new Bundle();
	        Log.d("Publish story", "message=="+fbFeedMessage);
	        postParams.putString("link", "http://www.loyalaz.com/newapp/");
//	        postParams.putString("caption", "LoyalAZ Loyalty Reward System - An ultimate loyalty program that saves money, gives best rewards in the shortest period of time to the customer AND helps retailers and local businesses to build a loyal client base - cost-effectively and with minimum fuss.");
	        postParams.putString("caption", URLDecoder.decode(fbFeedCaption));
			postParams.putString("message", URLDecoder.decode(fbFeedMessage));


	        Request.Callback callback= new Request.Callback() {
	            public void onCompleted(Response response) {
	                JSONObject graphResponse = response
	                                           .getGraphObject()
	                                           .getInnerJSONObject();
	                String postId = null;
	                try {
	                    postId = graphResponse.getString("id");
	                } catch (JSONException e) {
	                    Log.e("FBERR","JSON error "+ e.getMessage());
	                }
	                FacebookRequestError error = response.getError();
	                if (error != null) {
	                    Toast.makeText(MyProgramsActivity.this,
	                         error.getErrorMessage(),
	                         Toast.LENGTH_SHORT).show();
	                    } else {
//	                        Toast.makeText(MyProgramsActivity.this, 
//	                             postId,
//	                             Toast.LENGTH_LONG).show();
	                }
	            }
	        };

	        Request request = new Request(session, "me/feed", postParams, 
	                              HttpMethod.POST, callback);
	        RequestAsyncTask task = new RequestAsyncTask(request);
	        task.execute();
	    }

	}
		
	private void PromptFBPosts()
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		alertDialogBuilder.setTitle("LoyalAZ");
		alertDialogBuilder
		.setMessage("Also check-in and post about it to your Facebook Wall?")
		.setCancelable(false)
		.setPositiveButton("Yes",new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog,int id) {
				ApplicationLoyalAZ.loyalaz.enableFBPost="1";
				try {
					Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				dialog.dismiss();
				fbPostPendingFlag = true;
				DoFBLogin();
			}
		})
		.setNegativeButton("No",new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog,int id) {
				ApplicationLoyalAZ.loyalaz.enableFBPost="0";
				try {
					Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				dialog.dismiss();
			}
		});
		AlertDialog alertDialog = alertDialogBuilder.create();
		alertDialog.show();
	}
    
    private void FillMyProgramsListView()
    {
    	
		if(ApplicationLoyalAZ.loyalaz.programs==null)
			ApplicationLoyalAZ.loyalaz.programs = new ArrayList<Program>();
    	
    	programs = (ArrayList<Program>) ApplicationLoyalAZ.loyalaz.programs;
    	
    	ArrayList<Program> tempprograms = new ArrayList<Program>();
    	Program prg = null;
    	boolean flagDuplicate = false;
    	for(int i=0;i<programs.size();i++)
    	{
    		flagDuplicate = false;
    		prg = programs.get(i);
    		
    		for(int j=0;j<tempprograms.size();j++)
    		{
    			if(prg.pid.equals(tempprograms.get(j).pid))
    			{
    				flagDuplicate = true;
    				break;
    			}
    		}
    		if(flagDuplicate==false)
    		{
    			if(prg.active.equals("1") || prg.active.equals(""))
    				tempprograms.add(prg);
    		}
    	}
    	
    	programs = tempprograms;
    	
    	this.m_adapter = new ProgramsAdapter(this,R.layout.custom_list_item, programs);
    	ListView lv = (ListView) findViewById(R.id.listViewMyPrograms);
    	lv.setAdapter(new ProgramsAdapter(this,R.layout.custom_list_item, programs));
    }
    
//    public boolean onDown(MotionEvent e) {
//        // TODO Auto-generated method stub
//        return false;
//    }
//
//    public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
//        float velocityY) {
//        try {
//            if (Math.abs(e1.getY() - e2.getY()) > SWIPE_MAX_OFF_PATH) {
//
//                return false;
//            }
//            // right to left swipe
//            if (e1.getX() - e2.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
//                //CallNativeApp cna = new CallNativeApp(getApplicationContext());
//                //cna.sendSms("11111", "");
//                Toast.makeText(getApplicationContext(), "Left Swipe", Toast.LENGTH_SHORT).show();
//            } else if (e2.getX() - e1.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
//                //CallNativeApp cna = new CallNativeApp(getApplicationContext());
//                //cna.call("1111");
//
//                Toast.makeText(getApplicationContext(), "Right Swipe", Toast.LENGTH_SHORT).show();
//            }
//        } catch (Exception e) {
//            // nothing
//        }
//
//        return true;
//    }
//    public void onLongPress(MotionEvent e) {
//        // TODO Auto-generated method stub
//    	Toast.makeText(getApplicationContext(), "LongPress", Toast.LENGTH_SHORT).show();
//
//    }
//    public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX,
//        float distanceY) {
//        // TODO Auto-generated method stub
//        return true;
//    }
//    public void onShowPress(MotionEvent e) {
//        // TODO Auto-generated method stub
//
//    }
//    public boolean onSingleTapUp(MotionEvent e) {
//        // TODO Auto-generated method stub
//        return true;
//    }
    
	private class AsyncAddNewProgram extends AsyncTask<Program,Void,String>
	{
		private Program prg = null;
       @Override
 	   protected void onPreExecute() {
 	      super.onPreExecute();
 	     progressDialog = ProgressDialog.show(MyProgramsActivity.this, "", "Wait...");
 	   }

     	
 		@Override
 		protected String doInBackground(Program... params) {
 			Program localPrg = params[0];
 			BusinessLayer businessObject = new BusinessLayer();
 			businessObject.AddProgram(localPrg,false);
 			prg = localPrg;
			return localPrg.id;
 			// TODO Auto-generated method stub
 		}
		
 		@Override
 		protected void onPostExecute(String result) 
 		{
 		    super.onPostExecute(result);
 		    progressDialog.dismiss();
 		    FillMyProgramsListView();
			BusinessLayer businessObject = new BusinessLayer();
			
			
			if(prg.type.equals("1")==true || prg.type.equals("2")==true)
				ShowMessage(businessObject.GetProgramBalance(prg),prg.pt_target);
			else if(prg.type.equals("3")==true)
				ShowMessage(prg.pt_balance,prg.pt_target);
			else if(prg.type.equals("4")==true)
			{
				String strLevels = businessObject.GetProgramAccumulationLevels(prg);
//				Toast.makeText(MyProgramsActivity.this,strLevels, 500).show();
				String levels[] = strLevels.split(",");
				boolean levelReached = false;
				for(int levelCtr = 0;levelCtr<levels.length;levelCtr++)
				{
					if(prg.pt_balance.equals(levels[levelCtr]))
					{
						levelReached = true;
						if(Helper.IsNetworkAvailable())
						{
		 		    		AsyncGetCouponNumber taskGetCoupon = new AsyncGetCouponNumber();
		 		    		try {
								prg.coupon_no = taskGetCoupon.execute(prg).get();
								
								ShowRedeemMessage(prg);
							} catch (InterruptedException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (ExecutionException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
						else
						{
							// Show message that internet is required to get Coupon number.
							//BusinessLayer businessObject1 = new BusinessLayer();
							businessObject.UpdateProgramActState(prg);
							ShowInternetErrorMessage();
						}
						break;
					}
				}
				if(levelReached==false)
				{
						fbFeedMessage=  "I've just collected a reward point at " + prg.com_name + "," + prg.com_web2 + " using www.LoyalAZ.com";
		 	    		if(prg.fbstatus.equals(""))
		 	    			fbFeedCaption = "";
		 	    		else
		 	    			fbFeedCaption = prg.fbstatus;
		 	    		
						ApplicationLoyalAZ.fbMessage = "I've just collected a reward point at " + prg.com_name + "," + prg.com_web2 + " using LoyalAZ.com";
						ShowMessage(prg.pt_balance,prg.pt_target);
				}
			}
 		}
	}
	
	
	private class AsyncGetCouponNumber extends AsyncTask<Program,Void,String>
	{
       @Override
 	   protected void onPreExecute() {
 	      super.onPreExecute();
 	     progressDialog = ProgressDialog.show(MyProgramsActivity.this, "", "Wait...");
 	   }

     	
 		@Override
 		protected String doInBackground(Program... params) {
 			Program localPrg = params[0];
 			BusinessLayer businessObject = new BusinessLayer();
 			String coupon_number = businessObject.GetCouponNumber(localPrg);
 			localPrg.coupon_no = coupon_number;
			return localPrg.coupon_no;
 			// TODO Auto-generated method stub
 		}
		
 		@Override
 		protected void onPostExecute(String result) 
 		{
 		    super.onPostExecute(result);
 		   progressDialog.dismiss();
 		}
	}	
	
	
	private class AsyncRedeemCoupon extends AsyncTask<Program,Void,String>
	{
       @Override
 	   protected void onPreExecute() {
 	      super.onPreExecute();
 	     progressDialog = ProgressDialog.show(MyProgramsActivity.this, "", "Wait...");
 	   }

     	
 		@Override
 		protected String doInBackground(Program... params) {
 			Program localPrg = params[0];
 			BusinessLayer businessObject = new BusinessLayer();
 			String response = businessObject.ProcessRedeem(localPrg);
			return response;
 			// TODO Auto-generated method stub
 		}
		
 		@Override
 		protected void onPostExecute(String result) 
 		{
 		    super.onPostExecute(result);
 		   progressDialog.dismiss();
 		}
	}	
    
    
    private class ProgramsAdapter extends ArrayAdapter<Program> {

    	private ArrayList<Program> items;


    	public ProgramsAdapter(Context context, int textViewResourceId,
    			ArrayList<Program> items) {
    		super(context, textViewResourceId, items);
    		this.items = items;
    	}


    	@Override
    	public View getView(final int position, View convertView, ViewGroup parent) {
    		View v = convertView;
    		if (v == null) {
    			LayoutInflater vi = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    			v = vi.inflate(R.layout.custom_list_item, null);
    			v.setMinimumHeight(90);
    		}
    		
//    		programIndex = position;
    		final Program prg = items.get(position);
    		if (prg != null) {
    			TextView tvName = (TextView) v.findViewById(R.id.textView_FPName);
    			TextView tvDescription = (TextView) v.findViewById(R.id.textView_FPDescription);
    			TextView tvDistance = (TextView) v.findViewById(R.id.textView_FPDistance);
    			ImageView iv = (ImageView) v.findViewById(R.id.imageViewFPLogo);
    			ImageView ivPrgType = (ImageView) v.findViewById(R.id.ivPrgType);
    			
    			// ADD CODE HERE
    			v.setOnClickListener(new OnClickListener() {
    				
    				@Override
    				public void onClick(View arg0) {
    					// TODO Auto-generated method stub
    					Program prg = programs.get(programIndex);

    					if(prg.act.equals("1"))
    					{
    						if(prg.coupon_no.equals(""))
    						{
    							if(Helper.IsNetworkAvailable())
    							{
    					    		AsyncGetCouponNumber taskGetCoupon = new AsyncGetCouponNumber();
    					    		try {
    									prg.coupon_no = taskGetCoupon.execute(prg).get();
    									ShowRedeemMessage(prg);
    								} catch (InterruptedException e) {
    									// TODO Auto-generated catch block
    									e.printStackTrace();
    								} catch (ExecutionException e) {
    									// TODO Auto-generated catch block
    									e.printStackTrace();
    								}
    							}
    							else
    							{
    								ShowInternetErrorMessage();
    							}
    						}
    						else
    							ShowRedeemMessage(prg);
    					}
    					else
    					{
    						Intent in = new Intent("com.outstandingresultscompany.action.PROGRAMDETAILS");
    						in.putExtra("PRG_TYPE", "2");
    						in.putExtra("PRG", prg);
    						startActivity(in);
    					}
    				}
    			});
    			//
    			
    			Button buttonDelete = (Button)v.findViewById(R.id.buttonPrgDelete);
    			
    			buttonDelete.setOnClickListener(new View.OnClickListener() {
    				
    				@Override
    				public void onClick(View v) {
    					Program prg1 = items.get(position);
    					programIndex = position;
    					uid = ApplicationLoyalAZ.loyalaz.User.uid;
    					programId = prg1.id;
    					pid = prg1.pid;
    					ConfirmProgramDelete();
    					
    					
    					// TODO Auto-generated method stub
    					//finish();
    					//System.out.println("Delete===" + cpn.name);
    				}
    			});

    			
//    			v.setOnTouchListener(new OnTouchListener() {
//
//                    public boolean onTouch(View view, MotionEvent e) {
//                        detector.onTouchEvent(e);
//                        return false;
//                    }
//                });

    			if(prg.c.length()>0)
    			{
    				 v.setBackgroundColor(Color.parseColor(prg.c));
    			}
    			
    			
    			
    			if (tvName != null) {
    				tvName.setText(URLDecoder.decode(prg.name));
    				tvDescription.setText(URLDecoder.decode(prg.tagline));
    				
    				if(prg.type.equals("3"))
    				{
    					tvDistance.setText("Available:("+prg.pt_balance+"/"+prg.pt_target+")");
    					ivPrgType.setImageResource(R.drawable.type_savings);
    					
    					if(prg.pt_balance.equals("0"))
    					{
    						v.setBackgroundColor(Color.RED);
    					}

    				}
    				else
    				{
    					tvDistance.setText("Rewards:("+prg.pt_balance+"/"+prg.pt_target+")");
    					ivPrgType.setImageResource(R.drawable.type_basic);
    					
    				}
    				
    				Typeface typeFace=Typeface.createFromAsset(getAssets(),"fonts/opensans-extrabold.ttf");
    				tvName.setTypeface(typeFace);
    				
    				typeFace=Typeface.createFromAsset(getAssets(),"fonts/open-sans.light.ttf");
    				tvDescription.setTypeface(typeFace);
    				tvDistance.setTypeface(typeFace);
    				
    				//iv.setImageURI(prg.pic_logo);
    				//System.out.println("LOGO====="+mpg.pic_front);
    				if(prg.d.equals("1"))
    				{
    					// show placeholder image
        				//File imgFile = new  File("placeholder_logo.png");
        				//Bitmap myBitmap = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
        				//System.out.println(imgFile.getAbsolutePath());
        				//iv.setImageBitmap(myBitmap);
        				iv.setImageResource(R.drawable.placeholder_logo);
    				}
    				else
    				{
        				File imgFile = new  File(prg.pic_logo);
        				Bitmap myBitmap = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
        				System.out.println(imgFile.getAbsolutePath());
        				iv.setImageBitmap(myBitmap);
        				//iv.setTag(prg.pic_logo);
    				}

//    				AsyncImageDisplay imgDisp = new AsyncImageDisplay();
//    				imgDisp.execute(iv);
    			}
    		}
    		return v;
    	}
    }
    
    private void ConfirmProgramDelete()
    {
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");
		// set dialog message
		alertDialogBuilder
			.setMessage("Are you sure? You will lose all rewards accumulated for this program!")
			.setCancelable(false)
			
			.setPositiveButton("Yes",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					// if this button is clicked, just close
					// the dialog box and do nothing
					if(Helper.IsNetworkAvailable())
					{
						AsyncRemoveProgram removeTask = new AsyncRemoveProgram();
						removeTask.execute(null);
					}
					else
					{
						progressDialog = ProgressDialog.show(MyProgramsActivity.this, "", "Deleting...");
						BusinessLayer businessLayer = new BusinessLayer();
						businessLayer.RemoveUserProgramInOffline(pid);
						FillMyProgramsListView();
						progressDialog.dismiss();
					}
					
					dialog.dismiss();
				}
			})
			.setNegativeButton("No",new DialogInterface.OnClickListener() {
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


//	public void onGesture(GestureOverlayView arg0, MotionEvent arg1) {
//		// TODO Auto-generated method stub
//		
//	}
//
//
//	public void onGestureCancelled(GestureOverlayView arg0, MotionEvent arg1) {
//		// TODO Auto-generated method stub
//		
//	}
//
//
//	public void onGestureEnded(GestureOverlayView arg0, MotionEvent arg1) {
//		// TODO Auto-generated method stub
//		
//	}
//
//
//	public void onGestureStarted(GestureOverlayView arg0, MotionEvent arg1) {
//		// TODO Auto-generated method stub
//		
//	}
    
	
    private class AsyncRemoveProgram extends AsyncTask<Void,Void,String> 
    {

    	
    	@Override

    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	      progressDialog = ProgressDialog.show(MyProgramsActivity.this, "", "Deleting...");
    	      //displayProgressBar("Downloading...");
    	   }

    	
		@Override
		protected String doInBackground(Void... params) {
			// TODO Auto-generated method stub
	    	BusinessLayer businessObject = new BusinessLayer();
	    	String s = businessObject.RemoveUserProgram(uid, programId);
			return s;
		}
		
		@Override
		protected void onPostExecute(String result) 
		{
		    super.onPostExecute(result);
		    
		    if(result.equals("1"))
		    {
		    	ApplicationLoyalAZ.loyalaz.programs.remove(programIndex);
		    }
		    
		    
		    try {
				Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    
		    
		    FillMyProgramsListView();
	    	progressDialog.dismiss();
	    	
		}
    }	
    
    
}
