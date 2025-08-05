#!/usr/bin/env python3
"""
Convert favicon.svg to various formats (PNG, ICO) using ffmpeg and ImageMagick
"""

import subprocess
import os
import sys

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

def convert_svg_to_png_ffmpeg(svg_path, png_path, size):
    """Convert SVG to PNG using ffmpeg"""
    # ffmpeg doesn't directly support SVG, so we'll use ImageMagick
    return False

def convert_svg_to_png_magick(svg_path, png_path, size):
    """Convert SVG to PNG using ImageMagick"""
    command = f"magick '{svg_path}' -background transparent -resize {size}x{size} '{png_path}'"
    return run_command(command, f"Converting to {os.path.basename(png_path)} ({size}x{size})")

def create_ico_from_pngs(png_16_path, png_32_path, ico_path):
    """Create ICO file from multiple PNG files"""
    command = f"magick '{png_16_path}' '{png_32_path}' -background transparent '{ico_path}'"
    return run_command(command, "Creating favicon.ico")

def main():
    # Base directory
    base_dir = "/Users/coldwoong/SIDE-PROJECT/coldwoong-moon.github.io"
    static_dir = os.path.join(base_dir, "static")
    
    # Source SVG
    svg_path = os.path.join(static_dir, "favicon.svg")
    
    if not os.path.exists(svg_path):
        print(f"❌ Error: {svg_path} not found!")
        sys.exit(1)
    
    print(f"🎨 Converting favicon.svg to various formats...")
    print(f"📁 Working directory: {static_dir}")
    print()
    
    # Change to static directory
    os.chdir(static_dir)
    
    # Convert to various PNG sizes
    sizes = [
        (16, "favicon-16x16.png"),
        (32, "favicon-32x32.png"),
        (180, "apple-touch-icon.png"),
        (192, "android-chrome-192x192.png"),
        (512, "android-chrome-512x512.png")
    ]
    
    success = True
    for size, filename in sizes:
        if not convert_svg_to_png_magick("favicon.svg", filename, size):
            success = False
    
    # Create ICO file
    if success:
        if not create_ico_from_pngs("favicon-16x16.png", "favicon-32x32.png", "favicon.ico"):
            success = False
    
    print()
    if success:
        print("🎉 All conversions completed successfully!")
        
        # List generated files
        print("\n📋 Generated files:")
        for _, filename in sizes:
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