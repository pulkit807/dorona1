package com.example.dorona;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import static android.content.Context.ALARM_SERVICE;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),"Location")
                .setMethodCallHandler((call,result)->{
                    if(call.method.equals("startLocation")){
                       String userId=call.argument("userId").toString();
                       NewThread thread=new NewThread(userId,this);
                       thread.start();
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
