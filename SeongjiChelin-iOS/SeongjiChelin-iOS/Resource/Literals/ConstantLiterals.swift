//
//  ConstantLiterals.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

struct ConstantLiterals {
    
    enum ScreenSize {
        static var width: CGFloat {
            guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                fatalError()
            }
            return window.screen.bounds.width
        }
        
        static var height: CGFloat {
            guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                fatalError()
            }
            return window.screen.bounds.height
        }
    }
    
}

struct ImageLiterals {
    // SF Symbols
    static let map = UIImage(systemName: "map")
    static let mapFill = UIImage(systemName: "map.fill")
    static let bookmark = UIImage(systemName: "bookmark")
    static let bookmarkFill = UIImage(systemName: "bookmark.fill")
    static let star = UIImage(systemName: "star")
    static let starFill = UIImage(systemName: "star.fill")
    static let arrowLeft = UIImage(systemName: "arrow.left")
    static let forkKnife = UIImage(systemName: "fork.knife")
    static let xmark = UIImage(systemName: "xmark")
    static let listStar = UIImage(systemName: "list.star")
    static let listBullet = UIImage(systemName: "list.bullet")
    static let lineHorizontal3 = UIImage(systemName: "line.horizontal.3")
    static let microphone = UIImage(systemName: "microphone")
    static let handThumbsup = UIImage(systemName: "hand.thumbsup")
    static let phone = UIImage(systemName: "phone")
    static let clock = UIImage(systemName: "clock")
    static let video = UIImage(systemName: "video")
    static let parkingsignSquare = UIImage(systemName: "parkingsign.square")
    static let figureWalk = UIImage(systemName: "figure.walk")
    static let person2Fill = UIImage(systemName: "person.2.fill")
    static let cart = UIImage(systemName: "cart")
    static let eyeglasses = UIImage(systemName: "eyeglasses")
    static let roadLanes = UIImage(systemName: "road.lanes")
    static let siren = UIImage(systemName: "light.beacon.min")

    // Resource Images (Assets)
    static let riceBowl = UIImage(resource: .riceBowl)
    static let foot = UIImage(resource: .foot)
    static let footFill = UIImage(resource: .footFill)
    static let verticalLogo = UIImage(resource: .verticalLogo)
    static let horizentalLogo = UIImage(resource: .horizentalLogo)
    
    // Theme Image
    static let sikyungLogo = UIImage(resource: .mugeultende)
    static let choijaLogo = UIImage(resource: .choijaroad)
    static let pungjaLogo = UIImage(resource: .ttoganjipLogo)
    static let hongleeLogo = UIImage(resource: .honglee)
}

