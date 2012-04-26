package com.arlab.ARPicBrowser.location;

import android.content.Context;
import android.location.Location;
import android.util.Log;

import com.arlab.ARPicBrowser.data.UpdateJsonData;

public class CurrentPosition implements ServiceUpdateUIListener {
	final String LOG_TITLE = this.getClass().getName();
	private final boolean WITH_DIALOG = true;

	private static boolean isStartApp = true;

	private static CurrentPosition instance = null;

	private static Location loc = new Location("");
	private static Context context;

	public Location getLoc() {
		return loc;
	}

	/**
	 * Initialize update service listener
	 */
	protected CurrentPosition() {
		//
		LocationService.setUpdateListener(this);
	}

	public static CurrentPosition getInstance(Context _context) {
		context = _context;

		if (instance == null) {
			instance = new CurrentPosition();
		}

		return instance;
	}

	/**
	 * trigger to update json when location change
	 * 
	 * @param Location loc
	 */
	public void update(Location _loc) {
		// if location change more that 100 meters, update json
		if (loc.distanceTo(_loc) > 100) {
			loc = _loc;

			if (true == isStartApp)
				// Parse Json DATA
				UpdateJsonData.getInstance()
						.update(context, _loc, !WITH_DIALOG);
			else
				UpdateJsonData.getInstance().update(context, _loc, WITH_DIALOG);

			Log.i(LOG_TITLE, "update json data, change position");
		}
	}
}
