# Calculator Design - Digital Arithmetic Units

## Overview

This project implements fundamental digital arithmetic circuits in Verilog for FPGA deployment. The design includes two 4-bit adder architectures—Ripple Carry Adder (RCA) and Carry Lookahead Adder (CLA)—demonstrating the trade-offs between circuit complexity and propagation delay in digital arithmetic units.

## Author

- Anmol Dubey

## Objectives

1. Implement a ripple carry adder using cascaded full adders
2. Implement a carry lookahead adder for improved performance
3. Compare propagation characteristics of both architectures
4. Demonstrate registered output for synchronous operation

## Architecture Comparison

### Ripple Carry Adder (RCA)

```
     A[0] B[0]    A[1] B[1]    A[2] B[2]    A[3] B[3]
       │   │        │   │        │   │        │   │
       ▼   ▼        ▼   ▼        ▼   ▼        ▼   ▼
    ┌───────┐    ┌───────┐    ┌───────┐    ┌───────┐
Cin─►│  FA0  │───►│  FA1  │───►│  FA2  │───►│  FA3  │───► Cout
    └───┬───┘    └───┬───┘    └───┬───┘    └───┬───┘
        │            │            │            │
        ▼            ▼            ▼            ▼
      S[0]         S[1]         S[2]         S[3]
```

**Characteristics:**
- Simple, modular design
- Carry propagates sequentially through each stage
- Delay: O(n) where n = number of bits
- Area: O(n) - minimal gate count

### Carry Lookahead Adder (CLA)

```
        A[3:0]  B[3:0]
           │      │
           ▼      ▼
    ┌──────────────────┐
    │  Generate (G)    │  Gi = Ai · Bi
    │  Propagate (P)   │  Pi = Ai ⊕ Bi
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │  Carry Lookahead │  C1 = G0 + P0·C0
    │      Logic       │  C2 = G1 + P1·G0 + P1·P0·C0
    │                  │  C3 = G2 + P2·G1 + P2·P1·G0 + ...
    │                  │  C4 = G3 + P3·G2 + ...
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │   Sum Logic      │  Si = Pi ⊕ Ci
    └────────┬─────────┘
             │
             ▼
         S[3:0], Cout
```

**Characteristics:**
- Parallel carry computation
- All carries calculated simultaneously
- Delay: O(log n) - significantly faster
- Area: O(n²) - more complex logic

## Module Descriptions

### full_adder.v

Single-bit full adder - the fundamental building block.

```verilog
module full_adder(
    input A, B, Cin,
    output S, Cout
);
```

**Logic Equations:**
- Sum: `S = A ⊕ B ⊕ Cin`
- Carry: `Cout = (A · B) + (A · Cin) + (B · Cin)`

**Truth Table:**

| A | B | Cin | S | Cout |
|---|---|-----|---|------|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 |
| 0 | 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 0 | 1 |
| 1 | 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 1 | 1 |

---

### register_logic.v

5-bit synchronous register with enable control.

```verilog
module register_logic(
    input clk,
    input enable,
    input [4:0] Data,
    output reg [4:0] Q
);
```

**Behavior:**
- On rising clock edge, if `enable` is high, `Q` latches `Data`
- Provides synchronous output for pipeline integration
- Holds previous value when `enable` is low

---

### RCA_4bits.v

4-bit Ripple Carry Adder with registered output.

```verilog
module RCA_4bits(
    input clk,
    input enable,
    input [3:0] A, B,
    input Cin,
    output [4:0] Q
);
```

**Structure:**
- Four cascaded full adder instances
- Internal carry chain: `Cin → C1 → C2 → C3 → Cout`
- Output register stores `{Cout, Sum[3:0]}`

**Timing Analysis (typical FPGA):**
- Full adder delay: ~2 LUT levels
- Total combinational delay: 4 × FA_delay
- Critical path: Cin to Cout

---

### CLA_4bits.v

4-bit Carry Lookahead Adder with registered output.

```verilog
module CLA_4bits(
    input clk,
    input enable,
    input [3:0] A, B,
    input Cin,
    output reg [4:0] Q
);
```

**Generate and Propagate:**
```
G[i] = A[i] · B[i]     (Generate: produces carry regardless of Cin)
P[i] = A[i] ⊕ B[i]     (Propagate: passes carry from previous stage)
```

**Carry Equations:**
```
C[1] = G[0] + P[0]·C[0]
C[2] = G[1] + P[1]·G[0] + P[1]·P[0]·C[0]
C[3] = G[2] + P[2]·G[1] + P[2]·P[1]·G[0] + P[2]·P[1]·P[0]·C[0]
C[4] = G[3] + P[3]·G[2] + P[3]·P[2]·G[1] + P[3]·P[2]·P[1]·G[0] + P[3]·P[2]·P[1]·P[0]·C[0]
```

**Timing Analysis:**
- G, P computation: 1 LUT level
- Carry computation: 1-2 LUT levels (parallel)
- Sum computation: 1 LUT level
- Total: ~3 LUT levels (vs. 8 for RCA)

## Performance Comparison

| Metric | RCA (4-bit) | CLA (4-bit) |
|--------|-------------|-------------|
| Gate Count | ~20 | ~40 |
| LUT Usage | ~8 | ~12 |
| Critical Path | 4 × FA | 3 levels |
| Scalability | O(n) delay | O(log n) delay |
| Design Complexity | Simple | Moderate |

### Delay Scaling (n-bit adders)

| Bits | RCA Delay | CLA Delay |
|------|-----------|-----------|
| 4 | 4 units | 3 units |
| 8 | 8 units | 4 units |
| 16 | 16 units | 5 units |
| 32 | 32 units | 6 units |
| 64 | 64 units | 7 units |

## Interface Specification

### Input Signals

| Signal | Width | Description |
|--------|-------|-------------|
| `clk` | 1 | System clock (rising edge triggered) |
| `enable` | 1 | Register load enable |
| `A` | 4 | First operand |
| `B` | 4 | Second operand |
| `Cin` | 1 | Carry input |

### Output Signals

| Signal | Width | Description |
|--------|-------|-------------|
| `Q` | 5 | Registered result `{Cout, Sum[3:0]}` |

### Output Encoding

```
Q[4]   = Cout (carry out / overflow indicator)
Q[3:0] = Sum (4-bit sum result)
```

## Usage Example

```verilog
// Instantiate 4-bit CLA
CLA_4bits adder_inst (
    .clk(system_clk),
    .enable(compute_en),
    .A(operand_a),
    .B(operand_b),
    .Cin(carry_in),
    .Q(result)
);

// Result available on next clock edge after enable
// result[4] indicates overflow for unsigned addition
// result[3:0] contains the 4-bit sum
```

## Simulation

### Testbench Strategy

1. **Exhaustive testing**: All 512 input combinations (4+4+1 bits)
2. **Corner cases**: Maximum values, carry propagation chains
3. **Timing verification**: Setup/hold time compliance

### Sample Test Vectors

| A | B | Cin | Expected Q |
|---|---|-----|------------|
| 0000 | 0000 | 0 | 00000 |
| 1111 | 0001 | 0 | 10000 |
| 1111 | 1111 | 0 | 11110 |
| 1111 | 1111 | 1 | 11111 |
| 1010 | 0101 | 0 | 01111 |
| 0111 | 0001 | 0 | 01000 |

## File Structure

```
calculatorDesign/
├── README.md
├── full_adder.v        # 1-bit full adder primitive
├── register_logic.v    # 5-bit synchronous register
├── RCA_4bits.v         # Ripple Carry Adder (top module)
└── CLA_4bits.v         # Carry Lookahead Adder (top module)
```

## Synthesis Notes

### Target Devices

- Xilinx 7-series FPGAs (Artix-7, Kintex-7)
- Intel/Altera Cyclone series
- Any device with 6-input LUTs

### Resource Utilization (Estimated)

| Module | LUTs | FFs | 
|--------|------|-----|
| full_adder | 2 | 0 |
| register_logic | 0 | 5 |
| RCA_4bits | 8 | 5 |
| CLA_4bits | 12 | 5 |

## Extensions

### Possible Enhancements

1. **Wider adders**: Extend to 8, 16, or 32 bits
2. **Subtraction**: Add mode select for A - B operation
3. **Overflow detection**: Signed arithmetic overflow flag
4. **Carry-select adder**: Hybrid approach for better area/delay trade-off
5. **Pipelining**: Multi-stage pipeline for higher throughput

### Hierarchical CLA (16-bit example)

```
┌─────────────────────────────────────────────────┐
│              16-bit CLA (Group CLA)             │
├───────────┬───────────┬───────────┬─────────────┤
│  4-bit    │  4-bit    │  4-bit    │   4-bit     │
│  CLA[0]   │  CLA[1]   │  CLA[2]   │   CLA[3]    │
│           │           │           │             │
│  G0, P0   │  G1, P1   │  G2, P2   │   G3, P3    │
└─────┬─────┴─────┬─────┴─────┬─────┴──────┬──────┘
      │           │           │            │
      └───────────┴───────────┴────────────┘
                        │
              Group Carry Lookahead
```

