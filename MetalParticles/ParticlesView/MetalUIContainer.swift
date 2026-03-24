//
//  MetalUIContainer.swift
//  MetalParticles
//
//  Created by Demian on 24/03/2026.
//


import SwiftUI
import MetalKit
struct MetalUIContainer: UIViewRepresentable {
    var model: ParticleViewModel
    var gestures: [GestureType] = []

    init(model: ParticleViewModel, gestures: [GestureType] = []) {
        self.model = model
        self.gestures = gestures
    }

    func makeUIView(context: Context) -> UIView {
        let view = model.mtlView

        if gestures.contains(.longPress) {
            let longPressGesture = UILongPressGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleLongPress(_:))
            )
            longPressGesture.minimumPressDuration = 0.0
            view.addGestureRecognizer(longPressGesture)
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(receiver: model)
    }

    class Coordinator: NSObject {
        var receiver: InputReceiver
        var lastTouchLocation = SIMD2<Float>(0, 0)
        var touchStartTime: CFTimeInterval = 0

        init(receiver: InputReceiver) {
            self.receiver = receiver
        }

        @objc
        func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            let location = gesture.location(in: gesture.view)
            let pos = SIMD2<Float>(Float(location.x), Float(location.y))
            let now = CACurrentMediaTime()

            switch gesture.state {
            case .began:
                lastTouchLocation = pos
                touchStartTime = now
                receiver.handleInput(.pointerDown(position: pos))

            case .changed:
                let delta = pos - lastTouchLocation
                let dt = Float(now - touchStartTime)
                let speed = dt > 0 ? simd_length(delta) / dt : 0

                receiver.handleInput(.pointerMove(position: pos, delta: delta, speed: speed))

                lastTouchLocation = pos
                touchStartTime = now

            case .ended, .cancelled:
                receiver.handleInput(.pointerUp(position: pos))

            default:
                break
            }
        }
    }
}



