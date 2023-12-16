import UIKit

public class ParticleAnimationView: UIView {
    private var colorIndex: Int = 0
    private var gradientColorSet: [[CGColor]] = []
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
    
    public func update(with image: UIImage) {
        let near = makeEmmiterCell(image: image, velocity: 300, scale: 0.7, longitude: .pi)
        let middle = makeEmmiterCell(image: image, velocity: 200, scale: 0.5)
        let far = makeEmmiterCell(image: image, velocity: 100, scale: 0.3)
        particleEmitter.emitterCells = [far, middle, near]
        gradientLayer.colors = [
            UIColor.white.cgColor,
            image.averageColor!.cgColor
        ]
    }

    public func update(with theme: Theme) {
        let near = makeEmmiterCell(image: theme.mainImage, velocity: 300, scale: 0.7, longitude: .pi)
        let middle = makeEmmiterCell(image: theme.secondaryImage, velocity: 200, scale: 0.5)
        let far = makeEmmiterCell(image: theme.tertiaryImage, velocity: 100, scale: 0.3)
        particleEmitter.emitterCells = [far, middle, near]
        gradientLayer.colors = [
            UIColor.white.cgColor,
            theme.mainImage.averageColor!.cgColor
        ]
    }

    public func updateBounds() {
        particleEmitter.emitterPosition = CGPoint(x: bounds.maxX, y: -100)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: bounds.size.height, height: 1)
        particleEmitter.renderMode = .backToFront
        particleEmitter.birthRate = 1
    }

    public func lavaLampAnimation() {
        gradientColorSet = [
            [CGColor.lavaGradientColor1, CGColor.lavaGradientColor2],
            [CGColor.lavaGradientColor2, CGColor.lavaGradientColor3],
            [CGColor.lavaGradientColor3, CGColor.lavaGradientColor1]
        ]
        gradientLayer.colors = gradientColorSet

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
}

// MARK: - Private Methods -
private extension ParticleAnimationView {
    func setupUI() {
        particleEmitter.emitterPosition = CGPoint(x: bounds.maxX, y: -100)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: bounds.size.height, height: 1)
        particleEmitter.renderMode = .backToFront
        particleEmitter.birthRate = 1

        gradientLayer.frame = frame
        gradientLayer.bounds = bounds

        layer.addSublayer(gradientLayer)
        layer.addSublayer(particleEmitter)
    }

    func makeEmmiterCell(image: UIImage,
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

    func animateGradient() {
        gradientLayer.colors = gradientColorSet[colorIndex]
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.delegate = self
        gradientAnimation.duration = 2

        updateColorIndex()
        gradientAnimation.toValue = gradientColorSet[colorIndex]
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        gradientLayer.add(gradientAnimation, forKey: "colors")
    }
}

// MARK: - CAAnimationDelegate
extension ParticleAnimationView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animateGradient()
        }
    }

    func updateColorIndex() {
        colorIndex = colorIndex < gradientColorSet.count - 1 ? colorIndex + 1 : 0
    }
}

public extension ParticleAnimationView {
    struct Theme {
        public init(mainImage: UIImage, secondaryImage: UIImage, tertiaryImage: UIImage) {
            self.mainImage = mainImage
            self.secondaryImage = secondaryImage
            self.tertiaryImage = tertiaryImage
        }

        let mainImage: UIImage
        let secondaryImage: UIImage
        let tertiaryImage: UIImage
    }
}

// MARK: - Colors -
private extension CGColor {
    static let lavaGradientColor1 = UIColor(red: 255/255, green: 215/255, blue: 0, alpha: 1.00).cgColor
    static let lavaGradientColor2 = UIColor(red: 255/255, green: 165/255, blue: 0, alpha: 1.00).cgColor
    static let lavaGradientColor3 = UIColor(red: 255/255, green: 69/255, blue: 0, alpha: 1.00).cgColor
}
