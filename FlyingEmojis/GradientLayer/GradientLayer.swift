import UIKit

final class GradientLayer: CAGradientLayer {
    init(opacity: Float = 1, colors: [CGColor], locations: [NSNumber], bounds: CGRect) {
        super.init()
        self.colors = colors
        self.locations = locations
        self.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
