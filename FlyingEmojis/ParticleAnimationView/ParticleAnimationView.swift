import UIKit

public class ParticleAnimationView: UIView {
    private let particleEmitter = CAEmitterLayer()
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        layer.addSublayer(gradientLayer)
        gradientLayer.frame = frame
        gradientLayer.bounds = bounds
    }
    
    func update(with image: UIImage) {
        let near = makeEmmiterCell(image: image, velocity: 300, scale: 0.7, longitude: .pi)
        let middle = makeEmmiterCell(image: image, velocity: 200, scale: 0.5)
        let far = makeEmmiterCell(image: image, velocity: 100, scale: 0.3)
        particleEmitter.emitterCells = [far, middle, near]
        gradientLayer.colors = [
            UIColor.white.cgColor,
            image.averageColor!.cgColor
        ]
    }

    func update(with theme: Theme) {
        let near = makeEmmiterCell(image: theme.mainImage, velocity: 300, scale: 0.7, longitude: .pi)
        let middle = makeEmmiterCell(image: theme.secondaryImage, velocity: 200, scale: 0.5)
        let far = makeEmmiterCell(image: theme.tertiaryImage, velocity: 100, scale: 0.3)
        particleEmitter.emitterCells = [far, middle, near]
        gradientLayer.colors = [
            UIColor.white.cgColor,
            theme.mainImage.averageColor!.cgColor
        ]
    }

    func updateBounds() {
        particleEmitter.emitterPosition = CGPoint(x: bounds.maxX, y: -100)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: bounds.size.height, height: 1)
        particleEmitter.renderMode = .backToFront
        particleEmitter.birthRate = 1
    }

    func lavaLampAnimation() {
        let firstLave = "🔥".toImage()
        let secondLava = "🩸".toImage()
        let thirdLava = "💛".toImage()
        particleEmitter.emitterPosition = CGPoint(x: bounds.midX, y: 100)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: bounds.size.height, height: 1)
        particleEmitter.renderMode = .backToFront

        let near = makeEmmiterCell(image: firstLave, velocity: 200, scale: 1.5, longitude: .pi)
        let middle = makeEmmiterCell(image: secondLava, velocity: 150, scale: 1, longitude: .pi)
        let far = makeEmmiterCell(image: thirdLava, velocity: 100, scale: 1, longitude: .pi)
        particleEmitter.emitterCells = [far, middle, near]
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(blurEffectView)
    }

    private func setupUI() {
        particleEmitter.emitterPosition = CGPoint(x: bounds.maxX, y: -100)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: bounds.size.height, height: 1)
        particleEmitter.renderMode = .backToFront
        particleEmitter.birthRate = 1
        
        layer.addSublayer(particleEmitter)
    }

    private func makeEmmiterCell(image: UIImage,
                                 velocity: CGFloat,
                                 scale: CGFloat,
                                 longitude: CGFloat = 10)-> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 1
        cell.lifetime = 15.0
        cell.velocity = velocity
        cell.velocityRange = velocity / 2
        cell.spinRange = 2
        cell.scale = scale
        cell.scaleRange = scale / 3
        cell.emissionLongitude = longitude
        cell.contents = image.cgImage
        return cell
    }
}

extension ParticleAnimationView {
    struct Theme {
        let mainImage: UIImage
        let secondaryImage: UIImage
        let tertiaryImage: UIImage
    }
}
