package com.rawan.photoapp

import android.Manifest.permission.CAMERA
import android.Manifest.permission.WRITE_EXTERNAL_STORAGE
import android.app.Activity
import android.content.ContentValues
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.provider.MediaStore
import android.widget.Button
import android.widget.ImageView
import android.widget.Toast

/*  Start by making a photo app  (Links to an external site.)that either stores the photo's on the internal or external storage
    Choose a server technology most suitable for your Duo App (maybe even both) and create a proof of concept using the given tutorial or one of your own choosing.
    Save the client login data for your server in the shared preferences of your app.*/
class MainActivity : AppCompatActivity() {
    private val IMAGE_CAPTURE_CODE = 1001
    private val PERMISSION_CODE = 100
    var imageUri: Uri? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // button click
        var captureBtn: Button = findViewById<Button>(R.id.capture_btn)

        captureBtn.setOnClickListener {
            // if system os is Marshmallow or above, we need to request runtime permission
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if(checkSelfPermission(CAMERA)
                    == PackageManager.PERMISSION_DENIED ||
                    checkSelfPermission(WRITE_EXTERNAL_STORAGE)
                    == PackageManager.PERMISSION_DENIED) {
                    // permission was not enabled
                    val permission = arrayOf(CAMERA, WRITE_EXTERNAL_STORAGE)

                    // show popup to request permission
                    requestPermissions(permission, PERMISSION_CODE)
                }
                else {
                    // permission already granted
                    openCamera()
                }
            }
            else {
                // system os is < marshmallow
                openCamera()
            }
        }
    }

    private fun openCamera() {
        val values = ContentValues()

        values.put(MediaStore.Images.Media.TITLE, "New Photo")
        values.put(MediaStore.Images.Media.DESCRIPTION, "From the Camera")

        imageUri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)

        // camera intent
        val cameraIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri)
        startActivityForResult(cameraIntent, IMAGE_CAPTURE_CODE)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        // called when user presses ALLOW or DENY from Permission Request Popup
        when(requestCode) {
            PERMISSION_CODE -> {
                if(grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // permission from popup was granted
                    openCamera()
                }
                else {
                    // permission from popup was denied
                    Toast.makeText(this, "Permission denied", Toast.LENGTH_SHORT).show()
                }
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        // called when image was captured from camera intent
        if(resultCode == Activity.RESULT_OK) {
            // set image captured to image view
            var imageView: ImageView = findViewById<ImageView>(R.id.image_view)
            imageView.setImageURI(imageUri)

        }
    }
}