# 💡 LED Running Light for DE2-115 Board
## ⚡ FPGA Clock Enable Demonstration Project

This project serves as a hands-on educational demonstration of the **clock enable technique**—a fundamental design pattern in FPGA development. Instead of generating multiple clock domains (which can lead to timing issues and metastability), this design uses a single 50MHz system clock with a clock enable signal to control timing. This approach is **industry best practice** for frequency division in synchronous digital design, providing students and engineers with practical experience in proper clock domain management while creating an engaging visual display on the DE2-115 board.

## 📋 Project Description
This project demonstrates a **running LED pattern** on the Altera DE2-115 development board using the Cyclone IV FPGA. It showcases the **clock enable technique** for frequency division, creating a visual effect where one LED at a time lights up and rotates across all 18 red LEDs.

### ✨ Features
- 🔴 Running light pattern across 18 red LEDs
- ⚡ **Speed Control** (SW[0]) - Switch between slow (1Hz) and fast (5Hz)
- 🔄 **Direction Control** (SW[1]) - Switch between left and right rotation
- ⏸️ **Pause/Resume** (KEY[1]) - Hold to freeze, release to continue
- 🔁 **Reset** (KEY[0]) - Restart pattern from beginning

## 📁 Files Included
1. 📝 **led_blink.v** - Main Verilog HDL source code
2. 📌 **de2_115_pins.qsf** - Pin assignments for DE2-115 board
3. 📖 **README.md** - This documentation file

## 🔧 Hardware Requirements
- 🎛️ **Board:** Altera DE2-115 Development Board
- 🔲 **FPGA:** Cyclone IV E (EP4CE115F29C7)
- ⏱️ **Clock:** 50MHz onboard oscillator
- 🔌 **Programmer:** USB-Blaster cable (included with board)
- 💻 **PC:** Windows/Linux with Quartus Prime installed

## 💾 Software Requirements
- 🆓 **Intel Quartus Prime Lite Edition** (Free)
  - Version 23.1 or newer recommended
  - Download from: https://www.intel.com/fpga
- 🔌 **USB-Blaster Driver** (included with Quartus)
- 🔬 **ModelSim** (optional, for simulation)

---

## 🚀 Quick Start Guide

### 1️⃣ Step 1: Create New Project
1. Launch **Quartus Prime**
2. **File → New Project Wizard**
3. **Project Settings:**
   - Working directory: Choose your folder
   - Project name: `led_blink`
   - Top-level entity: `led_blink`
4. **Device Selection:**
   - Family: Cyclone IV E
   - Device: **EP4CE115F29C7**
   - Click Next → Finish

### 2️⃣ Step 2: Add Verilog File
1. **Project → Add/Remove Files in Project**
2. Add `led_blink.v`
3. Set as **top-level entity**
4. Click OK

### 3️⃣ Step 3: Assign Pins
**Method A: Manual Pin Assignment**
1. **Assignments → Pin Planner**
2. Assign pins according to DE2-115 schematic

**Method B: Import from .qsf (Recommended)**
1. Open your project's `.qsf` file (double-click in Project Navigator)
2. Open `de2_115_pins.qsf` in text editor
3. **Copy all contents** from `de2_115_pins.qsf`
4. **Paste at the end** of your project `.qsf`
5. Save and close

### 4️⃣ Step 4: Compile Design
1. **Processing → Start Compilation**
   - Or click the purple **▶ Play** button
2. Wait 2-5 minutes (first compilation is slower)
3. Check **Compilation Report** for success
4. Look for: ✅ **"Quartus Prime Compilation was successful"**

### 5️⃣ Step 5: Program FPGA
1. **Connect Hardware:**
   - Connect DE2-115 to PC via USB cable
   - Turn on board power switch
   - Wait for drivers to load

2. **Open Programmer:**
   - **Tools → Programmer**

3. **Setup Hardware:**
   - Click **Hardware Setup**
   - Select **USB-Blaster [USB-0]**
   - Click Close

4. **Add Programming File:**
   - Click **Add File**
   - Navigate to `output_files/led_blink.sof`
   - Select and open

5. **Program:**
   - Check ✅ **Program/Configure** box
   - Click **Start**
   - Wait for progress: 0% → 100%
   - Look for: **"100% (Successful)"**

### 6️⃣ Step 6: Observe Operation
- **Immediately after programming:** First LED (LEDR[0]) lights up
- **Every 1 second:** LED shifts one position to the left
- **After 18 seconds:** Pattern wraps back to LEDR[0]
- **Effect:** Creates a "Knight Rider" running light pattern

---

## 🎮 Board Controls

| Control | Component | Function | Description |
|---------|-----------|----------|-------------|
| **KEY[0]** | Push Button | Reset | Press to restart pattern from LEDR[0] |
| **KEY[1]** | Push Button | Pause/Resume | **Hold** to freeze animation, **release** to continue |
| **SW[0]** | Toggle Switch | Speed | DOWN = 1Hz (slow), UP = 5Hz (fast) |
| **SW[1]** | Toggle Switch | Direction | DOWN = Rotate Left →, UP = Rotate Right ← |

### Control Examples
- **Default:** SW[0]=OFF, SW[1]=OFF → LED runs LEFT at 1Hz (1 step per second)
- **Fast mode:** SW[0]=ON → LED runs 5x faster (5 steps per second)
- **Reverse:** SW[1]=ON → LED runs RIGHT instead of left
- **Pause:** Hold KEY[1] → LED freezes in place
- **Resume:** Release KEY[1] → LED continues from where it stopped
- **Reset:** Press KEY[0] → Pattern restarts from LEDR[0]

---

## ⚙️ How It Works

### Clock Enable Principle
Instead of creating a separate slow clock, this design uses **clock enable** signals:

1. **Main Clock:** 50MHz system clock runs continuously
2. **Counter:** Increments every clock cycle
3. **Clock Enable:** Pulses HIGH for 1 cycle every 50,000,000 clocks (= 1 second)
4. **LED Logic:** Only updates when clock_enable = 1

### Counter Calculation
```
Clock Frequency: 50 MHz = 50,000,000 Hz
Target Period: 1 second
Counter Max: 50,000,000 - 1 = 49,999,999
Counter Width: log₂(50,000,000) ≈ 25.6 → 26 bits
```

### LED Pattern Logic
```verilog
// Direction controlled by SW[1]
if (SW[1])
    LEDR <= {LEDR[0], LEDR[17:1]};   // Rotate RIGHT
else
    LEDR <= {LEDR[16:0], LEDR[17]};   // Rotate LEFT
```
- **Rotate Left:** Takes bits 0-16, shifts left. Bit 17 wraps to bit 0
- **Rotate Right:** Takes bits 17-1, shifts right. Bit 0 wraps to bit 17
- **Pause:** When KEY[1] is held, LED pattern freezes in place
- **Speed:** SW[0] selects between 1Hz (counter max = 49,999,999) and 5Hz (counter max = 9,999,999)

### Visual Sequence
```
Time 0s:  ●○○○○○○○○○○○○○○○○○  (LEDR = 0b000000000000000001)
Time 1s:  ○●○○○○○○○○○○○○○○○○  (LEDR = 0b000000000000000010)
Time 2s:  ○○●○○○○○○○○○○○○○○○  (LEDR = 0b000000000000000100)
...
Time 17s: ○○○○○○○○○○○○○○○○○●  (LEDR = 0b100000000000000000)
Time 18s: ●○○○○○○○○○○○○○○○○○  (wraps back to start)
```

---

## 📍 Pin Assignments (DE2-115)

| Signal | FPGA Pin | Description |
|--------|----------|-------------|
| CLOCK_50 | PIN_Y2 | 50MHz Clock Input |
| KEY[0] | PIN_M23 | Reset Button (Active Low) |
| KEY[1] | PIN_M21 | Pause/Resume Button (Active Low) |
| KEY[2] | PIN_N21 | Not Used |
| KEY[3] | PIN_R24 | Not Used |
| SW[0] | PIN_AB28 | Speed Control (OFF=1Hz, ON=5Hz) |
| SW[1] | PIN_AC28 | Direction Control (OFF=Left, ON=Right) |
| SW[2]-SW[17] | Various | Not Used (reserved for expansion) |
| LEDR[0] | PIN_G19 | Red LED 0 (Rightmost) |
| LEDR[1] | PIN_F19 | Red LED 1 |
| LEDR[2] | PIN_E19 | Red LED 2 |
| ... | ... | ... |
| LEDR[17] | PIN_H15 | Red LED 17 (Leftmost) |

**I/O Standard:** 2.5V for all pins

---

## 📊 Resource Utilization

Typical usage on EP4CE115F29C7:
- **Logic Elements:** ~60 LEs (< 0.1% of 114,480 total)
- **Registers:** ~45 registers
- **Combinational Functions:** ~40
- **Memory Bits:** 0
- **PLLs:** 0
- **Pins:** 43 I/O pins used (4 KEY + 18 SW + 18 LEDR + 1 CLK + 2 unused KEY)

---

## 🔍 Troubleshooting

### ❌ LED Not Running
- ✅ Check KEY[0] is **released** (not being pressed)
- ✅ Verify programming showed "100% Successful"
- ✅ Confirm board power LED is ON
- ✅ Try pressing and releasing KEY[0] once

### ⚠️ Compilation Errors
- ✅ Verify device is **EP4CE115F29C7**
- ✅ Check `led_blink.v` has no syntax errors
- ✅ Ensure top-level entity name matches module name
- ✅ Check all signals are declared properly

### 🚫 Programming Failed
- ✅ Install USB-Blaster drivers from Quartus directory
- ✅ Check USB cable connection
- ✅ Try different USB port
- ✅ Restart Quartus and reconnect board
- ✅ Check Device Manager for "USB-Blaster"

### 🔄 Pattern Not Rotating
- ✅ Verify all LEDR pin assignments are correct
- ✅ Check counter reaches 49,999,999 (not 50,000,000)
- ✅ Ensure clock_enable logic is correct

---

## 🧪 Modifications & Experiments

### Change Speed
Modify the counter compare value:
```verilog
// 0.5 Hz (2 seconds per LED)
assign clock_enable = (counter == 26'd99_999_999);

// 2 Hz (0.5 seconds per LED - faster)
assign clock_enable = (counter == 26'd24_999_999);

// 10 Hz (0.1 seconds per LED - very fast)
assign clock_enable = (counter == 26'd4_999_999);
```

### Different Patterns
```verilog
// Rotate right instead of left
LEDR <= {LEDR[0], LEDR[17:1]};

// Two LEDs chase each other
LEDR <= 18'b000000001000000001;  // Initial pattern
LEDR <= {LEDR[16:0], LEDR[17]};  // Rotate

// Fill pattern (accumulate)
LEDR <= {LEDR[16:0], 1'b1};  // Grows from right

// All blink together
LEDR <= ~LEDR;  // Toggle all
```

### Add Switch Control
Use SW[0] to control speed:
```verilog
wire [25:0] max_count;
assign max_count = SW[0] ? 26'd24_999_999 : 26'd49_999_999;
assign clock_enable = (counter == max_count);
```

---

## 🎓 Learning Objectives

This project teaches:
1. ✅ **Clock enable technique** for frequency division
2. ✅ **Counter design** and bit width calculation
3. ✅ **Synchronous reset** using active-low signals
4. ✅ **Bit manipulation** (shift and rotate operations)
5. ✅ **FPGA workflow** (design, compile, program)
6. ✅ **Pin assignment** for real hardware
7. ✅ **Timing concepts** in digital design
8. ✅ **User input handling** (switches and buttons)
9. ✅ **Conditional logic** (speed/direction control)
10. ✅ **Pause/resume** using gated clock enable

---

## 📚 References

- 📘 **DE2-115 User Manual:** [Terasic Website](https://www.terasic.com.tw)
- 📗 **Cyclone IV Handbook:** Intel FPGA Documentation
- 📙 **Quartus Prime User Guide:** Intel FPGA Software Documentation
- 📕 **Verilog HDL:** IEEE 1364-2005 Standard

---

## 👨‍💻 Author & License

**Author:** Harshit Settipalli  
📧 **Email:** harshitsettipalli@gmail.com  
💼 **LinkedIn:** [linkedin.com/in/harshit-settipalli-073356267](https://www.linkedin.com/in/harshit-settipalli-073356267)

**Project:** LED Running Light with Clock Enable  
**Target:** Altera DE2-115 (Cyclone IV FPGA)  
**Purpose:** Educational demonstration  
**License:** Free to use for learning purposes

---

**Enjoy your blinking LEDs!** 🎉✨
