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
    
    var gameCamera = SKCameraNode()

        override func didMove(to view: SKView) {
            
            let playerTexture = SKTexture(imageNamed: "OpossumDownFrame")
            let mapTexture = SKTexture(imageNamed: "Map")
            self.camera = gameCamera
            addChild(gameCamera)
            
            // Create the player node
            player = SKSpriteNode(texture: playerTexture)
            print("player gets created")
            
            player.size = CGSize(width: 75, height: 75)
            player.position = CGPoint(x: size.width / 2, y: size.height / 2)
            player.physicsBody = SKPhysicsBody(circleOfRadius:  40)
            player.physicsBody?.categoryBitMask = PhysicsCategroy.player
            player.physicsBody?.contactTestBitMask = PhysicsCategroy.fruits
            player.physicsBody?.collisionBitMask = PhysicsCategroy.fruits
            player.physicsBody?.affectedByGravity = false
            

            // Create the map node
            mapNode = SKSpriteNode(texture: mapTexture)
            mapNode.size = CGSize(width: 1800, height: 1800)
            mapNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
            addChild(mapNode)
            addChild(player)

            // Create the joystick base
            joystickBase = SKShapeNode(circleOfRadius: 50)
            joystickBase.position = CGPoint(x: -300, y: -100)
            joystickBase.zPosition = 5
            gameCamera.addChild(joystickBase)

            // Create the joystick knob
            joystickKnob = SKShapeNode(circleOfRadius: 25)
            joystickKnob?.fillColor = .white
            joystickKnob?.position = joystickBase.position
            joystickKnob?.zPosition = 5
            gameCamera.addChild(joystickKnob!)
            
            
            setUpPhysicsWorld()
            generateFruit()
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)

                if let touchedNode = atPoint(location) as? SKShapeNode, touchedNode == joystickBase || touchedNode == joystickKnob {
                    joystickActive = true
                }
            }
        }

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let joystickKnob = joystickKnob, joystickActive else { return }

            for touch in touches {
                let location = touch.location(in: self.gameCamera)
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

                // Move the player
                movePlayer(vector: CGVector(dx: cos(angle), dy: sin(angle)))
            }
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            joystickKnob?.position = joystickBase.position
            joystickActive = false
            player.physicsBody?.velocity = .zero
        }
    
    //Fruit spawning
    private func generateFruit() {
        let newFruitPosition = randomFruitPosition()
        let newFruit = SKSpriteNode(imageNamed: "apple")
        
        
        newFruit.name = "fruit"
        newFruit.position = newFruitPosition
        newFruit.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        newFruit.physicsBody?.categoryBitMask = PhysicsCategroy.fruits
        newFruit.physicsBody?.contactTestBitMask = PhysicsCategroy.player
        newFruit.physicsBody?.collisionBitMask = PhysicsCategroy.player
        newFruit.physicsBody?.affectedByGravity = false
        
        addChild(newFruit)
        
    }
    
    private func randomFruitPosition() -> CGPoint{
        var position = player.position
        position.x += 200
        return position
        
        //TODO: Replace code to generate actual random positions
    }
    
        // Other game logic and methods can go here
    
    func movePlayer(vector: CGVector) {
        
        let speed: CGFloat = 100
        
        player.physicsBody?.velocity = CGVector(dx: vector.dx * speed, dy: vector.dy * speed)
    }
    
 
    
    override func update(_ currentTime: TimeInterval) {
        
        //To make the camera follow the player
        gameCamera.position = player.position
    }
    
    private func setUpPhysicsWorld() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
}


extension ArcadeGameScene: SKPhysicsContactDelegate {
    //To manage the behavior in respons to two physics bodies having contact
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact happened!")
        
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if let node = firstBody.node, node.name == "fruit" {
            node.removeFromParent()
        }
        
        if let node = secondBody.node, node.name == "fruit" {
            node.removeFromParent()
        }
    }
}
