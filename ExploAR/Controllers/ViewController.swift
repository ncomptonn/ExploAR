//
//  ViewController.swift
//  ExploAR
//
//  Created by Nicholas Compton on 4/18/22.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var arView: ARView!
    var timer: Timer!
    var counter = 0.0
    var isPlaying = false
    var targets: [Entity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // create anchor which teathers content to real world
        let targetAnchor = AnchorEntity(plane: .vertical, minimumBounds: [0.2, 0.2])
        let buttonAnchor = AnchorEntity(.camera)
        
        // add anchor to scene
        arView.scene.addAnchor(targetAnchor)
        
        // create target items
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
            target.position = [x*0.5, Float.random(in: -3 ... -1), Float.random(in: -2...2)*0.5]
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
    

    @IBAction func fireButtonPressed(_ sender: Any) {
        if (isPlaying == false){
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(checkToStop), userInfo: nil, repeats: true)
            isPlaying = true
        }
        let point = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        if let target = arView.entity(at: point) {
            var flipTransform = target.transform
            flipTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
            target.move(to: flipTransform, relativeTo: target.parent, duration: 0.5, timingFunction: .easeInOut)
            target.isEnabled = false;
        }
    }
    
    @objc func checkToStop() {
        counter += 0.1
        var count = 0
        for target in targets{
            if (target.isEnabled){
                return
            } else {
                count += 1
            }
        }
        if (count != 20){
            return
        }
        timer.invalidate()
        isPlaying = false
        print(String(format: "%.1f", counter))
        self.present(endOfGameViewController(), animated: true)
    }
    
    
}
