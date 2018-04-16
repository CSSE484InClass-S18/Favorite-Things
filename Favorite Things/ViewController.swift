//
//  ViewController.swift
//  Favorite Things
//
//  Created by David Fisher on 4/5/18.
//  Copyright © 2018 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
  @IBOutlet weak var colorLabel: UILabel!
  @IBOutlet weak var numberLabel: UILabel!

  var docRef: DocumentReference!
  var favoriteThingsListener: ListenerRegistration!
  var favoriteNumber: Int = 2000

  override func viewDidLoad() {
    super.viewDidLoad()
    docRef = Firestore.firestore().collection("favoriteThings").document("myDocId")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    favoriteThingsListener = docRef.addSnapshotListener({ (documentSnapshot, error) in
      if let error = error {
        print("Error fetching document.  \(error.localizedDescription)")
        return
      }
      self.colorLabel.text = documentSnapshot?.get("color") as? String

      self.favoriteNumber = documentSnapshot?.get("number") as! Int
      self.numberLabel.text = String(self.favoriteNumber)
    })
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    favoriteThingsListener.remove()
  }


  @IBAction func pressedRed(_ sender: Any) {
    docRef.updateData(["color": "red"])
  }
  
  @IBAction func pressedWhite(_ sender: Any) {
    docRef.updateData(["color": "white"])
  }

  @IBAction func pressedBlue(_ sender: Any) {
    docRef.updateData(["color": "blue"])
  }

  @IBAction func pressedFetchColorOnce(_ sender: Any) {
    docRef.getDocument { (documentSnapshot, error) in
      if let error = error {
        print("Error fetching document.  \(error.localizedDescription)")
        return
      }
      // Option #1
      self.colorLabel.text = documentSnapshot?.get("color") as? String

      // Option #2
//      if let data = documentSnapshot?.data() {
//        self.colorLabel.text = data["color"] as? String
//      }
    }
  }

  @IBAction func pressedIncrement(_ sender: Any) {
    docRef.updateData(["number": favoriteNumber + 1])
  }

  @IBAction func pressedDecrement(_ sender: Any) {
    docRef.updateData(["number": favoriteNumber - 1])
  }
}

