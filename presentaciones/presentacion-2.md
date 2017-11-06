<!-- $theme: default -->

# Diseĺo de QoS para PCI

Segunda entrega
===

Robin Gonzalez
Boanerges Martinez
Emilio Rojas


---

![center](presentacion-2/Proyecto2.svg)

---

# ```Modulos```

###  ```fifo 4x8```, ```fifo 4x16```, ```mux 4 a 1```

### ```deMux 1 a 4```, ```roundRobin```, ```roundRobinPesado```, ```fsm```

---

# Bloque fifo16
<br >

#### Puertos y parametros
```verilog
module fifo #(parameter BUF_WIDTH = 3)
 (
  output buf_empty, buf_full, almost_full, almost_empty, 
  output [3:0] buf_out,sss
  output [BUF_WIDTH :0] fifo_counter, 
  input clk, rst, wr_en, rd_en, 
  input [3:0] buf_in
);
parameter BUF_SIZE = ( 1<<BUF_WIDTH );
```
  
---

# Mux-Demux
<br >

#### Puertos y parametros

```verilog

codigo

```
---

# Mux-Demux


![center](presentacion-2/TestMuxDemux.png)

---

# Round Robin

#### Puertos y parametros

```verilog
module roundRobin #(
  parameter QUEUE_QUANTITY = 4, 
  parameter DATA_BITS = 8, 
  parameter MIN_FIFO_COUNTER = 3
) (
  input clk, input rst, input enb,
  input [QUEUE_QUANTITY-1:0] buf_empty,
  input [QUEUE_QUANTITY-1:0] fifo_counter,
  output [$clog2(QUEUE_QUANTITY)-1:0] selector,
  output selector_enb
);

```
---



# Round Robin


![center](presentacion-2/testRoundRobin.png)

---


# Round Robin Pesado

#### Puertos y parametros

```verilog
module roundRobinPesado #(
  parameter QUEUE_QUANTITY = 4,
  parameter DATA_BITS = 8,
  parameter BUF_WIDTH = 3,
  parameter MAX_WEIGHT = 64
) (
  input clk, input rst, input enb,
  input 
  [((QUEUE_QUANTITY)*($clog2(MAX_WEIGHT)))-1:0] pesos,
  input [QUEUE_QUANTITY-1:0] buf_empty,
  input [(QUEUE_QUANTITY*BUF_WIDTH)-1:0] fifo_counter,
  output [$clog2(QUEUE_QUANTITY)-1:0] selector,
  output selector_enb
);

```
---


# Round Robin Pesado


![center](presentacion-2/testRoundRobinPesado.png)

---
# Flow Control
<br >

#### Puertos y parametros

```verilog

codigo

```

---

# Flow Control

simulacion

---











