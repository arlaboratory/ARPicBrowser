package com.arlab.ARPicBrowser.activities;

import java.text.NumberFormat;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.location.Location;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;

import com.arlab.ARPicBrowser.R;
import com.arlab.ARPicBrowser.data.UpdateJsonData;
import com.arlab.ARPicBrowser.location.CurrentPosition;

public class FiltersViewActivity extends Activity {
	final String LOG_TITLE = this.getClass().getName();
	private final boolean WITH_DIALOG = true;

	private ProgressDialog myProgressDialog = null;

	private SeekBar seekbarDistance;
	private SeekBar seekbarImages;

	private TextView txtDistance;
	private TextView txtImages;

	private Button btnRefresh;

	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.filters);

		seekbarDistance = (SeekBar) findViewById(R.id.seekBarDistance);
		txtDistance = (TextView) findViewById(R.id.txtDistance);
		
		seekbarDistance.setProgress(10);
		txtDistance.setText(calculateDistance(10));

		seekbarDistance.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
					public void onProgressChanged(SeekBar seekBar,
							int progress, boolean fromUser) {

						if (progress == 0)
							progress = 1;
						txtDistance.setText(calculateDistance(progress));
					}

					public void onStartTrackingTouch(SeekBar seekBar) {
					}

					public void onStopTrackingTouch(SeekBar seekBar) {
					}
				});

		seekbarImages = (SeekBar) findViewById(R.id.seekBarImages);
		txtImages = (TextView) findViewById(R.id.txtImages);

		seekbarImages.setProgress(10);
		txtImages.setText("10 images");

		seekbarImages.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {

				// No possible show 0 photos, min 1
				if (progress == 0) {
					progress = 1;
					txtImages.setText(progress + " image");
				} else
					txtImages.setText(progress + "images");
			}

			public void onStartTrackingTouch(SeekBar seekBar) {
			}

			public void onStopTrackingTouch(SeekBar seekBar) {
			}
		});

		btnRefresh = (Button) findViewById(R.id.btnRefresh);

		btnRefresh.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				if (null == myProgressDialog) {
					// udpate Json filters
					UpdateJsonData.distanceFromPosition = new Double(
							seekbarDistance.getProgress());

					UpdateJsonData.imageFilter = seekbarImages.getProgress();
					if(UpdateJsonData.imageFilter==0)
						UpdateJsonData.imageFilter=1;
					
					UpdateJsonData.getInstance().update(
							FiltersViewActivity.this, WITH_DIALOG);
				}
			}
		});

		
	}

	@Override
	protected void onPause() {
		super.onPause();

		System.gc();
	}

	/**
	 * Calculate distance from actual point and return a string with the
	 * distance in meters or km.
	 * 
	 * @param int radio
	 * 
	 * @return String
	 */
	private String calculateDistance(int radio) {
		Log.i(LOG_TITLE, "Calculate Distance");

		Location actualPosition = CurrentPosition.getInstance(this).getLoc();
		Location seekBarPosition = new Location("");

		seekBarPosition.setLongitude(actualPosition.getLongitude()
				+ (radio * 0.001));
		seekBarPosition.setLatitude(actualPosition.getLatitude()
				+ (radio * 0.001));

		double distance = actualPosition.distanceTo(seekBarPosition);

		NumberFormat nf = NumberFormat.getInstance();
		if (distance < 1000) {
			nf.setMaximumFractionDigits(0);
			return nf.format(distance) + " m";
		} else {
			nf.setMaximumFractionDigits(2);
			return nf.format(distance / 1000) + " km";
		}
	}
	@Override
	public void onBackPressed() {
		super.onBackPressed();
		Intent serviceIntent = new Intent(this,
				com.arlab.ARPicBrowser.location.LocationService.class);

		stopService(serviceIntent);
	}
}
