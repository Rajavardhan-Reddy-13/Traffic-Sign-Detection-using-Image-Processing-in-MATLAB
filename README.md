# 🚦 Traffic Sign Detection using MATLAB

## 📌 Overview
This project implements a traffic sign detection system using **color-based segmentation**, **morphological processing**, and **region analysis** in **MATLAB**. It identifies and localizes red, yellow, and blue traffic signs in static images by extracting and analyzing their visual features. It also supports the detection of **black-and-white signs** (e.g., speed limit signs) using **template matching**.

---

## 🧠 Problem Statement
The goal is to detect traffic signs from input images and draw bounding boxes around them. The project handles:
- Colorful signs based on red, yellow, and blue hues
- Monochrome signs (black and white) using structural pattern matching

---

## 🛠️ Techniques Used
- **Color space transformation (RGB → HSV)**
- **HSV thresholding** for color segmentation
- **Morphological operations** (`imopen`, `imclose`, `imfill`) to clean masks
- **Region labeling** using `bwlabel`
- **Region analysis** with `regionprops` to find bounding boxes and compute dominance
- **Bounding box visualization** using `rectangle`
- **Template matching** using a custom normalized cross-correlation function (`ncrossco`) for speed limit and other black-and-white signs

---

## 🔍 How It Works

### 1. Color Segmentation
- Converts the input image to HSV
- Applies hue, saturation, and brightness thresholds to isolate red, yellow, and blue areas

### 2. Morphological Processing
- Cleans segmented masks using opening and closing
- Fills holes to form solid regions
- Labels connected components for further analysis

### 3. Region Analysis
- Computes region properties like bounding boxes and pixel indices
- Scores each region using total saturation and brightness
- Selects the **most dominant region** per color
- Draws bounding boxes on the original image for visual feedback

### 4. Template Matching (for B/W Signs)
- Preprocesses target and template images with edge detection
- Applies **normalized cross-correlation** to measure similarity
- Finds the best match and overlays a bounding box on the matched location

---

## 📁 Files Included
- `traffic_sign_detection.m` – Main script for color-based detection
- `preprocessImage.m` – Edge preprocessing function for template matching
- `ncrossco.m` – Custom normalized cross-correlation function
- `plotbox.m` – Draws bounding boxes for matched templates
- `test_images/` – Sample input images
- `templates/` – Template images (e.g., speed limit signs)

---

## 📷 Output
Displays the original input image and the output image side-by-side with bounding boxes around detected signs.

---

## ⚠️ Limitations
- Only one sign is detected per color (most dominant)
- Sensitive to lighting, shadows, and color noise
- Template matching does not handle scale or rotation
- Not suitable for real-time applications without further optimization

---

## ✅ Future Improvements
- Handle multiple signs of the same color
- Add classification of signs (e.g., stop, yield, speed limit)
- Improve robustness to scale, rotation, and lighting changes
- Extend to video or real-time detection using ML or deep learning

---

## 📬 Contact
For questions or support, feel free to reach out.
