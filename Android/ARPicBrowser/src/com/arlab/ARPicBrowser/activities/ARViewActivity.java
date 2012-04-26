package com.arlab.ARPicBrowser.activities;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.ViewGroup.LayoutParams;

import com.arlab.ARPicBrowser.R;
import com.arlab.ARPicBrowser.data.JsonDataParse;
import com.arlab.ARPicBrowser.data.POI_Json;
import com.arlab.ARPicBrowser.data.UpdateJsonData;
import com.arlab.ARPicBrowser.data.UpdateJsonDataChangeListener;
import com.arlab.ARPicBrowser.location.CurrentPosition;
import com.arlab.arbrowser.general.ARbrowserView;
import com.arlab.arbrowser.general.POI;
import com.arlab.arbrowser.general.POIaction;
import com.arlab.arbrowser.general.POIlabel;

public class ARViewActivity extends Activity implements UpdateJsonDataChangeListener {
	
	private static final String ARBROWSERAPIKEY = "lEVa3uA8NBBKypMeveZ2ajegwnEEEM+BedsGcPnNXQ==";
	private ARbrowserView aRbrowserView;

	public void onCreate(Bundle savedInstanceState) {
		
		super.onCreate(savedInstanceState);
		
        if(isTablet())
        	aRbrowserView = new ARbrowserView(this,true,ARBROWSERAPIKEY, ARbrowserView.SCREEN_ORIENTATION_LANDSCAPE, true);
        else
        	aRbrowserView = new ARbrowserView(this,true,ARBROWSERAPIKEY, ARbrowserView.SCREEN_ORIENTATION_PORTRAIT, false);
       
		aRbrowserView.setPoiSize(2.0f);
		aRbrowserView.setTwitterAppCredentials("YOURCONSUMERKEY", "YOURCONSUMERSECRET", "callback", "panoramioTwitter");
		setContentView(aRbrowserView.getARviewInstance(), new LayoutParams(
				LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));

	}
	
	@Override
	protected void onResume() {
		super.onResume();
		Intent intent = TabBarProjectActivity.tabBar.getIntent();

		if (intent != null && intent.getData() != null) {
			Uri uri = intent.getData();
			//Log.i("URI", uri.toString());
			if (uri != null && uri.toString().startsWith("callback")) {
				aRbrowserView.processTwitterAuthorizationCallback(intent);
			}
		}
		UpdateJsonData.setUpdateListener(this);

		loadData();
	}
	/**
	 * Loads the Panoramio points into the browser
	 */
	private void loadData() {
		aRbrowserView.removeAllpoisFromList();
		if (CurrentPosition.getInstance(this).getLoc() != null) {
			aRbrowserView.setMyCurrentLocation(CurrentPosition.getInstance(this)
					.getLoc());
			synchronized (JsonDataParse.arrayListPoiJson) {
				for (POI_Json poi : JsonDataParse.arrayListPoiJson) {
				POI mPoi;
				mPoi = new POI();
				mPoi.setIconBitmap(poi.getPhoto());
				mPoi.setLatitude(poi.getLatitude());
				mPoi.setLongitude(poi.getLongitude());

				POIlabel label = new POIlabel();
				label.setLabelTitle(poi.getPhoto_title());
				label.setLabelLogoResource(R.drawable.watermark2);
				mPoi.setPoiLabelProperty(label);

				POIaction action = new POIaction();

				action.setPictureAction(poi.getPhoto_file_url_full_res());

				mPoi.addPoiActionToList(action);

				action = new POIaction();

				action.setTwitterAction(getApplicationContext().getResources()
						.getString(R.string.watchimage)
						+ " "
						+ poi.getPhoto_title());

				mPoi.addPoiActionToList(action);

				action = new POIaction();
				action.setMapDirectionAction(true);

				mPoi.addPoiActionToList(action);

				aRbrowserView.addPoiToRenderList(mPoi);
			}
			}
			aRbrowserView.ResumeArView();
		}
	}

	/**
	 * Find device base orientation by device display size (Phones: <b>Portrait</b> , Tablets: <b>Landscape</b>)
	 * 
	 * 
	 */	
	private boolean isTablet()
   	{    		
   	   DisplayMetrics dm = new DisplayMetrics();
	   this.getWindowManager().getDefaultDisplay().getMetrics(dm);
	   int wPix = dm.widthPixels;
	   int hPix = dm.heightPixels;
	   
	   Log.d("ARLAB", "w: " + wPix + " h :" + hPix);
	   
	   if( ((float)hPix/(float)wPix) > 1)
	   {
		   return false;  // Not tablet
	   }
	   else
	   {
		   return true;  // tablet
	   }
   	}

	@Override
	protected void onPause() {
		super.onPause();
		UpdateJsonData.setUpdateListener(null);
		aRbrowserView.PauseArView();


		System.gc();
	}

	public void update() {
		aRbrowserView.PauseArView();
		loadData();
	}
	@Override
	public void onBackPressed() {
		super.onBackPressed();
		Intent serviceIntent = new Intent(this,
				com.arlab.ARPicBrowser.location.LocationService.class);

		stopService(serviceIntent);
	}
}
