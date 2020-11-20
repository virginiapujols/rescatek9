//
//  Rescue.swift
//  RescateK9
//
//  Created by Virginia Pujols on 11/15/20.
//

import Foundation

enum RescuePetAge: Int {
    case puppy, young, adult
    func getLabel() -> String {
        switch self {
        case .puppy:
            return "Cachorro"
        case .young:
            return "Joven"
        case .adult:
            return "Adulto"
        }
    }
}

enum RescuePetSize: Int {
    case small, medium, large
    func getLabel() -> String {
        switch self {
        case .small:
            return "Pequeño"
        case .medium:
            return "Mediano"
        case .large:
            return "Grande"
        }
    }
}

enum Gender: Int {
    case female, male
    func getLabel() -> String {
        switch self {
        case .female:
            return "Femenino"
        case .male:
            return "Masculino"
        }
    }
}

struct RescuePet {
    var name: String
    var breed: String
    var size: RescuePetSize
    var gender: Gender
    var ageRange: RescuePetAge
    var comments: String
    var documentId: String?
    
    var dictionary: [String: Any] {
      return [
        "name": name,
        "breed": breed,
        "size": size.rawValue,
        "gender": gender.rawValue,
        "ageRange": ageRange.rawValue,
        "comments": comments,
      ]
    }

}

extension RescuePet {
    init?(dictionary: [String: Any], documentId:String? = nil) {
        let name = dictionary["name"] as? String ?? ""
        let breed = dictionary["breed"] as? String ?? ""
        let sizeVal = dictionary["size"] as? Int ?? 0
        let genderVal = dictionary["gender"] as? Int ?? 0
        let ageVal = dictionary["age"] as? Int ?? 0
        let comments = dictionary["comments"] as? String ?? ""

        let size = RescuePetSize(rawValue: sizeVal) ?? .small
        let gender = Gender(rawValue: genderVal) ?? .female
        let ageRange = RescuePetAge(rawValue: ageVal)  ?? .adult
        
        self.init(name: name,
                  breed: breed,
                  size: size,
                  gender: gender,
                  ageRange: ageRange,
                  comments: comments,
                  documentId: documentId)
    }
}
