# 8086 ASM 
## Register
- `AH` `AL` -> `AX`     (Accmulator Register)
- `BH` `BL` -> `BX`     (Base Register)
- `CH` `CL` -> `CX`     (Count Register)
- `DH` `DL` -> `DX`     (Data Register)
## Data Transfer 
### General purpose transfer
#### `MOV`
- Usage:
    ```ARM
    MOV dest,src
    ```
- Transfer a byte (8 bit) & a word (16 bits)
- Cannot move a byte or word from one memory address to another without transferring via registors. 

#### `NOP`
- Usage:
    ```ARM
       NOP
    ```
- Null operation for one clock cycle
