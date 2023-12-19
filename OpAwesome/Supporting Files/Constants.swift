//
//  Constants.swift
//  OpAwesome
//
//  Created by Michel Andre Pellegrin Quiroz on 07/12/23.
//

import Foundation
import SwiftUI

/**
 * # Constants
 *
 * This file gathers contant values that are shared all around the project.
 * Modifying the values of these constants will reflect along the complete interface of the application.
 *
 **/


/**
 * # GameState
 * Defines the different states of the game.
 * Used for supporting the navigation in the project template.
 */

enum GameState {
    case mainScreen
    case playing
    case gameOver
}

typealias Instruction = (icon: String, title: String, description: String, image: String)

/**
 * # MainScreenProperties
 *
 * Keeps the information that shows up on the main screen of the game.
 *
 */

struct MainScreenProperties {
    static let gameTitle: String = "OpAwsome!"
    
    static let gameInstructions: [Instruction] = [
        (icon: "hand.tap", title: "Explore the forest", description: "Use the joystick to move the opossum through the forest.", image: "joystick"),
        (icon: "divide.circle", title: "Find and collect apples", description: "Collect as many apples as you can.", image: "find_apples"),
        (icon: "multiply.circle", title: "Avoid owls", description: "Owls will be hunting in the forest, avoid them and their field of view!", image: "owls_instructions"),
        (icon: "multiply.circle", title: "Play dead!", description: "Use the button to play dead. This action consumes apples!", image: "FakeDead")
    ]
    
    /**
     * To change the Accent Color of the applciation edit it on the Assets folder.
     */
    
    static let accentColor: Color = Color.accentColor
}
