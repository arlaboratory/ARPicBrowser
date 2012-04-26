package com.arlab.ARPicBrowser.utils;

import java.net.HttpURLConnection;
import java.net.URL;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

public class Utils {
	private static Utils instance = null;

	public static Utils getInstance() {
		if (instance == null) {
			instance = new Utils();
		}
		return instance;
	}

	/**
	 * check data connection, if no connection return false
	 * 
	 * @param context
	 * 
	 * @return boolean
	 */
	public boolean isOnline(Context context) {
		if (null == context)
			return false;

		ConnectivityManager cm = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);

		NetworkInfo netInfo = cm.getActiveNetworkInfo();

		if (netInfo != null && netInfo.isConnectedOrConnecting()) {
			cm = null;
			netInfo = null;
			
			return true;
		}
		
		cm = null;
		netInfo = null;
		return false;
	}

	/**
	 * download an image from url and return image
	 * 
	 * @param String fileUrl
	 * 
	 * @return bitmap
	 */
	public Bitmap downloadFile(String fileUrl) {
		if (null == fileUrl)
			return null;

		URL myFileUrl = null;

		try {
			myFileUrl = new URL(fileUrl);

			HttpURLConnection conn = (HttpURLConnection) myFileUrl
					.openConnection();
			conn.setDoInput(true);
			conn.connect();

			return BitmapFactory.decodeStream(conn.getInputStream());

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

	
	/**
	 * resize image 
	 * 
	 * @param Bitmap bitmap
	 * 
	 * @param int newHeight
	 * 
	 * @param int newWidth
	 * 
	 * @return Bitmap
	 */
	public Bitmap getResizedBitmap(Bitmap bitmap, int newHeight, int newWidth) {
		int width = bitmap.getWidth();
		int height = bitmap.getHeight();
		float scaleWidth = ((float) newWidth) / width;
		float scaleHeight = ((float) newHeight) / height;

		// create a matrix for the manipulation
		Matrix matrix = new Matrix();

		// resize the bit map
		matrix.postScale(scaleWidth, scaleHeight);

		// recreate the new Bitmap
		Bitmap resizedBitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height,
				matrix, false);

		return resizedBitmap;
	}
}
