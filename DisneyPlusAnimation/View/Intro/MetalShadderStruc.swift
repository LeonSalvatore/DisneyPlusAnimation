////
////  MetalShadderStruc.swift
////  ClockAnimation
////
////  Created by Leon Salvatore on 22.05.2025.
////
//
//import SwiftUI
//import Foundation
//import Metal
//import MetalKit
//
//struct Light {
//    var position: SIMD3<Float>
//    var radius: Float
//    var color: SIMD3<Float>
//}
//
//
//final class MetalRenderer: NSObject, MTKViewDelegate {
//    private let device: MTLDevice
//    private let commandQueue: MTLCommandQueue
//    private var pipelineState: MTLRenderPipelineState!
//    private var vertexBuffer: MTLBuffer!
//    private var texture: MTLTexture!
//    
//    // Light properties
//    private var lightPosition: SIMD3<Float> = [0, 0, 0]
//    private var lightRadius: Float = 1.5
//    private var lightColor: SIMD3<Float> = [1, 1, 1]
//    private var time: Float = 0
//    
//    init?(metalView: MTKView) {
//        guard let device = MTLCreateSystemDefaultDevice(),
//              let commandQueue = device.makeCommandQueue()
//        else { return nil }
//        
//        self.device = device
//        self.commandQueue = commandQueue
//        metalView.device = device
//        metalView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
//        
//        super.init()
//        metalView.delegate = self
//        
//        setupPipeline()
//        createTextTexture()
//        createVertexBuffer()
//    }
//    
//    private func setupPipeline() {
//        guard let device = MTLCreateSystemDefaultDevice(),
//              let library = device.makeDefaultLibrary() else {
//            fatalError("Metal is not supported on this device")
//        }
//        
//        let pipelineDescriptor = MTLRenderPipelineDescriptor()
//        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")
//        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_main")
//        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
//        
//        do {
//            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
//        } catch {
//            fatalError("Failed to create pipeline state: \(error)")
//        }
//    }
//    
//    private func createTextTexture() {
//        let text = "Hello Metal!"
//        let fontSize: CGFloat = 48.0
//        
//        // 1. Create text attributes
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(ofSize: fontSize),
//            .foregroundColor: UIColor.white
//        ]
//        
//        // 2. Calculate text size with padding
//        let textSize = (text as NSString).size(withAttributes: attributes)
//        let padding: CGFloat = 20.0
//        let imageSize = CGSize(
//            width: textSize.width + padding,
//            height: textSize.height + padding
//        )
//        
//        // 3. Create image context
//        let renderer = UIGraphicsImageRenderer(size: imageSize)
//        let image = renderer.image { context in
//            UIColor.clear.setFill()
//            context.fill(CGRect(origin: .zero, size: imageSize))
//            
//            // Draw text centered
//            let textOrigin = CGPoint(
//                x: (imageSize.width - textSize.width) / 2,
//                y: (imageSize.height - textSize.height) / 2
//            )
//            text.draw(at: textOrigin, withAttributes: attributes)
//        }
//        
//        // 4. Create texture with proper options
//        let textureLoader = MTKTextureLoader(device: device)
//        let options: [MTKTextureLoader.Option: Any] = [
//            .SRGB: false,
//            .generateMipmaps: false,
//            .textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue),
//            .textureStorageMode: NSNumber(value: MTLStorageMode.private.rawValue)
//        ]
//        
//        do {
//            texture = try textureLoader.newTexture(
//                cgImage: image.cgImage!,
//                options: options
//            )
//        } catch {
//            fatalError("Failed to create texture: \(error.localizedDescription)\nEnsure the CGImage was created successfully.")
//        }
//    }
//    
//    private func createVertexBuffer() {
//        let vertices: [Float] = [
//            -1, -1,  0, 1,  // Bottom-left
//             1, -1,  1, 1,  // Bottom-right
//            -1,  1,  0, 0,  // Top-left
//             1,  1,  1, 0   // Top-right
//        ]
//        
//        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.stride, options: [])
//    }
//    
//    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
//    
//    func draw(in view: MTKView) {
//        guard let drawable = view.currentDrawable,
//              let commandBuffer = commandQueue.makeCommandBuffer(),
//              let renderPassDescriptor = view.currentRenderPassDescriptor
//        else { return }
//        
//        // Update light position (orbit around center)
//        time += 0.01
//        lightPosition = [sin(time) * 2, cos(time) * 2, 0]
//        
//        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
//        encoder.setRenderPipelineState(pipelineState)
//        
//        // Pass light data
//        encoder.setFragmentBytes(&lightPosition, length: MemoryLayout<SIMD3<Float>>.stride, index: 0)
//        encoder.setFragmentBytes(&lightRadius, length: MemoryLayout<Float>.stride, index: 1)
//        encoder.setFragmentBytes(&lightColor, length: MemoryLayout<SIMD3<Float>>.stride, index: 2)
//        
//        // Draw textured quad
//        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
//        encoder.setFragmentTexture(texture, index: 0)
//        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
//        
//        encoder.endEncoding()
//        commandBuffer.present(drawable)
//        commandBuffer.commit()
//    }
//}
//
//
//struct MetalView: UIViewRepresentable {
//    func makeUIView(context: Context) -> MTKView {
//        let mtkView = MTKView()
//        mtkView.preferredFramesPerSecond = 60
//        _ = MetalRenderer(metalView: mtkView)
//        return mtkView
//    }
//    
//    func updateUIView(_ uiView: MTKView, context: Context) {}
//}
//
//struct ContentViewS: View {
//    var body: some View {
//        VStack {
//            MetalView()
//                .frame(width: 300, height: 200)
//                .border(Color.gray, width: 1)
//            
//            Text("Metal Text with Orbiting Light")
//                .font(.title)
//        }
//    }
//}
//
//#Preview {
//    ContentViewS()
//}
