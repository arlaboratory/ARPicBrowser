package com.arlab.ARPicBrowser.activities;

import java.util.ArrayList;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.arlab.ARPicBrowser.R;
import com.arlab.ARPicBrowser.data.JsonDataParse;
import com.arlab.ARPicBrowser.data.POI_Json;
import com.arlab.ARPicBrowser.data.UpdateJsonData;
import com.arlab.ARPicBrowser.data.UpdateJsonDataChangeListener;

/**
 * Class adapter to manage a listView
 * 
 * This class implements a trigger to listen a call back from json updates,
 * this trigger update list.
 * 
 */
public class ListViewActivity extends ListActivity implements
		UpdateJsonDataChangeListener {
	final String LOG_TITLE = this.getClass().getName();

	private TextView title;
	private TextView date;
	private ImageView icon;

	private IconListViewAdapter m_adapter;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		this.m_adapter = new IconListViewAdapter(this, R.layout.listview_icon,
				JsonDataParse.arrayListPoiJson);
		setListAdapter(this.m_adapter);
	}

	/**
	 * onResume set json listener
	 */
	@Override
	protected void onResume() {
		super.onResume();

		// Initialize update Json listener
		UpdateJsonData.setUpdateListener(this);

		m_adapter.notifyDataSetChanged();
	};

	/**
	 * onPause set to null json listener
	 */
	@Override
	protected void onPause() {
		super.onPause();

		UpdateJsonData.setUpdateListener(null);

		System.gc();
	}

	@Override
	protected void onListItemClick(ListView listView, View view,
			int poiIndexTouched, long id) {
		super.onListItemClick(listView, view, poiIndexTouched, id);

		Log.i(LOG_TITLE, "Click on list, open image big size");

		if (poiIndexTouched != -1) {
			Intent intent = new Intent(this, ImageViewer.class);

			Bundle bundle = new Bundle();
			bundle.putString("URL",
					JsonDataParse.arrayListPoiJson.get(poiIndexTouched)
							.getPhoto_file_url_full_res());

			bundle.putString("URL_OWNER",
					JsonDataParse.arrayListPoiJson.get(poiIndexTouched)
							.getOwner_url());

			bundle.putString("TITLE",
					JsonDataParse.arrayListPoiJson.get(poiIndexTouched)
							.getPhoto_title());

			bundle.putString("DATE",
					JsonDataParse.arrayListPoiJson.get(poiIndexTouched)
							.getUpload_date());

			bundle.putDouble("LATITUDE",
					JsonDataParse.arrayListPoiJson.get(poiIndexTouched)
							.getLatitude());

			bundle.putDouble("LONGITUDE",
					JsonDataParse.arrayListPoiJson.get(poiIndexTouched)
							.getLongitude());

			intent.putExtras(bundle);
			startActivity(intent);
		}
	}

	public class IconListViewAdapter extends ArrayAdapter<POI_Json> {
		
		public IconListViewAdapter(Context context, int textViewResourceId,
				ArrayList<POI_Json> items) {
			super(context, textViewResourceId, items);

		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View view = convertView;

			if (view == null) {
				LayoutInflater layoutInflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
				view = layoutInflater.inflate(R.layout.listview_icon, null);
			}

			POI_Json poi = JsonDataParse.arrayListPoiJson.get(position);

			if (poi != null) {
				title = (TextView) view.findViewById(R.id.txtTitle);
				date = (TextView) view.findViewById(R.id.txtDate);
				icon = (ImageView) view.findViewById(R.id.icon);

				if (icon != null) {
					icon.setImageBitmap(poi.getPhoto());
				}

				if (title != null) {
					title.setText(poi.getPhoto_title());
				}

				if (date != null) {
					date.setText(poi.getUpload_date());
				}
			}
			return view;
		}
	}

	/**
	 * catch the trigger listener to refresh list adapter
	 */
	public void update() {
		m_adapter.notifyDataSetChanged();
	}
	
	@Override
	public void onBackPressed() {
		super.onBackPressed();
		Intent serviceIntent = new Intent(this,
				com.arlab.ARPicBrowser.location.LocationService.class);

		stopService(serviceIntent);
	}
}
