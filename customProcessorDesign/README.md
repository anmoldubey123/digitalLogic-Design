# Custom Processor Design - Stopwatch/Timer System

## Overview

This project implements a configurable stopwatch and countdown timer system in Verilog for FPGA deployment. The design features a finite state machine controller, multi-mode timing logic, and multiplexed 4-digit seven-segment display output. The system supports four operational modes including basic stopwatch, countdown timer, and externally-loaded variants of each.

## Author

- Anmol Dubey

## Objectives

1. Design a Moore FSM controller for start/stop/reset functionality
2. Implement multi-mode timing logic with configurable counting direction
3. Create a multiplexed seven-segment display driver
4. Integrate clock division for millisecond timing and display refresh

## System Architecture

```
                    ┌─────────────────────────────────────────────────────────┐
                    │              stopwatchTimerMain (Top Module)            │
                    │                                                         │
   startStopButton ─┼──┐    ┌──────────┐                                      │
                    │  └───►│          │                                      │
      resetButton ──┼──────►│controller│──► reset ──┐                         │
                    │  ┌───►│          │──► cnt ────┼──┐                      │
                    │  │    └──────────┘            │  │                      │
                    │  │                            │  │                      │
            clk ────┼──┼────────────────────────────┼──┼──────────┐           │
                    │  │    ┌──────────┐            │  │          │           │
                    │  └────┤  msClk   │◄───────────┘  │          │           │
                    │       │  Divider │               │          │           │
                    │       └──────────┘               │          │           │
                    │                                  │          │           │
                    │       ┌──────────────────────────┼──────────┼───┐       │
           mode ────┼──────►│                          ▼          ▼   │       │
       dig3_load ───┼──────►│     stopwatchTimer                      │       │
       dig2_load ───┼──────►│                                         │       │
                    │       │     dig3  dig2  dig1  dig0              │       │
                    │       └───────┼─────┼─────┼─────┼────────────────┘       │
                    │               │     │     │     │                        │
                    │               ▼     ▼     ▼     ▼                        │
                    │       ┌─────────────────────────────────┐                │
                    │       │      numToSeg_4b (×4)           │                │
                    │       │   BCD to 7-segment converters   │                │
                    │       └───────┬─────┬─────┬─────┬───────┘                │
                    │               │     │     │     │                        │
                    │               ▼     ▼     ▼     ▼                        │
                    │       ┌─────────────────────────────────┐                │
                    │       │     displayFourDigits           │◄── displayClk  │
                    │       │   Multiplexed display driver    │                │
                    │       └───────┬─────────────┬───────────┘                │
                    │               │             │                            │
                    └───────────────┼─────────────┼────────────────────────────┘
                                    ▼             ▼
                               out_seg[6:0]    an[3:0], dp
                              (segments)      (anodes)
```

## Module Descriptions

### controller.v

Finite state machine for user input handling with debounce-style state transitions.

```verilog
module controller(
    input startStopButton, resetButton, clk,
    output reg reset, cnt
);
```

**State Diagram:**

```
                    resetButton
                         │
                         ▼
                   ┌───────────┐
            ┌─────►│ S0: init  │◄────────────────────┐
            │      │ reset=1   │                     │
            │      │ cnt=0     │                     │
            │      └─────┬─────┘                     │
            │            │ startStopButton           │
            │            ▼                           │
            │      ┌───────────────┐                 │
            │      │S1: waitRelease│                 │
            │      │ reset=0       │                 │
            │      │ cnt=0         │                 │
            │      └─────┬─────────┘                 │
            │            │ !startStopButton          │
            │            ▼                           │
       resetButton ┌───────────┐                     │
            │      │ S2: count │◄────────────┐       │
            │      │ reset=0   │             │       │
            │      │ cnt=1     │             │       │
            │      └─────┬─────┘             │       │
            │            │ startStopButton   │       │
            │            ▼                   │       │
            │      ┌───────────┐             │       │
            │      │ S3: pause │             │       │
            │      │ reset=0   │             │       │
            │      │ cnt=0     │             │       │
            │      └─────┬─────┘             │       │
            │            │ !startStopButton  │       │
            │            ▼                   │       │
            │      ┌─────────────────┐       │       │
            │      │S4: pauseWaitPress│      │       │
            │      │ reset=0         │       │       │
            │      │ cnt=0           │       │       │
            │      └─────┬───────────┘       │       │
            │            │ startStopButton   │       │
            │            ▼                   │       │
            │      ┌──────────────────┐      │       │
            │      │S5: pauseWaitRel  │      │       │
            │      │ reset=0          │──────┘       │
            │      │ cnt=0            │              │
            │      └──────────────────┘              │
            │            │ !startStopButton          │
            └────────────┴───────────────────────────┘
```

**State Encoding:**

| State | Code | Description | reset | cnt |
|-------|------|-------------|-------|-----|
| S0 | 000 | Initial/Reset | 1 | 0 |
| S1 | 001 | Wait for button release | 0 | 0 |
| S2 | 010 | Counting active | 0 | 1 |
| S3 | 011 | Paused (button held) | 0 | 0 |
| S4 | 100 | Paused, wait for press | 0 | 0 |
| S5 | 101 | Paused, wait for release | 0 | 0 |

---

### stopwatchTimer.v

Multi-mode BCD counter with configurable direction and initial values.

```verilog
module stopwatchTimer(
    input clk, reset, cnt,
    input [1:0] mode,
    input [3:0] dig3_load, dig2_load,
    output reg [3:0] dig3, dig2, dig1, dig0
);
```

**Operating Modes:**

| Mode | Value | Function | Initial Value | Direction |
|------|-------|----------|---------------|-----------|
| 0 | 2'b00 | Stopwatch | 00.00 | Count Up |
| 1 | 2'b01 | Stopwatch + Load | {dig3,dig2}.00 | Count Up |
| 2 | 2'b10 | Timer | 99.99 | Count Down |
| 3 | 2'b11 | Timer + Load | {dig3,dig2}.00 | Count Down |

**Counter Logic:**

```
Display Format: [dig3][dig2].[dig1][dig0]
                 ─────────    ─────────
                  Seconds    Centiseconds

Cascade: dig0 → dig1 → dig2 → dig3

Stopwatch: 0→1→2→...→9→0 (rollover, increment next)
Timer:     9→8→7→...→0→9 (rollover, decrement next)
```

**Terminal Conditions:**

| Mode | Terminal Count | Rollover Value | Increment |
|------|----------------|----------------|-----------|
| Stopwatch | 9 | 0 | +1 |
| Timer | 0 | 9 | -1 |

---

### numToSeg_4b.v

BCD to seven-segment decoder.

```verilog
module numToSeg_4b(
    input [3:0] num,
    output reg [6:0] sseg
);
```

**Segment Mapping (Active Low):**

```
    ─a─
   │   │
   f   b
   │   │
    ─g─
   │   │
   e   c
   │   │
    ─d─

sseg[6:0] = {a, b, c, d, e, f, g}
```

**Encoding Table:**

| Digit | sseg[6:0] | Display |
|-------|-----------|---------|
| 0 | 0000001 | All except g |
| 1 | 1001111 | b, c only |
| 2 | 0010010 | a, b, g, e, d |
| 3 | 0000110 | a, b, g, c, d |
| 4 | 1001100 | f, g, b, c |
| 5 | 0100100 | a, f, g, c, d |
| 6 | 0100000 | a, f, e, d, c, g |
| 7 | 0001111 | a, b, c |
| 8 | 0000000 | All segments |
| 9 | 0000100 | a, b, c, d, f, g |

---

### displayFourDigits.v

Multiplexed 4-digit display driver with decimal point control.

```verilog
module displayFourDigits(
    input clk,
    input [27:0] in_seg,
    output reg [6:0] out_seg,
    output reg dp,
    output reg [3:0] an
);
```

**Multiplexing Sequence:**

| Index | Active Anode | Segment Source | Decimal Point |
|-------|--------------|----------------|---------------|
| 0 | an = 1110 | in_seg[6:0] | Off |
| 1 | an = 1101 | in_seg[13:7] | Off |
| 2 | an = 1011 | in_seg[20:14] | On (dp=0) |
| 3 | an = 0111 | in_seg[27:21] | Off |

**Timing:**
- Display refresh rate = displayClk frequency / 4
- Each digit illuminated for 25% duty cycle

---

### msClk.v

Clock divider for millisecond timing base.

```verilog
module msClk(
    input clk,
    output msClk
);
```

**Division Calculation:**

For 100 MHz input clock:
```
Counter width: 20 bits
Output: bit 19 (MSB)
Division ratio: 2^20 = 1,048,576
Output frequency: 100 MHz / 1,048,576 ≈ 95.4 Hz
Period: ~10.5 ms per half-cycle
```

---

### displayClk.v

Clock divider for display multiplexing.

```verilog
module displayClk(
    input clk,
    output displayClk
);
```

**Division Calculation:**

For 100 MHz input clock:
```
Counter width: 14 bits
Output: bit 13 (MSB)
Division ratio: 2^14 = 16,384
Output frequency: 100 MHz / 16,384 ≈ 6.1 kHz
Refresh rate per digit: ~1.5 kHz (no visible flicker)
```

---

### stopwatchTimerMain.v

Top-level module integrating all components.

```verilog
module stopwatchTimerMain(
    input startStopButton, resetButton, clk,
    input [1:0] mode,
    input [3:0] dig3_load, dig2_load,
    output [6:0] out_seg,
    output [3:0] an,
    output dp
);
```

## Interface Specification

### Inputs

| Signal | Width | Description |
|--------|-------|-------------|
| clk | 1 | System clock (typically 100 MHz) |
| startStopButton | 1 | Start/pause toggle (active high) |
| resetButton | 1 | Asynchronous reset (active high) |
| mode | 2 | Operating mode selection |
| dig3_load | 4 | BCD value for seconds tens digit |
| dig2_load | 4 | BCD value for seconds ones digit |

### Outputs

| Signal | Width | Description |
|--------|-------|-------------|
| out_seg | 7 | Seven-segment cathodes (active low) |
| an | 4 | Digit anodes (active low) |
| dp | 1 | Decimal point (active low) |

## Timing Specifications

| Clock Domain | Frequency | Purpose |
|--------------|-----------|---------|
| clk | 100 MHz | System clock |
| msClk | ~95 Hz | Counter increment |
| displayClk | ~6.1 kHz | Display multiplexing |

**Timing Accuracy:**

```
Target: 10 ms per count (centiseconds)
Actual: ~10.5 ms per count
Error: ~5% (acceptable for visual display)

For precise timing, use exact divider:
100 MHz / 10 ms = 1,000,000 counts
→ Use 20-bit counter with compare value
```

## Testbenches

### tb_controller.v

Tests FSM state transitions through complete button press sequences.

**Test Sequence:**
1. Reset → S0
2. Press start → S1 → Release → S2 (counting)
3. Press stop → S3 → Release → S4 (paused)
4. Press start → S5 → Release → S2 (resume)
5. Reset during count → S0

### tb_stopwatchTimer.v

Verifies all four operating modes.

**Test Coverage:**
- Mode 0: Stopwatch from 00.00
- Mode 1: Stopwatch from loaded value
- Mode 2: Timer from 99.99
- Mode 3: Timer from loaded value

### tb_stopwatchTimerMain.v

Integration test of complete system.

## File Structure

```
customProcessorDesign/
├── README.md
├── controller.v              # FSM controller
├── stopwatchTimer.v          # Multi-mode counter
├── numToSeg_4b.v            # BCD to 7-segment decoder
├── displayFourDigits.v       # Multiplexed display driver
├── msClk.v                   # Millisecond clock divider
├── displayClk.v              # Display refresh clock divider
├── stopwatchTimerMain.v      # Top-level integration
├── tb_controller.v           # Controller testbench
├── tb_stopwatchTimer.v       # Timer testbench
└── tb_stopwatchTimerMain.v   # System testbench
```

## FPGA Implementation

### Target Platform

- Xilinx Basys 3 or similar with 4-digit seven-segment display
- 100 MHz oscillator

### Pin Constraints (Example for Basys 3)

```tcl
# Clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Buttons
set_property PACKAGE_PIN U18 [get_ports startStopButton]
set_property PACKAGE_PIN T18 [get_ports resetButton]

# Seven-segment display
set_property PACKAGE_PIN W7 [get_ports {out_seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {out_seg[1]}]
# ... additional segment pins

# Anodes
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]

# Decimal point
set_property PACKAGE_PIN V7 [get_ports dp]

# Mode switches
set_property PACKAGE_PIN V17 [get_ports {mode[0]}]
set_property PACKAGE_PIN V16 [get_ports {mode[1]}]
```

### Resource Utilization (Estimated)

| Resource | Usage |
|----------|-------|
| LUTs | ~80 |
| Flip-Flops | ~50 |
| Clock Buffers | 1 |

## Usage Instructions

1. **Reset**: Press resetButton to initialize
2. **Select Mode**: Set mode switches before reset
3. **Load Values**: Set dig3_load and dig2_load switches (modes 1, 3)
4. **Start**: Press startStopButton to begin counting
5. **Pause**: Press startStopButton again to pause
6. **Resume**: Press startStopButton to continue
7. **Reset**: Press resetButton at any time to reinitialize

## Extensions

### Possible Enhancements

1. **Lap time**: Store intermediate values
2. **Alarm**: Sound output when timer reaches zero
3. **Split display**: Show elapsed and remaining simultaneously
4. **Precise timing**: Use exact clock division for accuracy
5. **Button debounce**: Hardware debounce circuit for inputs
