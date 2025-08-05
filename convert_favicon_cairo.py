#!/usr/bin/env python3
"""
Convert favicon.svg to various formats using cairosvg
"""

import cairosvg
from PIL import Image
import io
import os
import sys

def svg_to_png_cairo(svg_path, png_path, size):
    """Convert SVG to PNG using cairosvg"""
    print(f"🔄 Converting to {os.path.basename(png_path)} ({size}x{size})...")
    try:
        # Read SVG content
        with open(svg_path, 'r') as f:
            svg_content = f.read()
        
        # Convert SVG to PNG bytes
        png_bytes = cairosvg.svg2png(
            bytestring=svg_content.encode('utf-8'),
            output_width=size,
            output_height=size,
            background_color=None  # Transparent background
        )
        
        # Save PNG
        with open(png_path, 'wb') as f:
            f.write(png_bytes)
        
        print(f"✅ {os.path.basename(png_path)} created")
        return True
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

def create_ico_from_pngs(png_paths, ico_path):
    """Create ICO file from multiple PNG files using Pillow"""
    print(f"🔄 Creating {os.path.basename(ico_path)}...")
    try:
        images = []
        for png_path in png_paths:
            img = Image.open(png_path)
            images.append(img)
        
        # Save as ICO
        images[0].save(ico_path, format='ICO', sizes=[(16, 16), (32, 32)])
        print(f"✅ {os.path.basename(ico_path)} created")
        return True
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

def main():
    # Base directory
    base_dir = "/Users/coldwoong/SIDE-PROJECT/coldwoong-moon.github.io"
    static_dir = os.path.join(base_dir, "static")
    
    # Source SVG
    svg_path = os.path.join(static_dir, "favicon.svg")
    
    if not os.path.exists(svg_path):
        print(f"❌ Error: {svg_path} not found!")
        sys.exit(1)
    
    print(f"🎨 Converting favicon.svg using cairosvg...")
    print(f"📁 Working directory: {static_dir}")
    print()
    
    # Change to static directory
    os.chdir(static_dir)
    
    # Convert to various PNG sizes
    conversions = [
        (16, "favicon-16x16.png"),
        (32, "favicon-32x32.png"),
        (180, "apple-touch-icon.png"),
        (192, "android-chrome-192x192.png"),
        (512, "android-chrome-512x512.png")
    ]
    
    success = True
    for size, filename in conversions:
        if not svg_to_png_cairo("favicon.svg", filename, size):
            success = False
    
    # Create ICO file
    if success:
        if not create_ico_from_pngs(["favicon-16x16.png", "favicon-32x32.png"], "favicon.ico"):
            success = False
    
    print()
    if success:
        print("🎉 All conversions completed successfully!")
        
        # List generated files
        print("\n📋 Generated files:")
        for _, filename in conversions:
            if os.path.exists(filename):
                size_kb = os.path.getsize(filename) / 1024
                print(f"   - {filename} ({size_kb:.1f} KB)")
        
        if os.path.exists("favicon.ico"):
            size_kb = os.path.getsize("favicon.ico") / 1024
            print(f"   - favicon.ico ({size_kb:.1f} KB)")
    else:
        print("⚠️  Some conversions failed. Please check the errors above.")
        sys.exit(1)

if __name__ == "__main__":
    main()