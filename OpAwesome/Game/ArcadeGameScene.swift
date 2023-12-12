//
//  ArcadeGameScene.swift
//  OpAwesome
//
//  Created by Michel Andre Pellegrin Quiroz on 07/12/23.
//

import SpriteKit
import SwiftUI

struct PhysicsCategory{
    // how we will identify the elements in the game
    // how I know the asteroid is an asteroid
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let player : UInt32 = 0b1
    static let fruits : UInt32 = 0b10
    static let predators : UInt32 = 0b11
    static let wall : UInt32 = 0b100
}


class ArcadeGameScene: SKScene {
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    var lastUpdate: TimeInterval = 0
    
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
            player.position = CGPoint(x: size.width / 1.5, y: size.height / 2)
            player.physicsBody = SKPhysicsBody(texture: playerTexture, size: player.size) // collidable area mapped to alpha channel of sprite
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.fruits
            player.physicsBody?.collisionBitMask = PhysicsCategory.wall | PhysicsCategory.fruits
            player.physicsBody?.allowsRotation = false
            player.physicsBody?.affectedByGravity = false
            

            

            // Create the map node
            mapNode = SKSpriteNode(texture: mapTexture)
            mapNode.size = CGSize(width: 1800, height: 1800)
            mapNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
            addChild(mapNode)
            addChild(player)
            
            //Create the movement constraints for the player (player can't exit the map)
            let xRange = SKRange(lowerLimit: -mapNode.size.width / 2, upperLimit: mapNode.size.width / 2)
            let yRange = SKRange(lowerLimit: -mapNode.size.height / 2, upperLimit: mapNode.size.width / 2)
            let xConstraint = SKConstraint.positionX(xRange)
            let yConstraint = SKConstraint.positionY(yRange)
            
            player.constraints = [xConstraint, yConstraint]
            

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
            startFruitCycle()
            createWall()
        }
    
        func createWall() {
            let wallSize = CGSize(width: 200, height: 250)
            let wall = SKSpriteNode(color: .blue, size: wallSize)
            wall.position = CGPoint(x: size.width / 1, y: size.height / 1)

            wall.physicsBody = SKPhysicsBody(rectangleOf: wallSize)
            wall.physicsBody?.isDynamic = false
            wall.physicsBody?.categoryBitMask = PhysicsCategory.wall
            wall.physicsBody?.contactTestBitMask = PhysicsCategory.player
            wall.physicsBody?.collisionBitMask = PhysicsCategory.player

            addChild(wall)
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
    
    private func startFruitCycle() {
        let createFruitAction = SKAction.run(generateFruit)
        let waitAction = SKAction.wait(forDuration: 5.0)
        
        let createAndWaitAction = SKAction.sequence([createFruitAction, waitAction])
        let fruitCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(fruitCycleAction)
    }
    
    private func generateFruit() {
        let newFruitPosition = randomFruitPosition()
        let newFruit = SKSpriteNode(imageNamed: "apple")
        
        
        newFruit.name = "fruit"
        newFruit.position = newFruitPosition
        newFruit.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        newFruit.physicsBody?.categoryBitMask = PhysicsCategory.fruits
        newFruit.physicsBody?.contactTestBitMask = PhysicsCategory.player
        newFruit.physicsBody?.collisionBitMask = PhysicsCategory.player
        newFruit.physicsBody?.affectedByGravity = false
        
        addChild(newFruit)
        
    }
    
    private func randomFruitPosition() -> CGPoint{
        let xSpawnRange = -mapNode.size.width / 2 + 30 ... mapNode.size.width / 2 - 30
        let ySpawnRange = -mapNode.size.height / 2 + 30 ... mapNode.size.height / 2 - 30
        
        let position = CGPoint(x: CGFloat.random(in: xSpawnRange), y: CGFloat.random(in: ySpawnRange))
        
        return position
        
        //TODO: Replace code to generate actual random positions
    }
    
        // Other game logic and methods can go here
    
    func movePlayer(vector: CGVector) {
        
        let speed: CGFloat = 150
        
        player.physicsBody?.velocity = CGVector(dx: vector.dx * speed, dy: vector.dy * speed)
    }
    
 
    
    override func update(_ currentTime: TimeInterval) {
        
        //To make the camera follow the player
        gameCamera.position = player.position
        
        //To increase the timer counter
        
        // The first time the update function is called we must initialize the
        // lastUpdate variable
        if self.lastUpdate == 0 { self.lastUpdate = currentTime }
        
        // Calculates how much time has passed since the last update
        let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
        // Increments the length of the game session at the game logic
        self.gameLogic.increaseSessionTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
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
            gameLogic.score(points: 1)
        }
        
        if let node = secondBody.node, node.name == "fruit" {
            node.removeFromParent()
            gameLogic.score(points: 1)
        }
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if collision == PhysicsCategory.wall | PhysicsCategory.player {
            print("Player collided with the wall")
        }
    }
}
