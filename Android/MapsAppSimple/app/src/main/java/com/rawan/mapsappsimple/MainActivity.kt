package com.rawan.mapsappsimple

import android.Manifest
import android.annotation.SuppressLint
import android.content.IntentSender
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Looper
import android.util.Log
import android.widget.TextView
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.*
import com.google.android.gms.tasks.Task


// RESOURCES
// https://stackoverflow.com/questions/45958226/get-location-android-kotlin
// https://developer.android.com/training/permissions/requesting
class MainActivity : AppCompatActivity() {
    private lateinit var fusedLocationClient : FusedLocationProviderClient
    //private lateinit var locationCallback: LocationCallback

    private lateinit var locationRequest: LocationRequest


    //
/*    private val locationCallback: LocationCallback = object : LocationCallback() {
        override fun onLocationResult(locationResult: LocationResult?) {
            if (locationResult != null) {
                //showLocation(R.id.textView, locationResult.lastLocation)

                findViewById<TextView>(R.id.textViewLocation).text = ("" + locationResult.lastLocation.longitude + ":" + locationResult.lastLocation.latitude)

            }
        }
    }*/


    //private lateinit var fusedLocationClient: FusedLocationProviderClient

    lateinit var settingsClient: SettingsClient

    //lateinit var locationRequest: LocationRequest

    lateinit var locationCallback: LocationCallback

    @SuppressLint("MissingPermission")
    fun createLocationRequest() {
        println("createLocationRequest ")

        locationRequest = LocationRequest().apply {
            interval = 10000
            fastestInterval = 5000
            priority = LocationRequest.PRIORITY_HIGH_ACCURACY
        }

        val builder = LocationSettingsRequest.Builder()
                .addLocationRequest(locationRequest)

        settingsClient = LocationServices.getSettingsClient(this)

        val task: Task<LocationSettingsResponse> = settingsClient.checkLocationSettings(builder.build())

        task.addOnSuccessListener { locationSettingsResponse ->
            // All location settings are satisfied. The client can initialize
            // location requests here.
            // ...
            fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, Looper.getMainLooper())

        }

        task.addOnFailureListener { exception ->
            if (exception is ResolvableApiException) {
                // Location settings are not satisfied, but this can be fixed
                // by showing the user a dialog.
                try {
                    // Show the dialog by calling startResolutionForResult(),
                    // and check the result in onActivityResult().
                    //exception.startResolutionForResult(this@MainActivity,
                    //REQUEST_CHECK_SETTINGS)
                } catch (sendEx: IntentSender.SendIntentException) {
                    // Ignore the error.
                }
            }
        }
    }

    private fun createLocationCallBack() {
        println("createLocationCallBack ")

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                super.onLocationResult(locationResult)

                //Do what you want with the position here
               println("createLocationCallBack $locationResult")
            }
        }

    }




    //




    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        requestLocationPermission()

        println("onCreate ")


        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        createLocationRequest()

        createLocationCallBack()
    }

    //define the listener
    private val locationListener: LocationListener = object : LocationListener {
        override fun onLocationChanged(location: Location) {
            println("onLocationChanged $location")


            findViewById<TextView>(R.id.textViewLocation).text = ("" + location.longitude + "\n" +  + location.latitude)
            //textViewLocation.text = ("" + location.longitude + ":" + location.latitude)
        }
        override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {}
        override fun onProviderEnabled(provider: String) {}
        override fun onProviderDisabled(provider: String) {}
    }


    // Register the permissions callback, which handles the user's response to the
    // system permissions dialog. Save the return value, an instance of
    // ActivityResultLauncher. You can use either a val, as shown in this snippet,
    // or a lateinit var in your onAttach() or onCreate() method.
    private val requestPermissionLauncher =
            registerForActivityResult(ActivityResultContracts.RequestPermission()
            ) { isGranted: Boolean ->
                if (isGranted) {
                    // Permission is granted. Continue the action or workflow in your
                    // app.
                    startLocation()
                } else {
                    // Explain to the user that the feature is unavailable because the
                    // features requires a permission that the user has denied. At the
                    // same time, respect the user's decision. Don't link to system
                    // settings in an effort to convince the user to change their
                    // decision.
                }
            }

    private fun requestLocationPermission() {
        when {
            ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_COARSE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED -> {
                // You can use the API that requires the permission.
                startLocation()
            }
            // HOHOHOHO
            ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.ACCESS_COARSE_LOCATION) -> {

            }
            else -> {
                // You can directly ask for the permission.
                // The registered ActivityResultCallback gets the result of this request.
                requestPermissionLauncher.launch(
                        Manifest.permission.ACCESS_COARSE_LOCATION)
            }
        }
    }


    private fun startLocation() {
        // inside a basic activity
        // Create persistent LocationManager reference
        var locationManager : LocationManager = getSystemService(LOCATION_SERVICE) as LocationManager

        println("startLocation ")

        // findViewById<Button>(R.id.buttonShowLocation).setOnClickListener { view ->
            try {
                // Request location updates
                locationManager?.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0L, 0f, locationListener)
            } catch(ex: SecurityException) {
                Log.d("myTag", "Security Exception, no location available")
            }
        //}
    }


    override fun onResume() {
        super.onResume()
        //if (requestingLocationUpdates)

        println("OnResume ")
        startLocationUpdates()
    }


    /**
     * call this method for receive location
     * get location and give callback when successfully retrieve
     * function itself check location permission before access related methods
     *
     */
/*    fun getLastKnownLocation() {
        fusedLocationClient.lastLocation
                .addOnSuccessListener { location->
                    if (location != null) {
                        // use your location object
                        // get latitude , longitude and other info from this
                    }

                }

    }*/


    /**
     * call this method in onCreate
     * onLocationResult call when location is changed
     */
/*    private fun getLocationUpdates()
    {
        //fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        locationRequest = LocationRequest()
        locationRequest.interval = 50000
        locationRequest.fastestInterval = 50000
        locationRequest.smallestDisplacement = 170f // 170 m = 0.1 mile
        locationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY //set according to your app function
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult?) {
                locationResult ?: return

                if (locationResult.locations.isNotEmpty()) {
                    // get latest location
                    val location =
                            locationResult.lastLocation
                    // use your location object
                    // get latitude , longitude and other info from this
                }


            }
        }
    }*/

    private fun startLocationUpdates() {
        if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                && ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(this, "First enable LOCATION ACCESS in settings.", Toast.LENGTH_LONG).show();
            return;
        }
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        println("fusedLocationClient ${fusedLocationClient.lastLocation}")

        println("locationRequest $locationRequest")
        println("locationCallback $locationCallback")
        println("Looper " + Looper.getMainLooper())

        println("fusedLocationClient.lastLocation " + fusedLocationClient)

        //findViewById<TextView>(R.id.textViewLocation).text = ("" + fusedLocationClient.lastLocation.result.longitude + "\n" +  + fusedLocationClient.lastLocation.result.latitude )

        fusedLocationClient.requestLocationUpdates(locationRequest,
                locationCallback,
                Looper.getMainLooper()
        )
    }
}