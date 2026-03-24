//
//  MetalSwiftUIView.swift
//  MetalParticles
//
//  Created by Demian on 24/03/2026.
//

import SwiftUI

struct MetalSwiftUIView: View {
    @StateObject var model = ParticleViewModel()

    var body: some View {
        MetalUIContainer(model: model, gestures: [.longPress])
            .edgesIgnoringSafeArea(.all)
    }
}
