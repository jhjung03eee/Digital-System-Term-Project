
![KakaoTalk_20260205_114450113](https://github.com/user-attachments/assets/c3d8fdb3-4872-4a8f-a997-2932fde06d84)

# 🏀 FPGA Basketball Free Throw Game

Digital System Term Project  
Sungkyunkwan University  
Author: Jihoon Jung  

---

## 📌 Overview

This project implements a simplified basketball free throw game using Verilog HDL on the FPGA Starter Kit III (Xilinx Artix-7 XC7A75T).

The game runs on a 640×480 @ 60Hz VGA display.  
The player controls the ball’s initial velocity using DIP switches and throws the ball using a push button.

This project focuses on RTL-based digital system design, VGA timing control, and real-time hardware game logic.

---

## 🎮 Game Description

Game Elements:
- Player (green rectangle)
- Rim (red rectangle)
- Ball (parabolic motion)

Game Flow:
1. Set horizontal velocity using SW[3:0]
2. Set vertical velocity using SW[7:4]
3. Press center push button to throw
4. Ball follows a parabolic trajectory
5. If ball hits rim → score increases

---

## 🖥 Hardware Platform

Board: FPGA Starter Kit III  
FPGA: Xilinx Artix-7 XC7A75T  
Clock: 100 MHz onboard oscillator  
Video Output: VGA RGB444 (12-bit color)  

Inputs:
- 16-bit DIP Switch
- 5 Push Buttons
- Reset Button

---

## 🧠 System Architecture

Top Module
- Clock Divider (100MHz → 25MHz)
- VGA Controller (640×480 @ 60Hz)
- Game Logic Module
    - Ball Physics
    - Collision Detection
    - Score Logic
- Object Renderer
    - Player
    - Rim
    - Ball
- Input Control

---

## 🎥 VGA Timing

Resolution: 640 × 480 @ 60Hz  
Pixel Clock: 25 MHz  

Horizontal:
- HMAX = 800
- Visible Area = 640

Vertical:
- VMAX = 525
- Visible Area = 480

---

## ⚙ Ball Physics

Discrete-time motion:

x(t+1) = x(t) + vx  
y(t+1) = y(t) + vy  
vy(t+1) = vy(t) + gravity  

Gravity is implemented as a constant acceleration.  
All calculations are done using integer arithmetic.

---

## 🛠 How to Run

1. Open project in Xilinx Vivado
2. Set FPGA part: XC7A75T-1FGG484C
3. Add constraint (.xdc) file
4. Generate bitstream
5. Program board via USB-JTAG
6. Connect VGA monitor
7. Play the game

---

## 📂 Repository Structure

/src
- top.v
- vga_controller.v
- game_logic.v
- ball_physics.v
- renderer.v
- clock_divider.v

/constraints
- basketball.xdc

README.md

---

## 🎓 Learning Outcomes

- Designed a complete digital system in Verilog
- Implemented VGA timing controller
- Developed hardware-based real-time rendering
- Built modular RTL architecture
- Verified design on FPGA hardware

---

## 🚀 Possible Improvements

- More realistic collision detection
- Adjustable gravity
- 7-segment score display
- Sound effects using Piezo buzzer
- Enhanced play mode

---

## 👨‍💻 Author

Jihoon Jung  
Department of Electronic & Electrical Engineering  
Sungkyunkwan University
