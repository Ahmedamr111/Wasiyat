import os
import math
from PIL import Image, ImageDraw

def get_flame_points(cx, cy_bottom, height, width):
    points = []
    steps = 30
    # Left side (bottom to tip)
    for i in range(steps + 1):
        t = i / steps  # 0 to 1
        y = cy_bottom - t * height
        bulge = math.sin(t * math.pi) * (1.0 - t * 0.8) * (width / 2)
        x = cx - bulge
        points.append((x, y))
    
    # Right side (tip to bottom)
    for i in range(steps, -1, -1):
        t = i / steps
        y = cy_bottom - t * height
        bulge = math.sin(t * math.pi) * (1.0 - t * 0.8) * (width / 2)
        x = cx + bulge
        points.append((x, y))
    return points

def draw_candle(size, bg_color=None):
    # Create canvas
    img = Image.new("RGBA", (size, size), bg_color or (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Scale variables relative to size
    cx = size // 2
    cy = size // 2
    
    y_base = cy + int(size * 0.22)
    h_candle = int(size * 0.28)
    w_candle = int(size * 0.16)
    y_top = y_base - h_candle
    
    h_wick = int(size * 0.05)
    y_wick_top = y_top - h_wick
    
    h_flame = int(size * 0.14)
    w_flame = int(size * 0.08)
    
    w_saucer = int(size * 0.26)
    h_saucer = int(size * 0.04)
    
    # Colors
    c_bg_ivory = (250, 246, 241, 255)
    c_amber = (232, 168, 124, 255)
    c_rose = (196, 115, 106, 255)
    c_taupe = (139, 115, 85, 255)
    c_charcoal = (45, 37, 32, 255)
    c_gold = (242, 196, 109, 255)
    c_white = (250, 246, 241, 255)
    
    # 1. Soft glowing halo behind the flame
    flame_center_y = y_wick_top - int(h_flame * 0.4)
    for r_factor in [1.5, 1.1, 0.7]:
        r = int(w_flame * r_factor)
        alpha = int(255 * 0.06 * (2.0 - r_factor))
        draw.ellipse(
            [cx - r, flame_center_y - r, cx + r, flame_center_y + r],
            fill=(c_gold[0], c_gold[1], c_gold[2], alpha)
        )
        
    # 2. Draw base saucer
    # Outer saucer oval
    draw.ellipse(
        [cx - w_saucer // 2, y_base - h_saucer // 2, cx + w_saucer // 2, y_base + h_saucer // 2],
        fill=c_taupe
    )
    # Inner saucer rim to give a premium 3D look
    w_inner = int(w_saucer * 0.8)
    h_inner = int(h_saucer * 0.6)
    draw.ellipse(
        [cx - w_inner // 2, y_base - h_inner // 2, cx + w_inner // 2, y_base + h_inner // 2],
        fill=c_charcoal
    )
    
    # 3. Draw Candle Body
    draw.rounded_rectangle(
        [cx - w_candle // 2, y_top, cx + w_candle // 2, y_base],
        radius=int(size * 0.015),
        fill=c_rose
    )
    
    # Vertical soft highlight on the left for elegant 3D reflection
    w_highlight = int(w_candle * 0.15)
    r_highlight = int(size * 0.005)
    draw.rounded_rectangle(
        [cx - w_candle // 2 + int(w_candle * 0.1), y_top + int(size * 0.015), 
         cx - w_candle // 2 + int(w_candle * 0.1) + w_highlight, y_base - int(size * 0.015)],
        radius=r_highlight,
        fill=(c_amber[0], c_amber[1], c_amber[2], 180)
    )
    
    # 4. Draw the Wick
    draw.line(
        [(cx, y_top), (cx, y_wick_top)],
        fill=c_charcoal,
        width=max(2, int(size * 0.006))
    )
    
    # 5. Draw the Flame (multi-layered)
    # Outer flame
    outer_pts = get_flame_points(cx, y_wick_top, h_flame, w_flame)
    draw.polygon(outer_pts, fill=c_gold)
    
    # Middle flame
    mid_pts = get_flame_points(cx, y_wick_top, int(h_flame * 0.7), int(w_flame * 0.65))
    draw.polygon(mid_pts, fill=c_amber)
    
    # Core flame
    core_pts = get_flame_points(cx, y_wick_top, int(h_flame * 0.4), int(w_flame * 0.35))
    draw.polygon(core_pts, fill=c_white)
    
    return img

def main():
    print("Generating Wasiyati original candle assets...")
    
    icons_dir = r"c:\Users\10191\OneDrive\Documents\Wasiyat\wasiyati_app\assets\icons"
    images_dir = r"c:\Users\10191\OneDrive\Documents\Wasiyat\wasiyati_app\assets\images"
    os.makedirs(icons_dir, exist_ok=True)
    os.makedirs(images_dir, exist_ok=True)
    
    c_bg_ivory = (250, 246, 241, 255) # #FAF6F1
    
    # 1. Save app_icon.png (Opaque background)
    print("Drawing app_icon.png...")
    app_icon = draw_candle(1024, bg_color=c_bg_ivory)
    app_icon_path = os.path.join(icons_dir, "app_icon.png")
    app_icon.save(app_icon_path, "PNG")
    print(f"Saved app_icon to {app_icon_path}")
    
    # 2. Save app_icon_foreground.png (Transparent background)
    print("Drawing app_icon_foreground.png...")
    app_icon_fg = draw_candle(1024, bg_color=None)
    app_icon_fg_path = os.path.join(icons_dir, "app_icon_foreground.png")
    app_icon_fg.save(app_icon_fg_path, "PNG")
    print(f"Saved app_icon_foreground to {app_icon_fg_path}")
    
    # 3. Save splash_logo.png (Transparent background)
    print("Drawing splash_logo.png...")
    splash_logo = draw_candle(512, bg_color=None)
    splash_logo_path = os.path.join(images_dir, "splash_logo.png")
    splash_logo.save(splash_logo_path, "PNG")
    print(f"Saved splash_logo to {splash_logo_path}")
    
    print("All assets successfully generated!")

if __name__ == "__main__":
    main()
