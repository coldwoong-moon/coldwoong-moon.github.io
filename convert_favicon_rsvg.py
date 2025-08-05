#!/usr/bin/env python3
"""
Convert favicon.svg to various formats using rsvg-convert
"""

import subprocess
import os
import sys
from PIL import Image

def run_command(command, description):
    """Run a shell command and handle errors"""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"❌ Error: {result.stderr}")
            return False
        print(f"✅ {description} completed")
        return True
    except Exception as e:
        print(f"❌ Exception: {str(e)}")
        return False

def svg_to_png_rsvg(svg_path, png_path, size):
    """Convert SVG to PNG using rsvg-convert"""
    command = f"rsvg-convert -w {size} -h {size} -o '{png_path}' '{svg_path}'"
    return run_command(command, f"Converting to {os.path.basename(png_path)} ({size}x{size})")

def create_ico_from_pngs(png_paths, ico_path):
    """Create ICO file from multiple PNG files using Pillow"""
    print(f"🔄 Creating {os.path.basename(ico_path)}...")
    try:
        images = []
        for png_path in png_paths:
            img = Image.open(png_path)
            # Ensure RGBA mode for transparency
            if img.mode != 'RGBA':
                img = img.convert('RGBA')
            images.append(img)
        
        # Save as ICO with multiple sizes
        images[0].save(
            ico_path, 
            format='ICO', 
            sizes=[(16, 16), (32, 32)],
            append_images=images[1:] if len(images) > 1 else []
        )
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
    
    # Check if rsvg-convert is available
    check_result = subprocess.run("which rsvg-convert", shell=True, capture_output=True)
    if check_result.returncode != 0:
        print("❌ Error: rsvg-convert not found! Please install librsvg with: brew install librsvg")
        sys.exit(1)
    
    print(f"🎨 Converting favicon.svg using rsvg-convert...")
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
        if not svg_to_png_rsvg("favicon.svg", filename, size):
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
                # Display first few bytes to check if it's not empty
                with open(filename, 'rb') as f:
                    data = f.read(10)
                    if len(data) < 10 or all(b == 0 for b in data):
                        print(f"   - {filename} ({size_kb:.1f} KB) ⚠️  May be empty!")
                    else:
                        print(f"   - {filename} ({size_kb:.1f} KB)")
        
        if os.path.exists("favicon.ico"):
            size_kb = os.path.getsize("favicon.ico") / 1024
            print(f"   - favicon.ico ({size_kb:.1f} KB)")
            
        # Also display the SVG content for verification
        print("\n📄 Current SVG content:")
        with open("favicon.svg", "r") as f:
            print(f.read())
    else:
        print("⚠️  Some conversions failed. Please check the errors above.")
        sys.exit(1)

if __name__ == "__main__":
    main()