package com.example.dorona;

import android.Manifest;
import android.app.Activity;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.LocationProvider;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.CancellationToken;
import com.google.android.gms.tasks.OnCanceledListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.OnTokenCanceledListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.SetOptions;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import static android.content.Context.LOCATION_SERVICE;
import static androidx.core.content.ContextCompat.getSystemService;

public class MyLocationBroadcast extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {

        System.out.println("Location Broadcast");
        String userId = intent.getStringExtra("userId");
        System.out.println(userId);
        LocationManager locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        final boolean gpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);

        if (gpsEnabled) {
            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
                    != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)
                    != PackageManager.PERMISSION_GRANTED) {
                return;
            }
            FusedLocationProviderClient fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(context);
            CancellationToken token = new CancellationToken() {
                @Override
                public boolean isCancellationRequested() {
                    return false;
                }

                @NonNull
                @Override
                public CancellationToken onCanceledRequested(@NonNull OnTokenCanceledListener onTokenCanceledListener) {
                    return null;
                }
            };
            fusedLocationProviderClient.getLastLocation().addOnSuccessListener(new OnSuccessListener<Location>() {
                @Override
                public void onSuccess(Location location) {

                    if (location != null) {
                        Map<String, Object> locationData = new HashMap<>();
                        locationData.put("latitude", location.getLatitude());
                        locationData.put("longitude", location.getLongitude());
                        locationData.put("altitude", location.getAltitude());
                        locationData.put("timestamp", System.currentTimeMillis());
                        Geocoder geocoder;
                        geocoder = new Geocoder(context.getApplicationContext(), Locale.getDefault());
                        List<Address> addresses;
                        try {
                            addresses = geocoder.getFromLocation(location.getLatitude(), location.getLongitude(), 1);
                            System.out.println(addresses.get(0).getLocality());
                            System.out.println(addresses.get(0).getPostalCode());
                            if (addresses.size() > 0 && addresses.get(0).getAdminArea() != null
                                    && addresses.get(0).getSubAdminArea() != null && addresses.get(0).getPostalCode() != null) {
                                SharedPreferences sharedPreferences = context.getSharedPreferences("Location", Context.MODE_PRIVATE);
                                SharedPreferences.Editor editor = sharedPreferences.edit();
                                String pincode = sharedPreferences.getString("pincode", "");
                                if (pincode == "") {
                                    editor.putString("pincode", addresses.get(0).getPostalCode());
                                    editor.putString("latitude", String.valueOf(location.getLatitude()));
                                    editor.putString("longitude", String.valueOf(location.getLongitude()));
                                    editor.putString("adminArea", addresses.get(0).getAdminArea());
                                    editor.putString("subAdminArea", addresses.get(0).getSubAdminArea());
                                    editor.commit();
                                    Map<String, Object> address = new HashMap<>();
                                    address.put("adminArea", addresses.get(0).getAdminArea());
                                    address.put("subAdminArea", addresses.get(0).getSubAdminArea());
                                    address.put("pincode", addresses.get(0).getPostalCode());
                                    FirebaseFirestore.getInstance()
                                            .collection("Users")
                                            .document(userId)
                                            .set(address, SetOptions.merge());
                                }
                                if (pincode != "" && !pincode.equals(addresses.get(0).getPostalCode())) {
                                    String adminArea = sharedPreferences.getString("adminArea", "");
                                    String subAdminArea = sharedPreferences.getString("subAdminArea", "");
                                    if (adminArea != "" && subAdminArea != "" && pincode != "") {
                                        Map<String, Object> address = new HashMap<>();
                                        address.put("adminArea", addresses.get(0).getAdminArea());
                                        address.put("subAdminArea", addresses.get(0).getSubAdminArea());
                                        address.put("pincode", addresses.get(0).getPostalCode());
                                        FirebaseFirestore.getInstance()
                                                .collection("Users")
                                                .document(userId)
                                                .set(address, SetOptions.merge());
                                        FirebaseFirestore.getInstance()
                                                .collection("Locations")
                                                .document(adminArea)
                                                .collection(adminArea)
                                                .document(subAdminArea)
                                                .collection(subAdminArea)
                                                .document(pincode)
                                                .collection(pincode)
                                                .document(userId)
                                                .delete()
                                                .addOnSuccessListener(new OnSuccessListener<Void>() {
                                                    @Override
                                                    public void onSuccess(Void aVoid) {
                                                        editor.putString("pincode", addresses.get(0).getPostalCode());
                                                        editor.putString("latitude", String.valueOf(location.getLatitude()));
                                                        editor.putString("longitude", String.valueOf(location
                                                                .getLongitude()));
                                                        editor.putString("adminArea", addresses.get(0).getAdminArea());
                                                        editor.putString("subAdminArea", addresses.get(0).getSubAdminArea());
                                                        editor.commit();
                                                    }
                                                });
                                    }
                                }
                                FirebaseFirestore db = FirebaseFirestore.getInstance();
                                db.collection("Locations").document(addresses.get(0).getAdminArea())
                                        .collection(addresses.get(0).getAdminArea())
                                        .document(addresses.get(0).getSubAdminArea())
                                        .collection(addresses.get(0).getSubAdminArea())
                                        .document(addresses.get(0).getPostalCode())
                                        .collection(addresses.get(0).getPostalCode())
                                        .document(userId)
                                        .set(locationData).addOnSuccessListener(new OnSuccessListener<Void>() {
                                    @Override
                                    public void onSuccess(Void aVoid) {
                                        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "123456")
                                                .setContentTitle("Dorona Tracker")
                                                .setSmallIcon(R.mipmap.ic_launcher)
                                                .setOngoing(true)
                                                .setColor(Color.rgb(128, 131, 224))
                                                .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                                                .setStyle(new NotificationCompat.BigTextStyle()
                                                        .bigText("Dorona tracks you continuously, to keep you safe."))
                                                .setPriority(NotificationCompat.PRIORITY_HIGH);
                                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                            NotificationChannel channel = new NotificationChannel("123456", "123456", NotificationManager.IMPORTANCE_HIGH);
                                            NotificationManager notificationManager = (NotificationManager) getSystemService(context, NotificationManager.class);
                                            notificationManager.createNotificationChannel(channel);
                                        }
                                        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(context);
                                        notificationManagerCompat.notify(123, builder.build());
                                    }
                                });
                            }


                        } catch (IOException e) {
                            e.printStackTrace();
                        }

                    }


                }

            });


//


        }
    }
}
