//
//  ViewController.swift
//  ExploAR
//
//  Created by Nicholas Compton on 4/18/22.
//

import UIKit
import RealityKit

protocol ViewControllerDelegate {
    func sendGameInformation(time: Double, ammo: Int, numTargets: Int, accuracy: Double)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var arView: ARView!
    var timer: Timer!
    var counter = 0.0
    var isPlaying = false
    var targets: [Entity] = []
    var ammo: Int = 0
    var numTargets: Int = 10
    var currTarget: Int = 0
    var numOfShots: Int = 0
    var delegate: ViewControllerDelegate? = nil
    
    // create anchor which teathers content to real world
    let targetAnchor = AnchorEntity(plane: .vertical, minimumBounds: [0.2, 0.2])
    let buttonAnchor = AnchorEntity(.camera)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        // add anchor to scene
        arView.scene.addAnchor(targetAnchor)
        
        // create target items
        for _ in 1...numTargets {
            let target = MeshResource.generateBox(width: 0.2, height: 0.2, depth: 0.2)
            let targetMaterial = SimpleMaterial(color: .green, isMetallic: true)
            let model = ModelEntity(mesh: target, materials: [targetMaterial])
            model.generateCollisionShapes(recursive: true) // allow them to be touchable
            targets.append(model) // append to the targets array
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
        
        targetsOneAtATime(currTarget: 0)
        //targetsAtOnce()
    }
    
    func targetsAtOnce() {
        // position each target based on anchor
        for (index, target) in targets.enumerated(){
            let x = Float(index % 5)
            target.position = [x*0.5, Float.random(in: -3 ... -1), Float.random(in: -2...2)*0.5]
            targetAnchor.addChild(target)
        }
    }
    
    func targetsOneAtATime(currTarget: Int) {
        if (currTarget < numTargets){
            let target = targets[currTarget]
            target.position = [Float.random(in: 1...5)*0.5, Float.random(in: -3 ... -1), Float.random(in: -2...2)*0.5]
            targetAnchor.addChild(target)
        } else {
          checkToStop()
        }
    }

    @IBAction func fireButtonPressed(_ sender: Any) {
        numOfShots += 1
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
            currTarget += 1
            targetsOneAtATime(currTarget: currTarget)
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
        if (count != numTargets){
            return
        }
        timer.invalidate()
        isPlaying = false
        let accuracy: Double = Double(numTargets) / Double(numOfShots) * 100
        self.navigationController?.popToRootViewController(animated: true)
        delegate?.sendGameInformation(time: counter, ammo: ammo, numTargets: numTargets, accuracy: Double(accuracy))
    }
    
}
