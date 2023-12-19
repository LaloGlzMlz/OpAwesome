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
    var player: SKSpriteNode!
    var playerCharacter: Character!
    var movementWhithinMap: [SKConstraint]!
    var joystickBase: SKShapeNode!
    var joystickKnob: SKShapeNode?
    var joystickActive: Bool = false
    var mapNode: SKSpriteNode!
    var fakedeathButton: SKShapeNode?
    var buttonActive: Bool = false
    var enemies: [EnemyBundle] = []
    var enemyCharacter: EnemyCharacter!
    var wall: SKSpriteNode!
    let aliveButtonTexture = SKTexture(imageNamed: "aliveButton")
    let deadButtonTexture = SKTexture(imageNamed: "deadButton")
    var walls: [SKSpriteNode] = []
    
    
    var gameCamera = SKCameraNode()
    
    
    override func didMove(to view: SKView) {

        aliveButtonTexture.filteringMode = .nearest
        deadButtonTexture.filteringMode = .nearest
        
        let playerTexture = SKTexture(imageNamed: "OpossumDownFrame")
        let mapTexture = SKTexture(imageNamed: "Ground")
        self.camera = gameCamera
        addChild(gameCamera)
        
        // Create the player node
        
        playerCharacter = Character(name: "Opossum")
        
        player = SKSpriteNode(texture: playerCharacter.animations[.Bottom]?.first)
        print("player gets created")
        
        player.size = CGSize(width: 75, height: 75)
        player.position = CGPoint(x: size.width / 1.5, y: size.height / 2)
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: player.size) // collidable area mapped to alpha channel of sprite
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.fruits
        player.physicsBody?.collisionBitMask = PhysicsCategory.wall | PhysicsCategory.fruits
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        
        
        // Create the map node
        mapNode = SKSpriteNode(texture: mapTexture)
        mapNode.size = CGSize(width: 1576 * 2, height: 969 * 2)
        mapNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(mapNode)
        addChild(player)
        
        //Create the movement constraints for the player (player can't exit the map)
        let xRange = SKRange(lowerLimit: 0, upperLimit: 1576)
        let yRange = SKRange(lowerLimit: 0, upperLimit: 969)
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
        
        // Create the button for faking death
        fakedeathButton = SKShapeNode(circleOfRadius: 70)
        fakedeathButton?.fillColor = .white
        fakedeathButton?.fillTexture = deadButtonTexture
        fakedeathButton?.position = CGPoint(x: 300, y: -100)
        fakedeathButton?.zPosition = 5
        fakedeathButton?.alpha = 0.4
        gameCamera.addChild(fakedeathButton!)
        //Create the enemy
        enemyCharacter = EnemyCharacter()
        createEnemies()
        startFruitCycle()
        
        setUpPhysicsWorld()
        
        let wallTexture = SKTexture(imageNamed: "wall1")
        let wall2 = SKTexture(imageNamed: "wall2")
        let wall3 = SKTexture(imageNamed: "wall3")
        let wall4 = SKTexture(imageNamed: "wall4")
        let wall5 = SKTexture(imageNamed: "wall5")
        let wall6 = SKTexture(imageNamed: "wall6")
        createWall(texture: wallTexture, position: CGPoint(x: 700, y: 763))
        createWall(texture: wall2, position: CGPoint(x: 200, y: 620))
        createWall(texture: wall3, position: CGPoint(x: 1370, y: 915))
        createWall(texture: wall4, position: CGPoint(x: 500, y: 170))
        createWall(texture: wall5, position: CGPoint(x: 1200, y: 380))
        createWall(texture: wall6, position: CGPoint(x: 1522, y: 40))
        
        
    }
    
    func createWall(texture: SKTexture, position: CGPoint) {
        //let wallTexture = SKTexture(imageNamed: "paredbuena")
        let wallSize = texture.size()
        wall = SKSpriteNode(texture: texture)
        wall.position = position
        wall.physicsBody = SKPhysicsBody(texture: texture, size: wallSize)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        wall.physicsBody?.contactTestBitMask = PhysicsCategory.player
        wall.physicsBody?.collisionBitMask = PhysicsCategory.player
        print(position)
        
        addChild(wall)
        walls.append(wall)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            //When you touch the joystick
            if let touchedNode = atPoint(location) as? SKShapeNode, touchedNode == joystickBase || touchedNode == joystickKnob && buttonActive == false{
                joystickActive = true
            }
            
            //When you touch the fake death button
            if let touchedNode = atPoint(location) as? SKShapeNode, touchedNode == fakedeathButton {
                
                //When you activate the button
                if buttonActive==false {
                    
                    if gameLogic.currentScore > 0 {
                        print("QUICK! FAKE DEATH!")
                        fakedeathButton?.fillTexture = SKTexture(imageNamed: "aliveButton")
                        buttonActive = true
//                        fakedeathButton?.fillColor = .green
                        joystickKnob?.position = CGPoint(x: -300, y: -100)
                        joystickKnob?.alpha = 0.4
                        let eatApple = SKAction.run {
                            self.gameLogic.currentScore -= 1
                        }
                        let wait = SKAction.wait(forDuration: 1)
                        let fullAction = SKAction.sequence([wait, eatApple])
                        
                        fakedeathButton!.run(SKAction.repeatForever(fullAction), withKey: ActionKeys.eating.rawValue)
                        player.removeAction(forKey: ActionKeys.animation.rawValue)
                        player.texture = playerCharacter.animations[.FakeDeath]!.first
                    }else{
                        print("Grab more apples!")
                    }
                    
                }else{ //When you turn off the button
                    turnOffButton()
                }
                
                
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
            // Update player texture based on movement direction
            let playerOrientation = playerCharacter.updatePlayerOrientation(angle: angle)
            if playerOrientation != playerCharacter.orientation || !playerCharacter.isMoving {
                player.removeAction(forKey: ActionKeys.animation.rawValue)
                let textures = playerCharacter.animations[playerOrientation]
                let animation = SKAction.animate(with: textures!, timePerFrame: 0.1)
                let cyclingAnimation = SKAction.repeatForever(animation)
                player.run(cyclingAnimation, withKey: ActionKeys.animation.rawValue)
                playerCharacter.orientation = playerOrientation
                playerCharacter.isMoving.toggle()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystickKnob?.position = joystickBase.position
        joystickActive = false
        player.physicsBody?.velocity = .zero
        player.removeAction(forKey: ActionKeys.animation.rawValue)
        playerCharacter.isMoving.toggle()
    }
    
    //Fruit spawning
    
    private func startFruitCycle() {
        let createFruitAction = SKAction.run(generateFruit)
        let waitAction = SKAction.wait(forDuration: 2.0)
        
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
        //let xSpawnRange = -mapNode.size.width / 2 + 30 ... mapNode.size.width / 2 - 30
        //let ySpawnRange = -mapNode.size.height / 2 + 30 ... mapNode.size.height / 2 - 30
        
        let randomX = CGFloat.random(in: 0...1576)
        let randomY = CGFloat.random(in: 0...969)
        
        //let position = CGPoint(x: CGFloat.random(in: xSpawnRange), y: CGFloat.random(in: ySpawnRange))
        let position = CGPoint(x: randomX, y: randomY)
        
        var inWall = false
        for wall in walls {
            if wall.contains(position) {
                inWall = true
                print("Apples shan't spawn here.")
                break
            }
        }
        
        if inWall {
            return randomFruitPosition()
        }
        
        return position
    }
    
    // Other game logic and methods can go here
    
    func movePlayer(vector: CGVector) {
        let speed: CGFloat = 200
        
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
            let playerRelativePosition = convert(player.position, to: enemy.node)
            
            let viewCone = enemy.node.children.first(where: {node in node.name == "fieldOfView"})
            if viewCone?.contains(playerRelativePosition) ?? false {
                IsGameOver()
            }
            
        }
        
        if buttonActive==true && gameLogic.currentScore == 0 {
            turnOffButton()
            fakedeathButton?.alpha = 0.4
        }
        
    }
    
    private func setUpPhysicsWorld() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    
    //MARK: moved Enemies
    func createEnemies() {
        //        let movementAction = createMovementAction()
        
        for _ in 0..<8 {
            let enemy = SKSpriteNode()
            enemy.size = player.size
            enemy.position = randomEnemyPosition()
            enemy.constraints = movementWhithinMap
            enemy.zPosition = 3
            enemy.run(SKAction.repeatForever(SKAction.animate(with: enemyCharacter.animations[Orientation.Right]!, timePerFrame: 0.1)), withKey: ActionKeys.animation.rawValue)
            
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
                    let orientation = self.enemyCharacter.updateOrientation(angle: CGFloat(angle))
                    enemy.physicsBody?.velocity = velocity
                    visionCone.zRotation = CGFloat(angle)
                    enemy.removeAction(forKey: ActionKeys.animation.rawValue)
                    enemy.run(SKAction.repeatForever(SKAction.animate(with: self.enemyCharacter.animations[orientation]!, timePerFrame: 0.1)), withKey: ActionKeys.animation.rawValue)
                } else {
                    enemy.physicsBody?.velocity = .zero
                }
            }
            
            let waitAction = SKAction.wait(forDuration: 5.0)
            let fullActiom = SKAction.sequence([moveAction, waitAction])
            
            enemy.run(SKAction.repeatForever(fullActiom))
            enemies.append(EnemyBundle(node: enemy, orientation: Orientation.allCases.randomElement()!))
        }
    }
    
    func randomEnemyPosition() -> CGPoint {
        
        let randomX = CGFloat.random(in: 0...1576)
        let randomY = CGFloat.random(in: 300...969)
        
        //let position = CGPoint(x: CGFloat.random(in: xSpawnRange), y: CGFloat.random(in: ySpawnRange))
        let position = CGPoint(x: randomX, y: randomY)
        
        return position
    }
    
    //MARK: moved
    func decideMove() -> Bool {
        let range = 0...10
        let choice = Int.random(in: range)
        return choice < 7
    }
    
    //MARK: moved
    //generate random angle in radians
    func randomAngle() -> Float {
        let angleRange: Range<Float> = 0..<2 * Float.pi
        
        return Float.random(in: angleRange)
    }
    
    //MARK: moved
    func movementDirection(angle: Float) -> CGVector {
        let velocity: Float = 150
        
        let x: CGFloat = CGFloat(cos(angle) * velocity)
        let y: CGFloat = CGFloat(sin(angle) * velocity)
        
        return CGVector(dx: x, dy: y)
    }
    
    //MARK: Moved to enemy
    func createFieldOfView() -> SKShapeNode {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 100))
        path.addLine(to: CGPoint(x: 200, y: -100))
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
//        print("Contact happened!")
        
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if let node = firstBody.node, node.name == "fruit" {
            node.removeFromParent()
            if secondBody.categoryBitMask == PhysicsCategory.player {
                gameLogic.score(points: 1)
            }
            if(gameLogic.currentScore == 1) {
                fakedeathButton?.alpha = 1
            }
        }
        
        if let node = secondBody.node, node.name == "fruit" {
            node.removeFromParent()
            if firstBody.categoryBitMask == PhysicsCategory.player {
                gameLogic.score(points: 1)
            }
            if(gameLogic.currentScore == 1) {
                fakedeathButton?.alpha = 1
            }
        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.predators) ||
            (firstBody.categoryBitMask == PhysicsCategory.predators && secondBody.categoryBitMask == PhysicsCategory.player) {
            IsGameOver()
            
            print("game over")
        }
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.wall | PhysicsCategory.player {
            print("Player collided with the wall")
        }
    }
    
    //MARK: Game over
    func gameOver() {
        print("mannacc mannacc")
        gameLogic.isGameOver = true
    }
    
    func IsGameOver(){
        if buttonActive==false {
            print("NOO")
            gameOver()
        }else{
            print("nicee")
        }
    }
    
    func turnOffButton() {
        print("RUN POSSUM, RUN!")
        buttonActive = false
        fakedeathButton?.fillTexture = SKTexture(imageNamed: "deadButton")
        joystickKnob?.alpha = 1
        fakedeathButton?.removeAction(forKey: ActionKeys.eating.rawValue)
        player.texture = playerCharacter.animations[self.playerCharacter.orientation]!.first!
        if gameLogic.currentScore == 0 {
            fakedeathButton?.alpha = 0.4
        }
    }
}

enum ActionKeys: String {
    case animation, movement, eating
}
