//
//  ViewController.swift
//  QRCodeDemo
//
//  Created by 申潤五 on 2021/9/6.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    
    
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var outputLabel: UILabel!
    

    let avCaptureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //QRCocd 是透過 AVCaptureSession 來運作的
        
        
        
        //先檢查是否有預設的輸入設備
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("沒有輸入設備")
            return
        }
        
        //試試看影像設備是否被佔用，若正常的話它就是輸入設備
        guard  let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("無法取得影像")
            return
        }
        avCaptureSession.addInput(avCaptureInput)  //session 加上輸入
        
        
        //建立一個輸出物件，並設定 ViewController 為接受代理人
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) //輸出時，使用主線程
        avCaptureSession.addOutput(avCaptureMetadataOutput)  //session 加上輸出
        
        //加上支援的類別，這必需要加入 session 之後再做，不然會閃退
        avCaptureMetadataOutput.metadataObjectTypes =  [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec]

        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        //把輸入的圖層加到畫面中的圖層中，讓使用者可以看到
        let avCaptureVidoePreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVidoePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVidoePreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVidoePreviewLayer)
        
        //第一次啟動
        avCaptureSession.startRunning()

    }
    
    

    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
       
        if metadataObjects.count > 0 {
            let machineReabableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            outputLabel.text = machineReabableCode.stringValue
            let utterance = AVSpeechUtterance(string: "找到")
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-Hant")
            utterance.rate = 0.5

            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
            
            
            avCaptureSession.stopRunning()
        }
    }
    
    @IBAction func startScan(_ sender: Any) {
        scanQRCode()
    }
    
    
    func scanQRCode(){
        
        //啟動掃瞄
        avCaptureSession.startRunning()
        
    }

}

