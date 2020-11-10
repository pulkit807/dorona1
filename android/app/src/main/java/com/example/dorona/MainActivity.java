package com.example.dorona;

import android.app.AlarmManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.google.firebase.firestore.FirebaseFirestore;

import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import static android.content.Context.ALARM_SERVICE;
import static androidx.core.content.ContextCompat.getSystemService;

public class MainActivity extends FlutterActivity {
    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),"Location")
                    .setMethodCallHandler((call,result)->{
                        if(call.method.equals("startLocation")){
                           String userId=call.argument("userId").toString();
                           NewThread thread=new NewThread(userId,this);
                           thread.start();
                        }
                        if(call.method.equals("bluetooth")){
                           // final BluetoothManager manager = (BluetoothManager) getSystemService(BLUETOOTH_SERVICE);
                         //   System.out.println("Bluetooth Address:"+manager.getAdapter().getName());
                            Intent intent=new Intent(this,MyBluetoothConnectivity.class);
                            PendingIntent pendingIntent=PendingIntent.getBroadcast(this,1111,intent,0);
                            AlarmManager alarmManager=(AlarmManager) getSystemService(ALARM_SERVICE);
                            alarmManager.setRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis()+1000,12000,pendingIntent);
                            Intent intent1=new Intent(this,MyBluetoothActionFound.class);
                            intent1.setAction(BluetoothDevice.ACTION_FOUND);
                            PendingIntent pendingIntent1=PendingIntent.getBroadcast(this,1112,intent1,0);
                          //  AlarmManager alarmManager1=(AlarmManager) getSystemService(ALARM_SERVICE);
                           // alarmManager1.setRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis()+1000,60000,pendingIntent1);
    //                        IntentFilter filter=new IntentFilter();
    //                        filter.addAction(BluetoothDevice.ACTION_FOUND);
    //                        registerReceiver(new MyBluetoothActionFound(),filter);
                            String macAddress= Settings.Secure.getString(getContentResolver(),"bluetooth_address");
                            System.out.println(macAddress);
                        }
                        if(call.method.equals("getBluetoothAddress")){
    //                        String macAddress= Settings.Secure.getString(getContentResolver(),"bluetooth_address");
    //                        result.success(macAddress);
                            BluetoothAdapter bluetoothAdapter=BluetoothAdapter.getDefaultAdapter();
                            try {
                                Field mServiceField =  bluetoothAdapter.getClass().getDeclaredField("mService");
                                mServiceField.setAccessible(true);
                                Object btManagerService = mServiceField.get(bluetoothAdapter);
                                if (btManagerService != null) {
                                    String macAddress = (String) btManagerService.getClass().getMethod("getAddress").invoke(btManagerService);
                                    result.success(macAddress);
                                }
                            } catch (NoSuchFieldException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
                                e.printStackTrace();
                                System.out.println(e);
                            }

                        }
                        if(call.method.equals("getAddress")){
                            Geocoder geocoder;
                            geocoder=new Geocoder(this, Locale.getDefault());
                            List<Address> addresses;
                            try {
                                addresses=geocoder.getFromLocation(22.773141,78.537190,1);
                                System.out.println(addresses.get(0).getLocality());
                                System.out.println(addresses.get(0).getPostalCode());

                            } catch (IOException e) {
                                e.printStackTrace();
                            }

                        }
                    }
            );
        }
    }
    class NewThread extends Thread{
        String userId;
        Context context;
        NewThread(String uid,Context context1){
            userId=uid;
            context=context1;
        };
        @Override
        public void run() {
            System.out.println("location service  start");
            Intent intent= new Intent(context,MyLocationBroadcast.class);
            intent.putExtra("userId",userId);
            PendingIntent pendingIntent=PendingIntent.getBroadcast(context.getApplicationContext(),2222,intent,0);
            AlarmManager alarmManager=(AlarmManager) context.getSystemService(ALARM_SERVICE);
            alarmManager.setRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis()+1000,5000,pendingIntent);
        }
    }
}

