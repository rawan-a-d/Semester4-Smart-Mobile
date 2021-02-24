package com.rawan.dicer

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView

/**
 * A simple [Fragment] subclass as the second destination in the navigation.
 */
class SecondFragment : Fragment() {
    private var dicesImages = arrayOf(R.drawable.dice_1, R.drawable.dice_2, R.drawable.dice_3, R.drawable.dice_4, R.drawable.dice_5, R.drawable.dice_6)

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_second, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        view.findViewById<Button>(R.id.button_second).setOnClickListener {
            // get random numbers
            val firstRandomNr = (0..5).random() // generated random from 0 to 6 included
            val secondRandomNr = (0..5).random() // generated random from 0 to 6 included

            // get corresponding images
            var firstDiceImage = dicesImages[firstRandomNr]
            var secondDiceImage = dicesImages[secondRandomNr]

            // display images
            view.findViewById<ImageView>(R.id.firstDice).setImageResource(firstDiceImage)
            view.findViewById<ImageView>(R.id.secondDice).setImageResource(secondDiceImage)
        }
    }
}