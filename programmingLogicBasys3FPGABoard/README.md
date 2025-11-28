# Programming Logic - Basys 3 FPGA Board

## Overview

This project contains fundamental digital logic building blocks implemented in Verilog for the Digilent Basys 3 FPGA development board. The designs demonstrate three Verilog modeling styles—structural, dataflow, and behavioral—while implementing essential combinational logic circuits including basic gates, decoders, and seven-segment display drivers.

## Author

- Anmol Dubey

## Objectives

1. Understand and apply structural, dataflow, and behavioral Verilog modeling
2. Implement fundamental combinational logic circuits
3. Interface with Basys 3 board peripherals (switches, LEDs, seven-segment display)
4. Develop testbench methodology for design verification

## Target Hardware

| Specification | Details |
|---------------|---------|
| Board | Digilent Basys 3 |
| FPGA | Xilinx Artix-7 (XC7A35T-1CPG236C) |
| Clock | 100 MHz oscillator |
| Switches | 16 slide switches |
| LEDs | 16 user LEDs |
| Display | 4-digit seven-segment (common anode) |

## Module Descriptions

### myAND.v

Basic 2-input AND gate using structural modeling.

```verilog
module myAND(
    input a, b,
    output out
);
```

**Implementation:**
```verilog
and a0 (out, a, b);
```

**Truth Table:**

| a | b | out |
|---|---|-----|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

---

### decoder.v

3-to-8 decoder with enable input, implemented in three modeling styles.

```verilog
module decoder(
    input e, a, b, c,
    output d0, d1, d2, d3, d4, d5, d6, d7
);
```

**Function:**
- When `e = 0`: All outputs are 0
- When `e = 1`: Exactly one output is high based on `{a, b, c}`

**Truth Table (e = 1):**

| a | b | c | Active Output |
|---|---|---|---------------|
| 0 | 0 | 0 | d0 |
| 0 | 0 | 1 | d1 |
| 0 | 1 | 0 | d2 |
| 0 | 1 | 1 | d3 |
| 1 | 0 | 0 | d4 |
| 1 | 0 | 1 | d5 |
| 1 | 1 | 0 | d6 |
| 1 | 1 | 1 | d7 |

**Three Implementation Styles:**

#### Structural (Active)
```verilog
wire nota, notb, notc;
not int1(nota, a);
not int2(notb, b);
not int3(notc, c);
and out0 (d0, e, nota, notb, notc);
// ... additional AND gates
```

#### Dataflow (Commented)
```verilog
assign d0 = e & ~a & ~b & ~c;
assign d1 = e & ~a & ~b &  c;
// ... additional assignments
```

#### Behavioral (Commented)
```verilog
always @(*) begin
    if(e == 1) begin
        case({a, b, c})
            3'b000: d0 = 1;
            // ... additional cases
        endcase
    end
end
```

---

### display.v

BCD to seven-segment decoder for single digit display (0-9) with invalid input detection.

```verilog
module display(
    input w, x, y, z,
    output a, b, c, d, e, f, g,
    output an0, an1, an2, an3
);
```

**Segment Layout:**
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
```

**BCD Encoding:**
- Inputs `{w, x, y, z}` represent BCD digit (0-9)
- Values 10-15 are invalid and display all segments ON

**Digit Patterns (Active Low segments on Basys 3):**

| Digit | wxyz | a | b | c | d | e | f | g |
|-------|------|---|---|---|---|---|---|---|
| 0 | 0000 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| 1 | 0001 | 1 | 0 | 0 | 1 | 1 | 1 | 1 |
| 2 | 0010 | 0 | 0 | 1 | 0 | 0 | 1 | 0 |
| 3 | 0011 | 0 | 0 | 0 | 0 | 1 | 1 | 0 |
| 4 | 0100 | 1 | 0 | 0 | 1 | 1 | 0 | 0 |
| 5 | 0101 | 0 | 1 | 0 | 0 | 1 | 0 | 0 |
| 6 | 0110 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 7 | 0111 | 0 | 0 | 0 | 1 | 1 | 1 | 1 |
| 8 | 1000 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 9 | 1001 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| Invalid | 1010-1111 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

**Anode Control:**
```verilog
assign an3 = 1;  // Digit 3 OFF
assign an2 = 1;  // Digit 2 OFF
assign an1 = 1;  // Digit 1 OFF
assign an0 = 0;  // Digit 0 ON (rightmost)
```

**Invalid Input Detection:**
```verilog
// Invalid when w=1 AND (x=1 OR y=1) → values 10-15
and invalidInput1(invalid1, w, x);
and invalidInput2(invalid2, w, y);
or invalidOutput(invalid, invalid1, invalid2);
```

**Segment Logic (Example for segment 'a'):**
```
a = (w·x) + (w·y) + (x·y'·z') + (w'·x'·y'·z) + invalid

Minterms where a=0 (segment ON): 0, 2, 3, 5, 6, 7, 8, 9
Minterms where a=1 (segment OFF): 1, 4
```

## Testbenches

### tb_myAND.v

Exhaustive test of 2-input AND gate.

```verilog
initial begin
    a = 0; b = 0; #50;
    a = 0; b = 1; #50;
    a = 1; b = 0; #50;
    a = 1; b = 1; #50;
end
```

### tb_decoder.v

Tests all 16 input combinations (e=0/1, abc=000-111).

**Test Coverage:**
- Enable disabled (e=0): Verify all outputs low
- Enable active (e=1): Verify one-hot output encoding

**Optional Checker Logic:**
```verilog
wire [7:0] data_all = {d0,d1,d2,d3,d4,d5,d6,d7};
if(data_all === 8'b1000_0000) test_pass = 1;
else test_error = 1;
```

### tb_display.v

Tests all 16 BCD input combinations (0-15).

```verilog
initial begin
    {w,x,y,z} = 4'b0000; #10;  // Display 0
    {w,x,y,z} = 4'b0001; #10;  // Display 1
    // ... through 4'b1111
end
```

## Verilog Modeling Styles Comparison

| Style | Description | Use Case |
|-------|-------------|----------|
| **Structural** | Gate-level primitives, explicit interconnections | Low-level control, gate-accurate simulation |
| **Dataflow** | Continuous assignments with operators | Combinational logic, clear boolean expressions |
| **Behavioral** | Procedural blocks (always, initial) | Complex logic, state machines, sequential circuits |

### Example: 2-input AND

**Structural:**
```verilog
and gate1(out, a, b);
```

**Dataflow:**
```verilog
assign out = a & b;
```

**Behavioral:**
```verilog
always @(*) out = a & b;
```

## File Structure

```
programmingLogicBasys3FPGABoard/
├── README.md
├── myAND.v              # Basic AND gate
├── decoder.v            # 3-to-8 decoder (3 styles)
├── display.v            # BCD to 7-segment decoder
├── tb_myAND.v           # AND gate testbench
├── tb_decoder.v         # Decoder testbench
└── tb_display.v         # Display testbench
```

## Pin Constraints (Basys 3)

### Switches (Directly mapped to BCD input on display)

```tcl
set_property PACKAGE_PIN V17 [get_ports z]
set_property PACKAGE_PIN V16 [get_ports y]
set_property PACKAGE_PIN W16 [get_ports x]
set_property PACKAGE_PIN W17 [get_ports w]
set_property IOSTANDARD LVCMOS33 [get_ports {w x y z}]
```

### Seven-Segment Display

```tcl
# Segments (directly active low on Basys 3)
set_property PACKAGE_PIN W7 [get_ports a]
set_property PACKAGE_PIN W6 [get_ports b]
set_property PACKAGE_PIN U8 [get_ports c]
set_property PACKAGE_PIN V8 [get_ports d]
set_property PACKAGE_PIN U5 [get_ports e]
set_property PACKAGE_PIN V5 [get_ports f]
set_property PACKAGE_PIN U7 [get_ports g]

# Anodes (directly active low on Basys 3)
set_property PACKAGE_PIN U2 [get_ports an0]
set_property PACKAGE_PIN U4 [get_ports an1]
set_property PACKAGE_PIN V4 [get_ports an2]
set_property PACKAGE_PIN W4 [get_ports an3]

set_property IOSTANDARD LVCMOS33 [get_ports {a b c d e f g}]
set_property IOSTANDARD LVCMOS33 [get_ports {an0 an1 an2 an3}]
```

## Simulation

### Running Testbenches in Vivado

1. Add design and testbench files to project
2. Set testbench as simulation top module
3. Run behavioral simulation
4. Verify waveforms against expected truth tables

### Expected Waveforms

**Decoder (e=1):**
```
Time:    0   10   20   30   40   50   60   70
abc:    000  001  010  011  100  101  110  111
d0:      1    0    0    0    0    0    0    0
d1:      0    1    0    0    0    0    0    0
d2:      0    0    1    0    0    0    0    0
...
```

**Display:**
```
Time:    0   10   20   30   ...  90   100-150
wxyz:  0000 0001 0010 0011 ... 1001 1010-1111
Digit:   0    1    2    3  ...   9   INVALID
```

## Design Considerations

### Structural vs. Dataflow Trade-offs

| Aspect | Structural | Dataflow |
|--------|------------|----------|
| Readability | Lower | Higher |
| Synthesis Control | More explicit | Tool-dependent |
| Debugging | Gate-level visibility | Boolean expression |
| Code Length | Longer | Shorter |

### Invalid Input Handling

The display module explicitly detects invalid BCD values (10-15) and forces all segments ON, providing visual feedback for erroneous inputs rather than displaying garbage.

## Extensions

### Possible Enhancements

1. **Multiplexed 4-digit display**: Add time-multiplexing for full display
2. **Hexadecimal support**: Extend display to show A-F
3. **Priority encoder**: Implement reverse of decoder
4. **Cascaded decoders**: Build larger decoders from 3-to-8 building blocks
