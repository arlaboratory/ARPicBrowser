package com.arlab.ARPicBrowser.activities;

import android.app.Activity;
import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;

import com.arlab.ARPicBrowser.R;
import com.arlab.ARPicBrowser.utils.Utils;

public class ImageViewer extends Activity {
	final String LOG_TITLE = this.getClass().getName();

	private ImageView imageView;
	private TextView txtTitulo;
	private ProgressDialog myProgressDialog = null;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.image_view);

		imageView = (ImageView) findViewById(R.id.imageView);
		txtTitulo = (TextView) findViewById(R.id.txtTitulo);

		final Bundle bundle = getIntent().getExtras();

		String params[] = { bundle.getString("URL"), bundle.getString("TITLE") };

		new DownloadImg().execute(params);
	}

	@Override
	protected void onPause() {
		super.onPause();

		System.gc();
		finish();
	}

	/**
	 * Show a progress dialog, downloading images.
	 */
	public void loading() {
		String title = "Please wait...";
		String msg = "Download image...";

		myProgressDialog = ProgressDialog.show(this, title, msg, true, false);
	}

	/**
	 * Download image full size
	 */
	public class DownloadImg extends AsyncTask<String, Void, Boolean> {
		Bitmap downloadImage;

		@Override
		protected void onPreExecute() {
			super.onPreExecute();

			loading();
		}

		@Override
		protected Boolean doInBackground(String... params) {
			Log.i(LOG_TITLE, "Downloading image...");
	
			txtTitulo.setText(params[1]);
			downloadImage = Utils.getInstance().downloadFile(params[0]);

			if (null != downloadImage) {
				Log.i(LOG_TITLE, "Download image ok");
				return true;
			} else {
				Log.e(LOG_TITLE, "Downloading image error");
				return false;
			}
		}

		protected void onPostExecute(Boolean update) {
			if (true == update) {
				imageView.setImageBitmap(downloadImage);
				if (myProgressDialog != null)
					myProgressDialog.dismiss();

				myProgressDialog = null;
			} else {
				finish();
			}
		}
	}
}
