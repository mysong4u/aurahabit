import Foundation
import CoreGraphics
import ImageIO

let width = 1024
let height = 1024
let bitsPerComponent = 8
let bytesPerRow = width * 4
let colorSpace = CGColorSpaceCreateDeviceRGB()

// Create CGContext explicitly ignoring alpha channel (noneSkipLast) to ensure NO transparency.
guard let context = CGContext(
    data: nil,
    width: width,
    height: height,
    bitsPerComponent: bitsPerComponent,
    bytesPerRow: bytesPerRow,
    space: colorSpace,
    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
) else {
    print("Failed to create headless CGContext")
    exit(1)
}

// 1. Draw premium background gradient (Deep Navy Indigo #0C0A21 to Royal Velvet #4C1D95)
let colors = [
    CGColor(red: 0.05, green: 0.04, blue: 0.15, alpha: 1.0), // Deep Dark Navy
    CGColor(red: 0.35, green: 0.15, blue: 0.65, alpha: 1.0)  // Royal Velvet Purple
] as CFArray

let locations: [CGFloat] = [0.0, 1.0]
guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations) else {
    print("Failed to create gradient")
    exit(1)
}

let startPoint = CGPoint(x: 0, y: CGFloat(height))
let endPoint = CGPoint(x: CGFloat(width), y: 0)
context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])

// 2. Draw glowing circular "Aura Ring" (representing focus and productivity rings)
let center = CGPoint(x: CGFloat(width / 2), y: CGFloat(height / 2))
let radius: CGFloat = 300
context.setLineWidth(24)

// Draw subtle shadow for premium 3D depth
context.setShadow(offset: CGSize(width: 0, height: -12), blur: 20, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.4))

// Outer aura ring in bright white
context.setStrokeColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
context.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
context.strokePath()

// 3. Draw an elegant, glowing habit "Star" inside the ring
context.setShadow(offset: CGSize(width: 0, height: -8), blur: 16, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.3))
context.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

let points = 5
let innerRadius: CGFloat = 85
let outerRadius: CGFloat = 175
let angle = CGFloat.pi / CGFloat(points)

// Point 0 (top point)
context.move(to: CGPoint(x: center.x, y: center.y - outerRadius))

for i in 1..<(points * 2) {
    let r = i % 2 == 0 ? outerRadius : innerRadius
    // Angle offset by pi/2 to point upwards
    let currentAngle = CGFloat(i) * angle - CGFloat.pi / 2
    let x = center.x + r * cos(currentAngle)
    let y = center.y + r * sin(currentAngle)
    context.addLine(to: CGPoint(x: x, y: y))
}
context.closePath()
context.fillPath()

// 4. Save to PNG using ImageIO (100% headless command-line safe)
guard let cgImage = context.makeImage() else {
    print("Failed to render CGImage from context")
    exit(1)
}

let outputPath = "/Users/air/AuraHabit/AuraAppIcon.png"
let outputURL = URL(fileURLWithPath: outputPath)

// "public.png" is the universal UTI string for PNG files
guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, "public.png" as CFString, 1, nil) else {
    print("Failed to create CGImageDestination")
    exit(1)
}

CGImageDestinationAddImage(destination, cgImage, nil)
if CGImageDestinationFinalize(destination) {
    print("SUCCESS: 1024x1024 App Store compliant PNG Icon generated at: \(outputPath)")
} else {
    print("Failed to write image to destination")
    exit(1)
}
