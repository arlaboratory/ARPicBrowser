package com.arlab.ARPicBrowser.activities;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningServiceInfo;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.util.Log;
import android.widget.LinearLayout;

import com.arlab.ARPicBrowser.R;
import com.arlab.ARPicBrowser.data.UpdateJsonData;
import com.arlab.ARPicBrowser.data.UpdateJsonDataChangeListener;
import com.arlab.ARPicBrowser.location.CurrentPosition;
import com.arlab.ARPicBrowser.location.LocationService;
import com.arlab.ARPicBrowser.utils.Utils;

public class Splash extends Activity implements UpdateJsonDataChangeListener {
	final String LOG_TITLE = this.getClass().getName();
	final boolean NO_DIALOG = false;

	private static boolean started = false;
	
	private LinearLayout splashLayout;
	private AnimationDrawable splashAnimation;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.splash);

		
	}

	@Override
	protected void onResume() {
		super.onResume();
		if (!started) {
			UpdateJsonData.setUpdateListener(this);
			started = true;
		} else {
			UpdateJsonData.setUpdateListener(this);
			if(LocationService.getLocation()!=null)
				UpdateJsonData.getInstance().update(this, NO_DIALOG);
		}
		if (false == Utils.getInstance().isOnline(this))
		{
			Log.i(LOG_TITLE, "No internet connection, exit app");
			msgNoDataConnection();
		}
		else
		{
			animationSplash();
	
			// Start Location Service
			Log.i(LOG_TITLE, "Call start service");
			startLocationService();
		}
	}

	@Override
	protected void onPause() {
		super.onPause();
		
		UpdateJsonData.setUpdateListener(null);
	}

	/**
	 * Initialize animation splash
	 */
	private void animationSplash() {
		splashLayout = (LinearLayout) findViewById(R.id.splashLayout);
		splashLayout.bringToFront();
		splashLayout.setBackgroundResource(R.anim.splash_screen_animation);

		splashAnimation = (AnimationDrawable) splashLayout.getBackground();

		splashAnimation.setCallback(splashLayout);
		splashAnimation.setVisible(true, true);
	}

	@Override
	public void onWindowFocusChanged(boolean hasFocus) {
		super.onWindowFocusChanged(hasFocus);
		if(hasFocus)
			splashAnimation.start();
	}

	/**
	 * Start location service
	 */
	private void startLocationService() {
		// Initialize update service listener
		CurrentPosition.getInstance(this);
		if (false == isServiceRunning()) {
			Intent serviceIntent = new Intent(this,
					com.arlab.ARPicBrowser.location.LocationService.class);

			startService(serviceIntent);
		} else {
			LocationService.setUpdateListener(CurrentPosition.getInstance(this));
		}
	}

	/**
	 * check if service is running
	 */
	private boolean isServiceRunning() {
		ActivityManager manager = (ActivityManager) getSystemService(ACTIVITY_SERVICE);

		for (RunningServiceInfo service : manager
				.getRunningServices(Integer.MAX_VALUE)) {
			if (LocationService.class.getName().equals(
					service.service.getClassName())) {
				return true;
			}
		}
		return false;
	}

	/**
	 * trigger json parse finish, start main screen
	 */
	public void update() {
		if (true == Utils.getInstance().isOnline(this)){
			Intent intent = new Intent(getApplicationContext(),
					TabBarProjectActivity.class);
			
			startActivity(intent);

			finish();
		}
	}

	/**
	 * Dialog no data connection
	 */
	private void msgNoDataConnection() {
		new AlertDialog.Builder(this)
				.setMessage("No internet connection !!!")
				.setPositiveButton("Exit",
						new DialogInterface.OnClickListener() {

							public void onClick(DialogInterface dialog,
									int which) {
								System.exit(0);
							}
						}).show();
	}
	@Override
	public void onBackPressed() {
	}

	
}