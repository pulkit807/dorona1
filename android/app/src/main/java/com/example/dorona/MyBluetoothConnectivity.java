package com.example.dorona;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Build;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import static androidx.core.content.ContextCompat.getSystemService;

public class MyBluetoothConnectivity extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        BluetoothAdapter bluetoothAdapter=BluetoothAdapter.getDefaultAdapter();
        System.out.println(bluetoothAdapter.getAddress());
        bluetoothAdapter.startDiscovery();
//        if(bluetoothAdapter.startDiscovery()){
//            NotificationCompat.Builder builder=new NotificationCompat.Builder(context,"12347")
//                    .setContentTitle("Dorona Bluetooth from broadcast")
//                    .setSmallIcon(R.mipmap.ic_launcher)
//                    .setColor(Color.rgb(128,131,224))
//                    .setCategory(NotificationCompat.CATEGORY_MESSAGE)
//                    .setStyle(new NotificationCompat.BigTextStyle()
//                            .bigText("Discovery started"))
//                    .setPriority(NotificationCompat.PRIORITY_HIGH);
//            if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.O){
//                NotificationChannel channel=new NotificationChannel("14567","12347", NotificationManager.IMPORTANCE_HIGH);
//                NotificationManager notificationManager= (NotificationManager) context.getSystemService(NotificationManager.class);
//                notificationManager.createNotificationChannel(channel);
//            }
//            NotificationManagerCompat notificationManagerCompat=NotificationManagerCompat.from(context);
//            notificationManagerCompat.notify(12345,builder.build());
//        }


    }
}
