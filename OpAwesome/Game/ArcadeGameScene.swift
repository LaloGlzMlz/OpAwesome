//
//  ArcadeGameScene.swift
//  OpAwesome
//
//  Created by Michel Andre Pellegrin Quiroz on 07/12/23.
//

import SpriteKit
import SwiftUI

struct PhysicsCategroy{
    // how we will identify the elements in the game
    // how I know the asteroid is an asteroid
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let player : UInt32 = 0b1
    static let fruits : UInt32 = 0b10
    static let predators : UInt32 = 0b11
    static let walls : UInt32 = 0b100
}
class ArcadeGameScene: SKScene {
    //var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    //var lastUpdate: TimeInterval = 0
    
    //var player: SKSpriteNode!
    
    var player: SKSpriteNode!
        var joystickBase: SKShapeNode!
        var joystickKnob: SKShapeNode?
        var joystickActive: Bool = false
        var mapNode: SKSpriteNode!

        override func didMove(to view: SKView) {
            
            let playerTexture = SKTexture(imageNamed: "OpossumDownFrame")
            let mapTexture = SKTexture(imageNamed: "Map")
            
            // Create the player node
            player = SKSpriteNode(texture: playerTexture)
            player.size = CGSize(width: 75, height: 75)
            player.position = CGPoint(x: size.width / 2, y: size.height / 2)
            

            // Create the map node
            mapNode = SKSpriteNode(texture: mapTexture)
            mapNode.size = CGSize(width: 1800, height: 1800)
            mapNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
            addChild(mapNode)
            addChild(player)

            // Create the joystick base
            joystickBase = SKShapeNode(circleOfRadius: 50)
            joystickBase.position = CGPoint(x: 100, y: 100)
            addChild(joystickBase)

            // Create the joystick knob
            joystickKnob = SKShapeNode(circleOfRadius: 25)
            joystickKnob?.fillColor = .clear
            joystickKnob?.position = joystickBase.position
            addChild(joystickKnob!)
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)

                if joystickBase.contains(location) {
                    joystickActive = true
                }
            }
        }

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let joystickKnob = joystickKnob, joystickActive else { return }

            for touch in touches {
                let location = touch.location(in: self)
                let angle = atan2(location.y - joystickBase.position.y, location.x - joystickBase.position.x)
                let length = joystickBase.frame.size.width / 2

                let x = length * cos(angle)
                let y = length * sin(angle)

                let distance = sqrt(pow(location.x - joystickBase.position.x, 2) + pow(location.y - joystickBase.position.y, 2))

                if distance <= length {
                    joystickKnob.position = CGPoint(x: joystickBase.position.x + x, y: joystickBase.position.y + y)
                } else {
                    joystickKnob.position = CGPoint(x: joystickBase.position.x + cos(angle) * length, y: joystickBase.position.y + sin(angle) * length)
                }

                // Move the map in the opposite direction to create the effect of the map moving under the player
                let speed: CGFloat = 5.0
                mapNode.position.x -= cos(angle) * speed
                mapNode.position.y -= sin(angle) * speed
            }
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            joystickKnob?.position = joystickBase.position
            joystickActive = false
        }

        // Other game logic and methods can go here
    }
