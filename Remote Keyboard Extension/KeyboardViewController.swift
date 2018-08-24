//
//  KeyboardViewController.swift
//  Remote Keyboard Extension
//
//  Created by Xiao Shi on 31/1/18.
//  Copyright © 2018 devbycm. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet weak var textPreview: UILabel!
    var service = KeyboardService()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
//        let heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 160)
//        view.addConstraint(heightConstraint)
        print(-1)

        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.delegate = self
        print(0)
        
//        let nib = UINib(nibName: "Keyboard", bundle: nil)
//        let objects = nib.instantiate(withOwner: self, options: nil)
//        view = objects[0] as! UIView
//        service.delegate = self
        
        // Perform custom UI setup here
//        self.nextKeyboardButton = UIButton(type: .system)
        
//        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
//        self.nextKeyboardButton.sizeToFit()
//        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
//        self.view.addSubview(self.nextKeyboardButton)
        
//        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        service.disconnect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
//        var textColor: UIColor
//        let proxy = self.textDocumentProxy
//        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
//            textColor = UIColor.white
//        } else {
//            textColor = UIColor.black
//        }
//        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    func keyboardService(_ sender: KeyboardService) {
        
    }
    
    @IBAction func test(_ sender: Any) {
        print(2)
        textDocumentProxy.insertText("\n")
    }
    
}


extension KeyboardViewController: KeyboardServiceDelegate {
    func service(_: KeyboardService, didInsert text: String) {
        textDocumentProxy.insertText(text)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(125), execute: {
            self.textDocumentProxy.insertText("\n")
        })
    }
    
    func service(_: KeyboardService, didUpdate text: String) {
        DispatchQueue.main.async {
            self.textPreview.text = text
        }
    }
    
    func service(_: KeyboardService, didDelete count: Int) {
        textDocumentProxy.deleteBackward()
    }
    
    func service(_: KeyboardService, didEnter count: Int) {
    }
    
    
}
