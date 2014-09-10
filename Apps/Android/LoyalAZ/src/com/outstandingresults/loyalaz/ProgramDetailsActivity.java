package com.outstandingresults.loyalaz;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.ExecutionException;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.DataObjects.MProgram;
import com.outstandingresults.DataObjects.Program;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.BusinessLayer;
import com.outstandingresults.Helpers.Helper;
import com.outstandingresults.loyalaz.animation.DisplayNextView;
import com.outstandingresults.loyalaz.animation.Flip3dAnimation;

import android.R.drawable;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.animation.AccelerateInterpolator;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

public class ProgramDetailsActivity extends Activity {
	private ImageView image1;
	private ImageView image2;
	private ProgressDialog progressDialog;
	private boolean isFirstImage = true;
	private boolean moreProgramsFlag = false;
	private Program prg;
	private MProgram mpg;
	Button buttonAddOrInfo;
	private String com_id = "";
	private String lat = "", lng = "";
	private boolean flagSecondDownloaded = false;
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		BugSenseHandler.initAndStartSession(this, "dffdc98f");
		setContentView(R.layout.programdetails);
		
//		Commented on 05/June/13
//		Button buttonRefBusiness = (Button) findViewById(R.id.buttonProgramDetailsRefBusiness);
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
		
		Button buttonBack = (Button) findViewById(R.id.buttonProgramDetailsBack);
		
        buttonBack.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				finish();
			}
		});        		
		

		image1 = (ImageView) findViewById(R.id.ImageView01);
		image2 = (ImageView) findViewById(R.id.ImageView02);
		buttonAddOrInfo = (Button) findViewById(R.id.buttonProgramDetailsAddOrInfo);

		String prg_type = getIntent().getStringExtra("PRG_TYPE");
		if(prg_type.equals("1"))
		{
			moreProgramsFlag = true;
			mpg = (MProgram)getIntent().getSerializableExtra("PRG");
			
			com_id = mpg.com_id;
			lat = mpg.lat;
			lng = mpg.lng;
			buttonAddOrInfo.setBackgroundResource(R.drawable.add_button_states);
		}
		else if(prg_type.equals("2"))
		{
			moreProgramsFlag = false;
			prg = (Program)getIntent().getSerializableExtra("PRG");
			//buttonAddOrInfo.setText("Info");
			com_id = prg.com_id;
			buttonAddOrInfo.setBackgroundResource(R.drawable.info_button_states);
//			buttonRefBusiness.setVisibility(View.GONE);
		}
		
		String pic_front = "";
		String pic_back = "";
		
		if(moreProgramsFlag)
		{
			pic_front = mpg.pic_front;
			pic_back = mpg.pic_back;
		}
		else
		{
			pic_front = prg.pic_front;
			pic_back = prg.pic_back;
		}
		
		image1.setTag(pic_front);
		image2.setTag(pic_back);

		if(moreProgramsFlag)
		{
			LoadProgramImage(image1);
		}
		else
		{
			ShowProgramImage(image1);
		}

		
		buttonAddOrInfo.setOnClickListener(new View.OnClickListener() {
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		if(moreProgramsFlag==false)
        		{
        			ShowCompanyInfo();
        		}
        		else
        		{
        			if(isFirstImage)
        			{
        				AddProgram();
        			}
        			else
        			{
        				ShowCompanyInfo();
        			}
        		}
			}
		});
		
		image2.setVisibility(View.GONE);
		

		image1.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				if (isFirstImage) {
					applyRotation(0, 90);
					isFirstImage = !isFirstImage;

				} else {
					applyRotation(0, -90);
					isFirstImage = !isFirstImage;
				}
				
				if(moreProgramsFlag==false)
				{
					//buttonAddOrInfo.setText("Info");
					buttonAddOrInfo.setBackgroundResource(R.drawable.info_button_states);
				}
				else
				{
					if(isFirstImage)
					{
						//buttonAddOrInfo.setText("Add");
						buttonAddOrInfo.setBackgroundResource(R.drawable.add_button_states);
					}
					else
					{
						//buttonAddOrInfo.setText("Info");
						buttonAddOrInfo.setBackgroundResource(R.drawable.info_button_states);
					}
				}
			}
		});
		
		
//		image2.setOnClickListener(new View.OnClickListener() {
//			public void onClick(View view) {
//				if (isFirstImage) {
//					applyRotation(0, 90);
//					isFirstImage = !isFirstImage;
//
//				} else {
//					applyRotation(0, -90);
//					isFirstImage = !isFirstImage;
//				}
//				
//				if(moreProgramsFlag==false)
//				{
//					buttonAddOrInfo.setText("Info");
//				}
//				else
//				{
//					if(isFirstImage)
//						buttonAddOrInfo.setText("Add");
//					else
//						buttonAddOrInfo.setText("Info");
//				}
//			}
//		});		
	}
	
//	private void NavigateToReferABusinessActivity()
//	{
//		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
//	     
//		alertDialogBuilder.setTitle("LoyalAZ");
//
//		// set dialog message
//		alertDialogBuilder
//			.setMessage("Recommend Current Location to join LoyalAZ?")
//			.setCancelable(false)
//			.setPositiveButton("Yes",new DialogInterface.OnClickListener() {
//				public void onClick(DialogInterface dialog,int id) {
//					dialog.dismiss();
//					Intent in = new Intent("com.outstandingresultscompany.action.REFERBUSINESS");
//					in.putExtra("GPS", "1");
//					in.putExtra("com_id", com_id);
//					in.putExtra("LAT", lat);
//					in.putExtra("LNG", lng);
//					in.putExtra("GPS", "1");
//					startActivityForResult(in,7);
//				}
//			})
//			.setNegativeButton("No",new DialogInterface.OnClickListener() {
//				public void onClick(DialogInterface dialog,int id) {
//					dialog.dismiss();
//					Intent in = new Intent("com.outstandingresultscompany.action.REFERBUSINESS");
//					in.putExtra("GPS", "0");
//					in.putExtra("com_id", com_id);
//					startActivityForResult(in,7);
//				}
//			});
//			AlertDialog alertDialog = alertDialogBuilder.create();
//			alertDialog.show();
//	}
	
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
	
	
	private void ShowCompanyInfo()
	{
		Intent in = new Intent("com.outstandingresultscompany.action.COMPANYDETAILS");
		if(moreProgramsFlag)
		{
			in.putExtra("PRG_TYPE", "1");
			in.putExtra("PRG", mpg);
		}
		else
		{
			in.putExtra("PRG_TYPE", "2");
			in.putExtra("PRG", prg);
		}
		startActivity(in);
	}
	
	private void AddProgram()
	{
		Program prgNew = new Program();
		prgNew.act = mpg.act;
		prgNew.com_email = mpg.com_email;
		prgNew.com_id = mpg.com_id;
		prgNew.com_name = mpg.com_name;
		prgNew.com_phone = mpg.com_phone;
		prgNew.com_web1 = mpg.com_web1;
		prgNew.com_web2 = mpg.com_web2;
		prgNew.id = mpg.id;
		prgNew.name = mpg.name;
		prgNew.pic_back = mpg.pic_back;
		prgNew.pic_front = mpg.pic_front;
		prgNew.pic_logo = mpg.pic_logo;
		prgNew.pid = mpg.pid;
		prgNew.pt_balance = "0";
		prgNew.pt_target = mpg.pt_target;
		prgNew.tagline = mpg.tagline;
		prgNew.type = mpg.type;
		prgNew.pt_loc_balance = "0";
		
		BusinessLayer businessObject = new BusinessLayer();
		if(businessObject.IsProgramExists(prgNew))
		{
			//Show message
			ShowMessage();
		}
		else
		{
			// add the program and navigate to programs activity.
			AsyncAddProgram taskAddProgram = new AsyncAddProgram();
			taskAddProgram.execute(prgNew);
//			try {
//				if(taskAddProgram.execute(prgNew).get().length()>0)
//				{
//					//program added.
//					ShowAddMessage();
//				}
//			} catch (InterruptedException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			} catch (ExecutionException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
		}
	}
	
	
	private void ShowMessage()
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		alertDialogBuilder.setTitle("LoyalAZ");
		alertDialogBuilder
		.setMessage("This program is already added to your list. Kindly check My Programs.")
		.setCancelable(false)
		.setNegativeButton("OK",new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog,int id) {
				dialog.cancel();
			}
		});
		AlertDialog alertDialog = alertDialogBuilder.create();
		alertDialog.show();
	}
	
	private void ShowAddMessage()
	{
		final Intent in = new Intent();
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		alertDialogBuilder.setTitle("LoyalAZ");
		alertDialogBuilder
		.setMessage("Congratulations! You now have 0 rewards and your target is "+mpg.pt_target)
		.setCancelable(false)
		.setNegativeButton("OK",new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog,int id) {
				dialog.cancel();
				setResult(5,in);
				finish();
			}
		});
		AlertDialog alertDialog = alertDialogBuilder.create();
		alertDialog.show();
	}	

	private void applyRotation(float start, float end) {
		// Find the center of image
		final float centerX = image1.getWidth() / 2.0f;
		final float centerY = image1.getHeight() / 2.0f;

		// Create a new 3D rotation with the supplied parameter
		// The animation listener is used to trigger the next animation
		final Flip3dAnimation rotation = new Flip3dAnimation(start, end,
				centerX, centerY);
		rotation.setDuration(500);
		rotation.setFillAfter(true);
		rotation.setInterpolator(new AccelerateInterpolator());
		rotation.setAnimationListener(new DisplayNextView(isFirstImage, image1,
				image2));

		if (isFirstImage) {
			image1.startAnimation(rotation);
		} else {
			image2.startAnimation(rotation);
		}
		
		
		//Toast.makeText(ProgramDetailsActivity.this, pic_front, 500).show();
		
		if(moreProgramsFlag)
		{
			if(isFirstImage)
			{
				if(flagSecondDownloaded==false)
				{
					LoadProgramImage(image2);
					flagSecondDownloaded = true;
				}
				
			}
			else
			{
				//LoadProgramImage(image1);
			}
		}
		else
		{
			if(isFirstImage)
				ShowProgramImage(image2);
			else
				ShowProgramImage(image1);
		}
		
	}
	
	private void LoadProgramImage(ImageView targetIV)
	{
		
		AsyncImageDisplay imgDisp = new AsyncImageDisplay();
		imgDisp.execute(targetIV);
	}
	
	private void ShowProgramImage(ImageView targetIV)
	{
		if(prg.d.equals("1"))
		{
			targetIV.setImageResource(R.drawable.placeholder);
		}
		else
		{
			String fileName = (String) targetIV.getTag();
			File imgFile = new  File(fileName);
			Bitmap myBitmap = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
			targetIV.setImageBitmap(myBitmap);
		}

	}
	
	
	
	private class AsyncImageDisplay extends AsyncTask<ImageView,Void,Bitmap>
	{
		ImageView targetIV;
       @Override
 	   protected void onPreExecute() {
    	   
 	      super.onPreExecute();
 	      //if(targetIV.getTag(1).equals("YES")==false)
 	      progressDialog = ProgressDialog.show(ProgramDetailsActivity.this, "", "Loading Image...");
 	   }

     	
 		@Override
 		protected Bitmap doInBackground(ImageView... params) {
 			URL url = null;
			try {
				String logo =(String) params[0].getTag();
				this.targetIV = params[0];
				//System.out.println("LOGO====="+logo);
				url = new URL(logo);
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
 		    super.onPostExecute(result);
 		   targetIV.setImageBitmap(result);
 		   
 		  progressDialog.dismiss();
 		}
	}
	
	
	private class AsyncAddProgram extends AsyncTask<Program,Void,String>
	{
       @Override
 	   protected void onPreExecute() {
 	      super.onPreExecute();
 	     progressDialog = ProgressDialog.show(ProgramDetailsActivity.this, "", "Wait...");
 	   }

     	
 		@Override
 		protected String doInBackground(Program... params) {
 			Program localPrg = params[0];
 			BusinessLayer businessObject = new BusinessLayer();
 			businessObject.AddProgram(localPrg,true);
			return localPrg.id;
 			// TODO Auto-generated method stub
 		}
		
 		@Override
 		protected void onPostExecute(String result) 
 		{
 		    super.onPostExecute(result);
 		    System.out.println("ADD PRG RESULT==="+result);
		    if(result.length()>0)
		    {
		    	ShowAddMessage();
		    }
 		   progressDialog.dismiss();
 		}
	}
	
	
}
