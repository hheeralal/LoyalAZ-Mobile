package com.outstandingresults.loyalaz;

import java.io.IOException;
import java.util.ArrayList;
import java.util.concurrent.ExecutionException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.DataObjects.Countries;
import com.outstandingresults.DataObjects.Country;
import com.outstandingresults.DataObjects.LoyalAZ;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.BusinessLayer;
import com.outstandingresults.Helpers.Helper;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.AdapterView.OnItemSelectedListener;

public class SetupActivity extends Activity {

	
	private EditText textFirstName;
	private EditText textLastName;
	private EditText textEmailId;
	private ArrayList<Country> countriesArray = null;
	private CountryAdapter m_adapter;
	private EditText textMobileNumber;
	private EditText textCity;
	private Countries countries;
	private Country selectedCountry;
	private Spinner spinner ;
	private RadioGroup radioLocationGroup;
	private RadioGroup radioFacebookGroup;
	private CheckBox checkBoxLocationServices;
	private CheckBox checkBoxFBPosts;
	
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.setup);
        Button buttonNext = (Button)findViewById(R.id.buttonSetupNext);
        
        countries = Helper.GetCountriesFromXML();
        System.out.println(countries.countries.size());
        countriesArray =(ArrayList<Country>) countries.countries;
        selectedCountry = null;
        this.m_adapter = new CountryAdapter(this,R.layout.custom_spinner_item, countriesArray);
        spinner = (Spinner) findViewById(R.id.spinnerSetupCountry);
        //spinner.setAdapter(new CountryAdapter(this,R.layout.custom_spinner_item, countriesArray));
        //m_adapter.setDropDownViewResource(R.layout.custom_spinner_item);
        spinner.setAdapter(m_adapter);
        BindControls();
        
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
        
		Button buttonShowTutorial = (Button) findViewById(R.id.buttonShowTutorial);
		
		buttonShowTutorial.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent in = new Intent();
				setResult(9,in);
				finish();
			}
		});        
        
		Button buttonBack = (Button) findViewById(R.id.buttonSetupBack);
		
        buttonBack.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				finish();
			}
		});
        
		Button buttonSync = (Button) findViewById(R.id.buttonSync);
		
		buttonSync.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				SyncData();
			}
		});
		
		Button buttonDelete = (Button) findViewById(R.id.buttonDeleteAccount);
		
		buttonDelete.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				ConfirmDelete();
			}
		});		
        
        
        buttonNext.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				
//				ApplicationLoyalAZ.loyalaz.programs.clear();
//				ApplicationLoyalAZ.loyalaz.enableFBPost = "1";
//				try {
//					Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
//				} catch (IOException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
				
				
				if(ValidateData())
				{
					SaveData();
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

    
    private void ConfirmDelete()
    {
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");

		// set dialog message
		alertDialogBuilder
			.setMessage("All your account data will be deleted. You will not be able to retrieve your rewards with 'Restore'. Proceed?")
			.setCancelable(false)
			
			.setPositiveButton("Yes",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					// if this button is clicked, just close
					// the dialog box and do nothing
					dialog.dismiss();
					ConfirmDeleteAgain();
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
    
    private void ConfirmDeleteAgain()
    {
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");

		// set dialog message
		alertDialogBuilder
			.setMessage("Confirm Delete: All your data will be deleted. are you sure?")
			.setCancelable(false)
			
			.setPositiveButton("Yes",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					// if this button is clicked, just close
					// the dialog box and do nothing
					dialog.dismiss();
					DeleteAccount();
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
    
    private void DeleteAccount()
    {
    	AsyncDeleteAccount taskDelete = new AsyncDeleteAccount();
    	taskDelete.execute(null);
    }
    
    private class AsyncDeleteAccount extends AsyncTask<Void,Void,String>
    {
    	@Override

 	   protected void onPreExecute() {
 	      super.onPreExecute();
 	   }

 	
		@Override
		protected String doInBackground(Void... params) {
			// TODO Auto-generated method stub
	    	BusinessLayer businessObject = new BusinessLayer();
	    	String s = businessObject.DeleteAccount();
	    	return s;
		}
		
		@Override
		protected void onPostExecute(String result) 
		{
		    super.onPostExecute(result);
		    if(result.equals("1"))
		    {
		    	ShowDeletionMessage();
		    }
		}
    }
    
    private void ShowDeletionMessage()
    {
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");

		// set dialog message
		alertDialogBuilder
			.setMessage("You have successfully deleted your Profile.")
			.setCancelable(false)
			
			.setPositiveButton("OK",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					// if this button is clicked, just close
					// the dialog box and do nothing
					dialog.dismiss();
					BusinessLayer businessObject = new BusinessLayer();
					businessObject.DeleteAllFiles();
					
					Intent in = new Intent();
					setResult(4,in);
					finish();					
				}
			});

			// create alert dialog
			AlertDialog alertDialog = alertDialogBuilder.create();
			// show it
			alertDialog.show();
    }
    
    private void BindControls()
    {
    	textFirstName = (EditText)findViewById(R.id.textSetupFirstName);
    	textLastName = (EditText)findViewById(R.id.textSetupLastName);
    	textEmailId = (EditText)findViewById(R.id.textSetupEmail);
    	textMobileNumber = (EditText)findViewById(R.id.editTextSetupMobileNumber);
    	textCity = (EditText)findViewById(R.id.editTextSetupCity);
    	checkBoxLocationServices = (CheckBox)findViewById(R.id.checkBoxLocation);
    	checkBoxFBPosts = (CheckBox)findViewById(R.id.checkBoxFBPosts);
    	
    	
    	
    	textFirstName.setText(ApplicationLoyalAZ.loyalaz.User.firstname);
    	textLastName.setText(ApplicationLoyalAZ.loyalaz.User.lastname);
    	textEmailId.setText(ApplicationLoyalAZ.loyalaz.User.email);
    	textCity.setText(ApplicationLoyalAZ.loyalaz.User.addresscity);
    	
    	String textProviderCode="";
    	String textNumber="";
    	//split the phone number on - and set the values
    	String[] phoneValues = ApplicationLoyalAZ.loyalaz.User.mobilephone.split("\\-");
    	textNumber = phoneValues[1];
    	textMobileNumber.setText(textNumber);
    	
    	if(ApplicationLoyalAZ.loyalaz.find_enable.equals("1"))
    		checkBoxLocationServices.setChecked(true);
    	else
    		checkBoxLocationServices.setChecked(false);
    	
    	if(ApplicationLoyalAZ.loyalaz.enableFBPost.equals("1"))
    		checkBoxFBPosts.setChecked(true);
    	else
    		checkBoxFBPosts.setChecked(false);
    		
    	
    	Country selCountry = new Country();
    	selCountry.code = phoneValues[0];
    	selCountry.name = ApplicationLoyalAZ.loyalaz.User.addresscountry;
    	for(int i=0;i<countriesArray.size();i++)
    	{
    		if(selCountry.equals(countriesArray.get(i)))
    		{
    			spinner.setSelection(i, true);
    			break;
    		}
    	}
    	//select the country from spinner.
    }
    
    private void SaveData()
    {
    	finish();
    }
    
    private void SyncData()
    {
        if(Helper.IsNetworkAvailable())
        {
            AsyncSyncDB syncTask = new AsyncSyncDB();
            try {
    			syncTask.execute(null).get();
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
			AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
			alertDialogBuilder.setTitle("LoyalAZ");
			alertDialogBuilder
			.setMessage("Internet connection is required.")
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
    
    private boolean ValidateData()
    {
    	boolean valid=false;
    	//ApplicationLoyalAZ.loyalaz = new LoyalAZ();
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
    	else if(textMobileNumber.getText().length() ==0)
    	{
    		valid = false;
    		sb.append("Mobile phone can't be blank.");
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
    	
    	if(valid==true)
    	{
    		selectedCountry = countries.countries.get(spinner.getSelectedItemPosition());
	    	String mobileNumber = "";
	    	mobileNumber = mobileNumber.concat(selectedCountry.code);
	    	mobileNumber = mobileNumber.concat("-");
	    	mobileNumber = mobileNumber.concat(textMobileNumber.getText().toString());
	    	ApplicationLoyalAZ.loyalaz.User.addresscity = textCity.getText().toString();
	    	ApplicationLoyalAZ.loyalaz.User.mobilephone = mobileNumber;  
	    	ApplicationLoyalAZ.loyalaz.User.addresscountry = selectedCountry.name;
	    	
	    	if(checkBoxFBPosts.isChecked())
	    		ApplicationLoyalAZ.loyalaz.enableFBPost = "1";
	    	else
	    		ApplicationLoyalAZ.loyalaz.enableFBPost = "0";
	    	
	    	if(checkBoxLocationServices.isChecked())
	    		ApplicationLoyalAZ.loyalaz.find_enable = "1";
	    	else
	    		ApplicationLoyalAZ.loyalaz.find_enable = "0";
	    	
	    	try {
				Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
				finish();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
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
    			}
    		}
    		return v;
    	}
    }
    
    private class AsyncSyncDB extends AsyncTask<Void,Void,Void> 
    {

    	
    	@Override

    	   protected void onPreExecute() {
    	      super.onPreExecute();
    	   }

    	
		@Override
		protected Void doInBackground(Void... params) {
			// TODO Auto-generated method stub
	    	BusinessLayer businessObject = new BusinessLayer();
	    	businessObject.SyncDB();
	    	return null;
		}
		
		@Override
		protected void onPostExecute(Void result) 
		{
		    super.onPostExecute(result);
		}
    }
}
