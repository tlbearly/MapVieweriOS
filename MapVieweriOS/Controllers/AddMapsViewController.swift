//
//  AddMapsViewController.swift
//  MapVieweriOS
//
//  Add a map to the app from filepicker or a website
//
//  Created by Tammy Bearly on 4/23/20.
//  Copyright © 2020 Colorado Parks and Wildlife. All rights reserved.
//
// File Picker help https://www.google.com/search?client=firefox-b-1-d&q=swift+file+picker#kpvalbx=_2GqjXuXrEJrL0PEPi-id2AI26
//
// Segues https://matteomanferdini.com/unwind-segue

import UIKit
import MobileCoreServices

class AddMapsViewController: UIViewController {
    var map: PDFMap? = nil
    var fileName: String = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Map"
        
        
        // For debugging write a test file to the documents dir
        writeDebugPDF(self, newFile: "Wellington")
        writeDebugPDF(self, newFile: "Wellington1")
        writeDebugPDF(self, newFile: "Wellington3")
        writeDebugPDF(self, newFile: "63RanchSTL_geo")
        
        
    }

    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // map from file picker or website
        if (segue.identifier == "pdfFromFilePicker"){
            map = PDFMap(fileName: fileName) // pass URL also NEED TO WRITE NEW INIT FUNC
        }
    }
    
    //@IBAction func importMap(_ unwindSegue: UIStoryboardSegue){}
    
    
    // MARK: Private Functions
    
    
    func writeDebugPDF(_ sender: Any, newFile: String){
        // use in simulater to write pdfs in app directory to the Simulator documents directory.
        
        guard let pdfFileURL = Bundle.main.url(forResource: newFile, withExtension: "pdf") else {
            print ("Can't write file: PDF file not found.")
            return
        }
        
        // destination directory name
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Can't get documents directory.")
            return
        }
        
        let fileName = newFile+".pdf"
        let destURL = documentsURL.appendingPathComponent(fileName)
        
        let filePath = destURL.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            return
        }
       
        do {
            try FileManager.default.copyItem(at:pdfFileURL, to: destURL)
        }
        catch{
            return
        }
    }
    
    
    // MARK: File Picker functions
    
    @IBAction func filePickerClicked(_ sender: PrimaryUIButton) {
        // open file picker with PDFs
        // use documentTypes: com.adobe.pdf (kUTTypePDF)
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    
}

extension AddMapsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
       // called when user selects a pdf to import
        print("selected a pdf. File is in urls[0]",urls[0].lastPathComponent)
        
        // copy file to documents directory, warn if it already imported
        fileName = urls[0].lastPathComponent
        
        self.performSegue(withIdentifier: "pdfFromFilePicker", sender: nil)
    }
}
