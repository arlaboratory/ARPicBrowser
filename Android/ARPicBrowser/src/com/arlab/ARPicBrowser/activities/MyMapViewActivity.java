package com.arlab.ARPicBrowser.activities;

import java.util.ArrayList;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.Log;

import com.arlab.ARPicBrowser.R;
import com.arlab.ARPicBrowser.data.JsonDataParse;
import com.arlab.ARPicBrowser.data.POI_Json;
import com.arlab.ARPicBrowser.data.UpdateJsonData;
import com.arlab.ARPicBrowser.data.UpdateJsonDataChangeListener;
import com.arlab.ARPicBrowser.location.CurrentPosition;
import com.arlab.ARPicBrowser.utils.Utils;
import com.google.android.maps.GeoPoint;
import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;

public class MyMapViewActivity extends MapActivity implements
		UpdateJsonDataChangeListener {
	final String LOG_TITLE = this.getClass().getName();

	private MapView mapView;
	private GeoPoint myCenter;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.map_view_layout);

		mapView = (MapView) findViewById(R.id.map_view);
		mapView.setBuiltInZoomControls(true);

		myCenter = new GeoPoint(
				(int) (CurrentPosition.getInstance(getApplicationContext())
						.getLoc().getLatitude() * 1E6), (int) (CurrentPosition
						.getInstance(getApplicationContext()).getLoc()
						.getLongitude() * 1E6));
		mapView.getController().setCenter(myCenter);
		mapView.getController().setZoom(12);
		mapView.setBuiltInZoomControls(true);
	}

	@Override
	protected void onResume() {
		super.onResume();

		// Initialize update Json listener
		UpdateJsonData.setUpdateListener(this);

		clearMap();
		loadData();
	}

	@Override
	protected void onPause() {
		super.onPause();

		// Stop update Json listener
		UpdateJsonData.setUpdateListener(null);

		System.gc();
	}

	private void clearMap() {
		if (mapView.getOverlays().size() > 0) {
			mapView.getOverlays().clear();
		}
	}

	/**
	 * draw thumbnail on map with coordinates from poi
	 * 
	 */
	private void loadData() {
		int index = 0;
		synchronized (JsonDataParse.arrayListPoiJson) {
			
		
		for (POI_Json poi : JsonDataParse.arrayListPoiJson) {
			Drawable myDrawable = new BitmapDrawable(
					putImageHolder(poi.getPhoto()));

			if (myDrawable == null || poi.getPhoto() == null) {
				// Load Image by default
			}
			MapItemizedOverlay mapItemizedOverlay = new MapItemizedOverlay(
					myDrawable, this, index);
			mapView.getOverlays().add(mapItemizedOverlay);

			GeoPoint myPoint = new GeoPoint((int) (poi.getLatitude() * 1E6),
					(int) (poi.getLongitude() * 1E6));
			mapItemizedOverlay.addItem(myPoint, poi.getPhoto_title(), "");
			index++;
		}
		}
	}

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}

	// refresh
	public void update() {
		// update map
		Log.i(LOG_TITLE, "Update map Pois");

		clearMap();
		loadData();
	}

	class MapItemizedOverlay extends ItemizedOverlay<OverlayItem> {
		MyMapViewActivity activity;
		private int index;
		private ArrayList<OverlayItem> overlayItemList = new ArrayList<OverlayItem>();

		public MapItemizedOverlay(Drawable marker, MyMapViewActivity activity,
				int index) {
			this(boundCenterBottom(marker));
			this.index = index;
			this.activity = activity;
		}

		public MapItemizedOverlay(Drawable marker) {
			super(boundCenterBottom(marker));
			populate();
		}

		public void addItem(GeoPoint p, String title, String snippet) {
			OverlayItem newItem = new OverlayItem(p, title, snippet);
			overlayItemList.add(newItem);
			populate();
		}

		@Override
		protected OverlayItem createItem(int i) {
			return overlayItemList.get(i);
		}

		/**
		 * @return number of pois on map
		 * 
		 */
		@Override
		public int size() {
			return overlayItemList.size();
		}

		@Override
		public void draw(Canvas canvas, MapView mapView, boolean shadow) {
			super.draw(canvas, mapView, shadow);
		}

		/**
		 * clear map, delete all pois
		 * 
		 */
		public void clear() {
			overlayItemList.clear();
			mapView.invalidate();
		}

		/**
		 * catch click event on map
		 * 
		 */
		@Override
		protected boolean onTap(int index) {
			String title = overlayItemList.get(index).getTitle();
			final POI_Json poi = JsonDataParse.arrayListPoiJson
					.get(MapItemizedOverlay.this.index);
			if (poi == null)
				return false;

			AlertDialog alertDialog = new AlertDialog.Builder(
					MyMapViewActivity.this).create();
			Drawable myDrawable = new BitmapDrawable(poi.getPhoto());

			alertDialog.setIcon(myDrawable);
			alertDialog.setTitle(title);
			alertDialog.setButton("View",
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {

							dialog.dismiss();
							if (MapItemizedOverlay.this.index != -1) {
								Intent intent = new Intent(
										getApplicationContext(),
										ImageViewer.class);

								Bundle bundle = new Bundle();
								bundle.putString("URL",
										poi.getPhoto_file_url_full_res());

								bundle.putString("URL_OWNER",
										poi.getOwner_url());

								bundle.putString("TITLE", poi.getPhoto_title());

								bundle.putString("DATE", poi.getUpload_date());

								bundle.putDouble("LATITUDE", poi.getLatitude());

								bundle.putDouble("LONGITUDE",
										poi.getLongitude());

								intent.putExtras(bundle);

								startActivity(intent);
							}
						}
					});
			alertDialog.setButton2("Cancel",
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
						}
					});
			alertDialog.setCancelable(true);
			alertDialog.show();
			return true;
		}
	}

	/**
	 * Put to thumbnail a holder
	 * 
	 * draw the Panoramio thumbnail image over an ImageHolder using a canvas.
	 * resize the holder image to size of image and center the thumbnail inside holder image
	 * 
	 * @param Bitmap thumbnail
	 * 
	 * @return thumnail with holder.
	 * 
	 */
	private Bitmap putImageHolder(Bitmap bmpPoi) {
		int HOLDER_MARGIN = 50;

		int width = bmpPoi.getWidth() + HOLDER_MARGIN;
		int height = bmpPoi.getHeight() + HOLDER_MARGIN;

		Bitmap bitmap = Bitmap.createBitmap(width, height,
				Bitmap.Config.ARGB_8888);
		Canvas canvas = new Canvas(bitmap);

		Bitmap myBitmap = BitmapFactory.decodeResource(getResources(),
				R.drawable.image_holder);

		canvas.drawBitmap(
				Utils.getInstance().getResizedBitmap(myBitmap, width, height),
				2, 0, null);

		int centreX = (width - bmpPoi.getWidth()) / 2;
		int centreY = (height - bmpPoi.getHeight() - 15) / 2;

		canvas.drawBitmap(Utils.getInstance()
				.getResizedBitmap(bmpPoi, 128, 128), centreX, centreY, null);

		return bitmap;
	}
	@Override
	public void onBackPressed() {
		super.onBackPressed();
		Intent serviceIntent = new Intent(this,
				com.arlab.ARPicBrowser.location.LocationService.class);

		stopService(serviceIntent);
	}
}
