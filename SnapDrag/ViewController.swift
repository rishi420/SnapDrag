//
//  ViewController.swift
//  SnapDrag
//
//  Created by Warif Akhand Rishi on 7/24/16.
//  Copyright © 2016 Warif Akhand Rishi. All rights reserved.
//

import UIKit

enum SnapState {
    case willSnap
    case didSnap
    case willRelease
}

class ViewController: UIViewController {
    
    let snapPoint = CGPoint(x: 367, y: 0)  // CALCULATE SNAP POINT CONTENT OFFSET
    
    // EXPERIMENT WITH THESE VALUES
    let minDistanceToSnap = 7.0
    let minVelocityToSnap = 25.0
    let minDragDistanceToReleaseSnap = 7.0
    let snapDuringDecelerating = false
    
    fileprivate var startSnapLocaion = CGPoint.zero
    fileprivate var snapState: SnapState = .willSnap
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func distance(between point1: CGPoint, and point2: CGPoint) -> Double {
        return Double(hypotf(Float(point1.x - point2.x), Float(point1.y - point2.y)))
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch(snapState) {
        case .willSnap:
            let distanceFromSnapPoint = distance(between: scrollView.contentOffset, and: snapPoint)
            let velocity = scrollView.panGestureRecognizer.velocity(in: view)
            let velocityDistance = distance(between: velocity, and: CGPoint.zero)
            if distanceFromSnapPoint <= minDistanceToSnap && velocityDistance <= minVelocityToSnap && (snapDuringDecelerating || velocityDistance > 0.0) {
                startSnapLocaion = scrollView.panGestureRecognizer.location(in: scrollView)
                snapState = .didSnap
            }
        case .didSnap:
            scrollView.setContentOffset(snapPoint, animated: false)
            var dragDistance = 0.0
            let location = scrollView.panGestureRecognizer.location(in: scrollView)
            dragDistance = distance(between: location, and: startSnapLocaion)
            if dragDistance > minDragDistanceToReleaseSnap  {
                startSnapLocaion = CGPoint.zero
                snapState = .willRelease
            }
        case .willRelease:
            let distanceFromSnapPoint = distance(between: scrollView.contentOffset, and: snapPoint)
            if distanceFromSnapPoint > minDistanceToSnap {
                snapState = .willSnap
            }
        }
    }
}

