//
//  ViewController.swift
//  ExploAR
//
//  Created by Nicholas Compton on 4/18/22.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create anchor which teathers content to real world
        let targetAnchor = AnchorEntity(plane: .vertical, minimumBounds: [0.2, 0.2])
        let buttonAnchor = AnchorEntity(.camera)
        
        // add anchor to scene
        arView.scene.addAnchor(targetAnchor)
        
        // create target items
        var targets: [Entity] = []
        for _ in 1...20 {
            let target = MeshResource.generateBox(width: 0.2, height: 0.2, depth: 0.2)
            let targetMaterial = SimpleMaterial(color: .green, isMetallic: true)
            let model = ModelEntity(mesh: target, materials: [targetMaterial])
            model.generateCollisionShapes(recursive: true) // allow them to be touchable
            targets.append(model) // append to the targets array
        }
        
        // position each target based on anchor
        for (index, target) in targets.enumerated(){
            let x = Float(index % 5)
            let y = Float(index / 5)
            target.position = [x*0.5, y*0.5 - 2, Float.random(in: -2...2)*0.5]
            targetAnchor.addChild(target)
        }
        
        // create crosshairs
        let crosshair1 = ModelEntity(
            mesh: MeshResource.generateBox(size: [0.002, 0.01, 0.1]),
            materials: [SimpleMaterial(color: .red, isMetallic: false)]
        )
        let crosshair2 = ModelEntity(
            mesh: MeshResource.generateBox(size: [0.01, 0.002, 0.1]),
            materials: [SimpleMaterial(color: .red, isMetallic: false)]
        )
        
        // add button + crosshair
        buttonAnchor.addChild(crosshair1)
        buttonAnchor.addChild(crosshair2)
        arView.scene.addAnchor(buttonAnchor)
        crosshair1.transform.translation = [0, 0, -0.5]
        crosshair2.transform.translation = [0, 0, -0.5]
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//            let touch = arView.center
//            let results: [CollisionCastHit] = arView.hitTest(touch)
//
//            if let result: CollisionCastHit = results.first {
//                if result.entity.name == "Cube" && sphere?.isAnchored == true {
//                    print("BOOM!")
//                }
//            }
//        }
    
    @objc func fire(sender: UIButton!) {
        
    }
    
    
}
