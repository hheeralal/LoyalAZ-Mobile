package com.outstandingresults.loyalaz;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;

import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.OnInfoWindowClickListener;
import com.google.android.gms.maps.GoogleMap.OnMarkerClickListener;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.SupportMapFragment;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.DataObjects.MProgram;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.BusinessLayer;
import com.markupartist.android.widget.PullToRefreshListView;
import com.markupartist.android.widget.PullToRefreshListView.OnRefreshListener;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
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
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

public class FindProgramsActivity extends FragmentActivity implements LocationListener {

	LocationManager locationManager;
	private ProgressDialog progressDialog;
	private Location foundLocation;
	
	private ArrayList<MProgram> mprograms = null;
	private MoreProgramsAdapter m_adapter;
	
	private RelativeLayout relativeLayoutMap = null;
	private ListView lv = null;
	private HashMap<Marker, MProgram> markersHash = new HashMap<Marker, MProgram>();
	
	boolean searchInProgress = false;
//	  static final LatLng HAMBURG = new LatLng(53.558, 9.927);
//	  static final LatLng KIEL = new LatLng(53.551, 9.993);
	  private GoogleMap map;	
	
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.findprograms);
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
        
        
        
        
//            Marker hamburg = map.addMarker(new MarkerOptions().position(HAMBURG)
//                .title("Hamburg"));
//            Marker kiel = map.addMarker(new MarkerOptions()
//                .position(KIEL)
//                .title("Kiel")
//                .snippet("Kiel is cool")
//                .icon(BitmapDescriptorFactory
//                    .fromResource(R.drawable.ic_launcher)));
//
//            // Move the camera instantly to hamburg with a zoom of 15.
//            map.moveCamera(CameraUpdateFactory.newLatLngZoom(HAMBURG, 15));
//
//            // Zoom in, animating the camera.
//            map.animateCamera(CameraUpdateFactory.zoomTo(10), 2000, null);
        
        
		Button buttonRefBusiness = (Button) findViewById(R.id.buttonFindProgramsReferBusiness);
		
		buttonRefBusiness.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				NavigateToReferABusinessActivity();

			}
		});
        
        
        
		Button buttonBack = (Button) findViewById(R.id.buttonFindProgramsBack);
		
        buttonBack.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				finish();
			}
		});
        
		Button buttonCamera = (Button) findViewById(R.id.buttonFindProgramsCamera);
		
		buttonCamera.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
	    		Intent in = new Intent();
	    		setResult(6,in);
	    		finish();
			}
		});
        
		// Manually starting the FindPrograms
//		AsyncFindPrograms findPrograms = new AsyncFindPrograms();
//		findPrograms.execute();
		// Block ends here.
        

		if(ApplicationLoyalAZ.cachePrograms==false)
		{
			StartLocationUpdates();
			progressDialog = ProgressDialog.show(FindProgramsActivity.this, "", "Searching...");
			ApplicationLoyalAZ.cachePrograms = true;
		}
		else
		{
		    mprograms = (ArrayList<MProgram>) ApplicationLoyalAZ.morePrograms.MPrograms;
		    FillFindProgramsListView();
		}
        
        
        
        //UA-8952881-16
        
        lv = (ListView)findViewById(R.id.listViewMorePrograms);
        
        ((PullToRefreshListView) lv).setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh() {
                // Do work to refresh the list here.
            	searchInProgress = false;
            	progressDialog = ProgressDialog.show(FindProgramsActivity.this, "", "Searching...");
            	StartLocationUpdates();
            }
        });
        
        
        lv.setOnItemClickListener(new OnItemClickListener() {

        	@Override
        	public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
        		MProgram mpg = mprograms.get(position-1);
				//Toast.makeText(FindProgramsActivity.this, mpg.name, 500).show();
        		
				
				Intent in = new Intent("com.outstandingresultscompany.action.PROGRAMDETAILS");
				in.putExtra("PRG_TYPE", "1");
				in.putExtra("PRG", mpg);
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
    	MProgram mPrg = null;
    	Marker marker = null;
    	
    	map.setOnInfoWindowClickListener(new OnInfoWindowClickListener() {
			
			@Override
			public void onInfoWindowClick(Marker markerObject) {
				// TODO Auto-generated method stub
				MProgram mPrg = markersHash.get(markerObject);
				System.out.println("PRG="+mPrg.name);
				Intent in = new Intent("com.outstandingresultscompany.action.PROGRAMDETAILS");
				in.putExtra("PRG_TYPE", "1");
				in.putExtra("PRG", mPrg);
				startActivityForResult(in,1);

			}
		});
    	
    	LatLngBounds.Builder builder = new LatLngBounds.Builder();
    	
    	markersHash.clear();
    	
    	for(int i=0;i<ApplicationLoyalAZ.morePrograms.MPrograms.size();i++)
    	{
    		mPrg = ApplicationLoyalAZ.morePrograms.MPrograms.get(i);
    		prgLocation = new LatLng(Double.parseDouble(mPrg.lat), Double.parseDouble(mPrg.lng));
    		marker = map.addMarker(new MarkerOptions().position(prgLocation).title(URLDecoder.decode(mPrg.name)));

    		markersHash.put(marker, mPrg);
    		
    		builder.include(marker.getPosition());
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
    }
    

	private void NavigateToReferABusinessActivity()
	{
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");
		final String lat;
		final String lng;
		
		lat = Double.toString(foundLocation.getLatitude());
		lng = Double.toString(foundLocation.getLongitude());		

		// set dialog message
		alertDialogBuilder
			.setMessage("Recommend Current Location to join LoyalAZ?")
			.setCancelable(false)
			.setPositiveButton("Yes",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					dialog.dismiss();
					Intent in = new Intent("com.outstandingresultscompany.action.REFERBUSINESS");
					in.putExtra("GPS", "1");
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
//    		String text = String.format("Lat:\t %f\nLong:\t %f ", location.getLatitude(),location.getLongitude());
    		//Log.d("LOC CHANGED", text);
//    		Toast.makeText(this, text, 800).show();
    		AsyncFindPrograms findPrograms = new AsyncFindPrograms();
    		findPrograms.execute();
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
	
    private class AsyncFindPrograms extends AsyncTask<Void,Void,Void> 
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
						
			String lat,lng;
			
			lat = Double.toString(foundLocation.getLatitude());
			lng = Double.toString(foundLocation.getLongitude());
			

			
//			lat = "7.060835";
//			lng = "125.593475";
			
	    	BusinessLayer businessObject = new BusinessLayer();
	    	businessObject.FindPrograms(lat,lng);
	    	//String s = businessObject.RegisterUserStep1();
			return null;
		}
		
		@Override
		protected void onPostExecute(Void result) 
		{
		    super.onPostExecute(result);
		    mprograms = (ArrayList<MProgram>) ApplicationLoyalAZ.morePrograms.MPrograms;
	    	ListView lv = (ListView)findViewById(R.id.listViewMorePrograms);
	    	((PullToRefreshListView) lv).onRefreshComplete();
		    FillFindProgramsListView();
	    	progressDialog.dismiss();
		}
    }
    
    private void FillFindProgramsListView()
    {
    	this.m_adapter = new MoreProgramsAdapter(this,R.layout.custom_list_item, mprograms);
    	ListView lv = (ListView) findViewById(R.id.listViewMorePrograms);
    	lv.setAdapter(new MoreProgramsAdapter(this,R.layout.custom_list_item, mprograms));
    }
    
    
    private class MoreProgramsAdapter extends ArrayAdapter<MProgram> {

    	private ArrayList<MProgram> items;


    	public MoreProgramsAdapter(Context context, int textViewResourceId,
    			ArrayList<MProgram> items) {
    		super(context, textViewResourceId, items);
    		this.items = items;
    	}


    	@Override
    	public View getView(int position, View convertView, ViewGroup parent) {
    		View v = convertView;
    		if (v == null) {
    			LayoutInflater vi = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    			v = vi.inflate(R.layout.findprograms_listitem, null);
    			v.setMinimumHeight(90);
    			
    		}
    		
    		MProgram mpg = items.get(position);
    		if (mpg != null) {
    			TextView tvName = (TextView) v.findViewById(R.id.textView_FPName);
    			TextView tvDescription = (TextView) v.findViewById(R.id.textView_FPDescription);
    			TextView tvAddress = (TextView) v.findViewById(R.id.textView_FPAddress);
    			TextView tvDistance = (TextView) v.findViewById(R.id.textView_FPDistance);
    			ImageView iv = (ImageView) v.findViewById(R.id.imageViewFPLogo);
    			ImageView ivPrgType = (ImageView) v.findViewById(R.id.ivPrgType);
    			
    			if(mpg.c.length()>0)
    			{
    				 v.setBackgroundColor(Color.parseColor(mpg.c));
    			}
    			
    			//Log.d("COLOR",mpg.c);
    			
    			
    			if (tvName != null) {
    				tvName.setText(URLDecoder.decode(mpg.name));
    				tvDescription.setText(URLDecoder.decode(mpg.description));
    				tvDistance.setText(mpg.distance + " km");
    				tvAddress.setText(mpg.com_street+", "+mpg.com_suburb);
    				//System.out.println("LOGO====="+mpg.pic_front);
    				iv.setTag(mpg.pic_logo);
    				
    				if(mpg.type.equals("3"))
    				{
    					ivPrgType.setImageResource(R.drawable.type_savings);
    				}
    				else
    				{
    					ivPrgType.setImageResource(R.drawable.type_basic);
    				}
    				
    				Typeface typeFace=Typeface.createFromAsset(getAssets(),"fonts/opensans-extrabold.ttf");
    				tvName.setTypeface(typeFace);
    				
    				typeFace=Typeface.createFromAsset(getAssets(),"fonts/open-sans.light.ttf");
    				tvDescription.setTypeface(typeFace);
    				tvDistance.setTypeface(typeFace);
    				tvAddress.setTypeface(typeFace);

    				AsyncImageDisplay imgDisp = new AsyncImageDisplay();
    				imgDisp.execute(iv);
//    				URL url = null;
//					try {
//						url = new URL(o.pic_logo);
//						
//					} catch (MalformedURLException e) {
//						// TODO Auto-generated catch block
//						e.printStackTrace();
//					}
//    				Bitmap bmp = null;
//					try {
//						bmp = BitmapFactory.decodeStream(url.openConnection().getInputStream());
//					} catch (IOException e) {
//						// TODO Auto-generated catch block
//						e.printStackTrace();
//					}
//    				iv.setImageBitmap(bmp);
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
//					System.out.println("LOGO====="+logo);
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


}
