;实验六内容一

DATA SEGMENT

;==============正弦波数据表格，取样点128个=========================== 
BUFFER    DB    127,133,139,146,152,158,164,170,176,182,187,193        
    DB    198,203,208,213,217,221,226,229,233,236,239,242
    DB    245,247,249,251,252,253,254,254,254,254,254,253
    DB    252,251,249,247,245,242,239,236,233,229,226,221
    DB    217,213,208,203,198,193,187,182,176,170,164,158
    DB    152,146,139,133,127,121,115,108,102,96,90,84,78
    DB    72,67,61,56,51,46,41,37,33,28,25,21,18,15,12,9,7
    DB    5,3,2,1,0,0,0,0,0,1,2,3,5,7,9,12,15,18,21,25,28
    DB    33,37,41,46,51,56,61,67,72,78,84,90,96,102,108,115,121
    
;===========================提示输入=================================     
MESS DB 'please input 1 for sawt-wave, 2 for tria-wave, 3 for sine-wave, 4 to exit, other for not:', 0DH, 0AH, '$'

DATA ENDS

STACKS SEGMENT
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS

MAIN PROC FAR

START:
    MOV AX,DATA
    MOV DS,AX                ;载入数据    
    MOV AH,9
    LEA DX, MESS
    INT 21H                ;显示提示信息    
    MOV BH, 0                ;清零    
ENTER1:
    MOV AH, 0
    INT 16H                ;读取输入的字符
SELECT_WAVE:
    CMP AL, 31H
    JZ STW                       ;锯齿波
    CMP AL, 32H    
    JZ TW                         ;三角波
    CMP AL, 33H
    JZ SW                         ;正弦波
    CMP AL, 34H
    JZ EXIT                ;退出
    MOV AL, BH
    JMP SELECT_WAVE            ;保持

STW:                       ;锯齿波    
    MOV DX, 280H
    MOV BH, 1                    ;1代表锯齿波
STW_NEXT:
    MOV AL, BL    
    OUT DX, AL                ;输出计数BL，从0逐步升到0FFH后迅速降回0
    CALL DELAY                ;延时
    INC BL                ;BL为计数器，下同，从0~0FFH变化
    MOV AH, 1
    INT 16H                ;?
    JNZ ENTER1                      ;扫描输入，1次/周期
    JMP STW_NEXT            ;循环    

TW:                             ;三角波
    MOV DX, 280H
    MOV BH, 2                    ;2代表三角波
TW_UP:
    INC BL
    MOV AL, BL
    OUT DX, AL                ;输出计数BL，从0逐步升到0FFH
    CALL DELAY                ;延时
    MOV AH, 1
    INT 16H                
    JNZ ENTER1                      ;扫描输入
    CMP BL, 0FFH
    JZ TW_DOWN                ;计满，转下降
    JMP TW_UP                ;未计满，继续
TW_DOWN:
    DEC BL
    MOV AL, BL
    OUT DX, AL                ;输出计数BL，从0FFH逐步降回0
    CALL DELAY                ;延时
    MOV AH, 1
    INT 16H                
    JNZ ENTER1                      ;扫描输入
    CMP BL, 0
    JZ TW_UP                ;计满，转上升
    JMP TW_DOWN                ;未计满，继续
    
SW:                           ;正弦波
    MOV DX, 280H
    MOV CH, 127                    ;用来计数
    LEA SI, BUFFER            ;载入采样点
SW_NEXT:    
    MOV AL, [SI]
    OUT DX, AL                ;输出采样值
    CALL DELAY                ;延时
    INC SI                ;移向下一采样点
    DEC CH                ;计数减一
    JNZ SW_NEXT                ;未计满，继续
    MOV AH, 1
    INT 16H                
    JNZ ENTER1                      ;扫描输入
    JMP SW                ;输出下一正弦波
    
DELAY PROC                ;延时
    MOV CL, 0FFH            ;延时计数        
D_WAIT:    
    DEC CL
    JNZ D_WAIT
    RET
DELAY ENDP
    
EXIT:                    ;退出
    MOV AH,4CH
    INT 21H
    
MAIN ENDP  
  
CODE ENDS
    END START
