//
//  TappableView.swift
//  FingerGesture
//
//  Created by kazunori.aoki on 2022/07/14.
//

import SwiftUI

struct MultipleFingerTapView: UIViewRepresentable {
    typealias UIViewType = UIView

    let fingers: Int
    var callback: (UITapGestureRecognizer) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let multipleTapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator,
                                                                  action: #selector(Coordinator.handleTap(sender:)))

        multipleTapGestureRecognizer.numberOfTouchesRequired = fingers

        view.addGestureRecognizer(multipleTapGestureRecognizer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(callback: callback)
    }

    class Coordinator {
        var callback: (UITapGestureRecognizer) -> Void

        init(callback: @escaping (UITapGestureRecognizer) -> Void) {
            self.callback = callback
        }

        @objc func handleTap(sender: UITapGestureRecognizer) {
            self.callback(sender)
        }
    }
}
