//
//  ViewController.swift
//  HarryProphet
//
//  Created by Benny Pham on 8/18/20.
//  Copyright © 2020 Benny Pham. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // Create an object to tell which images to track
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaperImages", bundle: Bundle.main) {
            configuration.trackingImages = trackedImages
            
            configuration.maximumNumberOfTrackedImages = 1
            
            // Made sure images found in NewsPaperImages
            // print("Images found")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        // Create new node
        let node = SCNNode()
        
        // use imageAnchor to detect image on the scene to add our plane
        if let imageAnchor = anchor as? ARImageAnchor {
            
            // create videoNode object
            let videoNode = SKVideoNode(fileNamed: "harrypotter.mp4")
            videoNode.play()
            
            // video size based the .mp4
            let videoScence = SKScene(size: CGSize(width: 480, height: 360))
            
            // change position so that video is in center of plane
            videoNode.position = CGPoint(x: videoScence.size.width / 2, y: videoScence.size.height / 2)
            
            // rotate along the y axis so video is viewed correctly
            videoNode.yScale = -1.0
                
            // add to node to videoScene
            videoScence.addChild(videoNode)
            
            // create plane
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            // put material on plane
            plane.firstMaterial?.diffuse.contents = videoScence
            
            let planeNode = SCNNode(geometry: plane)
            
            // Rotate anti clockwise by half pi which is 90 degress, flat and flush
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
}
