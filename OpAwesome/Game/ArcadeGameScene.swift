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
    static let walls : UInt32 = 0b100
}


class ArcadeGameScene: SKScene {
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    var lastUpdate: TimeInterval = 0
    
    //var player: SKSpriteNode!
    
    var player: SKSpriteNode!
    var movementWhithinMap: [SKConstraint]!
        var joystickBase: SKShapeNode!
        var joystickKnob: SKShapeNode?
        var joystickActive: Bool = false
        var mapNode: SKSpriteNode!
    var enemies: [SKSpriteNode] = []
    
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
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.collisionBitMask = PhysicsCategory.none
            player.physicsBody?.contactTestBitMask = PhysicsCategory.all
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.allowsRotation = false
            

            

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
            movementWhithinMap = [xConstraint, yConstraint]
            
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
            
            //Create the enemy
            createEnemies()
            
            
            setUpPhysicsWorld()
            startFruitCycle()
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
        newFruit.physicsBody?.collisionBitMask = PhysicsCategory.none
        newFruit.physicsBody?.contactTestBitMask = PhysicsCategory.all
        newFruit.physicsBody?.affectedByGravity = false
        
        addChild(newFruit)
        
    }
    
    private func randomFruitPosition() -> CGPoint{
        let xSpawnRange = -mapNode.size.width / 2 + 30 ... mapNode.size.width / 2 - 30
        let ySpawnRange = -mapNode.size.height / 2 + 30 ... mapNode.size.height / 2 - 30
        
        let position = CGPoint(x: CGFloat.random(in: xSpawnRange), y: CGFloat.random(in: ySpawnRange))
        
        return position
    }
    
        // Other game logic and methods can go here
    
    func movePlayer(vector: CGVector) {
        
        let speed: CGFloat = 300
        
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
        
        //Check if the player has been spotted by an enemy
        for enemy in enemies {
            //Since the viewCone of the enemy is a child of the enemy, we need to convert the position of the player to make it relative to the enemy as well to detect an overlap
            let playerRelativePosition = convert(player.position, to: enemy)
            
            let viewCone = enemy.children.first(where: {node in node.name == "fieldOfView"})
            if viewCone?.contains(playerRelativePosition) ?? false {
                gameOver()
            }
            
        }
    }
    
    private func setUpPhysicsWorld() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    
    //MARK: Enemies
    func createEnemies() {
//        let movementAction = createMovementAction()
        let owlFlyingDown = [SKTexture(imageNamed: "owlFlyingDown0"), SKTexture(imageNamed: "owlFlyingDown1"), SKTexture(imageNamed: "owlFlyingDown2"), SKTexture(imageNamed: "owlFlyingDown1")]
        let owlStandingDown = SKTexture(imageNamed: "owlStandingDown")
        
        for _ in 0..<5 {
            let enemy = SKSpriteNode()
            enemy.size = player.size
            enemy.position = randomFruitPosition()
            enemy.constraints = movementWhithinMap
            enemy.zPosition = 3
            enemy.texture = owlStandingDown
            
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: 35)
            enemy.physicsBody?.categoryBitMask = PhysicsCategory.predators
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.allowsRotation = false
            enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
            addChild(enemy)
            
//            enemy.run(movementAction)
            
            let visionCone = createFieldOfView()
            enemy.addChild(visionCone)
            
            let moveAction = SKAction.run {
                if self.decideMove() {
                    let angle = self.randomAngle()
                    let velocity = self.movementDirection(angle: angle)
                    enemy.physicsBody?.velocity = velocity
                    visionCone.zRotation = CGFloat(angle)
                    enemy.run(SKAction.repeatForever(SKAction.animate(with: owlFlyingDown, timePerFrame: 0.1)), withKey: ActionKeys.animation.rawValue)
                } else {
                    enemy.physicsBody?.velocity = .zero
                    enemy.removeAction(forKey: ActionKeys.animation.rawValue)
                }
                if enemy.physicsBody?.velocity == .zero {
                    enemy.texture = owlStandingDown
                }
            }
            
            let waitAction = SKAction.wait(forDuration: 5.0)
            let fullActiom = SKAction.sequence([moveAction, waitAction])
            
            enemy.run(SKAction.repeatForever(fullActiom))
            enemies.append(enemy)
        }
    }
    
    
    func decideMove() -> Bool {
        let range = 0...10
        let choice = Int.random(in: range)
        return choice < 7
    }
    
    //generate random angle in radians
    func randomAngle() -> Float {
        let angleRange: Range<Float> = 0..<2 * Float.pi
        
        return Float.random(in: angleRange)
    }

    func movementDirection(angle: Float) -> CGVector {
        let velocity: Float = 150
         
        let x: CGFloat = CGFloat(-sin(angle) * velocity)
        let y: CGFloat = CGFloat(cos(angle) * velocity)
        //Why are sin and cos effed up, you may wonder. When the character moves, I need to change the orientation of the field of view and the sprite of the character accordingly. The angle 0 for the orientation of the field of view is currently the y+ axis. I used cos and sin like this to be coherent with that angle. I may change it later like so: sin and cos go back to their rightful places, i'll modify the shape of the field of view so that it extends to the right rather than to the top
        
        return CGVector(dx: x, dy: y)
    }

    func createFieldOfView() -> SKShapeNode {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 100, y: 200))
        path.addLine(to: CGPoint(x: -100, y: 200))
        path.closeSubpath()
        
        let fieldOfView = SKShapeNode()
        fieldOfView.name = "fieldOfView"
        fieldOfView.path = path
        fieldOfView.strokeColor = .clear
        fieldOfView.fillColor = .yellow
        fieldOfView.alpha = 0.4
        fieldOfView.zPosition = 1
        fieldOfView.position = .zero
        
        
        return fieldOfView
    }
}

//MARK: PhysicsContactDelegate
extension ArcadeGameScene: SKPhysicsContactDelegate {
    //To manage the behavior in respons to two physics bodies having contact
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact happened!")
        
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if let node = firstBody.node, node.name == "fruit" {
            node.removeFromParent()
            if secondBody.categoryBitMask == PhysicsCategory.player {
                gameLogic.score(points: 1)
            }
        }
        
        if let node = secondBody.node, node.name == "fruit" {
            node.removeFromParent()
            if firstBody.categoryBitMask == PhysicsCategory.player {
                gameLogic.score(points: 1)
            }
        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.predators) ||
            (firstBody.categoryBitMask == PhysicsCategory.predators && secondBody.categoryBitMask == PhysicsCategory.player) {
            gameLogic.isGameOver = true
            print("game over")
        }
    }
    
    //MARK: Game over
    func gameOver() {
        print("mannacc mannacc")
        gameLogic.isGameOver = true
    }
}

enum ActionKeys: String {
    case animation, movement
}
