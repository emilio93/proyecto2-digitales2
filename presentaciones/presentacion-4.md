<!-- $theme: default -->

# Diseño de QoS para PCI

Tercera entrega
===

Robin Gonzalez
Boanerges Martinez
Emilio Rojas

---

# ```Avance Final```

###  ```Interfaz Round Robin```, ```FSM```, ```Makefile```

### ```Memoria```, ```transmisorQoS```


---

# Bloque Interfaz Round Robin 

```verilog


```

---  

#### Archivo .gtkw de las señales del Interfaz Round Robin

![center](presentacion-4/interfazRR.png)

_De: ```interfazRoundRobin_test.v```_




---  

# Maquina de estados

#### Archivo .gtkw de las señales del fsm_test
![center](presentacion-4/fsm.png)
_De: ```fsm_test.v```_

---


 # Makefile
<br >

#### Comandos unicos para cada modulos

```verilog
make all fifo8
make view fifo
make all fifo8 fifo16 fsm 

```
---
 # Bloque transmisor
<br >

#### Puertos y parametros
```verilog
module qos 
#(parameter DATA_WIDTH = 4, parameter QUEUE_QUANTITY = 4)
( output [DATA_WIDTH-1:0] output_qos,
  output [QUEUE_QUANTITY-1:0] error_full_qos, pausa_qos, 
  output [QUEUE_QUANTITY-1:0] continue_qos,
  output idle_qos,
  //inputs se単ales de control
  input clk, rst, enb, init,
  input uH,uL,
  input [1:0] vc_id, 
  input [QUEUE_QUANTITY-1:0] arbiterTable,
  //inputs data
  input [DATA_WIDTH-1:0] input_qos
  );
```











