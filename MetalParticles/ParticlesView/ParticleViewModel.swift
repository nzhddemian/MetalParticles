//
//  ParticleViewModel.swift
//  MetalParticles
//
//  Created by Demian on 24/03/2026.
//



import SwiftUI
import Combine
import UIKit
import simd

enum GestureType {
    case longPress
}

enum InputEvent {
    case pointerDown(position: SIMD2<Float>)
    case pointerMove(position: SIMD2<Float>, delta: SIMD2<Float>, speed: Float)
    case pointerUp(position: SIMD2<Float>)
}

protocol InputReceiver {
    func handleInput(_ event: InputEvent)
}

final class ParticleViewModel: NSObject, ObservableObject, ParticleLabDelegate, InputReceiver {
    let mtlView: ParticleLab

    private var pointerPosition: SIMD2<Float>?
    private var pointerSpeed: Float = 0

    override init() {
        let size = UIScreen.main.bounds.size
        let scale = UIScreen.main.scale

        mtlView = ParticleLab(
            width: UInt((size.width * scale).rounded()),
            height: UInt((size.height * scale).rounded()),
            numParticles: .eightMillion,
            hiDPI: true
        )

        super.init()

        mtlView.particleLabDelegate = self
        mtlView.dragFactor = 0.95
        mtlView.respawnOutOfBoundsParticles = false
        mtlView.clearOnStep = true
        mtlView.resetParticles(false)
        mtlView.isMultipleTouchEnabled = true
    }

    func particleLabMetalUnavailable() {
        // handle metal unavailable here
    }

    func particleLabDidUpdate(status: String) {
        mtlView.resetGravityWells()

        guard
            let pointerPosition,
            mtlView.bounds.width > 0,
            mtlView.bounds.height > 0
        else {
            return
        }

        let normalisedX = Float(pointerPosition.x / Float(mtlView.bounds.width))
        let normalisedY = Float(pointerPosition.y / Float(mtlView.bounds.height))
        let speedBoost = max(1, min(pointerSpeed / 25, 4))

        mtlView.setGravityWellProperties(
            gravityWellIndex: 0,
            normalisedPositionX: normalisedX,
            normalisedPositionY: normalisedY,
            mass: 40 * speedBoost,
            spin: 20 * speedBoost
        )
    }

    func handleInput(_ event: InputEvent) {
        switch event {
        case let .pointerDown(position):
            pointerPosition = position
            pointerSpeed = 0
        case let .pointerMove(position, _, speed):
            pointerPosition = position
            pointerSpeed = speed
        case .pointerUp:
            pointerPosition = nil
            pointerSpeed = 0
        }
    }
}
