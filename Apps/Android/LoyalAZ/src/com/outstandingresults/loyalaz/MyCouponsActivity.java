package com.outstandingresults.loyalaz;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.DataObjects.Coupon;
import com.outstandingresults.DataObjects.MCoupon;
import com.outstandingresults.DataObjects.Program;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.BusinessLayer;
import com.outstandingresults.Helpers.Helper;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.AsyncTask;
import android.os.Bundle;
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

public class MyCouponsActivity  extends Activity  
{

	private CouponsAdapter m_adapter;
	private ProgressDialog progressDialog;
	private ArrayList<Coupon> coupons = null;
	private String uid;
	private String couponId;
	private int couponIndex;

    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.mycoupons);
        
        //System.out.println(ApplicationLoyalAZ.loyalaz.coupons.size());
        
		Button buttonBack = (Button) findViewById(R.id.buttonMyCouponsBack);
		
        buttonBack.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				finish();
			}
		});
    

        ListView lv = (ListView)findViewById(R.id.listViewMyCoupons);
        
        FillMyCouponsListView();
        
        
       
        
        lv.setOnItemClickListener(new OnItemClickListener() {

        	@Override
        	public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				
        		System.out.println("CCCCCCCCCCC");
        		
					Coupon cpn = coupons.get(position);
					Intent in = new Intent("com.outstandingresultscompany.action.COUPONDETAILS");
					in.putExtra("CPN_TYPE", "2");
					in.putExtra("CPN", cpn);
					startActivity(in);
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
    
    
    private void FillMyCouponsListView()
    {
    	
		if(ApplicationLoyalAZ.loyalaz.coupons==null)
			ApplicationLoyalAZ.loyalaz.coupons = new ArrayList<Coupon>();
    	
    	coupons = (ArrayList<Coupon>) ApplicationLoyalAZ.loyalaz.coupons;
    	this.m_adapter = new CouponsAdapter(this,R.layout.listitem_coupon, coupons);
    	ListView lv = (ListView) findViewById(R.id.listViewMyCoupons);
    	lv.setAdapter(new CouponsAdapter(this,R.layout.listitem_coupon, coupons));
    }
    
    private void ShowCouponDetails(Coupon cpn)
    {
		Intent in = new Intent("com.outstandingresultscompany.action.COUPONDETAILS");
		in.putExtra("CPN_TYPE", "2");
		Toast.makeText(MyCouponsActivity.this,cpn.id,500).show();
		in.putExtra("CPN", cpn);
		startActivity(in);
    }
    
    
    private class CouponsAdapter extends ArrayAdapter<Coupon> {

    	private ArrayList<Coupon> items;


    	public CouponsAdapter(Context context, int textViewResourceId,
    			ArrayList<Coupon> items) {
    		super(context, textViewResourceId, items);
    		this.items = items;
    	}

    	
    	@Override
    	public View getView(final int position, View convertView, ViewGroup parent) {
    		View v = convertView;
    		if (v == null) {
    			LayoutInflater vi = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    			//v = vi.inflate(R.layout.custom_list_item, null);
    			//v = vi.inflate(R.layout.listitem_coupon, parent,false);
    			v = vi.inflate(R.layout.listitem_coupon, null);
    			v.setMinimumHeight(90);
    			//v = vi.inflate(R.layout.listitem_coupon, null);
    		}
//    		couponIndex = position;
    		final Coupon cpn = items.get(position);
    		if (cpn != null) {
    			TextView tvName = (TextView) v.findViewById(R.id.textView_CpnName);
    			TextView tvDescription = (TextView) v.findViewById(R.id.textView_CpnDescription);
    			TextView tvDistance = (TextView) v.findViewById(R.id.textView_CpnDistance);
    			ImageView iv = (ImageView) v.findViewById(R.id.imageViewCpnLogo);
    			Button buttonDelete = (Button)v.findViewById(R.id.buttonCpnDelete);
    			
				Typeface typeFace=Typeface.createFromAsset(getAssets(),"fonts/opensans-extrabold.ttf");
				tvName.setTypeface(typeFace);
				
				typeFace=Typeface.createFromAsset(getAssets(),"fonts/open-sans.light.ttf");
				tvDescription.setTypeface(typeFace);
				tvDistance.setTypeface(typeFace);    			
    			
    			if(cpn.c.length()>0)
    			{
    				 v.setBackgroundColor(Color.parseColor(cpn.c));
    			}    			
    			
    			/*
    			v.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						Coupon cpn = coupons.get(couponIndex);
						ShowCouponDetails(cpn);
					}
				});
    			*/
    			
    			buttonDelete.setOnClickListener(new View.OnClickListener() {
    				
    				@Override
    				public void onClick(View v) {
    					Coupon cpn1 = items.get(position);
    					uid = ApplicationLoyalAZ.loyalaz.User.uid;
    					couponId = cpn1.id;
    					couponIndex = position;
//    					System.out.println("Id===="+couponIndex+"POS====="+position);
//    					Toast.makeText(MyCouponsActivity.this, couponId, 500).show();
    					
    					AsyncRemoveCoupon removeTask = new AsyncRemoveCoupon();
    					removeTask.execute(null);
    					
    					// TODO Auto-generated method stub
    					//finish();
    					//System.out.println("Delete===" + cpn.name);
    				}
    			});
    			
    			
    			if (tvName != null) {
    				tvName.setText(URLDecoder.decode(cpn.name));
    				tvDescription.setText(URLDecoder.decode(cpn.description));
    				tvDistance.setText("Distance: "+URLDecoder.decode(cpn.distance) + " km");
    				//tvDistance.setText(" km");
    				//iv.setImageURI(prg.pic_logo);
    				//System.out.println("LOGO====="+mpg.pic_front);
        			File imgFile = new  File(cpn.pic_logo);
        			Bitmap myBitmap = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
        			System.out.println(imgFile.getAbsolutePath());
        			iv.setImageBitmap(myBitmap);
    			}
    		}
    		return v;
    	}
    }
    
    
    private class AsyncRemoveCoupon extends AsyncTask<Void,Void,Void> 
    {

    	
    	@Override

    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	      progressDialog = ProgressDialog.show(MyCouponsActivity.this, "", "Deleting...");
    	      //displayProgressBar("Downloading...");
    	   }

    	
		@Override
		protected Void doInBackground(Void... params) {
			// TODO Auto-generated method stub
	    	BusinessLayer businessObject = new BusinessLayer();
	    	businessObject.RemoveUserCoupon(uid, couponId);
			return null;
		}
		
		@Override
		protected void onPostExecute(Void result) 
		{
		    super.onPostExecute(result);
		    ApplicationLoyalAZ.loyalaz.coupons.remove(couponIndex);
		    
		    try {
				Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    
		    
		    FillMyCouponsListView();
	    	progressDialog.dismiss();
	    	
		}
    }

}
