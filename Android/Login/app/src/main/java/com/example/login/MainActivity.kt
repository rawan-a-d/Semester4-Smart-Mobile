package com.example.login

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        /*val loginButton = findViewById<Button>(R.id.button);

        val username = findViewById<EditText>(R.id.editTextUsername);

        loginButton.setOnClickListener {
            Toast.makeText(this, "Hello " + username.text, Toast.LENGTH_LONG).show();
        }*/
    }


    /* Called when the user logs in */
    fun logIn(view: View) {
        val usernameTextView = findViewById<EditText>(R.id.editTextUsername);
        // username
        val username = usernameTextView.text.toString();

        // Greet user
        Toast.makeText(this, "Hello $username", Toast.LENGTH_LONG).show();
    }
}