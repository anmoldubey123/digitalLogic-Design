# Sprinkler Valve Controller & Data Bus

## Overview

This project implements fundamental digital building blocks for a sprinkler valve control system and data bus architecture in Verilog. The designs include a 3-to-8 decoder for valve selection and a 4-to-1 multiplexer for data routing, demonstrating both structural and behavioral modeling approaches essential for embedded control systems.

## Author

- Anmol Dubey

## Objectives

1. Design a decoder for one-hot valve selection from binary address
2. Implement a multiplexer for sensor data aggregation
3. Compare structural and behavioral Verilog implementations
4. Create reusable components for control system architectures

## System Concept

```
┌─────────────────────────────────────────────────────────────────────┐
│                  Sprinkler Valve Control System                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   ┌─────────────┐                         ┌─────────────────────┐   │
│   │   Control   │                         │   Valve Array       │   │
│   │   Unit      │                         │                     │   │
│   │             │     ┌───────────┐       │  ┌───┐ ┌───┐ ┌───┐  │   │
│   │  Address    │────►│  3-to-8   │──────►│  │V0 │ │V1 │ │...│  │   │
│   │  [2:0]      │     │  Decoder  │       │  └───┘ └───┘ └───┘  │   │
│   │             │     │           │       │    │     │     │    │   │
│   │  Enable     │────►│           │       │    ▼     ▼     ▼    │   │
│   │             │     └───────────┘       │  Zone  Zone  Zone   │   │
│   └─────────────┘                         └─────────────────────┘   │
│                                                                     │
│   ┌─────────────────────────────────────────────────────────────┐   │
│   │                    Sensor Data Bus                          │   │
│   │                                                             │   │
│   │  Sensor 0 ──┐                                               │   │
│   │  Sensor 1 ──┼──►  ┌───────────┐      ┌─────────────────┐    │   │
│   │  Sensor 2 ──┼──►  │  4-to-1   │─────►│  Data Processor │    │   │
│   │  Sensor 3 ──┘     │    MUX    │      │                 │    │   │
│   │                   └─────┬─────┘      └─────────────────┘    │   │
│   │           Select ───────┘                                   │   │
│   │           [1:0]                                             │   │
│   └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## Module Descriptions

### decoder.v

3-to-8 decoder with enable input for valve/zone selection.

```verilog
module decoder(
    input e, a, b, c,
    output reg d0, d1, d2, d3, d4, d5, d6, d7
);
```

**Application in Sprinkler System:**
- Address inputs `{a, b, c}` select one of 8 irrigation zones
- Enable `e` acts as master system enable
- Each output `d0-d7` controls one solenoid valve
- Only one valve active at a time (one-hot encoding)

**Truth Table:**

| e | a | b | c | Active Output |
|---|---|---|---|---------------|
| 0 | X | X | X | None (all 0) |
| 1 | 0 | 0 | 0 | d0 (Zone 1) |
| 1 | 0 | 0 | 1 | d1 (Zone 2) |
| 1 | 0 | 1 | 0 | d2 (Zone 3) |
| 1 | 0 | 1 | 1 | d3 (Zone 4) |
| 1 | 1 | 0 | 0 | d4 (Zone 5) |
| 1 | 1 | 0 | 1 | d5 (Zone 6) |
| 1 | 1 | 1 | 0 | d6 (Zone 7) |
| 1 | 1 | 1 | 1 | d7 (Zone 8) |

**Implementation (Behavioral - Active):**

```verilog
always @(*) begin
    // Default: all outputs off
    d0 = 0; d1 = 0; d2 = 0; d3 = 0;
    d4 = 0; d5 = 0; d6 = 0; d7 = 0;
    
    if(e == 1) begin
        case({a, b, c})
            3'b000: d0 = 1;
            3'b001: d1 = 1;
            // ... etc
        endcase
    end
end
```

**Alternative Implementations (Commented):**

*Structural:*
```verilog
wire nota, notb, notc;
not int1(nota, a);
not int2(notb, b);
not int3(notc, c);
and out0 (d0, e, nota, notb, notc);
// ... additional gates
```

*Dataflow:*
```verilog
assign d0 = e & ~a & ~b & ~c;
assign d1 = e & ~a & ~b &  c;
// ... additional assignments
```

---

### mux.v

4-to-1 multiplexer for sensor data routing.

```verilog
module mux(
    input i0, i1, i2, i3,
    input s0, s1,
    output reg d
);
```

**Application in Sprinkler System:**
- Inputs `i0-i3` connect to moisture/flow sensors
- Select lines `{s1, s0}` choose which sensor to read
- Output `d` routes selected sensor data to processor
- Enables sequential polling of multiple sensors

**Function Table:**

| s1 | s0 | Output d |
|----|----|----------|
| 0 | 0 | i0 |
| 0 | 1 | i1 |
| 1 | 0 | i2 |
| 1 | 1 | i3 |

**Implementation (Behavioral - Active):**

```verilog
always @(*) begin
    case({s1, s0})
        2'b00: d = i0;
        2'b01: d = i1;
        2'b10: d = i2;
        2'b11: d = i3;
    endcase
end
```

**Alternative Implementation (Structural - Commented):**

```verilog
wire ns0, ns1;
wire y0, y1, y2, y3;

not(ns0, s0);
not(ns1, s1);

and(y0, i0, ns1, ns0);  // i0 when s1s0 = 00
and(y1, i1, ns1, s0);   // i1 when s1s0 = 01
and(y2, i2, s1, ns0);   // i2 when s1s0 = 10
and(y3, i3, s1, s0);    // i3 when s1s0 = 11

or(d, y0, y1, y2, y3);
```

**Logic Equation:**
```
d = (i0 · s1' · s0') + (i1 · s1' · s0) + (i2 · s1 · s0') + (i3 · s1 · s0)
```

## Circuit Diagrams

### 3-to-8 Decoder

```
         ┌─────────────────────────────────────┐
         │           3-to-8 Decoder            │
         │                                     │
    e ──►│ E                            d0 ───►│──► Valve 0
         │                              d1 ───►│──► Valve 1
    a ──►│ A (MSB)                      d2 ───►│──► Valve 2
         │                              d3 ───►│──► Valve 3
    b ──►│ B                            d4 ───►│──► Valve 4
         │                              d5 ───►│──► Valve 5
    c ──►│ C (LSB)                      d6 ───►│──► Valve 6
         │                              d7 ───►│──► Valve 7
         │                                     │
         └─────────────────────────────────────┘
```

### 4-to-1 Multiplexer

```
              ┌─────────────────┐
   i0 ───────►│ 0               │
              │    ┌───┐        │
   i1 ───────►│ 1  │MUX│───────►│──► d
              │    └───┘        │
   i2 ───────►│ 2               │
              │                 │
   i3 ───────►│ 3               │
              │                 │
              │   s1  s0        │
              └────┬───┬────────┘
                   │   │
    Select[1] ─────┘   └───── Select[0]
```

## Testbenches

### tb_decoder.v

Exhaustive test of all input combinations.

**Test Sequence:**
1. Enable = 0: Verify all outputs remain 0 for all address combinations
2. Enable = 1: Verify one-hot output for each address

```verilog
initial begin
    // Test with enable = 0 (all outputs should be 0)
    e = 0; a = 0; b = 0; c = 0; #10;
    // ... all combinations with e=0
    
    // Test with enable = 1 (one-hot outputs)
    e = 1; a = 0; b = 0; c = 0; #10;  // d0 = 1
    e = 1; a = 0; b = 0; c = 1; #10;  // d1 = 1
    // ... remaining combinations
end
```

**Optional Checker Logic:**
```verilog
wire [7:0] data_all = {d0,d1,d2,d3,d4,d5,d6,d7};
if(data_all === 8'b1000_0000) test_pass = 1;
else test_error = 1;
```

### tb_mux.v

Tests all select combinations with varying input patterns.

**Test Strategy:**
1. Set inputs to non-trivial pattern (0101)
2. Cycle through all select combinations
3. Change inputs to complementary pattern (1010)
4. Repeat select combinations

```verilog
initial begin
    // Pattern 1: i0=0, i1=1, i2=0, i3=1
    i0=0; i1=1; i2=0; i3=1;
    
    s1=0; s0=0; #10;  // d should be 0 (i0)
    s1=0; s0=1; #10;  // d should be 1 (i1)
    s1=1; s0=0; #10;  // d should be 0 (i2)
    s1=1; s0=1; #10;  // d should be 1 (i3)
    
    // Pattern 2: Complementary
    i0=1; i1=0; i2=1; i3=0;
    // ... repeat select tests
end
```

## Implementation Comparison

### Structural vs. Behavioral

| Aspect | Structural | Behavioral |
|--------|------------|------------|
| Abstraction | Gate-level | Algorithm-level |
| Readability | Lower | Higher |
| Synthesis Control | Explicit | Tool-dependent |
| Debugging | Gate visibility | Logic flow |
| Maintenance | More complex | Simpler |
| Optimization | Manual | Automatic |

### When to Use Each Style

**Structural:**
- Critical timing paths requiring specific gate topology
- Teaching gate-level concepts
- Interfacing with specific library cells
- Area-critical designs with manual optimization

**Behavioral:**
- Rapid prototyping
- Complex control logic
- Higher abstraction designs
- Letting synthesis tools optimize

## File Structure

```
sprinklerValveController&DataBus/
├── README.md
├── decoder.v        # 3-to-8 decoder (behavioral active, others commented)
├── mux.v            # 4-to-1 multiplexer (behavioral active, structural commented)
├── tb_decoder.v     # Decoder testbench with optional checker
└── tb_mux.v         # Multiplexer testbench
```

## Application Examples

### Sprinkler Zone Control

```verilog
// Zone selection based on time schedule
reg [2:0] current_zone;
wire [7:0] valve_control;

decoder zone_select (
    .e(system_enable),
    .a(current_zone[2]),
    .b(current_zone[1]),
    .c(current_zone[0]),
    .d0(valve_control[0]),
    // ... remaining outputs
);

// Cycle through zones
always @(posedge zone_timer) begin
    if (current_zone == 7)
        current_zone <= 0;
    else
        current_zone <= current_zone + 1;
end
```

### Sensor Data Acquisition

```verilog
// Poll multiple moisture sensors
reg [1:0] sensor_select;
wire sensor_data;

mux sensor_mux (
    .i0(moisture_sensor_0),
    .i1(moisture_sensor_1),
    .i2(moisture_sensor_2),
    .i3(moisture_sensor_3),
    .s1(sensor_select[1]),
    .s0(sensor_select[0]),
    .d(sensor_data)
);

// Sequential sensor polling
always @(posedge poll_clk) begin
    sensor_select <= sensor_select + 1;
    sensor_readings[sensor_select] <= sensor_data;
end
```

## Synthesis Notes

### Resource Utilization (Estimated)

| Module | LUTs | Description |
|--------|------|-------------|
| decoder | 8 | 8 output functions, 4 inputs each |
| mux | 2 | 4-to-1 selection, 1 output |

### Timing Characteristics

| Module | Levels of Logic | Critical Path |
|--------|-----------------|---------------|
| decoder | 2 | Input → Any output |
| mux (structural) | 3 | Input → OR gate |
| mux (behavioral) | 2 | Optimized by synthesis |

## Extensions

### Possible Enhancements

1. **Parameterized decoder**: N-to-2^N decoder with generate statements
2. **Multi-bit mux**: Extend to bus-width data paths
3. **Priority encoder**: Reverse function of decoder
4. **Cascaded decoders**: Build larger decoders from smaller ones
5. **Tri-state bus**: Add output enable for bus sharing

### Parameterized Decoder Example

```verilog
module decoder_param #(
    parameter N = 3  // Number of select bits
)(
    input enable,
    input [N-1:0] select,
    output reg [(2**N)-1:0] out
);
    always @(*) begin
        out = 0;
        if (enable)
            out[select] = 1;
    end
endmodule
```
