package com.outstandingresults.loyalaz;

import com.bugsense.trace.BugSenseHandler;
import com.outstandingresults.DataObjects.Program;
import com.outstandingresults.Helpers.BusinessLayer;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

public class PasscodeActivity extends Activity {

	private String pins[] = null;
	private Program prg = null;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		BugSenseHandler.initAndStartSession(this, "dffdc98f");
		setContentView(R.layout.passcode);
		
		final ImageView ivPin1 = (ImageView) findViewById(R.id.ivPin1);
		final ImageView ivPin2 = (ImageView) findViewById(R.id.ivPin2);
		final ImageView ivPin3 = (ImageView) findViewById(R.id.ivPin3);
		final ImageView ivPin4 = (ImageView) findViewById(R.id.ivPin4);
		
		Button buttonCancel = (Button) findViewById(R.id.buttonPasscodeCancel);
		
		buttonCancel.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				//MockTest();
				setResult(RESULT_CANCELED);
				finish();
			}
		});
		
		prg = (Program) getIntent().getSerializableExtra("PRG");
		
		BusinessLayer businessLayer = new BusinessLayer();
		
		prg.pins = prg.pins + "," + businessLayer.GetProgramPins(prg);
		System.out.println("PINS="+prg.pins);
		pins = prg.pins.split(",");

		
		EditText etPasscode = (EditText)findViewById(R.id.editTextPasscode);
		
		if(etPasscode.requestFocus()) {
		    getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
		}
		
		etPasscode.addTextChangedListener(new TextWatcher(){
	        public void afterTextChanged(Editable s) {
	        	
	        	ivPin1.setImageResource(R.drawable.filled);
	        	ivPin2.setImageResource(R.drawable.filled);
	        	ivPin3.setImageResource(R.drawable.filled);
	        	ivPin4.setImageResource(R.drawable.filled);
	        	
	        	if(s.length()==1)
	        	{
	        		ivPin1.setImageResource(R.drawable.empty);
	        	}
	        	else if(s.length()==2)
	        	{
	        		ivPin1.setImageResource(R.drawable.empty);
	        		ivPin2.setImageResource(R.drawable.empty);
	        	}
	        	else if(s.length()==3)
	        	{
	        		ivPin1.setImageResource(R.drawable.empty);
	        		ivPin2.setImageResource(R.drawable.empty);
	        		ivPin3.setImageResource(R.drawable.empty);
	        	}
	        	else if(s.length()==4)
	        	{
	        		ivPin1.setImageResource(R.drawable.empty);
	        		ivPin2.setImageResource(R.drawable.empty);
	        		ivPin3.setImageResource(R.drawable.empty);
	        		ivPin4.setImageResource(R.drawable.empty);
	        		ValidatePassword(s.toString());
	        	}
	        }
	        public void beforeTextChanged(CharSequence s, int start, int count, int after){}
	        public void onTextChanged(CharSequence s, int start, int before, int count){}
	    }); 
	}
	
	private void ValidatePassword(String pass)
	{
		boolean valid = false;
		System.out.println(pass);
		for(int i=0;i<pins.length;i++)
		{
//			System.out.println("PASS:"+pins[i]);
			if(pass.equals(pins[i]))
			{
				valid = true;
				break;
			}
		}
//		valid = true; // bypass the check temporarily.
		
		if(valid)
		{
			AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
			alertDialogBuilder.setTitle("LoyalAZ");
			alertDialogBuilder
			.setMessage("PIN Code Successfully Authenticated.")
			.setCancelable(false)
			.setPositiveButton("OK", new DialogInterface.OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					// TODO Auto-generated method stub
					Intent intent = new Intent();
					intent.putExtra("PRG", prg);
					setResult(RESULT_OK,intent);
					finish();
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
			.setMessage("Incorrect PIN code.")
			.setCancelable(false)
			.setPositiveButton("OK", new DialogInterface.OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					// TODO Auto-generated method stub
				}
			});
			AlertDialog alertDialog = alertDialogBuilder.create();
			alertDialog.show();
		}
	}
}
