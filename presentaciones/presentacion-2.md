<!-- $theme: default -->

# Diseño de QoS para PCI

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

#### Diagrama de bloque

![110% center](presentacion-2/fifo.png)
  
---

# Bloque fifo16
<br >

#### Puertos y parametros
```verilog
module fifo16 #(
parameter BUF_WIDTH = 4, 
parameter DATA_WIDTH = 4
)(
  output reg buf_empty, buf_full, almost_full, almost_empty, 
  output reg [(DATA_WIDTH-1):0] buf_out,
  output reg [BUF_WIDTH :0] fifo_counter,
  input clk, rst, wr_en, rd_en, 
  input [(DATA_WIDTH-1):0] buf_in
);
parameter BUF_SIZE = ( 1<<BUF_WIDTH );
```
  
---

 # Bloque fifo16
<br >

#### Archivo .gtkw de las señales del fifo16

![95% center](presentacion-2/fifos_8_16.png)

_De: ```fifo16_test.v```_

---

 # Bloque Mux
<br >

#### Diagrama de bloque

![150% center](presentacion-2/mux.png)

---
 # Bloque Demux
<br >

#### Diagrama de bloque

![150% center](presentacion-2/demux.png)
  
---

# Bloque Mux-Demux
<br >

#### Asignaciones

```verilog

case(selector_mux)
    2'b00 : salida_mux = entrada0_mux;
    2'b01 : salida_mux = entrada1_mux;
    2'b10 : salida_mux = entrada2_mux;
    2'b11 : salida_mux = entrada3_mux;
endcase
```
---

# Bloque Mux-Demux

#### Archivo .gtkw de las señales del muxDemux_test

![85% center](presentacion-2/TestMuxDemux.png)
_De: ```muxDemux_test.v```_

---

 # Bloque Round Robin
<br >

#### Diagrama de bloque

![150% center](presentacion-2/rr.png)
  
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

<br >

#### Archivo .gtkw de las señales del roundRobin_test

![center](presentacion-2/testRoundRobin.png)

_De: ```roundRobin_test.v```_

---


 # Bloque Round Robin Pesado
<br >

#### Diagrama de bloque

![150% center](presentacion-2/rrpesado.png)
  
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
  input [(QUEUE_QUANTITY*$clog2(MAX_WEIGHT))-1:0] fifo_counter,
  output [$clog2(QUEUE_QUANTITY)-1:0] selector,
  output selector_enb
);

```
---


# Round Robin Pesado
<br >

#### Archivo .gtkw de las señales del roundRobinPesado_test

![center](presentacion-2/testRoundRobinPesado.png)

_De: ```roundRobinPesado_test.v```_

---
# Maquina de estados
<br >

#### Codigo

```verilog


always @(actual ... or init) begin
	case(actual)

		continue : begin 
		if(full > 0) proximo = error;
			else proximo =  active;
	end
		pause : begin 
		proximo = active;
	end  

```

---

# Maquina de estados

#### Archivo .gtkw de las señales del fsm_test
![center](presentacion-2/fsm.jpg)
_De: ```fsm_test.v```_
---











