<!-- $theme: default -->

Diseño de de QoS
===

Robin Gonzalez
Boanerges Martinez
Emilio Rojas

---

Propuesta de diseño
===

Sqwertyuio:
- wertyu
- asd

---

![center](presentacion-1/Proyecto2.svg)

---

### [Bloque FIFO](http://electrosofts.com/verilog/fifo.html)

- __Modelo de referencia__ 
- __http://electrosofts.com/verilog/fifo.html__
![center](presentacion-1/fifo_block.jpg)

---

# Bloque ```FIFO```
#### Puertos y parametros
```verilog
module fifo #(parameter BUF_WIDTH = 3)
 (
  output buf_empty, buf_full, almost_full, almost_empty, 
  output [3:0] buf_out,
  output [BUF_WIDTH :0] fifo_counter, 
  input clk, rst, wr_en, rd_en, 
  input [3:0] buf_in
);
parameter BUF_SIZE = ( 1<<BUF_WIDTH );
```
  
---


# Bloque ```FIFO```
#### Banderas
```verilog
//banderas dependientes de conteo de datos en el fifo
always @(fifo_counter) begin
   buf_empty = (fifo_counter==0);
   buf_full = (fifo_counter== BUF_SIZE);
   almost_full = (fifo_counter == (BUF_SIZE-2));
   almost_empty = (fifo_counter == 3);
end
```

---  

# Bloque ```FIFO```
#### Test_fifo

```verilog
push(13);
pop(tempdata);
task push;
input [3:0] data;
   if( buf_full )
        $display("---Cannot push: Buffer Full---");
        else
        begin
           $display("Pushed ",data );
			buf_in = data;
			wr_en = 1;
            @(posedge clk);
                #1 wr_en = 0;
        end
endtask
```

--- 


# Bloque ```FIFO```
#### Imagen



---  

# Conclusiones del Estudio de Mercado

  - Mercado con precios muy competitivos, dificulta ingreso de nuevas empresas.
  - Características similares entre los distintos productos.


---

# División Propuesta del Trabajo

 
 - __Robin__: Isdfsdfsdfsd.
 
 - __Emilio__: Rasdsfsgfdfgfg.
 - __Boanerges__: Modulo FIFO y su tester.
