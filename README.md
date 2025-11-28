# Digital Logic Design Laboratory Projects

## FPGA-Based Digital Systems
### Verilog HDL Implementation on Xilinx Artix-7

## Overview

This repository contains a comprehensive collection of digital logic design projects implemented in Verilog HDL for FPGA deployment. The coursework progresses from fundamental combinational circuits through sequential logic, finite state machines, and complete system integration including arithmetic units, timers, and control systems.

## Author

- **Anmol Dubey**

## Target Platform

| Specification | Details |
|---------------|---------|
| Development Board | Digilent Basys 3 |
| FPGA | Xilinx Artix-7 (XC7A35T-1CPG236C) |
| Logic Cells | 33,280 |
| Block RAM | 1,800 Kb |
| DSP Slices | 90 |
| Clock | 100 MHz oscillator |
| I/O | 16 switches, 16 LEDs, 4-digit 7-segment display, 5 buttons |

## Project Summary

| Project | Directory | Key Concepts |
|---------|-----------|--------------|
| Programming Logic Basics | `programmingLogicBasys3FPGABoard` | Gates, decoders, 7-segment display, modeling styles |
| Sprinkler Controller & Data Bus | `sprinklerValveController&DataBus` | Multiplexers, decoders, control systems |
| Sequential Logic Design | `sequentialLogicDesign` | FSMs, clock division, edge detection, display multiplexing |
| Calculator Arithmetic Units | `calculatorDesign` | Ripple carry adder, carry lookahead adder, registered outputs |
| Stopwatch/Timer System | `customProcessorDesign` | Multi-mode timer, FSM controller, integrated display |

## Skills Progression

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        Digital Logic Design Curriculum                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Level 1: Combinational Logic Fundamentals                                  │
│  ├── Basic gates (AND, OR, NOT)                                             │
│  ├── 3-to-8 decoders                                                        │
│  ├── 4-to-1 multiplexers                                                    │
│  ├── BCD to 7-segment decoders                                              │
│  └── Three modeling styles (structural, dataflow, behavioral)               │
│                                                                             │
│  Level 2: Arithmetic Circuits                                               │
│  ├── Full adder design                                                      │
│  ├── Ripple carry adder (4-bit)                                             │
│  ├── Carry lookahead adder (4-bit)                                          │
│  └── Registered outputs for synchronous operation                           │
│                                                                             │
│  Level 3: Sequential Logic                                                  │
│  ├── SR latch (flight attendant call system)                                │
│  ├── Edge detection FSM                                                     │
│  ├── Clock dividers (16-bit, 25-bit)                                        │
│  └── Time-multiplexed display drivers                                       │
│                                                                             │
│  Level 4: Complex FSM Design                                                │
│  ├── Multi-state controllers (6+ states)                                    │
│  ├── Mode-selectable operation                                              │
│  ├── Bidirectional counters                                                 │
│  └── Complete system integration                                            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Project Details

### 1. Programming Logic - Basys 3 FPGA Board

**Directory:** `programmingLogicBasys3FPGABoard/`

Fundamental combinational logic circuits demonstrating three Verilog modeling styles.

**Modules:**
- `myAND.v` - Basic 2-input AND gate
- `decoder.v` - 3-to-8 decoder with enable (structural/dataflow/behavioral)
- `display.v` - BCD to 7-segment decoder with invalid input detection

**Key Concepts:**
- Gate-level primitives
- Continuous assignments
- Procedural blocks
- Seven-segment display interfacing

---

### 2. Sprinkler Valve Controller & Data Bus

**Directory:** `sprinklerValveController&DataBus/`

Building blocks for embedded control systems including address decoding and data multiplexing.

**Modules:**
- `decoder.v` - 3-to-8 decoder for valve selection
- `mux.v` - 4-to-1 multiplexer for sensor data routing

**Applications:**
- Irrigation zone control
- Sensor data acquisition
- Address decoding for memory-mapped I/O

---

### 3. Sequential Logic Design

**Directory:** `sequentialLogicDesign/`

Finite state machines and sequential circuits for real-world applications.

**Modules:**
- `flight_attendant_call_system.v` - SR latch FSM (behavioral)
- `flight_attendant_call_system_dataflow.v` - SR latch (dataflow)
- `rising_edge_detector.v` - 3-state edge detection FSM
- `clkdiv.v` - 16-bit clock divider (~1.5 kHz output)
- `clk_div_disp.v` - 25-bit clock divider (~3 Hz output)
- `hexto7segment.v` - Full hexadecimal decoder (0-F)
- `time_mux_state_machine.v` - 4-digit display multiplexer
- `time_multiplexing_main.v` - Complete display system

**Key Concepts:**
- Moore FSM design
- Clock domain crossing
- Persistence of vision displays
- Debouncing techniques

---

### 4. Calculator Design - Arithmetic Units

**Directory:** `calculatorDesign/`

Digital arithmetic circuits comparing propagation delay vs. complexity trade-offs.

**Modules:**
- `full_adder.v` - 1-bit full adder primitive
- `register_logic.v` - 5-bit synchronous register
- `RCA_4bits.v` - 4-bit Ripple Carry Adder
- `CLA_4bits.v` - 4-bit Carry Lookahead Adder

**Performance Comparison:**

| Architecture | Gate Count | Critical Path | Scalability |
|--------------|------------|---------------|-------------|
| Ripple Carry | ~20 | O(n) | Linear delay growth |
| Carry Lookahead | ~40 | O(log n) | Logarithmic delay |

---

### 5. Custom Processor Design - Stopwatch/Timer

**Directory:** `customProcessorDesign/`

Complete integrated system with FSM controller, multi-mode counter, and display output.

**Modules:**
- `controller.v` - 6-state start/stop/reset FSM
- `stopwatchTimer.v` - 4-mode BCD counter (up/down, load options)
- `numToSeg_4b.v` - BCD to 7-segment decoder
- `displayFourDigits.v` - Multiplexed display driver
- `msClk.v` - Millisecond timing base
- `displayClk.v` - Display refresh clock
- `stopwatchTimerMain.v` - Top-level integration

**Operating Modes:**

| Mode | Function | Initial Value | Direction |
|------|----------|---------------|-----------|
| 0 | Stopwatch | 00.00 | Count Up |
| 1 | Stopwatch + Load | User defined | Count Up |
| 2 | Timer | 99.99 | Count Down |
| 3 | Timer + Load | User defined | Count Down |

## Verilog Modeling Styles

### Comparison

| Style | Abstraction | Use Case | Example |
|-------|-------------|----------|---------|
| **Structural** | Gate-level | Critical paths, teaching | `and gate1(out, a, b);` |
| **Dataflow** | RTL | Combinational logic | `assign out = a & b;` |
| **Behavioral** | Algorithmic | Complex logic, FSMs | `always @(*) out = a & b;` |

### When to Use Each

```
Structural:
├── Timing-critical designs
├── Gate-accurate simulation
└── Library cell instantiation

Dataflow:
├── Boolean expressions
├── Continuous assignments
└── Combinational networks

Behavioral:
├── State machines
├── Complex control logic
└── Rapid prototyping
```

## Common Design Patterns

### FSM Template (Moore Machine)

```verilog
module fsm_template (
    input clk, reset,
    input [N-1:0] inputs,
    output reg [M-1:0] outputs
);
    // State encoding
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
    reg [1:0] state, next_state;
    
    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S0: next_state = (condition) ? S1 : S0;
            S1: next_state = (condition) ? S2 : S0;
            S2: next_state = S0;
            default: next_state = S0;
        endcase
    end
    
    // Output logic (combinational)
    always @(*) begin
        case (state)
            S0: outputs = VALUE_0;
            S1: outputs = VALUE_1;
            S2: outputs = VALUE_2;
            default: outputs = 0;
        endcase
    end
    
    // State register (sequential)
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end
endmodule
```

### Clock Divider Template

```verilog
module clock_divider #(
    parameter WIDTH = 16
)(
    input clk, reset,
    output divided_clk
);
    reg [WIDTH-1:0] counter;
    assign divided_clk = counter[WIDTH-1];
    
    always @(posedge clk) begin
        if (reset)
            counter <= 0;
        else
            counter <= counter + 1;
    end
endmodule
```

### Seven-Segment Decoder Template

```verilog
module hex_to_7seg (
    input [3:0] hex,
    output reg [6:0] seg  // Active low: {a,b,c,d,e,f,g}
);
    always @(*) begin
        case (hex)
            4'h0: seg = 7'b0000001;
            4'h1: seg = 7'b1001111;
            // ... remaining digits
            default: seg = 7'b1111111;
        endcase
    end
endmodule
```

## Repository Structure

```
digitalLogicDesign/
├── README.md                                    # This file
│
├── programmingLogicBasys3FPGABoard/            # Project 1
│   ├── README.md
│   ├── myAND.v
│   ├── decoder.v
│   ├── display.v
│   ├── tb_myAND.v
│   ├── tb_decoder.v
│   └── tb_display.v
│
├── sprinklerValveController&DataBus/           # Project 2
│   ├── README.md
│   ├── decoder.v
│   ├── mux.v
│   ├── tb_decoder.v
│   └── tb_mux.v
│
├── sequentialLogicDesign/                      # Project 3
│   ├── README.md
│   ├── flight_attendant_call_system.v
│   ├── flight_attendant_call_system_dataflow.v
│   ├── rising_edge_detector.v
│   ├── clkdiv.v
│   ├── clk_div_disp.v
│   ├── hexto7segment.v
│   ├── time_mux_state_machine.v
│   ├── time_multiplexing_main.v
│   ├── tb_flight_attendant_call_system.v
│   ├── tb_rising_edge_detector.v
│   └── tb_muxsm.v
│
├── calculatorDesign/                           # Project 4
│   ├── README.md
│   ├── full_adder.v
│   ├── register_logic.v
│   ├── RCA_4bits.v
│   └── CLA_4bits.v
│
└── customProcessorDesign/                      # Project 5
    ├── README.md
    ├── controller.v
    ├── stopwatchTimer.v
    ├── numToSeg_4b.v
    ├── displayFourDigits.v
    ├── msClk.v
    ├── displayClk.v
    ├── stopwatchTimerMain.v
    ├── tb_controller.v
    ├── tb_stopwatchTimer.v
    └── tb_stopwatchTimerMain.v
```

## Development Environment

### Required Software

| Tool | Purpose | Version |
|------|---------|---------|
| Vivado Design Suite | Synthesis, implementation, programming | 2020.2+ |
| Vivado Simulator | Behavioral simulation | Included |
| Digilent Adept | Board programming (alternative) | 2.x |

### Project Setup

1. **Create new Vivado project**
   ```
   File → New Project → RTL Project
   ```

2. **Add source files**
   ```
   Add Sources → Add or create design sources
   Select .v files from project directory
   ```

3. **Add constraint file**
   ```
   Add Sources → Add or create constraints
   Create/import .xdc file with pin mappings
   ```

4. **Run synthesis and implementation**
   ```
   Flow Navigator → Run Synthesis
   Flow Navigator → Run Implementation
   Flow Navigator → Generate Bitstream
   ```

5. **Program FPGA**
   ```
   Open Hardware Manager → Auto Connect
   Program Device → Select bitstream
   ```

## Basys 3 Pin Reference

### Common Pin Assignments

```tcl
# Clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

# Switches (directly active)
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
# ... sw[2] through sw[15]

# LEDs (directly active)
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
# ... led[2] through led[15]

# Seven-segment display (active low)
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]   # CA
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]   # CB
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]   # CC
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]   # CD
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]   # CE
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]   # CF
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]   # CG
set_property PACKAGE_PIN V7 [get_ports dp]         # DP

# Anodes (active low)
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]

# Buttons (directly active)
set_property PACKAGE_PIN U18 [get_ports btnC]
set_property PACKAGE_PIN T18 [get_ports btnU]
set_property PACKAGE_PIN W19 [get_ports btnL]
set_property PACKAGE_PIN T17 [get_ports btnR]
set_property PACKAGE_PIN U17 [get_ports btnD]

# All I/O standard
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]]
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]]
```

## Learning Outcomes

Upon completing these projects, students will be able to:

1. **Design combinational circuits** using Boolean algebra and K-maps
2. **Implement circuits in Verilog** using structural, dataflow, and behavioral styles
3. **Design finite state machines** with proper state encoding and transition logic
4. **Understand timing constraints** including clock domains and propagation delay
5. **Interface with FPGA peripherals** including switches, LEDs, and displays
6. **Compare arithmetic architectures** and their performance trade-offs
7. **Create testbenches** for design verification
8. **Use industry-standard tools** for synthesis and implementation

## References

- [Basys 3 Reference Manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual)
- [Xilinx Vivado Design Suite User Guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug910-vivado-getting-started.pdf)
- [Verilog HDL Quick Reference Guide](https://www.verilog.com/VerilogBNF.html)
- Digital Design: Principles and Practices (Wakerly)
- Digital Design and Computer Architecture (Harris & Harris)
