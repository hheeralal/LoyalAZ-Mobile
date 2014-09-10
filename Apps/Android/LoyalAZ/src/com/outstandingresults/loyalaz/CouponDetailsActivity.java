package com.outstandingresults.loyalaz;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.ExecutionException;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.DataObjects.Coupon;
import com.outstandingresults.DataObjects.MCoupon;
import com.outstandingresults.Helpers.BusinessLayer;
import com.outstandingresults.loyalaz.animation.DisplayNextView;
import com.outstandingresults.loyalaz.animation.Flip3dAnimation;

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

public class CouponDetailsActivity  extends Activity {
	private ImageView image1;
	private ImageView image2;
	private ProgressDialog progressDialog;
	private boolean isFirstImage = true;
	private boolean moreCouponsFlag = false;
	private Coupon cpn;
	private MCoupon mcpn;
	Button buttonAdd;
	private boolean couponAdded = false;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		BugSenseHandler.initAndStartSession(this, "dffdc98f");
		setContentView(R.layout.coupondetails);


		Button buttonBack = (Button) findViewById(R.id.buttonCouponDetailsBack);

		buttonBack.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				finish();
			}
		});        		


		image1 = (ImageView) findViewById(R.id.ImageView01);
		image2 = (ImageView) findViewById(R.id.ImageView02);
		buttonAdd = (Button) findViewById(R.id.buttonCouponDetailsAdd);

		String cpn_type = getIntent().getStringExtra("CPN_TYPE");
		if(cpn_type.equals("1"))
		{
			moreCouponsFlag = true;
			mcpn = (MCoupon)getIntent().getSerializableExtra("CPN");

			//			com_id = mpg.com_id;
			//			lat = mpg.lat;
			//			lng = mpg.lng;
			buttonAdd.setBackgroundResource(R.drawable.add_button_states);
		}
		else if(cpn_type.equals("2"))
		{
			moreCouponsFlag = false;
			cpn = (Coupon)getIntent().getSerializableExtra("CPN");
			//buttonAddOrInfo.setText("Info");
			buttonAdd.setVisibility(View.INVISIBLE);
		}

		String pic_front = "";
		String pic_back = "";

		if(moreCouponsFlag)
		{
			pic_front = mcpn.pic_front;
			pic_back = mcpn.pic_back;
		}
		else
		{
			pic_front = cpn.pic_qrcode;
			pic_back = cpn.pic_back;
		}

		image1.setTag(pic_front);
		image2.setTag(pic_back);

		if(moreCouponsFlag)
		{
			LoadProgramImage(image1);
		}
		else
		{
			ShowProgramImage(image1);
		}


		buttonAdd.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				AddCoupon();
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

				if(moreCouponsFlag==false)
				{
					buttonAdd.setVisibility(View.GONE);
				}
				else
				{
					buttonAdd.setBackgroundResource(R.drawable.add_button_states);
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


private void AddCoupon()
{
	Coupon tempCpn = new Coupon();
	tempCpn.com_id = mcpn.com_id;
	tempCpn.com_city = mcpn.com_city;
	tempCpn.com_name = mcpn.com_name;
	tempCpn.com_phone = mcpn.com_phone;
	tempCpn.com_street = mcpn.com_street;
	tempCpn.com_suburb = mcpn.com_suburb;
	tempCpn.com_web1 = mcpn.com_web1;
	tempCpn.com_web2 = mcpn.com_web2;
	tempCpn.description = mcpn.description;
	tempCpn.distance = mcpn.distance;
	tempCpn.guid = mcpn.guid;
	tempCpn.id = mcpn.id;
	tempCpn.lat = mcpn.lat;
	tempCpn.lng = mcpn.lng;
	tempCpn.name = mcpn.name;
	tempCpn.pic_back = mcpn.pic_back;
	tempCpn.pic_front = mcpn.pic_front;
	tempCpn.pic_logo = mcpn.pic_logo;
	tempCpn.pic_qrcode = mcpn.pic_qrcode;
	tempCpn.typeid = mcpn.typeid;
	tempCpn.typename = mcpn.typename;
	tempCpn.xdate = mcpn.xdate;
	
	BusinessLayer businessObject = new BusinessLayer();
	if(businessObject.IsCouponExists(tempCpn)==false)
	{
		AsyncAddCoupon taskAddCoupon = new AsyncAddCoupon();
		taskAddCoupon.execute(tempCpn);
	}
	else
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		alertDialogBuilder.setTitle("LoyalAZ");
		alertDialogBuilder
		.setMessage("This coupon is already added to your list.")
		.setCancelable(false)
		.setNegativeButton("OK",new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog,int id) {
				dialog.cancel();
			}
		});
		AlertDialog alertDialog = alertDialogBuilder.create();
		alertDialog.show();
	}
	
//		if(taskAddCoupon.execute(tempCpn).get().length()>0)
//		{
//			//program added.
//			ShowAddMessage();
}

private void ShowAddMessage()
{
	final Intent in = new Intent();
	AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	alertDialogBuilder.setTitle("LoyalAZ");
	alertDialogBuilder
	.setMessage("Congratulations! Coupon added successfully to your list.")
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

private void ShowErrorMessage()
{
	final Intent in = new Intent();
	AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	alertDialogBuilder.setTitle("LoyalAZ");
	alertDialogBuilder
	.setMessage("System Error, Coupon not added.")
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

	if(moreCouponsFlag)
	{
		if(isFirstImage)
		{
			LoadProgramImage(image2);
		}
		else
		{
			LoadProgramImage(image1);
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
	String fileName = (String) targetIV.getTag();
	File imgFile = new  File(fileName);
	Bitmap myBitmap = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
	targetIV.setImageBitmap(myBitmap);
}



	private class AsyncImageDisplay extends AsyncTask<ImageView,Void,Bitmap>
	{
		ImageView targetIV;
		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			progressDialog = ProgressDialog.show(CouponDetailsActivity.this, "", "Loading Image...");
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
	
	private class AsyncAddCoupon extends AsyncTask<Coupon,Void,String>
	{
	   @Override
	   protected void onPreExecute() {
	      super.onPreExecute();
	     progressDialog = ProgressDialog.show(CouponDetailsActivity.this, "", "Wait...");
	   }

	 	
		@Override
		protected String doInBackground(Coupon... params) {
			Coupon localCpn = params[0];
			BusinessLayer businessObject = new BusinessLayer();
			String retVal = businessObject.AddCoupon(localCpn);
			return retVal;
			// TODO Auto-generated method stub
		}
		
		@Override
		protected void onPostExecute(String result) 
		{
		    super.onPostExecute(result);
		    if(result.equals("1"))
		    {
		    	couponAdded = true;
		    	ShowAddMessage();
		    }
		    else
		    {
		    	ShowErrorMessage();
		    	couponAdded = false;
		    }
		    
		   progressDialog.dismiss();
		}
	}

}
