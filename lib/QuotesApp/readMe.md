Api Used - PaperQuotes

In App Api used - http://api.paperquotes.com/apiv1/quotes/?format=json&limit=20&tags=motivation

Packages used - permission_ handler/flutter_background_service/http

Permissions and Tag Used in Manifest-

POST_NOTIFICATIONS
FOREGROUND_SERVICE
FOREGROUND_SERVICE_DATA_SYNC

<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_SPECIAL_USE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC"/>

Inside application tag

<!-- For Foreground Service -->
         <meta-data android:name="com.google.firebase.messaging.default_notification_channel_id" android:value="my_foreground"/>
        <service android:name="id.flutter.flutter_background_service.BackgroundService" android:foregroundServiceType="dataSync" android:exported="true" android:stopWithTask="false"/>
