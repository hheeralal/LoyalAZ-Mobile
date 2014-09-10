package com.outstandingresults.loyalaz;

import com.bugsense.trace.BugSenseHandler;
import com.google.analytics.tracking.android.EasyTracker;
import com.outstandingresults.Helpers.Helper;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager.LayoutParams;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

public class TutorialActivity extends Activity {

	Button imageButtonGetStartedHelp;
	Button imageButtonSkipHelp;
	RelativeLayout layoutButtons;
	Button buttonNextHelp;
	Button buttonBackHelp;
	Button buttonSkipHelp2;
	int helpIndex;
	ImageView ivHelp ;
	
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        BugSenseHandler.initAndStartSession(this, "dffdc98f");
        setContentView(R.layout.tutorial);
        helpIndex=-1;
        View v;
		LayoutInflater vi = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		v = vi.inflate(R.layout.testbuttons, null,false);

        
        RelativeLayout linearLayoutMain = (RelativeLayout)findViewById(R.id.linearLayoutMain);
        linearLayoutMain.addView(v,2);
        BindControls();
        ResetButtonImages();
        HideAll();
    	imageButtonSkipHelp.setVisibility(View.VISIBLE);
    	imageButtonGetStartedHelp.setVisibility(View.VISIBLE);
    	ShowBackNext();
    	HideBack();
    	buttonSkipHelp2.setVisibility(View.INVISIBLE);
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
    	imageButtonGetStartedHelp = (Button)findViewById(R.id.imageButtonGetStartedHelp);
    	imageButtonSkipHelp = (Button)findViewById(R.id.imageButtonSkipHelp);
//    	layoutButtons = (RelativeLayout)findViewById(R.id.layoutButton);
    	buttonNextHelp = (Button)findViewById(R.id.buttonNextHelp);
    	buttonBackHelp = (Button)findViewById(R.id.buttonBackHelp);
    	buttonSkipHelp2 = (Button)findViewById(R.id.buttonSkipHelp2);
    	
    	buttonSkipHelp2.setVisibility(View.INVISIBLE);
    	buttonBackHelp.setVisibility(View.INVISIBLE);
    	
        ivHelp = (ImageView)findViewById(R.id.imageViewHelp);
    	
    	
//    	imageButtonSetupHelp.setVisibility(View.INVISIBLE);
//    	imageButtonFindProgramsHelp.setVisibility(View.INVISIBLE);
//    	imageButtonFindCouponsHelp.setVisibility(View.INVISIBLE);
//    	imageButtonMyProgramsHelp.setVisibility(View.INVISIBLE);
//    	imageButtonMyCouponsHelp.setVisibility(View.INVISIBLE);
//    	imageButtonScanHelp.setVisibility(View.INVISIBLE);
    	
    	
    	
    	buttonNextHelp.setOnClickListener(new View.OnClickListener() {
    		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		if(helpIndex==13)
        		{
    				Intent in = new Intent();
    				setResult(9,in);
            		finish();
        		}
        		helpIndex++;
        		ShowHelp();
			}
		});
    	
    	buttonBackHelp.setOnClickListener(new View.OnClickListener() {
    		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
        		helpIndex--;
        		ShowHelp();
			}
		});
    	
    	buttonSkipHelp2.setOnClickListener(new View.OnClickListener() {
    		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent in = new Intent();
				setResult(9,in);
        		finish();
			}
		});
    	
    	imageButtonSkipHelp.setOnClickListener(new View.OnClickListener() {
    		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent in = new Intent();
				setResult(9,in);
        		finish();
			}
		});
    	
    	imageButtonGetStartedHelp.setOnClickListener(new View.OnClickListener() {
    		
        	@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
//            	imageButtonSkipHelp.setVisibility(View.GONE);
//            	imageButtonGetStartedHelp.setVisibility(View.GONE);
        		helpIndex=0;
        		ShowHelp();
			}
		});    	
    	
    	
    }
    
    private void GoneAll()
    {
//    	imageButtonSetupHelp.setVisibility(View.GONE);
//    	imageButtonFindProgramsHelp.setVisibility(View.GONE);
//    	imageButtonFindCouponsHelp.setVisibility(View.GONE);
//    	imageButtonMyProgramsHelp.setVisibility(View.GONE);
//    	imageButtonMyCouponsHelp.setVisibility(View.GONE);
//    	imageButtonScanHelp.setVisibility(View.GONE);
    	imageButtonSkipHelp.setVisibility(View.GONE);
    	imageButtonGetStartedHelp.setVisibility(View.GONE);
    }
    
    private void HideAll()
    {
//    	imageButtonSetupHelp.setVisibility(View.INVISIBLE);
//    	imageButtonFindProgramsHelp.setVisibility(View.INVISIBLE);
//    	imageButtonFindCouponsHelp.setVisibility(View.INVISIBLE);
//    	imageButtonMyProgramsHelp.setVisibility(View.INVISIBLE);
//    	imageButtonMyCouponsHelp.setVisibility(View.INVISIBLE);
//    	imageButtonScanHelp.setVisibility(View.INVISIBLE);
    	imageButtonSkipHelp.setVisibility(View.INVISIBLE);
    	imageButtonGetStartedHelp.setVisibility(View.INVISIBLE);
    	
//    	ivHelp = (ImageView)findViewById(R.id.imageViewHelp);
//    	if(ivHelp != null)
//    	{
//    		ivHelp.setVisibility(View.GONE);
//    	}
    	
    }
    
    private void ShowHelp()
    {
        View v = null;
        LayoutInflater vi = null;
        RelativeLayout linearLayoutMain = null;
    	ResetButtonImages();
    	System.out.println(helpIndex);
    	buttonSkipHelp2.setVisibility(View.VISIBLE);
    	switch(helpIndex)
    	{
    	case 0:
        	imageButtonSkipHelp.setVisibility(View.INVISIBLE);
        	imageButtonGetStartedHelp.setVisibility(View.INVISIBLE);

    		ivHelp.setImageResource(R.drawable.page1);
    		ShowBackNext();
    		HideBack();
    		break;
    	case 1:
            ivHelp.setImageResource(R.drawable.page2);
    		ShowBackNext();
    		break;
    	case 2:
            ivHelp.setImageResource(R.drawable.page2_1);
    		ShowBackNext();
    		break;
//        	HideImageView();
//    		imageButtonFindProgramsHelp.setVisibility(View.VISIBLE);
//    		imageButtonFindProgramsHelp.setImageResource(R.drawable.t3);
//    		ShowBackNext();
//    		break;
    	case 3:
            ivHelp.setImageResource(R.drawable.page2_2);
    		ShowBackNext();
    		break;

//    		GoneAll();
//            ivHelp = (ImageView)findViewById(R.id.imageViewHelp);
//            ivHelp.setVisibility(View.VISIBLE);
//            ivHelp.setImageResource(R.drawable.t3_1);
//            ShowBackNext();
//            break;
    	case 4:
            ivHelp.setImageResource(R.drawable.page2_3);
    		ShowBackNext();
    		break;
//    		GoneAll();
//            ivHelp = (ImageView)findViewById(R.id.imageViewHelp);
//            ivHelp.setVisibility(View.VISIBLE);
//            ivHelp.setImageResource(R.drawable.t3_2);
//            ShowBackNext();
//            break;
    	case 5:
            ivHelp.setImageResource(R.drawable.page3);

    		ShowBackNext();
    		break;

//    		GoneAll();
//            ivHelp = (ImageView)findViewById(R.id.imageViewHelp);
//            ivHelp.setVisibility(View.VISIBLE);
//            ivHelp.setImageResource(R.drawable.t3_3);
//            ShowBackNext();
//            break;            
    	case 6:
            ivHelp.setImageResource(R.drawable.page4);
    		ShowBackNext();
    		break;
//    		GoneAll();
//            ivHelp = (ImageView)findViewById(R.id.imageViewHelp);
//            ivHelp.setVisibility(View.VISIBLE);
//            ivHelp.setImageResource(R.drawable.t3_4);
//            ShowBackNext();
//            break;
    	case 7:
            ivHelp.setImageResource(R.drawable.page5);
    		ShowBackNext();
    		break;

//        	HideImageView();
//    		imageButtonMyProgramsHelp.setVisibility(View.VISIBLE);
//    		imageButtonMyProgramsHelp.setImageResource(R.drawable.t4);
//    		ShowBackNext();
//    		break;
    	case 8:
            ivHelp.setImageResource(R.drawable.page6);
            ShowBackNext();
    		break;
//        	HideImageView();
//    		imageButtonSetupHelp.setVisibility(View.VISIBLE);
//    		imageButtonSetupHelp.setImageResource(R.drawable.t5);
//    		ShowBackNext();
//    		break;
    	case 9:
            ivHelp.setImageResource(R.drawable.page7);
            ShowBackNext();
    		break;
//        	HideImageView();
//    		imageButtonFindCouponsHelp.setVisibility(View.VISIBLE);
//    		imageButtonFindCouponsHelp.setImageResource(R.drawable.t6);
//    		ShowBackNext();
//    		break;
    	case 10:
            ivHelp.setImageResource(R.drawable.page8);
            ShowBackNext();
    		break;

//        	HideImageView();
//    		imageButtonMyCouponsHelp.setVisibility(View.VISIBLE);
//    		imageButtonMyCouponsHelp.setImageResource(R.drawable.t7);
//    		ShowBackNext();
//    		break;
    	case 11:
            ivHelp.setImageResource(R.drawable.page9);
            ShowBackNext();
    		break;
//    		GoneAll();
//            ivHelp = (ImageView)findViewById(R.id.imageViewHelp);
//            ivHelp.setVisibility(View.VISIBLE);
//            ivHelp.setImageResource(R.drawable.t7_1);
//            ShowBackNext();
//            //HideNext();
//            break;
    	case 12:
            ivHelp.setImageResource(R.drawable.page10);
            ShowBackNext();
    		break;

    	case 13:
            ivHelp.setImageResource(R.drawable.page11);
            ShowBackNext();
    		break;

    		
    	}
    }
    
    private void ShowBackNext()
    {
    	buttonSkipHelp2.setVisibility(View.VISIBLE);
    	buttonNextHelp.setVisibility(View.VISIBLE);
    	buttonBackHelp.setVisibility(View.VISIBLE);
    	
    	if(helpIndex==13)
    	{
    		buttonNextHelp.setBackgroundResource(R.drawable.finish);
    	}
    	else
    	{
    		buttonNextHelp.setBackgroundResource(R.drawable.next_button);
    	}
    }
    
    private void ResetButtonImages()
    {
//    	imageButtonScanHelp.setImageResource(R.drawable.scan_button_states);
//    	imageButtonSetupHelp.setImageResource(R.drawable.setup_button_states);
//    	imageButtonFindProgramsHelp.setImageResource(R.drawable.find_button_states);
//    	imageButtonFindCouponsHelp.setImageResource(R.drawable.findcoupons_button_states);
//    	imageButtonMyProgramsHelp.setImageResource(R.drawable.programs_buton_states);
//    	imageButtonMyCouponsHelp.setImageResource(R.drawable.mycoupons_pressed);
    	
//    	float alpha = 0.45f;
//    	AlphaAnimation alphaUp = new AlphaAnimation(alpha, alpha);
//    	alphaUp.setFillAfter(true);
//    	imageButtonFindCouponsHelp.setAnimation(alphaUp);
    	
//    	HideAll();
    }
    
    private void HideImageView()
    {
    	ImageView ivHelp2 = (ImageView)findViewById(R.id.imageViewHelp);
    	if(ivHelp2 != null)
    	{
    		ivHelp2.setVisibility(View.GONE);
    	}
    	
    }
    
    private void HideBackNext()
    {
    	buttonSkipHelp2.setVisibility(View.INVISIBLE);
    	buttonNextHelp.setVisibility(View.INVISIBLE);
    	buttonBackHelp.setVisibility(View.INVISIBLE);
    }
    
    private void HideBack()
    {
    	buttonBackHelp.setVisibility(View.INVISIBLE);
    }    
    
    private void HideNext()
    {
    	buttonNextHelp.setVisibility(View.INVISIBLE);
    }        
    
    private void ShowBack()
    {
    	buttonBackHelp.setVisibility(View.VISIBLE);
    }    
    
    private void ShowNext()
    {
    	buttonNextHelp.setVisibility(View.VISIBLE);
    }
    
    
}
