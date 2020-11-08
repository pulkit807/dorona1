package com.example.dorona;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Build;
import android.os.Vibrator;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;

public class MyBluetoothActionFound extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        System.out.println("Action Found fired");
        System.out.println("Action:"+action);
        if (BluetoothDevice.ACTION_FOUND.equals(action)) {
            // Discovery has found a device. Get the BluetoothDevice
            // object and its info from the Intent.
            BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
            String deviceName = device.getName();
            String deviceHardwareAddress = device.getAddress(); // MAC address
            System.out.println(deviceName+":"+deviceHardwareAddress);
            FirebaseFirestore.getInstance().collection("bluetoothAddress").document(deviceHardwareAddress).get().addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
                @Override
                public void onComplete(@NonNull Task<DocumentSnapshot> task) {
                    if(task.isSuccessful()){
                        DocumentSnapshot documentSnapshot=task.getResult();
                        if(documentSnapshot.exists()){
                            Vibrator vibrator=(Vibrator) context.getSystemService(Context.VIBRATOR_SERVICE);
                            vibrator.vibrate(2000);
                            if(documentSnapshot.get("status").equals("He/she is at high risk")){
                                NotificationCompat.Builder builder=new NotificationCompat.Builder(context,"1234567")
                                        .setContentTitle("Dorona Update")
                                        .setLargeIcon(BitmapFactory.decodeResource(context.getResources(),R.mipmap.coronavirus))
                                        .setSmallIcon(R.mipmap.ic_launcher)
                                        .setColor(Color.rgb(236,14,45))
                                        .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                                        .setStyle(new NotificationCompat.BigTextStyle()
                                                .bigText("One person near you is at high risk"))
                                        .setPriority(NotificationCompat.PRIORITY_HIGH);
                                if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.O){
                                    NotificationChannel channel=new NotificationChannel("1234567","1234567", NotificationManager.IMPORTANCE_HIGH);
                                    NotificationManager notificationManager= (NotificationManager) context.getSystemService(NotificationManager.class);
                                    notificationManager.createNotificationChannel(channel);
                                }
                                NotificationManagerCompat notificationManagerCompat=NotificationManagerCompat.from(context);
                                notificationManagerCompat.notify(1234,builder.build());
                            }

                        }
                    }
                }
            });
        }

    }
}
