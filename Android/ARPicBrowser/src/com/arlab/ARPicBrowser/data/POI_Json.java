package com.arlab.ARPicBrowser.data;

import android.graphics.Bitmap;

import com.arlab.ARPicBrowser.utils.Utils;

public class POI_Json {
	private final int HEIGHT = 128;
	private final int WIDTH = 128;

	// Json information per POI
	private String upload_date;
	private String owner_name;
	private String photo_id;
	private double longitude;
	private int height;
	private int width;
	private String photo_title;
	private double latitude;
	private String owner_url;
	private String photo_url;
	private Bitmap photo_file_url;
	private String photo_file_url_full_res;
	private String owner_id;

	/**
	 * Get the url to full resolution image.
	 * 
	 * @return url to full resolution image
	 * 
	 */
	public String getPhoto_file_url_full_res() {
		return photo_file_url_full_res;
	}

	/**
	 * Set the url to full resolution image.
	 * 
	 */
	public void setPhoto_file_url_full_res(String photo_file_url_full_res) {
		this.photo_file_url_full_res = photo_file_url_full_res;
	}

	public String getUpload_date() {
		return upload_date;
	}

	public void setUpload_date(String upload_date) {
		this.upload_date = upload_date;
	}

	public String getOwner_name() {
		return owner_name;
	}

	public void setOwner_name(String owner_name) {
		this.owner_name = owner_name;
	}

	public String getPhoto_id() {
		return photo_id;
	}

	public void setPhoto_id(String photo_id) {
		this.photo_id = photo_id;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public int getHeight() {
		return height;
	}

	public void setHeight(int height) {
		this.height = height;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	public String getPhoto_title() {
		return photo_title;
	}

	public void setPhoto_title(String photo_title) {
		this.photo_title = photo_title;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	public String getOwner_url() {
		return owner_url;
	}

	public void setOwner_url(String owner_url) {
		this.owner_url = owner_url;
	}

	public String getPhoto_url() {
		return photo_url;
	}

	public void setPhoto_url(String photo_url) {
		this.photo_url = photo_url;
	}

	public Bitmap getPhoto() {
		return photo_file_url;
	}

	/**
	 * Download thumbnails and resize to 128x128. This images are used in all the POI screens.
	 * 
	 */
	public void setPhoto(String photo_file_url) {
		Bitmap image = Utils.getInstance().downloadFile(photo_file_url);

		this.photo_file_url = Utils.getInstance().getResizedBitmap(image,
				HEIGHT, WIDTH);
	}

	public String getOwner_id() {
		return owner_id;
	}

	public void setOwner_id(String owner_id) {
		this.owner_id = owner_id;
	}

	public String toString() {
		return owner_name;
	}
}
