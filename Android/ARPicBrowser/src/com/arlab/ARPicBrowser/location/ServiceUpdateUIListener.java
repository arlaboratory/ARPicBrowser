package com.arlab.ARPicBrowser.location;

import android.location.Location;

/**
 * Interface to call back used on update service.
 */
public interface ServiceUpdateUIListener {
	public void update(Location loc);
}
