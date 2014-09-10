package com.outstandingresults.loyalaz;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.OnInfoWindowClickListener;
import com.google.android.gms.maps.GoogleMap.OnMarkerClickListener;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.markupartist.android.widget.PullToRefreshListView;
import com.markupartist.android.widget.PullToRefreshListView.OnRefreshListener;
import com.outstandingresults.DataObjects.MCoupon;
import com.outstandingresults.DataObjects.MProgram;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.BusinessLayer;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Typeface;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.CompoundButton.OnCheckedChangeListener;

public class FindCouponsActivity  extends FragmentActivity implements LocationListener,OnMarkerClickListener {

	LocationManager locationManager;
	private ProgressDialog progressDialog;
	private Location foundLocation;
	
	private ArrayList<MCoupon> mcoupons = null;
	private MoreCouponsAdapter m_adapter;
	private RelativeLayout relativeLayoutMap = null;
	private ListView lv = null;
	private GoogleMap map;
	private HashMap<Marker, MCoupon> markersHash = new HashMap<Marker, MCoupon>();
	
	
	boolean searchInProgress = false;
	
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.findcoupons);
        searchInProgress = false;
        
        map = ((SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map)).getMap();
        
        relativeLayoutMap = (RelativeLayout) findViewById(R.id.relativeLayoutMap);
        
        relativeLayoutMap.setVisibility(View.GONE);
        
        ToggleButton toggleButtonViewType = (ToggleButton) findViewById(R.id.toggleButtonViewType);
        toggleButtonViewType.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			
			@Override
			public void onCheckedChanged(CompoundButton arg0, boolean arg1) {
				// TODO Auto-generated method stub
				if(arg1==true)
				{
					//relativeLayoutMap.setVisibility(View.GONE);
					ShowMapView();
				}
				else
				{
					//relativeLayoutMap.setVisibility(View.VISIBLE);
					ShowListView();
				}
			}
		});
        
		Button buttonBack = (Button) findViewById(R.id.buttonFindCouponsBack);
		
        buttonBack.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				finish();
			}
		});
        
//		Button buttonCamera = (Button) findViewById(R.id.buttonFindProgramsCamera);
//		
//		buttonCamera.setOnClickListener(new View.OnClickListener() {
//			
//			@Override
//			public void onClick(View v) {
//				// TODO Auto-generated method stub
//	    		Intent in = new Intent();
//	    		setResult(6,in);
//	    		finish();
//			}
//		});
        if(ApplicationLoyalAZ.cacheCoupons==false)
        {
        	StartLocationUpdates();
        	progressDialog = ProgressDialog.show(FindCouponsActivity.this, "", "Searching...");
        	ApplicationLoyalAZ.cacheCoupons=true;
        }
        else
        {
		    mcoupons = (ArrayList<MCoupon>) ApplicationLoyalAZ.moreCoupons.MCoupons;
		    FillFindCouponsListView();
        }

        
        
        
        lv = (ListView)findViewById(R.id.listViewMoreCoupons);

        ((PullToRefreshListView) lv).setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh() {
                // Do work to refresh the list here.
            	searchInProgress = false;
            	progressDialog = ProgressDialog.show(FindCouponsActivity.this, "", "Searching...");
            	StartLocationUpdates();
            }
        });
        
        //View scrollableView = findViewById(R.id.blah); 

        // Create a PullToRefreshAttacher instance
        //mPullToRefreshAttacher = PullToRefreshAttacher.get(this);

        // Add the Refreshable View and provide the refresh listener
        //mPullToRefreshAttacher.addRefreshableView(lv, this);        
                
        lv.setOnItemClickListener(new OnItemClickListener() {

        	@Override
        	public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				
				MCoupon mcpn = mcoupons.get(position-1);
				Intent in = new Intent("com.outstandingresultscompany.action.COUPONDETAILS");
				in.putExtra("CPN_TYPE", "1");
				in.putExtra("CPN", mcpn);
				startActivityForResult(in,1);
				// TODO Auto-generated method stub
				//Toast.makeText(getApplicationContext(),"Selected:"+ s,Toast.LENGTH_SHORT).show();
			}
		});
    }
    
    private void ShowMapView()
    {
    	lv.setVisibility(View.GONE);
    	relativeLayoutMap.setVisibility(View.VISIBLE);
    	
    	map.clear();
    	LatLng prgLocation = null;
    	MCoupon mCpn = null;
    	Marker marker = null;
    	
    	LatLngBounds.Builder builder = new LatLngBounds.Builder();
    	markersHash.clear();
    	
    	map.setOnInfoWindowClickListener(new OnInfoWindowClickListener() {
			
			@Override
			public void onInfoWindowClick(Marker markerObject) {
				// TODO Auto-generated method stub
				MCoupon mCpn = markersHash.get(markerObject);
				System.out.println("PRG="+mCpn.name);
				Intent in = new Intent("com.outstandingresultscompany.action.COUPONDETAILS");
				in.putExtra("CPN_TYPE", "1");
				in.putExtra("CPN", mCpn);
				startActivityForResult(in,1);

			}
		});
    	
    	for(int i=0;i<ApplicationLoyalAZ.moreCoupons.MCoupons.size();i++)
    	{
    		mCpn = ApplicationLoyalAZ.moreCoupons.MCoupons.get(i);
    		prgLocation = new LatLng(Double.parseDouble(mCpn.lat), Double.parseDouble(mCpn.lng));
    		marker = map.addMarker(new MarkerOptions().position(prgLocation).title(URLDecoder.decode(mCpn.name)));
    		builder.include(marker.getPosition());
    		
    		markersHash.put(marker, mCpn);
    	}
    	if(builder!=null)
    	{
    	LatLngBounds bounds = builder.build();
    	
    	int padding = 0; // offset from edges of the map in pixels
    	final CameraUpdate cu = CameraUpdateFactory.newLatLngBounds(bounds, padding);
    	
    	
    	map.setOnMapLoadedCallback(new GoogleMap.OnMapLoadedCallback() {
    	    @Override
    	    public void onMapLoaded() {
    	        //map.moveCamera(CameraUpdateFactory.newLatLngBounds(bounds, 30));
    	    	map.moveCamera(cu);
    	    }
    	});
    	}
    	
    	
    	
//    	map.moveCamera(CameraUpdateFactory.newLatLngZoom(prgLocation, 15));
    }
    
    private void ShowListView()
    {
    	lv.setVisibility(View.VISIBLE);
    	relativeLayoutMap.setVisibility(View.GONE);
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
    
    
    private void StartLocationUpdates()
    {
        locationManager = (LocationManager)this.getSystemService(LOCATION_SERVICE);
        locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0,0, this);
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0,0, this);
        
//		AsyncFindCoupons findCoupons = new AsyncFindCoupons();
//		findCoupons.execute();
        
    }
    

    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) 
    {
    	//Log.d("CheckStartActivity","onActivityResult and resultCode = "+resultCode);
    	// TODO Auto-generated method stub
    	super.onActivityResult(requestCode, resultCode, data);
    	if(resultCode==5) // Program added successfully from Program Details activity.
    	{
    		Intent in = new Intent();
    		setResult(5,in);
    		finish();
    	}
    	else if(resultCode==7) // returned back from Refer Business Activity.
    	{
    		finish();
    	}
    }
    
    @Override
	public void onLocationChanged(Location location) {
		// TODO Auto-generated method stub
    	Log.d("GPS", "working");
    	if(searchInProgress==false)
    	{
    		searchInProgress = true;
    		foundLocation = location;
    		String text = String.format("Lat:\t %f\nLong:\t %f ", location.getLatitude(),location.getLongitude());
    		//Log.d("LOC CHANGED", text);
    		Toast.makeText(this, text, 800).show();
    		AsyncFindCoupons findCoupons = new AsyncFindCoupons();
    		findCoupons.execute();
    	}
	}


    @Override
	public void onProviderDisabled(String arg0) {
		// TODO Auto-generated method stub
		
	}


    @Override
	public void onProviderEnabled(String arg0) {
		// TODO Auto-generated method stub
		
	}


    @Override
	public void onStatusChanged(String arg0, int arg1, Bundle arg2) {
		// TODO Auto-generated method stub
		
	}
	
	
	
	// class to handle the Aysnc process for programs search
	
    private class AsyncFindCoupons extends AsyncTask<Void,Void,Void> 
    {

    	
    	@Override

    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	      //progressDialog = ProgressDialog.show(FindProgramsActivity.this, "", "Searching...");
    	      //displayProgressBar("Downloading...");
    	   }

    	
		@Override
		protected Void doInBackground(Void... params) {
			// TODO Auto-generated method stub
			
			//-36.771816

			//174.746521
			
			String lat,lng;
			
			lat = Double.toString(foundLocation.getLatitude());
			lng = Double.toString(foundLocation.getLongitude());
			
//			lat = "7.060835";
//			lng = "125.593475";
			
	    	BusinessLayer businessObject = new BusinessLayer();
	    	businessObject.FindCoupons(lat,lng);
	    	//String s = businessObject.RegisterUserStep1();
			return null;
		}
		
		@Override
		protected void onPostExecute(Void result) 
		{
		    super.onPostExecute(result);
		    mcoupons = (ArrayList<MCoupon>) ApplicationLoyalAZ.moreCoupons.MCoupons;
		    FillFindCouponsListView();
	    	ListView lv = (ListView)findViewById(R.id.listViewMoreCoupons);
	    	((PullToRefreshListView) lv).onRefreshComplete();
	    	progressDialog.dismiss();
		}
    }
    
    private void FillFindCouponsListView()
    {
    	this.m_adapter = new MoreCouponsAdapter(this,R.layout.custom_list_item, mcoupons);
    	ListView lv = (ListView) findViewById(R.id.listViewMoreCoupons);
    	lv.setAdapter(new MoreCouponsAdapter(this,R.layout.custom_list_item, mcoupons));
    }
    
    
    private class MoreCouponsAdapter extends ArrayAdapter<MCoupon> {

    	private ArrayList<MCoupon> items;


    	public MoreCouponsAdapter(Context context, int textViewResourceId,
    			ArrayList<MCoupon> items) {
    		super(context, textViewResourceId, items);
    		this.items = items;
    	}


    	@Override
    	public View getView(int position, View convertView, ViewGroup parent) {
    		View v = convertView;
    		if (v == null) {
    			LayoutInflater vi = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    			//v = vi.inflate(R.layout.custom_list_item, null);
    			//v = vi.inflate(R.layout.listitem_coupon, parent,false);
    			v = vi.inflate(R.layout.findcoupons_listitem, null);
    			v.setMinimumHeight(90);
    		}
    		
    		MCoupon mcpn = items.get(position);
    		if (mcpn != null) {
    			TextView tvName = (TextView) v.findViewById(R.id.textView_CpnName);
    			TextView tvDescription = (TextView) v.findViewById(R.id.textView_CpnDescription);
    			TextView tvDistance = (TextView) v.findViewById(R.id.textView_CpnDistance);
    			TextView tvAddress = (TextView) v.findViewById(R.id.textView_CpnAddress);
    			ImageView iv = (ImageView) v.findViewById(R.id.imageViewCpnLogo);
    			Button buttonDelete = (Button)v.findViewById(R.id.buttonCpnDelete);
    			buttonDelete.setVisibility(View.GONE);
    			
    			if(mcpn.c.length()>0)
    			{
    				 v.setBackgroundColor(Color.parseColor(mcpn.c));
    			}
    			
    			
    			if (tvName != null) {
    				tvName.setText(URLDecoder.decode(mcpn.name));
    				tvDescription.setText(URLDecoder.decode(mcpn.description));
    				tvAddress.setText(URLDecoder.decode(mcpn.com_street)+", "+URLDecoder.decode(mcpn.com_suburb));
    				tvDistance.setText("Distance: " + URLDecoder.decode(mcpn.distance) + " km");
    				//System.out.println("LOGO====="+mcpn.pic_front);
    				iv.setTag(mcpn.pic_logo);
    				AsyncImageDisplay imgDisp = new AsyncImageDisplay();
    				imgDisp.execute(iv);
    				
    				Typeface typeFace=Typeface.createFromAsset(getAssets(),"fonts/opensans-extrabold.ttf");
    				tvName.setTypeface(typeFace);
    				
    				typeFace=Typeface.createFromAsset(getAssets(),"fonts/open-sans.light.ttf");
    				tvDescription.setTypeface(typeFace);
    				tvDistance.setTypeface(typeFace);
    				tvAddress.setTypeface(typeFace);
    				
    			}
    		}
    		return v;
    	}
    	
    	private class AsyncImageDisplay extends AsyncTask<ImageView,Void,Bitmap>
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
					String logo =(String) params[0].getTag();
					this.targetIV = params[0];
					System.out.println("LOGO====="+logo);
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
	 		}
    	}
    }

	@Override
	public boolean onMarkerClick(Marker arg0) {
		// TODO Auto-generated method stub
		return false;
	}


}
