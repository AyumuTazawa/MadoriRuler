//
//  ViewController.swift
//  MadoriRuler
//
//  Created by 田澤歩 on 2021/02/16.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate {

    var resultaa: ARHitTestResult!
    var database: Database!
    
    @IBOutlet var sceneView: ARSCNView!
    var currentPos = float3(0,0,0)
    var dots = [SCNNode]()
      var distanceTextNode = SCNNode()
      var line = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        database = Database()
        //デリゲート設定
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //シーンを作成、登録
        sceneView.scene = SCNScene()
        
        // 特徴点を表示する
         sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // ライトの追加
         sceneView.autoenablesDefaultLighting = true
        
        // 平面検出
         let configuration = ARWorldTrackingConfiguration()
         configuration.planeDetection = .horizontal
         sceneView.session.run(configuration)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

//    // 画面をタップしたときに呼ばれる
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        // 最初にタップした座標を取り出す
//        guard let touch = touches.first else {return}
//        print("a\(touch)")
//        // スクリーン座標に変換する
//        let touchPos = touch.location(in: sceneView)
//        print("a\(touchPos)")
//        //平面にヒットテストを実行
//        let hitTest = sceneView.hitTest(touchPos, types: .existingPlaneUsingExtent)
//        // 最最近の結果を取得
//        guard let result = hitTest.first else {return}
//
//
        
        
//        if let touch = touches.first {
//            let location = touch.location(in: sceneView)
//            let results = sceneView.hitTest(location, types: .featurePoint)
//            if let result = results.first {
//                //ヒットつめの点をおく
//
//            }
//        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // 平面検出
             let configuration = ARWorldTrackingConfiguration()
             configuration.planeDetection = .horizontal
             sceneView.session.run(configuration)
            
            //タップした座標を取り出す
            guard let touch = touches.first else { return }
            
            //スクリーン座標に変換
            let touchPos = touch.location(in: sceneView)
            
            let x = Int(touchPos.x)
            print("x\(x)")
            
            
            //firebasに保存
            database.save(coordinate: touchPos)
           
            
            if dots.count >= 2 {
                for dot in dots {
                    //dot.removeFromParentNode()
                }
                dots = []
            }
            if let touch = touches.first {
                let location = touch.location(in: sceneView)
                let results = sceneView.hitTest(location, types: .featurePoint)
                if let result = results.first {
                    addDot(at: result)
                    //resultaa = result
                    print("タップを検知")
                }
            }
            
            
        }
        
        func addDot(at location: ARHitTestResult) {
            let dot = SCNSphere(radius: 0.007)
            let material = SCNMaterial()
            material.diffuse.contents = [material]
            let node = SCNNode(geometry: dot)
            
            node.position = SCNVector3(x: location.worldTransform.columns.3.x, y: location.worldTransform.columns.3.y, z: location.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(node)
            dots.append(node)
            if dots.count >= 2 {
                calculate()
            }
        }
        
        func calculate() {
            let firstPoint = dots[0]
            let secondPoint = dots[1]
            let distance = sqrt(pow((secondPoint.position.x - firstPoint.position.x), 2) + pow((secondPoint.position.y - firstPoint.position.y), 2) + pow((secondPoint.position.z - firstPoint.position.z), 2))
            printTextOnScreen(distance: String(format: "%.2f", abs(distance * 100)), position: secondPoint.position)
            
            addLines(firstPoint, secondPoint)
        }
        
        func addLines(_ firstPoint: SCNNode, _ secondPoint: SCNNode) {
            line.removeFromParentNode()
            let vertices: [SCNVector3] = [
                       SCNVector3(firstPoint.position.x, firstPoint.position.y, firstPoint.position.z),
                       SCNVector3(secondPoint.position.x, secondPoint.position.y, secondPoint.position.z)
                   ]

                   let linesGeometry = SCNGeometry(
                       sources: [
                           SCNGeometrySource(vertices: vertices)
                       ],
                       elements: [
                           SCNGeometryElement(
                               indices: [Int32]([0, 1]),
                               primitiveType: .line
                           )
                       ]
                   )

                   line = SCNNode(geometry: linesGeometry)
                   sceneView.scene.rootNode.addChildNode(line)
        }
        
        func printTextOnScreen(distance: String, position: SCNVector3) {
            distanceTextNode.removeFromParentNode()
            let distanceText = SCNText(string: "\(distance)cm", extrusionDepth: 1.0)
            distanceText.firstMaterial?.diffuse.contents = UIColor.blue
            distanceTextNode = SCNNode(geometry: distanceText)
            distanceTextNode.position = SCNVector3(position.x, position.y, position.z)
            distanceTextNode.scale = SCNVector3(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(distanceTextNode)
        }
    // 平面を検出したときに呼ばれる
     func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("平面を検出")
        //addDot(at: resultaa)
     }
    
    @IBAction func toImage(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Image", bundle: Bundle.main)
//        let rootConfigurViewContoroller = storyboard.instantiateViewController(withIdentifier: "Image") as! ImageViewController
//        self.navigationController?.pushViewController(rootConfigurViewContoroller, animated: true)
        
        //Storyboardを指定
        let anotherStoryboard:UIStoryboard = UIStoryboard(name: "Image", bundle: nil)
         
        //生成するViewControllerを指定
        let anotherViewController:ImageViewController = anotherStoryboard.instantiateInitialViewController() as! ImageViewController
         
        //表示
        self.present(anotherViewController, animated: true, completion: nil)
    }
    
}


extension ViewController {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}







/*
 func save() {
     db.collection("users").addDocument(data: [
         "first": "ssss",
         "last": "Lovelace",
         "born": 1815
     ]) { err in
         if let err = err {
             print("Error adding document: \(err)")
         } else {
             
 }
     }
 }
 */
