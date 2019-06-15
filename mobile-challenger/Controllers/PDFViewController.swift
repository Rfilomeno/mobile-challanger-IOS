//
//  PDFViewController.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 13/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {

    var pdfView: PDFView?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(redimensionaView), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        pdfView = PDFView(frame: self.view.bounds)
        self.view.addSubview(pdfView!)
        pdfView!.autoScales = true
        let fileURL = Bundle.main.url(forResource: "Desafio Mobile Manual de Usabilidade", withExtension: "pdf")
        pdfView!.document = PDFDocument(url: fileURL!)

    }
    
    @objc func redimensionaView(){
        pdfView!.frame = self.view.bounds
    }

}
