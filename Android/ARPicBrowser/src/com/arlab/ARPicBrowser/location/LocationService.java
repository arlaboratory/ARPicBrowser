package com.arlab.ARPicBrowser.location;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.util.Log;

public class LocationService extends Service implements LocationListener {
	private static final int UPDATE_LOCATION = 1;
	//private final int DISTANCE_TO_UPDATE = 100; // 100m
	//private final int UPDATE_INTERVAL = 1 * 5* 1000; // 5 sec

	private static LocationManager locationManager;

	private static Location location;

	public static ServiceUpdateUIListener UI_UPDATE_LISTENER;

	String places[];

	private final String LOG_TITLE = this.getClass().getName();
	public static Location getLocation(){
		return location;
	}
	@Override
	public void onCreate() {
		Log.i(LOG_TITLE, "OnCreate");

		super.onCreate();

		startService();
	}

	/**
	 * Start service check if location manager was initialized, if not, do this
	 * take the best location provider available get actual position and order
	 * download data with the new position.
	 * 
	 */
	private void startService() {
		Log.i(LOG_TITLE, "Start service");

		if (null == locationManager) {
			initLocationManager();
		}

		String bestProvider = getBestProvider();

		// If location by network is not enabled, not start service
		if (!locationManager.isProviderEnabled(bestProvider)) {
			// Show warning no provider
			Log.e(LOG_TITLE, "No provider found");
			showNotification();
		}

		location = locationManager.getLastKnownLocation(bestProvider);
		Log.i(LOG_TITLE, "get location");

		// Update actual position
		new Thread(new Runnable() {
			public void run() {
				if (null != location)
					handlerDataProcess.sendEmptyMessage(UPDATE_LOCATION);
			}
		}).start();
	}

	/**
	 * destroy service, and remove the call back
	 * 
	 */
	@Override
	public void onDestroy() {
		Log.i(LOG_TITLE, "Stop service");
		// Finally we should call removeUpdates that will stop handling further
		// activity from the locationManager instance, as we do not need the
		// service anymore.
		locationManager.removeUpdates(this);

		super.onDestroy();
	}

	/**
	 * Initialize locationManager with best provider available on device
	 * 
	 */
	private void initLocationManager() {
		locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);

		Log.i(LOG_TITLE, "Best provider: " + getBestProvider());
		locationManager.requestLocationUpdates(getBestProvider(),
				0, 0, this);
	}

	/**
	 * Look for best provider available on device
	 * 
	 * @return String provider.
	 */
	private String getBestProvider() {
		String provider = locationManager.getBestProvider(getCriteria(), true);

		if (provider == null)
			return LOCATION_SERVICE;

		return provider;
	}

	/**
	 * set call back
	 * 
	 * @param ServiceUpdateUIListener
	 */
	public static void setUpdateListener(
			final ServiceUpdateUIListener serviceListener) {
		UI_UPDATE_LISTENER = serviceListener;
	}

	/**
	 * parameters to search the best location provider.
	 * http://developer.android.com/reference/android/location/Criteria.html
	 * 
	 * @return Criteria
	 */
	private Criteria getCriteria() {
		// Options to choose the best location provider
		Criteria criteria = new Criteria();

		// criteria.setAccuracy(Criteria.ACCURACY_FINE);
		criteria.setPowerRequirement(Criteria.POWER_LOW);
		criteria.setAltitudeRequired(false);
		criteria.setBearingRequired(false);
		criteria.setCostAllowed(true);

		return criteria;
	}

	@Override
	public IBinder onBind(Intent arg0) {
		return null;
	}

	/**
	 * Called when the location has changed.
	 * 
	 * @param Location
	 *
	 */
	public void onLocationChanged(final Location _loc) {
		Log.i(LOG_TITLE, "Location Changed");

		// update actual position
		location = _loc;

		// Update actual position
		new Thread(new Runnable() {
			public void run() {
				handlerDataProcess.sendEmptyMessage(UPDATE_LOCATION);
			}
		}).start();
	}

	/**
	 * Called when the provider is disabled by the user.
	 * 
	 * @param String
	 *
	 */
	public void onProviderDisabled(String provider) {
		Log.i(LOG_TITLE, "ProviderDisabled");

		showNotification();

		// Service stop
		stopSelf();
	}

	/**
	 * Show a notification to warning have not location provider
	 *
	 */
	private void showNotification() {
		final String NO_PROVIDER = "No location provider";

		final String start_provider = "Check 'Use wireless networks.'";

		//Get a reference to notification service
		String notificationService = Context.NOTIFICATION_SERVICE;
		NotificationManager notManager = (NotificationManager) getSystemService(notificationService);

		// setup notification
		int icono = android.R.drawable.stat_sys_warning;
		CharSequence textoEstado = "Warning";
		long hora = System.currentTimeMillis();

		Notification notif = new Notification(icono, textoEstado, hora);

		// setup Intent
		Context contexto = getApplicationContext();
		CharSequence titulo = NO_PROVIDER;
		CharSequence descripcion = start_provider;

		//when push notification, open Location and security window
		Intent notIntent = new Intent(
				android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS);

		PendingIntent contIntent = PendingIntent.getActivity(contexto, 0,
				notIntent, 0);

		notif.setLatestEventInfo(contexto, titulo, descripcion, contIntent);

		notif.flags |= Notification.FLAG_AUTO_CANCEL;

		// send notification
		notManager.notify(1, notif);
	}
	
	/**
	 * Called when the provider is enabled by the user.
	 * 
	 * @param String
	 *
	 */
	public void onProviderEnabled(String provider) {
		Log.i(LOG_TITLE, "ProviderEnabled");

		startService();
	}

	Handler handlerDataProcess = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if (UPDATE_LOCATION == msg.what) {
				if (null != UI_UPDATE_LISTENER) {
					Log.i(LOG_TITLE, "update new position");
					// update new position
					UI_UPDATE_LISTENER.update(location);
				}
			}
		}
	};

	public void onStatusChanged(String provider, int status, Bundle extras) {
	}
}
