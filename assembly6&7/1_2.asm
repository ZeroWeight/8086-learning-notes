;实验六内容二

DATA SEGMENT
    HEAD DB 0DH, 0AH, 'D/A         A/D', 0DH, 0AH, '$'        ;表头
    INFO DB 'Please input c to get the datas, e to exit:'        ;提示
    LINE DB 0DH, 0AH, '$'                        ;空行
    SPACE DB '         $'                        ;空格
DATA ENDS

STACKS SEGMENT
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS
MAIN PROC FAR

START:
    MOV AX,DATA
    MOV DS,AX            ;载入数据
    
    MOV BX, 0            ;清零

DISPLAY:

    MOV BL,BH            ;?
    INC BH            ;记录操作次数
    MOV CX, 20            ;用于计数
    MOV AH, 9
    LEA DX, HEAD
    INT 21H               ;显示表头 
ONE_LINE:
    MOV AL, BL   
    MOV DX, 280H        
    OUT DX, AL                   ;数据送往DAC
    
    CALL SHOW                   ;显示
    CALL DELAY            ;延时
    
    MOV AH, 9
    LEA DX, SPACE
    INT 21H                   ;输出空格
    
    MOV DX, 289H
    OUT DX, AL                 ;ADC进行转换
    
    CALL DELAY            ;延时
    
    MOV DX, 289H
    IN AL, DX            ;读取转换结果
    
    CALL SHOW            ;显示
    
    MOV AH, 9
    LEA DX, LINE
    INT 21H                    ;换行
    
    ADD BL, 0FH          ;? 
    LOOP ONE_LINE             ;输出下一行
    
    MOV AH, 9
    LEA DX, INFO
    INT 21H            ;提示信息
    
ENTER:    
    MOV AH, 1
    INT 21H               ;读取输入
    CMP AL, 'C'
    JZ DISPLAY
    CMP AL, 'c'    
    JZ DISPLAY            ;继续
    CMP AL, 'E'
    JZ EXIT
    CMP AL, 'e'
    JZ EXIT            ;退出
    JMP ENTER
    
EXIT:    
    MOV AH,4CH
    INT 21H            ;退出
    
DELAY PROC                    
    PUSH AX
    PUSH BX
    PUSH CX
    MOV CX, 0FFFH        ;延时计数
WAIT:   
    LOOP WAIT
    
    POP CX
    POP BX
    POP AX
    RET
DELAY ENDP

;==========显示AL里的内容,将压缩BCD转ASCII码==========
SHOW PROC 
    PUSH AX
    AND AL, 0F0H        ;读取高位
    SHR AL, 1
    SHR AL, 1
    SHR AL, 1
    SHR AL, 1            ;把高位移至低位
    CMP AL, 09H        
    JBE DIG2            ;小于等于9跳转
    ADD AL, 07H            ;处理字母
DIG2:
    ADD AL, 30H            ;转ASCII码，如1H+30H=31H('1'),如0AH+07H+30H=41H('A')
    MOV DL, AL
    MOV AH, 2
    INT 21H            ;显示输出
    POP AX
    
    AND AL, 0FH            ;读取低位
    CMP AL, 09H
    JBE DIG1
    ADD AL, 07H            ;处理字母
DIG1:
    ADD AL, 30H            ;转ASCII码
    MOV DL, AL
    MOV AH, 2
    INT 21H            ;显示输出
    MOV DL, 'H'            ;显示说明为十六进制
    MOV AH, 2
    INT 21H            ;显示输出
    RET
SHOW ENDP

MAIN ENDP
CODE ENDS
    END START
