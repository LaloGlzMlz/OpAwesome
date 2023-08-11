//
//  Character.swift
//  OpAwesome
//
//  Created by Chiara Giorgia Ricci on 14/12/23.
//

import SpriteKit

enum Orientation: String, CaseIterable {
    case Bottom, BottomRight, BottomLeft, Right, Left, Top, TopRight, TopLeft, FakeDeath
}

class Character {
    let name: String
    var animations: Dictionary<Orientation, [SKTexture]>
    var orientation: Orientation = .Bottom
    var isMoving: Bool = false
    
    init(name: String) {
        self.name = name
        var animations: Dictionary<Orientation, [SKTexture]> = [:]
        for orientation in Orientation.allCases {
            var textures: [SKTexture] = []
            for i in 0..<4 {
                let texture = SKTexture(imageNamed: name + orientation.rawValue + "\(i)")
                texture.filteringMode = .nearest
                textures.append(texture)
            }
            animations.updateValue(textures, forKey: orientation)
        }
        if name == "Opossum" {
            let fakeDeath = SKTexture(imageNamed: "OpossumFakeDeath")
            fakeDeath.filteringMode = .nearest
            animations.updateValue([fakeDeath], forKey: .FakeDeath)
        }
        self.animations = animations
    }
    
    func updatePlayerOrientation(angle: CGFloat) -> Orientation {
        
        if (angle > (-1.0 * (CGFloat.pi/8))) && (angle < (CGFloat.pi/8)) {
            //Moving up
            return Orientation.Right
        } else if (angle > (CGFloat.pi/8)) && (angle < (3.0 * (CGFloat.pi/8))){
            return Orientation.TopRight
        } else if (angle > (3.0 * (CGFloat.pi/8))) && (angle < (5.0 * (CGFloat.pi/8))){
            return Orientation.Top
        } else if (angle > (5.0 * (CGFloat.pi/8))) && (angle < (7.0 * (CGFloat.pi/8))){
            return Orientation.TopLeft
        } else if (angle > (7.0 * (CGFloat.pi/8))) && (angle < (9.0 * (CGFloat.pi/8))){
            return Orientation.Left
        } else if (angle < (-1.0 * (CGFloat.pi/8))) && (angle > (-3.0 * (CGFloat.pi/8))){
            return Orientation.BottomRight
        } else if (angle < (-3.0 * (CGFloat.pi/8))) && (angle > (-5.0 * (CGFloat.pi/8))){
            return Orientation.Bottom
        } else {
            return Orientation.BottomLeft
        }
    }
        
//    get orientation
}

class EnemyCharacter {
    let name = "Owl"
    var animations: Dictionary<Orientation, [SKTexture]>
    
    init() {
        var animations: Dictionary<Orientation, [SKTexture]> = [:]
        for orientation in Orientation.allCases {
            var textures: [SKTexture] = []
            for i in 0..<4 {
                let texture = SKTexture(imageNamed: name + orientation.rawValue + "\(i)")
                texture.filteringMode = .nearest
                textures.append(texture)
            }
            animations.updateValue(textures, forKey: orientation)
        }

        self.animations = animations
    }
    
    func updateOrientation(angle: CGFloat) -> Orientation {
        var theAngle = angle
        
        if angle > CGFloat.pi {
            theAngle = angle - CGFloat.pi*2
        }
        
        if (theAngle > (-1.0 * (CGFloat.pi/8))) && (theAngle < (CGFloat.pi/8)) {
            //Moving up
            return Orientation.Right
        } else if (theAngle > (CGFloat.pi/8)) && (theAngle < (3.0 * (CGFloat.pi/8))){
            return Orientation.TopRight
        } else if (theAngle > (3.0 * (CGFloat.pi/8))) && (theAngle < (5.0 * (CGFloat.pi/8))){
            return Orientation.Top
        } else if (theAngle > (5.0 * (CGFloat.pi/8))) && (theAngle < (7.0 * (CGFloat.pi/8))){
            return Orientation.TopLeft
        } else if (theAngle > (7.0 * (CGFloat.pi/8))) && (theAngle < (9.0 * (CGFloat.pi/8))){
            return Orientation.Left
        } else if (theAngle < (-1.0 * (CGFloat.pi/8))) && (theAngle > (-3.0 * (CGFloat.pi/8))){
            return Orientation.BottomRight
        } else if (theAngle < (-3.0 * (CGFloat.pi/8))) && (theAngle > (-5.0 * (CGFloat.pi/8))){
            return Orientation.Bottom
        } else {
            return Orientation.BottomLeft
        }
    }
    
    
}

struct EnemyBundle {
    var node: SKSpriteNode
    var orientation: Orientation
}
