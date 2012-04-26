package com.arlab.ARPicBrowser.data;

import android.app.ProgressDialog;
import android.content.Context;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.arlab.ARPicBrowser.R;
import com.arlab.ARPicBrowser.location.CurrentPosition;

public class UpdateJsonData {
	private static final boolean ORIGINAL_SIZE = true;
	private static final int DATA_UPDATE = 1;

	private final String LOG_TITLE = this.getClass().getName();

	public static int imageFilter = 10;
	public static double distanceFromPosition = 10;
	public static UpdateJsonDataChangeListener JSON_DATA_UPDATE_LISTENER;
	private static UpdateJsonData instance = null;

	Context context;

	/**
	 * Listener to call back
	 * 
	 * @param UpdateJsonDataChangeListener
	 *            jsonListener
	 * 
	 */
	public static void setUpdateListener(
			final UpdateJsonDataChangeListener jsonListener) {
		JSON_DATA_UPDATE_LISTENER = jsonListener;
	}

	protected UpdateJsonData() {
	}

	public static UpdateJsonData getInstance() {
		if (null == instance)
			instance = new UpdateJsonData();

		return instance;
	}

	/**
	 * Location listener, if location change, update json
	 * 
	 * @param Context
	 *            context
	 * @param Location
	 *            loc
	 * @param boolean dialog
	 * 
	 */
	public void update(final Context context, final Location loc,
			final boolean dialog) {
		this.context = context;

		Log.i(LOG_TITLE, "Read new json");
		new ParseJsonThread(context, dialog).execute(loc);
	}

	/**
	 * update json under demand when the app need.
	 * 
	 * @param Context
	 *            context
	 * 
	 * @param boolean dialog
	 * 
	 */
	public void update(final Context context, final boolean dialog) {
		this.context = context;

		new ParseJsonThread(context, dialog).execute(CurrentPosition
				.getInstance(context).getLoc());
	}

	/**
	 * configure the url to download the json for pois
	 * 
	 * @param Location
	 *            loc
	 * 
	 * @param boolean originalSize
	 * 
	 * @return String
	 * 
	 */
	private String getURL(final Location loc, final boolean originalSize) {
		StringBuffer sUrl = new StringBuffer();

		Log.i(LOG_TITLE, "Prepare url to parse");

		sUrl.append(context.getResources().getString(R.string.JsonUrl));

		sUrl.append("set=public");
		sUrl.append("&from=0&to=").append(imageFilter);

		sUrl.append("&minx=").append(
				loc.getLongitude() + ((distanceFromPosition / 1000) * -1));
		sUrl.append("&miny=").append(
				loc.getLatitude() + ((distanceFromPosition / 1000) * -1));
		sUrl.append("&maxx=").append(
				loc.getLongitude() + (distanceFromPosition / 1000));
		sUrl.append("&maxy=").append(
				loc.getLatitude() + (distanceFromPosition / 1000));
		if (true == originalSize)
			sUrl.append("&size=").append(
					context.getResources().getString(
							R.string.originalResolution));
		else
			sUrl.append("&size=")
					.append(context.getResources().getString(
							R.string.normalResolution));

		sUrl.append("&mapfilter=true");

		sUrl.toString().replace(" ", "");

		return sUrl.toString();
	}

	/**
	 * trigger to update json
	 */
	Handler handlerDataProcess = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if (DATA_UPDATE == msg.what) {
				if (null != JSON_DATA_UPDATE_LISTENER)
					// update for new position
					JSON_DATA_UPDATE_LISTENER.update();
			}
		}
	};

	/**
	 * 
	 * Download json file with data about user, and photos, on background. First
	 * download thumbnails and data user, after that, download only the url
	 * to full image
	 * 
	 */
	public class ParseJsonThread extends AsyncTask<Location, Void, Void> {
		private ProgressDialog pd;

		private Context context;
		private boolean dialog;

		public ParseJsonThread(final Context context, final boolean _dialog) {
			this.context = context;
			this.dialog = _dialog;
		}

		@Override
		protected void onPreExecute() {
			super.onPreExecute();

			if (true == dialog) {
				try {
					pd = ProgressDialog.show(context, "Downloading",
							"Requesting new POIs");
				} catch (Exception e) {
					dialog = false;
					pd = null;
				}
			}
		}

		@Override
		protected Void doInBackground(Location... params) {
			JsonDataParse jsonDataParse = new JsonDataParse(context);
			jsonDataParse.startDownloadJsonData(
					getURL(params[0], !ORIGINAL_SIZE), !ORIGINAL_SIZE);
			jsonDataParse.startDownloadJsonData(
					getURL(params[0], ORIGINAL_SIZE), ORIGINAL_SIZE);

			return null;
		}

		@Override
		protected void onPostExecute(Void v) {

			handlerDataProcess.sendEmptyMessage(DATA_UPDATE);

			if (null != pd) {
				pd.dismiss();
				pd = null;
			}
		}

	}
}
