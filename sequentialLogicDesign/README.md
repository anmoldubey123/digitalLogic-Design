# Sequential Logic Design

## Overview

This project implements fundamental sequential logic circuits in Verilog for FPGA deployment. The designs demonstrate finite state machine (FSM) design principles, clock domain management, and practical applications including a flight attendant call system, rising edge detector, and time-multiplexed seven-segment display driver.

## Author

- Anmol Dubey

## Objectives

1. Design and implement Moore and Mealy finite state machines
2. Understand clock division for human-observable timing
3. Create practical sequential circuits with real-world applications
4. Implement time-multiplexed display systems

## System Components

```
┌────────────────────────────────────────────────────────────────────┐
│                    Sequential Logic Modules                        │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐    │
│  │  Flight Call    │  │  Rising Edge    │  │  Time-Mux       │    │
│  │  System         │  │  Detector       │  │  Display        │    │
│  │  (SR Latch)     │  │  (3-state FSM)  │  │  (4-state FSM)  │    │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘    │
│           │                   │                    │               │
│           └───────────────────┴────────────────────┘               │
│                               │                                    │
│                    ┌──────────┴──────────┐                         │
│                    │   Clock Dividers    │                         │
│                    │  clkdiv, clk_div_   │                         │
│                    │       disp          │                         │
│                    └─────────────────────┘                         │
│                               │                                    │
│                    ┌──────────┴──────────┐                         │
│                    │   hexto7segment     │                         │
│                    │   (Combinational)   │                         │
│                    └─────────────────────┘                         │
└────────────────────────────────────────────────────────────────────┘
```

## Module Descriptions

### flight_attendant_call_system.v

SR latch-based call system using behavioral FSM modeling.

```verilog
module flight_attendant_call_system(
    input wire clk,
    input wire call_button,
    input wire cancel_button,
    output reg light_state
);
```

**Functionality:**
- Press call button → Light turns ON
- Press cancel button → Light turns OFF
- Call has priority over cancel (both pressed → Light ON)
- Light maintains state when no buttons pressed

**State Transition Table:**

| call | cancel | current | next |
|------|--------|---------|------|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 1 |
| 1 | 1 | 1 | 1 |

**State Diagram:**

```
         call=1 (any cancel)
              ┌────┐
              │    │
              ▼    │
┌───────┐         ┌───────┐
│ OFF   │◄───────►│  ON   │
│ Q=0   │ call=1  │  Q=1  │
└───┬───┘         └───┬───┘
    │                 │
    │                 │ cancel=1, call=0
    │                 ▼
    └─────────────────┘
       cancel=1 OR
       (call=0, cancel=0)
```

---

### flight_attendant_call_system_dataflow.v

Simplified dataflow implementation of the call system.

```verilog
assign next_state = call_button || (~cancel_button && light_state);
```

**Boolean Expression:**
```
Q_next = CALL + (CANCEL' · Q)
```

This is equivalent to an SR latch with S=CALL, R=CANCEL.

---

### rising_edge_detector.v

Three-state FSM that detects rising edges on an input signal.

```verilog
module rising_edge_detector(
    input clk,
    input signal,
    input reset,
    output reg outedge
);
```

**State Diagram:**

```
                signal=1
         ┌────────────────────┐
         │                    ▼
    ┌─────────┐          ┌─────────┐
    │   S0    │ signal=1 │   S1    │
    │  IDLE   │─────────►│ EDGE    │
    │ out=0   │          │ out=1   │
    └────┬────┘          └────┬────┘
         │                    │
         │ signal=0           │ signal=1
         │                    ▼
         │               ┌─────────┐
         │               │   S2    │
         └───────────────│  HIGH   │
           signal=0      │ out=0   │
                         └────┬────┘
                              │
                              │ signal=0
                              ▼
                         (back to S0)
```

**State Encoding:**

| State | Code | Output | Description |
|-------|------|--------|-------------|
| S0 | 00 | 0 | Idle, waiting for rising edge |
| S1 | 01 | 1 | Edge detected, pulse output |
| S2 | 10 | 0 | Signal high, wait for fall |

**Timing:**
- Uses divided clock for debouncing
- Output pulse width = one slow_clk period

---

### clkdiv.v

16-bit clock divider for general-purpose slow clock generation.

```verilog
module clkdiv(
    input clk,
    input reset,
    output clk_out
);
```

**Division Calculation:**

For 100 MHz input:
```
Counter width: 16 bits
Output: bit 15 (MSB)
Division ratio: 2^16 = 65,536
Output frequency: 100 MHz / 65,536 ≈ 1.526 kHz
Period: ~655 μs
```

---

### clk_div_disp.v

25-bit clock divider for human-visible display refresh rates.

```verilog
module clk_div_disp(
    input clk,
    input reset,
    output slow_clk
);
```

**Division Calculation:**

For 100 MHz input:
```
Counter width: 25 bits
Output: bit 24 (MSB)
Division ratio: 2^25 = 33,554,432
Output frequency: 100 MHz / 33,554,432 ≈ 2.98 Hz
Period: ~336 ms
```

This creates a visible blinking rate for debugging or slow state transitions.

---

### hexto7segment.v

Hexadecimal (0-F) to seven-segment decoder.

```verilog
module hexto7segment(
    input [3:0] x,
    output reg [6:0] r
);
```

**Full Hexadecimal Encoding (Active Low):**

| Hex | x[3:0] | r[6:0] | Display |
|-----|--------|--------|---------|
| 0 | 0000 | 0000001 | 0 |
| 1 | 0001 | 1001111 | 1 |
| 2 | 0010 | 0010010 | 2 |
| 3 | 0011 | 0000110 | 3 |
| 4 | 0100 | 1001100 | 4 |
| 5 | 0101 | 0100100 | 5 |
| 6 | 0110 | 0100000 | 6 |
| 7 | 0111 | 0001111 | 7 |
| 8 | 1000 | 0000000 | 8 |
| 9 | 1001 | 0000100 | 9 |
| A | 1010 | 0001000 | A |
| b | 1011 | 1100000 | b |
| C | 1100 | 0110001 | C |
| d | 1101 | 1000010 | d |
| E | 1110 | 0110000 | E |
| F | 1111 | 0111000 | F |

---

### time_mux_state_machine.v

Four-state FSM for time-multiplexed 4-digit display.

```verilog
module time_mux_state_machine(
    input clk,
    input reset,
    input [6:0] in0, in1, in2, in3,
    output reg [3:0] an,
    output reg [6:0] sseg
);
```

**State Diagram:**

```
    ┌────────────────────────────────────┐
    │                                    │
    ▼                                    │
┌───────┐    ┌───────┐    ┌───────┐    ┌───────┐
│  S0   │───►│  S1   │───►│  S2   │───►│  S3   │
│ an=E  │    │ an=D  │    │ an=B  │    │ an=7  │
│sseg=  │    │sseg=  │    │sseg=  │    │sseg=  │
│ in0   │    │ in1   │    │ in2   │    │ in3   │
└───────┘    └───────┘    └───────┘    └───────┘
```

**Output Encoding:**

| State | an[3:0] | Active Digit | Segment Source |
|-------|---------|--------------|----------------|
| 00 | 1110 | Digit 0 (rightmost) | in0 |
| 01 | 1101 | Digit 1 | in1 |
| 10 | 1011 | Digit 2 | in2 |
| 11 | 0111 | Digit 3 (leftmost) | in3 |

---

### time_multiplexing_main.v

Top-level module integrating all display components.

```verilog
module time_multiplexing_main(
    input clk,
    input reset,
    input [15:0] sw,
    output [3:0] an,
    output [6:0] sseg
);
```

**System Architecture:**

```
sw[15:0]
    │
    ├── sw[3:0]  ──► hexto7segment ──► in0 ──┐
    ├── sw[7:4]  ──► hexto7segment ──► in1 ──┼──► time_mux_   ──► sseg[6:0]
    ├── sw[11:8] ──► hexto7segment ──► in2 ──┤    state_      ──► an[3:0]
    └── sw[15:12]──► hexto7segment ──► in3 ──┘    machine
                                                      ▲
clk ──► clk_div_disp ──► slow_clk ────────────────────┘
```

**Functionality:**
- 16 switches control 4 hexadecimal digits
- Each group of 4 switches sets one digit (0-F)
- Display rapidly cycles through all 4 digits
- Persistence of vision creates appearance of static display

## Testbenches

### tb_flight_attendant_call_system.v

Tests all button combinations and state transitions.

**Test Sequence:**
1. Initial state (both buttons released)
2. Call button press → Light ON
3. Cancel button press → Light OFF
4. Both buttons pressed → Light ON (call priority)
5. Release sequence verification

### tb_rising_edge_detector.v

Verifies edge detection with multiple signal transitions.

**Test Coverage:**
- Reset behavior
- First rising edge detection
- Sustained high signal (no repeated edges)
- Multiple rising edges with low periods between

### tb_muxsm.v

Comprehensive test of multiplexed display system.

**Test Coverage:**
- All 16 hex values on each digit position
- Reset functionality
- State machine cycling

## Timing Analysis

### Clock Domains

| Clock | Source | Frequency | Purpose |
|-------|--------|-----------|---------|
| clk | Board oscillator | 100 MHz | System clock |
| slow_clk (clkdiv) | Divided | ~1.5 kHz | Edge detector debounce |
| slow_clk (clk_div_disp) | Divided | ~3 Hz | Visible state changes |

### Display Refresh Rate

For flicker-free display:
```
Minimum refresh: 60 Hz per digit
4 digits: 240 Hz total scan rate
With clk_div_disp: 3 Hz (too slow for persistence)

For production: Use 16-18 bit divider
100 MHz / 2^17 ≈ 763 Hz → 190 Hz per digit ✓
```

## File Structure

```
sequentialLogicDesign/
├── README.md
├── flight_attendant_call_system.v       # SR latch FSM (behavioral)
├── flight_attendant_call_system_dataflow.v  # SR latch (dataflow)
├── rising_edge_detector.v               # Edge detection FSM
├── clkdiv.v                             # 16-bit clock divider
├── clk_div_disp.v                       # 25-bit clock divider
├── hexto7segment.v                      # Hex to 7-seg decoder
├── time_mux_state_machine.v             # Display multiplexer FSM
├── time_multiplexing_main.v             # Top-level display system
├── tb_flight_attendant_call_system.v    # Call system testbench
├── tb_rising_edge_detector.v            # Edge detector testbench
└── tb_muxsm.v                           # Display system testbench
```

## Design Patterns

### FSM Template (Moore Machine)

```verilog
// State register
reg [N-1:0] state, next_state;

// Combinational: Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = (condition) ? STATE_B : STATE_A;
        // ...
    endcase
end

// Combinational: Output logic
always @(*) begin
    case (state)
        STATE_A: output = VALUE_A;
        // ...
    endcase
end

// Sequential: State update
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= INITIAL_STATE;
    else
        state <= next_state;
end
```

### Clock Divider Template

```verilog
reg [N-1:0] counter;
assign divided_clk = counter[N-1];  // MSB as output

always @(posedge clk) begin
    if (reset)
        counter <= 0;
    else
        counter <= counter + 1;
end
```

## FPGA Implementation Notes

### Basys 3 Pin Assignments

```tcl
# Switches for display input
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
# ... sw[1] through sw[15]

# Seven-segment outputs
set_property PACKAGE_PIN W7 [get_ports {sseg[0]}]
# ... sseg[1] through sseg[6]

# Anodes
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]

# Buttons
set_property PACKAGE_PIN U18 [get_ports call_button]
set_property PACKAGE_PIN T18 [get_ports cancel_button]
set_property PACKAGE_PIN W19 [get_ports reset]

# Clock
set_property PACKAGE_PIN W5 [get_ports clk]
```

### Resource Utilization (Estimated)

| Module | LUTs | FFs |
|--------|------|-----|
| flight_attendant_call_system | 3 | 1 |
| rising_edge_detector | 8 | 18 |
| time_multiplexing_main | 35 | 30 |
| hexto7segment | 7 | 0 |
| clk_div_disp | 8 | 25 |

## Extensions

### Possible Enhancements

1. **Debounced buttons**: Add synchronizer and debounce FSM
2. **Adjustable clock divider**: Parameterized division ratio
3. **Decimal point control**: Add dp output to display driver
4. **Brightness control**: PWM on segment outputs
5. **Scrolling display**: Shift register for text scrolling
