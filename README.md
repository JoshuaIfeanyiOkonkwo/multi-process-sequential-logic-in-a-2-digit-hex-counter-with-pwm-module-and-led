# **Multi‑Process Sequential Logic in a 2‑Digit Hex Counter With PWM and LED**

This project implements a **bi‑directional 2‑digit hexadecimal counter** (00–FF) combined with an **8‑bit PWM module** to drive an LED.  
It demonstrates multi‑process sequential logic, clock division, synchronous load, overflow/underflow detection, and PWM‑based LED brightness control on an FPGA (Zedboard).

---

## **1. Project Overview**

The system extends a single‑digit counter into a **double‑digit hexadecimal counter**, producing two 4‑bit outputs:

- `count_lo_out` → Low nibble (0–F)  
- `count_hi_out` → High nibble (0–F)

Together, they represent an 8‑bit value:

```
00 → FF   (0 → 255 decimal)
```

The counter supports:

- Up/Down counting  
- Synchronous load  
- Asynchronous active‑low reset  
- Overflow/underflow detection  
- Clock division  
- PWM output mapped to LED brightness  

---

## **2. Hexadecimal Reference Table**

| Decimal | Hex | Binary |
|---------|-----|--------|
| 0 | 0 | 0000 |
| 1 | 1 | 0001 |
| 2 | 2 | 0010 |
| 3 | 3 | 0011 |
| 4 | 4 | 0100 |
| 5 | 5 | 0101 |
| 6 | 6 | 0110 |
| 7 | 7 | 0111 |
| 8 | 8 | 1000 |
| 9 | 9 | 1001 |
| 10 | A | 1010 |
| 11 | B | 1011 |
| 12 | C | 1100 |
| 13 | D | 1101 |
| 14 | E | 1110 |
| 15 | F | 1111 |

---

## **3. Counter Entity Definition**

```
entity 8bitcounter is
  port (
    clk           : in  std_logic;                     -- rising-edge clock
    arst_n        : in  std_logic;                     -- async active-low reset
    enable_in     : in  std_logic;                     -- enable
    load_in       : in  std_logic;                     -- synchronous load
    dir_in        : in  std_logic;                     -- 0=up, 1=down
    data_in       : in  std_logic_vector(7 downto 0);  -- load value
    count_lo_out  : out std_logic_vector(3 downto 0);  -- low nibble
    count_hi_out  : out std_logic_vector(3 downto 0);  -- high nibble
    over_out      : out std_logic                      -- overflow/underflow flag
  );
```

---

## **4. Counter Behaviour Specification**

### **Reset**
When `arst_n = 0`:
```
count = h"00"
over_out = '0'
```

### **Enable = 0**
Counter holds its value.

### **Load Operation**
Occurs when:
```
load_in = '1' AND enable_in = '1'
```

Then:
```
count_hi_out <= data_in(7 downto 4)
count_lo_out <= data_in(3 downto 0)
```

### **Counting Logic**
- `dir_in = 0` → Up count  
- `dir_in = 1` → Down count  

### **Overflow / Underflow**
- Up count at FF → wraps to 00, `over_out = '1'`  
- Down count at 00 → wraps to FF, `over_out = '1'`  

---

## **5. Architecture Requirements**

The architecture include **two processes**:

### **A. Combinational Process**
Implements:
- Load logic  
- Up/down count logic  
- Overflow/underflow detection  
- Next‑state logic  

### **B. Clock Divider Process**
- Divides the input clock to a slower frequency  
- For simulation, ~100 kHz is sufficient  
- Divided clock drives the counter  

---

## **6. Testbench Requirements (Part 1)**

Testbench verify:

- Reset behavior  
- Enable gating  
- Load operation  
- Up counting  
- Down counting  
- Overflow and underflow  
- Correct nibble outputs  
- Correct `over_out` flag  

Each scenario include **assertions** comparing DUT output to expected values.

---

## **7. PWM Module (Part 2)**

### **Entity Definition**

```
entity pwm is
  port (
    clk     : in  std_logic;                    -- clock input
    dc_in   : in  std_logic_vector(7 downto 0); -- duty cycle (0–255)
    pwm_out : out std_logic                     -- PWM output
  );
```

### **PWM Behaviour**
- 8‑bit resolution  
- Output HIGH for `dc_in` counts out of 255  
- Used to drive LED brightness  

### **PWM Testbench Requirements**
- Apply multiple duty cycles (0, 64, 128, 192, 255)  
- Verify PWM high‑time matches expected duty cycle  
- Use assertions  

---

## **8. Top‑Level Integration**

The top module:

### **1. Instantiate the 8‑bit counter**
Combine outputs:
```
dc_in <= count_lo_out & count_hi_out
```

### **2. Instantiate the PWM module**
- Feed `dc_in` into PWM  
- Drive LED with `pwm_out`  

### **3. Map Inputs on Zedboard**
- DIP switches → `data_in`  
- Push buttons → `enable_in`, `load_in`, `dir_in`, `arst_n`  
- (Bonus) Add debouncing  

---

## **9. Hardware Demonstration (Zedboard)**

- Counter increments/decrements based on button input  
- PWM brightness changes according to the 8‑bit count  
- Load button sets counter to DIP switch value  
- Overflow/underflow indicated via `over_out`  
- LED brightness smoothly transitions as counter cycles  

---

## **10. Summary**

This project demonstrates:

- Multi‑process VHDL design  
- Sequential logic with clock division  
- Bi‑directional 8‑bit counting  
- Overflow/underflow handling  
- 8‑bit PWM generation  
- Hardware integration on Zedboard  
- Comprehensive testbenching with assertions  

It provides a complete example of combining **digital design**, **PWM control**, and **FPGA hardware implementation**.
