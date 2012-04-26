package com.arlab.ARPicBrowser.activities;

import android.app.TabActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.widget.TabHost;

import com.arlab.ARPicBrowser.R;
import com.arlab.ARPicBrowser.location.CurrentPosition;
import com.arlab.ARPicBrowser.location.LocationService;

public class TabBarProjectActivity extends TabActivity {
	public static TabBarProjectActivity tabBar;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		addIntent(ARViewActivity.class, "ARView", "ARView",
				R.drawable.tab_arview);
		addIntent(ListViewActivity.class, "ListView", "List",
				R.drawable.tab_listview);
		addIntent(MyMapViewActivity.class, "MapView", "Map",
				R.drawable.tab_mapview);
		addIntent(FiltersViewActivity.class, "FiltersView", "Options",
				R.drawable.tab_filtersview);
		getTabHost().setCurrentTab(0);
		tabBar=this;
		

	}
	/**
	 * add tab
	 */
	@SuppressWarnings("rawtypes")
	private void addIntent(Class myClass, String id, String title, int drawable) {
		Resources res = getResources(); // Resource object to get Drawables
		TabHost tabHost = getTabHost(); // The activity TabHost
		TabHost.TabSpec spec; // Reusable TabSpec for each tab
		Intent intent; // Reusable Intent for each tab
		intent = new Intent().setClass(this, myClass);

		spec = tabHost.newTabSpec(id)
				.setIndicator(title, res.getDrawable(drawable))
				.setContent(intent);

		tabHost.addTab(spec);
	}
	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		tabBar=this;
	}
	@Override
	protected void onResume() {
		super.onResume();
		
		
		LocationService.setUpdateListener(CurrentPosition.getInstance(this));
	}
	@Override
	protected void onPause() {
		super.onPause();
		LocationService.setUpdateListener(null);
	}
}