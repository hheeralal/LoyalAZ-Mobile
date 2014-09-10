package com.outstandingresults.loyalaz;

import java.io.IOException;
import java.util.ArrayList;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.DataObjects.Countries;
import com.outstandingresults.DataObjects.Country;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.Helper;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

public class RegisterUserStep2Activity extends Activity {

	private ArrayList<Country> countriesArray = null;
	private CountryAdapter m_adapter;
	private EditText textMobileNumber;
	private EditText textCity;
	private Countries countries;
	private Country selectedCountry;
	private Spinner spinner ;
	
	@Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        countries = Helper.GetCountriesFromXML();
        System.out.println(countries.countries.size());
        countriesArray =(ArrayList<Country>) countries.countries;
        
        setContentView(R.layout.registeruserstep2);
        selectedCountry = null;
        this.m_adapter = new CountryAdapter(this,R.layout.custom_spinner_item, countriesArray);
        spinner = (Spinner) findViewById(R.id.spinnerCountry);
        //spinner.setAdapter(new CountryAdapter(this,R.layout.custom_spinner_item, countriesArray));
        //m_adapter.setDropDownViewResource(R.layout.custom_spinner_item);
        spinner.setAdapter(m_adapter);
        
        spinner.setOnItemSelectedListener(new OnItemSelectedListener() {
        	@Override
        	public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
                // your code here
            	selectedCountry = countries.countries.get(position);
            	Log.d("SEL COUNTRY", selectedCountry.name);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parentView) {
                // your code here
            	selectedCountry = null;
            }

        });
        
        Button buttonNext = (Button)findViewById(R.id.buttonRegUserStep2Next);
        
        BindControls();
        
        buttonNext.setOnClickListener(new View.OnClickListener() {
			
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if(ValidateData())
				{
					RegisterUser();
				}
			}
		});
        
        /*
        Spinner spinner = (Spinner) findViewById(R.id.spinner1);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(
                this, R.array.card_type, R.layout.custom_spinner_item);
        adapter.setDropDownViewResource(R.layout.custom_spinner_dropdown_item);
        spinner.setAdapter(adapter);
        */
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
    	textMobileNumber = (EditText)findViewById(R.id.editTextMobileNumber);
    	textCity = (EditText)findViewById(R.id.editTextCity);
    	
        Button buttonHintMobile = (Button)findViewById(R.id.buttonHintMobile);
        buttonHintMobile.setOnClickListener(new View.OnClickListener() {
			
        	@Override
			public void onClick(View v) {
        		Toast toast=Toast.makeText(RegisterUserStep2Activity.this, "In unlikely event of losing all the app data or your phone you can recover all your accumulated points by requesting a ‘restore’ SMS to your mobile.", Toast.LENGTH_LONG);
        		int yOffset = getAbsolutePositionY(textMobileNumber) - 10;
        		toast.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL, 0, yOffset);
        		toast.show();
        	}
        });
        
        
        Button buttonHintCity = (Button)findViewById(R.id.buttonHintCity);
        buttonHintCity.setOnClickListener(new View.OnClickListener() {
			
        	@Override
			public void onClick(View v) {
        		Toast toast=Toast.makeText(RegisterUserStep2Activity.this, "You will receive only programs in your locality – no more annoying marketing without your permission.", Toast.LENGTH_LONG);
        		int yOffset = getAbsolutePositionY(textCity) - 10;
        		toast.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL, 0, yOffset);
        		toast.show();
        	}
        });            	
    }
    
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
    	//Log.d("REGISTER", "TRUE");
    	try {
			Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
			Log.d("REG_USER_STEP2","DONE");
			startActivityForResult(new Intent("com.outstandingresultscompany.action.ENABLELOCATIONS"), 3);

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) 
    {
    	//Log.d("CheckStartActivity","onActivityResult and resultCode = "+resultCode);
    	// TODO Auto-generated method stub
    	super.onActivityResult(requestCode, resultCode, data);
    	Intent in = new Intent();
    	setResult(2,in);
    	finish();
    }
    
    private boolean ValidateData()
    {
    	boolean valid=false;
    	//ApplicationLoyalAZ.loyalaz = new LoyalAZ();
    	

    	StringBuilder sb = new StringBuilder();
    	
    	if(textMobileNumber.getText().length() ==0)
    	{
    		valid = false;
    		sb.append("Mobile number is required.");
    	}
    	else if(textCity.getText().length() ==0)
    	{
    		valid = false;
    		sb.append("City can't be blank.");
    	}
    	else if(spinner.getSelectedItemPosition()<=0)
    	{
    		valid = false;
    		sb.append("Country can't be blank.");
    	}
    	else
    	{
    		valid=true;
    		selectedCountry = countries.countries.get(spinner.getSelectedItemPosition());
	    	String mobileNumber = "";
	    	mobileNumber = mobileNumber.concat(selectedCountry.code);
	    	mobileNumber = mobileNumber.concat("-");
	    	mobileNumber = mobileNumber.concat(textMobileNumber.getText().toString());
	    	ApplicationLoyalAZ.loyalaz.User.addresscity = textCity.getText().toString();
	    	ApplicationLoyalAZ.loyalaz.User.addresscountry = selectedCountry.name;
	    	ApplicationLoyalAZ.loyalaz.User.mobilephone = mobileNumber;
    	}

    	
    	
    	if(valid==false)
    	{
    		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
     
    			alertDialogBuilder.setTitle("Validation");
     
    			// set dialog message
    			alertDialogBuilder
    				.setMessage(sb.toString())
    				.setCancelable(false)
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
    	
    	return valid;
    }
    
    
    private class CountryAdapter extends ArrayAdapter<Country> {

    	private ArrayList<Country> items;

    	public CountryAdapter(Context context, int textViewResourceId,
    			ArrayList<Country> items) {
    		super(context, textViewResourceId, items);
    		this.items = items;
    	}

    	@Override
    	public View getDropDownView(int position, View convertView,
    	ViewGroup parent) {
    	// TODO Auto-generated method stub
    		View v = convertView;
    		if (v == null) {
    			LayoutInflater vi = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    			v = vi.inflate(R.layout.custom_spinner_item, null);
    		}
    		
    		Country o = items.get(position);
    		if (o != null) {
    			TextView tvCountryName = (TextView) v.findViewById(R.id.textViewCountryName);
    			TextView tvCountryCode = (TextView) v.findViewById(R.id.textViewCountryCode);


    			if (tvCountryName != null) {
    				tvCountryName.setText(o.name);
    				tvCountryCode.setText(o.code);
    				// ivIcon.setImageResource(R.drawable.folder);
    			}
    		}
    		return v;
    	}

    	@Override
    	public View getView(int position, View convertView, ViewGroup parent) {
    		View v = convertView;
    		if (v == null) {
    			LayoutInflater vi = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    			v = vi.inflate(R.layout.custom_spinner_item, null);
    		}
    		
    		Country o = items.get(position);
    		if (o != null) {
    			TextView tvCountryName = (TextView) v.findViewById(R.id.textViewCountryName);
    			TextView tvCountryCode = (TextView) v.findViewById(R.id.textViewCountryCode);


    			if (tvCountryName != null) {
    				tvCountryName.setText(o.name);
    				tvCountryCode.setText(o.code);
    				// ivIcon.setImageResource(R.drawable.folder);
    			}
    		}
    		return v;
    	}
    }
}
