package com.rawan.loginsharedpreferences

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast

class Welcome : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_welcome)

        // get shared preferences in mode private (only this app can access them)
        val sharedPref = getSharedPreferences("LOGIN_INFO", Context.MODE_PRIVATE)

        showGreeting(sharedPref)

        // on logout button press
        findViewById<Button>(R.id.buttonLogout).setOnClickListener {
            // clear shared preferences
            sharedPref.edit().clear().commit()

            // redirect to login screen
            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)
        }

    }

    private fun showGreeting(sharedPref: SharedPreferences) {
        val username = sharedPref.getString("username", null)

        findViewById<TextView>(R.id.textViewWelcome).text = "Welcome $username"
    }
}