package com.rawan.mapsapp

import android.Manifest
import android.annotation.SuppressLint
import android.app.Service.START_STICKY
import android.content.ContentValues.TAG
import android.content.Intent
import android.content.pm.PackageManager
import android.location.*
import android.location.LocationListener
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.core.content.ContextCompat

import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions

import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.*
// ******************************
import java.util.*

class MapsActivity : AppCompatActivity(), OnMapReadyCallback {
    // Pass userLocation to showLocation
    private lateinit var mMap: GoogleMap

    // used to get user's location
   private lateinit var locationManager : LocationManager
   private lateinit var userLocation: Location

       private lateinit var locationCallback: LocationCallback

    lateinit var locationRequest: LocationRequest
    var fusedLocationClient: FusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(this)


    // NEW
//    var locationManager: LocationManager? = null
//
//    override fun onBind(intent: Intent?) = null
//
//    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//        super.onStartCommand(intent, flags, startId)
//        return START_STICKY
//    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // request permission
        //requestLocationPermission()


/*
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult?) {
                locationResult ?: return
                for (location in locationResult.locations){
                    // Update UI with location data
                    // ...
                    userLocation = location
                    showLocation()
                }
            }
        }*/

        val crit : Criteria = Criteria();
        crit.accuracy = Criteria.ACCURACY_FINE;
        val provider = locationManager.getBestProvider(crit, false).toString();
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }

        println("crit " + crit)
        println("provider " + provider)
        println("locationManager " + locationManager)

        locationManager.requestLocationUpdates(provider, 0, 3f, locationListener);

        setContentView(R.layout.activity_maps)

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        val mapFragment = supportFragmentManager
                .findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)
    }

    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    override fun onMapReady(googleMap: GoogleMap) {
        mMap = googleMap

        //fusedLocationClient =


        //val address = getAddress(userLocation.latitude, userLocation.longitude)

        showLocation()
    }


    private fun showLocation() {
        mMap.clear()

        //val location = LatLng(userLocation.latitude, userLocation.longitude)
        val location = LatLng(userLocation.latitude, userLocation.longitude)

        println("showLocation $location")

        // Add a marker in current location and move the camera
        mMap.addMarker(MarkerOptions().position(location).title("Current location"))
        mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(location, 15f))
    }


    //define the listener
    private val locationListener: LocationListener = object : LocationListener {

        override fun onLocationChanged(location: Location) {
            Log.v(TAG, "IN ON LOCATION CHANGE, lat=" + location.latitude + ", lon=" + location.longitude);

            println("onLocationChanged $location")
            userLocation = location

            showLocation()
        }
        override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {}
        override fun onProviderEnabled(provider: String) {}
        override fun onProviderDisabled(provider: String) {}
    }

    // Register the permissions callback, which handles the user's response to the
    // system permissions dialog. Save the return value, an instance of
    // ActivityResultLauncher. You can use either a val, as shown in this snippet,
    // `or a lateinit var in your onAttach() or onCreate() method.
    private val requestPermissionLauncher =
            registerForActivityResult(
                    ActivityResultContracts.RequestPermission()
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
                    Toast.makeText(applicationContext,"We can't show your current location" ,Toast.LENGTH_SHORT).show()
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
            //shouldShowRequestPermissionRationale(Manifest.permission.ACCESS_COARSE_LOCATION) -> {
       // }
            else -> {
                // You can directly ask for the permission.
                // The registered ActivityResultCallback gets the result of this request.
                requestPermissionLauncher.launch(
                        Manifest.permission.ACCESS_COARSE_LOCATION)
            }
        }
    }

    private fun startLocation() {
        // Create persistent LocationManager reference
        //locationManager = getSystemService(LOCATION_SERVICE) as LocationManager

        try {
            // Request location updates
            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0L, 0f, locationListener)

            userLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)!!
        } catch(ex: SecurityException) {
            Log.d("myTag", "Security Exception, no location available")
        }
    }

/*    override fun onPause() {
        super.onPause()
        stopLocationUpdates()
    }

    private fun stopLocationUpdates() {
        fusedLocationClient.removeLocationUpdates(locationCallback)
    }

    override fun onResume() {
        super.onResume()
        if (requestingLocationUpdates) startLocationUpdates()
    }*/

/*    override fun onResume() {
        super.onResume()
        LocationManager.requestLocationUpdates(best, 10000, 1, locationListener);
    }

    override fun onPause() {
        super.onPause()
        fusedLocationClient.requestLocationUpdates(locationRequest,
                locationCallback,
                Looper.getMainLooper())
    }*/





    private fun getAddress(lat: Double, lng: Double): String {
        var addresses: List<Address>;
        val geocoder = Geocoder(this, Locale.getDefault());

        addresses = geocoder.getFromLocation(lat, lng, 1); // Here 1 represent max location result to returned, by documents it recommended 1 to 5

        val address: String = addresses.get(0).getAddressLine(0); // If any additional address line present than only, check with max available address lines by getMaxAddressLineIndex()
/*        String city = addresses.get(0).getLocality();
        String state = addresses.get(0).getAdminArea();
        String country = addresses.get(0).getCountryName();
        String postalCode = addresses.get(0).getPostalCode();
        String knownName = addresses.get(0).getFeatureName(); // Only if available else return NULL*/
        return address;
    }
}