//
//  Button.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class Button: UIButton {

    // MARK: - Properties

    var didTouchUpInside: DidTouchUpInside? {
        didSet {
            attachTouchUpInsideEvent()
        }
    }

    var repeatOnLongPress: EmptyClosure? {
        didSet {
            attachLonPressGestureRecognizer()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.8 : 1
        }
    }


    // MARK: - UI
    // MARK: Attachments

    private func attachTouchUpInsideEvent() {
        addTarget(self, action: #selector(touchedUpInside), for: .touchUpInside)
    }

    private func attachLonPressGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                             action: #selector(handleLongGesture(_:)))
        addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func handleLongGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            timer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                         repeats: true)
            { [unowned self] _ in
                self.repeatOnLongPress?()
            }
            timer?.fire()
        default:
            timer?.invalidate()
        }

    }
    private var timer: Timer?

    // MARK: Actions

    @objc
    private func touchedUpInside() {
        didTouchUpInside?()
    }
}

