//
//  ViewController.swift
//  RescateK9
//
//  Created by Virginia Pujols on 11/13/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class RescuePetListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var listener: ListenerRegistration?
    private let collection = Firestore.firestore().collection("rescues")
    private var rescues: [RescuePet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopObserving()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func refreshData() {
        stopObserving()
        listener = collection.addSnapshotListener { [unowned self] (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            
            self.rescues = []
            for document in snapshot.documents {
                if let item = RescuePet(dictionary: document.data(), documentId: document.documentID) {
                    self.rescues.append(item)
                }
            }
            
            let db = Firestore.firestore()
            db.collection("rescues").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }

            self.tableView.reloadData()
        }
    }
    
    private func stopObserving() {
      listener?.remove()
    }
}

extension RescuePetListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rescues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RescuePetTableViewCell

        let pet = rescues[indexPath.row]
        cell.populate(item: pet)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.08)
        cell.selectedBackgroundView = bgColorView

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
}

class RescuePetTableViewCell: UITableViewCell {
    @IBOutlet weak private var containerView: UIView!
    
    @IBOutlet weak private var picture: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var breedLabel: UILabel!
    @IBOutlet weak private var genderLabel: UILabel!
    @IBOutlet weak private var ageLabel: UILabel!
    @IBOutlet weak private var sizeLabel: UILabel!

    let storage = Storage.storage()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.applyShadow(alpha: 0.06, blur: 25)
    }

    func populate(item: RescuePet) {
        nameLabel.text = item.name
        breedLabel.text = item.breed
        genderLabel.text = item.gender.getLabel()
        ageLabel.text = item.ageRange.getLabel()
        sizeLabel.text = item.size.getLabel()
        
        guard let documentId = item.documentId else { return }
        let ref = storage.reference(withPath: "images/\(documentId).png")
        ref.downloadURL { (url, error) in
            DispatchQueue.main.async {
                if let url = url {
                    print("image URL \(url.absoluteString)")
                    self.picture.setImage(url: url.absoluteString, placeholder: UIImage(named: "paw"))
                }
            }
        }

    }

}
