# 🎬 Disney+ Style Animation in SwiftUI

This project recreates the elegant Disney+ launch animation using **SwiftUI** and **Metal**. It features:

- A **curved arc animation** similar to the iconic Disney+ logo.
- Dynamic **star particles** following the arc.
- **Gradient and glowing effects**.
- A **Metal shader** that casts directional shadows on text based on a glowing object.

## ✨ Features

- ✅ Custom `DisneyArc` shape with trimming and animation
- ✅ Procedurally generated `StarShape` elements with glowing and motion
- ✅ Accurate Disney+ style gradient and logo animation
- ✅ Directional shadow effect using Metal shaders
- ✅ MTLTexture rendering of SwiftUI text for Metal processing

## 📸 Preview

![Disney Plus Arc Animation Preview](Assets/preview.gif)

## 🛠 Requirements

- iOS 15.0+
- Xcode 15+
- Swift 5.9+
- Metal (GPU support)

## 🧩 Project Structure

- `DisneyArc.swift` – Custom `Shape` mimicking the Disney+ arc.
- `StarShape.swift` – A stylized 4-point star shape with sharp tips.
- `DisneyPlusSymbol.swift` – Shape-based recreation of the "+" logo.
- `DirectionalShadow.metal` – Metal fragment shader for light-based shadows.
- `MetalView.swift` – MTKView integration with SwiftUI.
- `TextRenderer.swift` – SwiftUI text to `MTLTexture` conversion.

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/DisneyPlusAnimation.git
   ```
2. Open in Xcode:
       ```cd DisneyPlusAnimation ```

3.	Build and run on an iOS simulator or device with Metal support.

## ⚙️ Customization

- Adjust the config values to tweak the arc angle, stroke width, and glow color.
- Modify the shader in DirectionalShadow.metal to simulate different lighting effects.

## 🧠 Concepts Covered

- SwiftUI Shape, trim, overlay, and animation
-	Procedural UI generation
-	CoreGraphics for shape math
-	Metal shading pipeline for 2D effects
-	Bridging SwiftUI with Metal using MTKView

## 🙏 Credits

-	Inspired by the Disney+ app launch animation.
-	Gradient and colors were extracted using image sampling from official app screenshots.
-	Built with ❤️ using SwiftUI and Metal.

## 📄 License

This project is licensed under the MIT License. See LICENSE for more information.

---

Let me know if you'd like to add badges (build, license, etc.), or include installation instructions via Swift Package Manager.
