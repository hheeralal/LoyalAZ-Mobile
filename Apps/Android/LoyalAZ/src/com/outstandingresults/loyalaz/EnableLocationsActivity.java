package com.outstandingresults.loyalaz;

import java.io.IOException;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.Helpers.ApplicationLoyalAZ;
import com.outstandingresults.Helpers.Helper;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;

public class EnableLocationsActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.enablelocations);
        
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
	     
		alertDialogBuilder.setTitle("LoyalAZ");
		ApplicationLoyalAZ.showTutorial = true;
		// set dialog message
		alertDialogBuilder
			.setMessage("Please enable Location Services, so that AZ can find more opportunities for you to  earn Loyalty Rewards nearby...")
			.setCancelable(false)
			
			.setPositiveButton("Enable",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					// if this button is clicked, just close
					// the dialog box and do nothing
					try {
						ApplicationLoyalAZ.loyalaz.find_enable="1";
						ApplicationLoyalAZ.loyalaz.enableFBPost="";
						Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					dialog.dismiss();
					finish();
				}
			})
			.setNegativeButton("Disable",new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int id) {
					// if this button is clicked, just close
					// the dialog box and do nothing
					try {
						ApplicationLoyalAZ.loyalaz.find_enable="0";
						ApplicationLoyalAZ.loyalaz.enableFBPost="";
						Helper.SaveApplicationObjectToDB(ApplicationLoyalAZ.loyalaz);
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					dialog.cancel();
					finish();
				}
			});

			// create alert dialog
			AlertDialog alertDialog = alertDialogBuilder.create();

			// show it
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

}
