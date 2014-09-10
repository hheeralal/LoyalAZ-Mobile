package com.outstandingresults.loyalaz;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;

public class TutorialBaseActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_tutorial_base);
		
		LoadTutorial();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.activity_tutorial_base, menu);
		return true;
	}
	
	
    private void LoadTutorial()
    {
    	startActivityForResult(new Intent("com.outstandingresultscompany.action.TUTORIAL"), 5);
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) 
    {
    	//Log.d("CheckStartActivity","onActivityResult and resultCode = "+resultCode);
    	// TODO Auto-generated method stub
    	super.onActivityResult(requestCode, resultCode, data);
    	if(resultCode==9)
    	{
    		Intent in = new Intent();
    		setResult(5,in);
    		finish();
    	}

    }


}
