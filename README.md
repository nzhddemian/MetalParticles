## ParticleLab - Swift + Metal GPU Particles

High-performance particle simulation where update + render both run on the GPU via Metal.

![ParticleLab Demo](screen-preview.gif)

[Full video (MP4)](screen.MP4)

### Quick Usage

```swift
particleLab = ParticleLab(width: 1024, height: 768, numParticles: .TwoMillion)
view.addView(particleLab)
```

```swift
particleLab.setGravityWellProperties(
    gravityWell: .One,
    normalisedPositionX: 0.3,
    normalisedPositionY: 0.3,
    mass: 11,
    spin: -4
)
```

### Notes

- Supports up to four gravity wells.
- `ParticleLabDelegate` provides `particleLabDidUpdate()`.
- `resetGravityWells()` and `resetParticles()` are available.
