# LPC1114 ARM Cortex-M0 Assembly: Keypad, LCD & Servo Controller

A bare-metal ARM Cortex-M0 assembly implementation on the NXP LPC1114 microcontroller. The system interfaces a 4x4 matrix keypad and an HD44780 LCD to allow users to input, store, and recall target angles, driving a hobby servo motor to the selected position via software/timer PWM.

---

## System Overview

* **Microcontroller:** NXP LPC1114FN28 (ARM Cortex-M0)
* **Language:** ARM Assembly (Thumb-2 instruction set)
* **Toolchain / IDE:** Keil µVision
* **Peripherals Interfaced:**
  * 4x4 Matrix Keypad (Row/Column scanning)
  * HD44780 16x2 Character LCD (4-bit / 8-bit mode)
  * Standard 50 Hz Analog Servo Motor

---

## Hardware Architecture & Pinout

| Peripheral | LPC1114 Pin | Function / Description |
| :--- | :--- | :--- |
| **Servo PWM** | PIO1_6 | PWM control signal (1.0 ms – 2.0 ms pulse) |
| **LCD RS** | PIO0_7 | Register Select (0 = Command, 1 = Data) |
| **LCD EN** | PIO1_8 | Enable strobe pulse |
| **LCD Data** | PIO0_1 – PIO0_4 | Data / Command bus bits |
| **Keypad Rows** | PIO1_0 – PIO1_2, PIO1_4 | Driven low sequentially during scan |
| **Keypad Cols** | PIO0_1 – PIO0_4 | Inputs with internal/external pull-ups |

---

## Software Architecture & Control Flow

1. **Initialization:**
   * Configure `SYSAHBCLKCTRL` to enable clocks for GPIO and IO configuration blocks.
   * Configure `IOCON` registers for digital GPIO functionality.
   * Set GPIO direction registers (`GPIOnDIR`) for outputs (LCD control/data, servo signal, keypad rows) and inputs (keypad columns).
   * Execute HD44780 LCD power-on initialization sequence.

2. **Main State Loop:**
   * **Keypad Polling:** Actively drive row pins low and read column pins; identify key press coordinates and convert to numeric degree values.
   * **Angle Storage & Recall:** Store valid angle values (0°–180°) in RAM buffers for quick recall.
   * **LCD Updates:** Transmit formatted ASCII characters to display current and requested angles.
   * **PWM Pulse Generation:** Translate target degree value into a proportional high pulse width (typically ~1.0 ms for 0° up to ~2.0 ms for 180°)

---

## Known Constraints & Optimization Opportunities

*Note: This project was developed as a midterm coursework project with strict deadlines. The initial release represents functional, working firmware with several identified areas for optimization:*

* **Timing Routines:** Current delay implementations rely on busy-wait software decrement loops. Future revisions will migrate to 16-bit/32-bit hardware match timers or the ARM SysTick timer to free CPU cycles.
* **Low-Register Allocation:** Several subroutines use stack pushes (`PUSH`/`POP`) where dedicated Cortex-M0 low registers (`R0`–`R7`) could be pinned to reduce cycle counts.
* **Non-Blocking Architecture:** Future updates will transition keypad debouncing and input capture into an interrupt-driven state machine (`GPIOnIE`), allowing the MCU to enter low-power sleep modes (`WFI`) between events.
