package com.arlab.ARPicBrowser.data;

public interface UpdateJsonDataChangeListener {
	/**
	 * This method is called after the new Panoramio data is fetched. The UpdateJsonData class calls this after the data is ready and before removing the processing label
	 */
	public void update();
}
