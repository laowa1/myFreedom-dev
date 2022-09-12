//
//  BlockSwipe.swift
//  MyFreedom
//
//  Created by m1pro on 08.04.2022.
//

import UIKit

class BlockSwipe: UISwipeGestureRecognizer {
    private var swipeAction: ((UISwipeGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init(
        direction: UISwipeGestureRecognizer.Direction,
        fingerCount: Int = 1,
        action: @escaping (_ gesture: UISwipeGestureRecognizer) -> Void) {
            self.init()
            self.direction = direction

            numberOfTouchesRequired = fingerCount
            swipeAction = action
            addTarget(self, action: #selector(didSwipe(_:)))
        }

    @objc open func didSwipe(_ swipe: UISwipeGestureRecognizer) {
        swipeAction?(swipe)
    }
}

class BlockTap: UITapGestureRecognizer {
    private var tapAction: ((UITapGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init(
        action: @escaping (_ gesture: UITapGestureRecognizer) -> Void) {
            self.init()
            tapAction = action
            addTarget(self, action: #selector(didTap(_:)))
        }

    @objc open func didTap(_ tap: UITapGestureRecognizer) {
        tapAction?(tap)
    }
}
