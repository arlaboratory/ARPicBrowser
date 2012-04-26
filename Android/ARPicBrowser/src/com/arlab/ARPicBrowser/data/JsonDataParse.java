package com.arlab.ARPicBrowser.data;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.util.Log;

public class JsonDataParse {
	final String LOG_TITLE = this.getClass().getName();
	final String CHARSET = "iso-8859-1";

	Context context;
	public static ArrayList<POI_Json> arrayListPoiJson = new ArrayList<POI_Json>();

	public JsonDataParse(Context context) {
		this.context = context;
	}

	
	/**
	 * Get an url, download json string and parse information to create
	 * POI_Json's class.
	 * 
	 * @param String
	 *            sourceUrl
	 * @param boolean original_size
	 * 
	 */
	public void startDownloadJsonData(String sourceUrl, boolean original_size) {
		Log.i(LOG_TITLE, "ParseJsonPOIs - Start to parse json");

		try {
			String sJson = getJsonString(sourceUrl);
			if (!sJson.isEmpty()) {
				Log.i(LOG_TITLE, sJson);

				JSONObject jsonObj = new JSONObject(sJson);

				JSONArray poisArray = jsonObj.getJSONArray("photos");
				synchronized (JsonDataParse.arrayListPoiJson) {
					if (false == original_size)
						arrayListPoiJson.clear();

					for (int i = 0; i < poisArray.length(); i++) {
						JSONObject allpoi = poisArray.getJSONObject(i);

						// if need original photo size, search poi, and update
						// photo_file_url
						if (true == original_size) {
							updateJsonFullSizeImg(i, allpoi);
						} else {
							POI_Json jsonPoi = new POI_Json();

							jsonPoi.setUpload_date(allpoi
									.getString("upload_date"));
							jsonPoi.setOwner_name(allpoi
									.getString("owner_name"));
							jsonPoi.setPhoto_id(allpoi.getString("photo_id"));
							jsonPoi.setLongitude(allpoi.getDouble("longitude"));
							jsonPoi.setHeight(allpoi.getInt("height"));
							jsonPoi.setWidth(allpoi.getInt("width"));
							jsonPoi.setPhoto_title(allpoi
									.getString("photo_title"));
							jsonPoi.setLatitude(allpoi.getDouble("latitude"));
							jsonPoi.setOwner_url(allpoi.getString("owner_url"));
							jsonPoi.setPhoto_url(allpoi.getString("photo_url"));
							jsonPoi.setPhoto(allpoi.getString("photo_file_url"));
							jsonPoi.setOwner_id(allpoi.getString("owner_id"));

							arrayListPoiJson.add(jsonPoi);

							allpoi = null;
							jsonPoi = null;
						}
					}
					Log.i(LOG_TITLE, "ParseJsonPOIs - Parse json ok");
				}

				jsonObj = null;
				poisArray = null;
			} else
				Log.e(LOG_TITLE, "ParseJsonPOIs - the Url: " + sourceUrl
						+ " is empty");

		} catch (JSONException e) {
			Log.e(LOG_TITLE, "ParseJsonPOIs Error - " + e.getMessage());
			e.printStackTrace();
		}
	}

	/**
	 * Update poi obj with url to original size of photo
	 * 
	 * @param int index
	 * 
	 * @param JSONObject
	 *            allpoi
	 * 
	 */
	private void updateJsonFullSizeImg(final int index, final JSONObject allpoi)
			throws JSONException {
		String owner_id = JsonDataParse.arrayListPoiJson.get(index)
				.getOwner_id();
		String photo_id = JsonDataParse.arrayListPoiJson.get(index)
				.getPhoto_id();

		if (owner_id.equals(allpoi.getString("owner_id"))
				&& photo_id.equals(allpoi.getString("photo_id"))) {
			JsonDataParse.arrayListPoiJson.get(index)
					.setPhoto_file_url_full_res(
							allpoi.getString("photo_file_url"));
		} else {

			for (int j = 0; j < JsonDataParse.arrayListPoiJson.size(); j++) {
				owner_id = JsonDataParse.arrayListPoiJson.get(j).getOwner_id();
				photo_id = JsonDataParse.arrayListPoiJson.get(j).getPhoto_id();
				if (owner_id.equals(allpoi.getString("owner_id"))
						&& photo_id.equals(allpoi.getString("photo_id"))) {
					JsonDataParse.arrayListPoiJson.get(j)
							.setPhoto_file_url_full_res(
									allpoi.getString("photo_file_url"));
				}
			}
		}
	}

	/**
	 * get a url string and return a json string with the panoramio Data
	 * 
	 * @param String
	 *            sUrl
	 * 
	 * 
	 * @return String
	 * 
	 */
	private String getJsonString(final String sUrl) {
		URL url;
		URLConnection urlConnection;

		try {
			url = new URL(sUrl);

			urlConnection = url.openConnection();

			// Set timeout to 5 seconds to connection and 10 to read timeout
			urlConnection.setConnectTimeout(5000);
			urlConnection.setReadTimeout(10000);

			// get a stream to read data from
			BufferedReader br;

			br = new BufferedReader(new InputStreamReader(
					urlConnection.getInputStream(), CHARSET));

			// read bufferedReader content
			String jsonString = br.readLine();

			br.close();

			br = null;
			urlConnection = null;
			url = null;

			return jsonString;

		} catch (UnsupportedEncodingException e) {
			Log.e(LOG_TITLE, "getJsonString - " + e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			Log.e(LOG_TITLE, "getJsonString - " + e.getMessage());
			e.printStackTrace();
		}

		return "";
	}
}