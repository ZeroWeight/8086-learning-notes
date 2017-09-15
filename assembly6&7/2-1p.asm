;实验七内容一选作

DATA SEGMENT
DATA ENDS

STACKS SEGMENT
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS
    
MAIN PROC FAR
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV DX, 283H
    MOV AL, 10010000B
    OUT DX, AL                    ;控制字，方式0，A输入，C输出
SCAN:    
    MOV DX, 280H
    IN AL, DX                ;读A口
    
    CMP AL, 11000000B
    JZ TOFLASH                   ;仅K6=K7=1
    
    CMP AL, 10000000B
    JZ L_MOVE                   ;仅K7=1
    
    CMP AL, 01000000B
    JZ R_MOVE                   ;仅K6=1
    
    MOV DX, 282H
    OUT DX, AL                    ;写C口
    
    MOV AH, 1
    INT 16H                       ;检测键盘是否按下
    JZ SCAN                ;没有，继续
    
    MOV AH, 0
    INT 16H                ;读按键
    CMP AL, 20H
    JZ TOEXIT                   ;为空格，退出    
    JMP SCAN 
        
L_MOVE:                                ;左移
    MOV DX, 282H
    MOV BL, 10000000B
    MOV AL, BL
    OUT DX, AL                ;输出亮灯                
R_LEFT:    
    ROL BL, 1                ;左移一位
    MOV AL, BL
    MOV DX, 282H
    OUT DX, AL                ;亮灯
    
    CALL DELAY                ;延时
    
    MOV DX, 280H
    IN AL, DX                 ;读A口
    CMP AL, 10000000B
    JNZ SCAN                ;状态改变，重新扫描
    
    MOV DX, 282H
    OUT DX, AL                ;???                
    MOV AH, 1
    INT 16H                       ;检测键盘是否按下
    JZ R_LEFT                ;没有，继续循环
    
    MOV AH, 0
    INT 16H
    CMP AL, 20H                   ;是否为空格
    JZ EXIT
    
    JMP R_LEFT

TOFLASH:                ;超出了条件转移的范围，利用无条件转移JMP进行转移
    JMP FLASH
TOEXIT:
    JMP EXIT
      
R_MOVE:                                ;右移
    MOV DX, 282H
    MOV BL, 10000000B        
    MOV AL, BL
    OUT DX, AL                ;7号灯亮
    
R_RIGHT: 
    ROR BL, 1                ;右移
    MOV AL, BL
    MOV DX, 282H
    OUT DX, AL                ;亮灯右移
    
    CALL DELAY                ;延时
    
    MOV DX, 280H
    IN AL, DX                ;读A口
    CMP AL, 01000000B        
    JNZ SCAN                ;状态改变，重新扫描
    
    MOV DX, 282H
    OUT DX, AL                ;???      
    MOV AH, 1        
    INT 16H                       ;检测键盘是否按下
    JZ R_RIGHT                ;没有，继续循环
    MOV AH, 0
    INT 16H
    CMP AL, 20H                   ;是否为空格
    JZ EXIT                ;退出
    
    JMP R_RIGHT

TOSCAN:
    JMP SCAN
FLASH:                                ;闪烁
    MOV DX, 282H
    MOV AL, 0
    OUT DX, AL                ;全灭
    
    CALL DELAY
    
    MOV DX, 282H
    MOV AL, 0FFH
    OUT DX, AL                ;全亮

    MOV DX, 280H
    IN AL, DX
    CMP AL, 11000000B
    JNZ TOSCAN                ;状态改变，重新扫描
    
    CALL DELAY
    
    MOV DX, 282H
    OUT DX, AL              ;???     
    MOV AH, 1
    INT 16H                    ;检测键盘是否按下       
    JZ FLASH                ;没有，继续循环
    MOV AH, 0
    INT 16H
    CMP AL, 20H                   ;是否为空格
    JZ EXIT                ;退出
    
    JMP FLASH
                     
EXIT:                    ;退出
    MOV AH,4CH
    INT 21H
    
DELAY PROC                        ;延时较长，用两个计数器
    PUSH BX
    PUSH CX
    MOV BX, 0FH
WAITB:
    MOV CX, 0FFFFH
WAITC:
    DEC CX
    JNZ WAITC                ;计数循环1
    DEC BX
    JNZ WAITB                ;计数循环2
    POP CX
    POP BX
    RET
DELAY ENDP

MAIN ENDP
CODE ENDS
    END START
