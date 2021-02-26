package com.rawan.loginsharedpreferences

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Switch
import android.widget.Toast

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // get shared preferences in mode private (only this app can access them)
        val sharedPref = getSharedPreferences("LOGIN_INFO", Context.MODE_PRIVATE)
        // Shared preferences
        val editor = sharedPref.edit()

        // get credentials
        val username = sharedPref.getString("username", null)
        val password = sharedPref.getString("password", null)

/*        if(username != null) {
            findViewById<EditText>(R.id.editTextUsername).setText(username)
        }
        if(password != null) {
            findViewById<EditText>(R.id.editTextPassword).setText(password)
        }*/

        // OR
        if(username != null && password != null) {
            // redirect to welcome
            val intent = Intent(this, Welcome::class.java)
            startActivity(intent)
        }

        // on login button press
        findViewById<Button>(R.id.buttonLogin).setOnClickListener {
            val username = findViewById<EditText>(R.id.editTextUsername).text.toString()
            val password = findViewById<EditText>(R.id.editTextPassword).text.toString()
            //val rememberMe = findViewById<Switch>(R.id.switchRememberMe).isChecked

            if(username.isEmpty() || password.isEmpty()) {
                Toast.makeText(this, "Please fill in your credentials", Toast.LENGTH_LONG).show()
            }
            else {
                //if(rememberMe) {
                    // save to shared preferences
                    editor.apply {
                        putString("username", username)
                        putString("password", password)
                        // finish and write to shared preferences
                        apply()
                    }
               // }

                // redirect to welcome page
                val intent = Intent(this, Welcome::class.java)
                startActivity(intent)
            }
        }


    }
}