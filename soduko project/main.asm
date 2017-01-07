INCLUDE Irvine32.inc
INCLUDE macros.inc

BUFFER_SIZE = 175
.data
		buffergame byte BUFFER_SIZE DUP(?)
		buffersol byte BUFFER_SIZE DUP(?) 
		src  byte BUFFER_SIZE dup(?) 
		
		f1_1 BYTE  'diff_1_1.txt',0
		solf1_1 byte 'diff_1_1_solved.txt',0
		
		f1_2 BYTE  'diff_1_2.txt',0
		solf1_2 byte 'diff_1_2_solved.txt',0

		f1_3 BYTE  'diff_1_3.txt',0
		solf1_3 byte 'diff_1_3_solved.txt',0

		f2_1 BYTE  'diff_2_1.txt',0
		solf2_1 byte 'diff_2_1_solved.txt',0

		f2_2 BYTE  'diff_2_2.txt',0
		solf2_2 byte 'diff_2_2_solved.txt',0

		f2_3 BYTE  'diff_2_3.txt',0
		solf2_3 byte 'diff_2_3_solved.txt',0

		f3_1 BYTE  'diff_3_1.txt',0
		solf3_1 byte 'diff_3_1_solved.txt',0

		f3_2 BYTE  'diff_3_2.txt',0
		solf3_2 byte 'diff_3_2_solved.txt',0

		f3_3 BYTE  'diff_3_3.txt',0
		solf3_3 byte 'diff_3_3_solved.txt',0

		x dword ? 
		y dword ? 
		true_cnt dword 0 
		wrong_cnt dword 0
		row  dword ?
		cnt dword 0
		filehandle HANDLE ?
.code
main PROC

  mov eax , white
  call settextcolor 
  start :
	call diff 
	call readdec
  cmp eax , 4
  jae start
    
  call crlf
  mov ebx , eax 
  call Randomize               ;Sets seed
  mov  eax, 3                  ;Keeps the range 0 - 3
  call RandomRange
  
  cmp ebx, 1 
  jne  easy 
	cmp eax , 0
		jne easy1
			call easy_lvl1
		easy1:
	cmp eax , 1
		jne easy2
			call easy_lvl2 
		easy2:
	cmp eax , 2
		jne easy3
			call easy_lvl3 
		easy3:
  easy :

  cmp ebx, 2 
  jne  medium 
	cmp eax , 0
		jne medium1
			call medium_lvl1
		medium1:
	cmp eax , 1
		jne medium2
			call medium_lvl2 
		medium2:
	cmp eax , 2
		jne medium3
			call medium_lvl3 
		medium3:
   medium :

  cmp ebx, 3 
  jne  hard 
	cmp eax , 0
		jne hard1
			call hard_lvl1
		hard1:
	cmp eax , 1
		jne hard2
			call hard_lvl2 
		hard2:
	cmp eax , 2
		jne hard3
			call hard_lvl3 
		hard3:
   hard :

  call closefile
  call clrscr
  mov esi , offset buffergame 
  call drawboard
  call crlf 
  begingame :: 
  again :
	cmp eax , 3
	jbe r 
	mwriteln "Choose 1 , 2 , 3 only  "
	call crlf 
	r :
 	call showchoices										; read the choices from the user 
    call readdec  
	cmp eax , 3 
	ja again
	 cmp eax , 1 
	 jne option1
		call opt1	
		jmp  continue
	 option1 :
	  
	cmp eax , 2 
	jne option2  
		call opt2
	    jmp	begingame 
   	option2 :

	cmp eax , 3 
	jne option3
		call opt3
	option3 :

			continue :
	call crlf  

exit
main ENDP 



;/**************************************************************/
;				 difficulties procodure 
	diff proc 
			    mwriteln  "                           choose the difficulty "
				mwriteln  "press 1 for easy "
				mwriteln  "press 2 for medium "
				mwriteln  "press 3 for hard "
				call crlf 
			ret 
	diff endp

; /************************************************************/
;                      levels procedure 
	levels proc
				mwriteln  "                            choose the level "	
				mwriteln  " press 1 for level 1 "
				mwriteln  " press 2 for level 2 "
				mwriteln  " press 3 for level 3 "
				call crlf
		ret
	levels endp

; /************************************************************/
;              read file procedure  

	readfil proc								
			 call OpenInputFile			 ; Open the file for input.
			 mov fileHandle,eax       			 
			 mov edx,esi				 ;  read file  into  buffer 
			 mov ecx,BUFFER_SIZE
			 call ReadFromFile			 ; insert null terminator                
			mov byte ptr [esi +eax] ,  0 
	               	 
    ret 
   readfil endp
   	
;/**************************************************************\
showchoices proc
mwriteln "Options : "
 mwriteln "1 - finish board"
 mwriteln "2 - clear board "
 mwriteln "3 - edit board  "
ret
showchoices endp

;****************************************************************
opt1 proc 
		call clrscr
		mWrite <" solution board :",0dh,0ah,0dh,0ah>
		call crlf
		mov esi , OFFSET buffersol                        ; display the buffer
		call drawboard 
		ret
		opt1 endp

;*******************************************************************
opt2 proc 
		call clrscr
		mWriteln <"game board : ">
		call crlf 
		cld									    ; direction=forward
		mov ecx, LENGTHOF buffergame			; set REP counter
		mov edi, OFFSET buffergame
		mov esi, OFFSET src
		rep movsb						       ; clear the buffer game 
		mov esi  , offset src
		call drawboard
		call crlf 
ret
opt2 endp

;*******************************************************************
opt3 proc    

		mwrite "enter the row : " 
		call readdec			  ;  read row
		mov ebx ,  eax 
		dec ebx  

		mwrite "enter the col : "
		call readdec			    ; read col
		mov ecx  ,  ebx             ; check if the cell in the first row 
		mov ebx , 0
		cmp ecx , 0
		je row1 
			L2 :                           
				 add ebx ,  11            ; get  row index  
			loop L2
		row1 :
		add ebx , eax	                  ; add the col index 
		mov edx , offset src 		  
		add edx , ebx  
		mov edi  ,  offset buffergame 
		add edi , ebx				    ;  find exact  index buf[ebx]
		mov esi  , offset  buffersol
		add esi , ebx
		dec edx
		dec esi
		dec edi    
		mwrite "enter the value : "
		call readchar
		call  writechar
		call crlf 
		call crlf
		cmp  [esi]  , al                                 ; check if the value true in the sol 
		jne  wrong_value 
		cmp byte ptr[edx] , '0'							 ; check if the cell was 0 (avilable to edit in )
		jne wrong_value
		call clrscr
		mwriteln  "Correct answer "
		call crlf
		cmp byte ptr [edi] , '0'                        ;  check if the cell not edited previously 
		jne  s 
			mov [edi] , al 
			inc true_cnt
		s :
		jmp end_edit 	   
	wrong_value : 	
	call clrscr
	mwriteln "Wrong answer "
	call crlf 
	inc wrong_cnt
	end_edit :
	
	call drawboard_color
	cld 
	mov ecx , lengthof buffergame
	mov esi , offset buffergame 
	mov edi , offset buffersol
	repe cmpsb                                       ; check if the game is solved or continue 
	je continue 
		   jmp begingame
	continue :
	mwriteln "successfully solved  "
	mwrite "the number of false answers  : "
	mov eax , wrong_cnt
	call writedec
	call crlf  
	mwrite "the number of true answers  : "
	mov eax , true_cnt
	call writedec 
	call crlf 

ret
opt3 endp

;/***************************************************************/
;							draw board 

drawboard  proc 
		
	mov eax,1
	mov row,eax
	mov edx,0
	mov ecx ,81
	mov ebx,0
	mwriteln "    1  2  3    4  5  6    7  8  9  "
	mwriteln "  =================================="
	
	lo:		
		cmp ebx , 0 
		jne r 
		mov eax,row               
		inc row 
		call writedec 
		mwrite " | "
		r :
		mov eax , 0
		mov eax , [esi]
		call writechar
		mwrite "  "
		inc cnt 
		inc esi
		inc edi
		inc ebx
		
		cmp cnt , 3               ; seperate each 3 adjcent cells by | 
		jne llll
		mwrite "| "
		mov cnt , 0
		llll:

		cmp ebx,9             ; finish row 
		jne cont		
		call crlf
		mov ebx,0
		add esi,2
		inc edx
		
		cmp edx,3               ; seperate each 3 lines 
		jne cont
		mwriteln "  =================================="           
		mov edx,0 
		cont:
		
		dec ecx
		cmp ecx,0
		jne  lo  
				
	call crlf	 
ret
drawboard endp

;/***************************************************************/
;				draw board with color in edit 

drawboard_color  proc 
	
	mov ebx , offset buffersol
	mov esi , offset buffergame
	mov edx , offset src
	mov eax,1
	mov row,eax
	mov x,0
	mov ecx , 81
	mov y,0
	mwriteln "    1  2  3    4  5  6    7  8  9  "   ; number of coloumn
	mwriteln "  =================================="
	
	lo:		
		cmp y , 0 
		jne r 
		mov eax,row               ; number of row 
		inc row 
		call writedec 
		mwrite " | "
		r :
		
		mov eax , 0
		mov eax , [esi]        
		cmp al , [ebx]
		jne ee  
		cmp byte ptr[edx] , '0'
		jne ee 
		mov eax , 5
		call settextcolor
		ee :
		mov al , [esi]
		call writechar
		mwrite "  "
		inc cnt 
		inc ebx 
		inc edx
		inc esi
		inc edi
		inc y
		
		mov eax , white 
		call settextcolor
		cmp cnt , 3            ; seperate each 3 adjecent cells 
		jne llll
		mwrite "| "
		mov cnt , 0
		llll:

		cmp y,9             ; finish row 
		jne cont		
		call crlf
		mov y,0
		add esi,2
		add ebx,2
		add edx,2
		inc x
		
		cmp x,3             ;  draw line after 3 rows to seperate blocks
		jne cont
		mwriteln "  =================================="
		mov x,0 
		cont:
			
		dec ecx
		cmp ecx,0
		jne  lo  
				
	    call crlf	 
ret
drawboard_color endp

;/**************************************************************/
;                   load easy level 1 
		
	easy_lvl1 proc 			
		mov edx, offset f1_1 
		mov esi , offset buffergame
		call readfil
  
        mov ecx, LENGTHOF buffergame			; set REP counter
		mov esi, OFFSET buffergame
		mov edi, OFFSET src
		rep movsb

		mov edx ,  offset  solf1_1
		mov esi , offset buffersol
		call readfil
	ret 
	easy_lvl1 endp

;/**************************************************************/
;                   load easy level 2 
		
	easy_lvl2 proc 			
		mov edx, offset f1_2 
		mov esi , offset buffergame
		call readfil
  
        mov ecx, LENGTHOF buffergame			; set REP counter
		mov esi, OFFSET buffergame
		mov edi, OFFSET src
		rep movsb

		mov edx ,  offset  solf1_2
		mov esi , offset buffersol
		call readfil
	ret 
	easy_lvl2 endp
 
;/**************************************************************/
;                   load easy level 3
		
	easy_lvl3 proc 			
		mov edx, offset f1_3 
		mov esi , offset buffergame
		call readfil
  
        mov ecx, LENGTHOF buffergame			; set REP counter
		mov esi, OFFSET buffergame
		mov edi, OFFSET src
		rep movsb

		mov edx ,  offset  solf1_3
		mov esi , offset buffersol
		call readfil
	ret 
	easy_lvl3 endp


	
;/**************************************************************/
;                   load medium level 1 
		
	medium_lvl1 proc 			
		mov edx, offset f2_1 
		mov esi , offset buffergame
		call readfil
  
        mov ecx, LENGTHOF buffergame			; set REP counter
		mov esi, OFFSET buffergame
		mov edi, OFFSET src
		rep movsb

		mov edx ,  offset  solf2_1
		mov esi , offset buffersol
		call readfil
	ret 
	medium_lvl1 endp

;/**************************************************************/
;                   load medium level 2 
		
	medium_lvl2 proc 			
		mov edx, offset f2_2 
		mov esi , offset buffergame
		call readfil
  
        mov ecx, LENGTHOF buffergame			; set REP counter
		mov esi, OFFSET buffergame
		mov edi, OFFSET src
		rep movsb

		mov edx ,  offset  solf2_2
		mov esi , offset buffersol
		call readfil
	ret 
	medium_lvl2 endp

 
;/**************************************************************/
;                   load medium level 3
		
	medium_lvl3 proc 			
		mov edx, offset f2_3 
		mov esi , offset buffergame
		call readfil
  
        mov ecx, LENGTHOF buffergame			; set REP counter
		mov esi, OFFSET buffergame
		mov edi, OFFSET src
		rep movsb

		mov edx ,  offset  solf2_3
		mov esi , offset buffersol
		call readfil
	ret 
	medium_lvl3 endp

;/**************************************************************/
;                   load hard level 1 
		
	hard_lvl1 proc 			
		mov edx, offset f3_1 
		mov esi , offset buffergame
		call readfil
  
        mov ecx, LENGTHOF buffergame			; set REP counter
		mov esi, OFFSET buffergame
		mov edi, OFFSET src
		rep movsb

		mov edx ,  offset  solf3_1
		mov esi , offset buffersol
		call readfil
	ret 
	hard_lvl1 endp

;/**************************************************************/
;                   load hard level 2 
		
	hard_lvl2 proc 			
		mov edx, offset f3_2 
		mov esi , offset buffergame
		call readfil
  
        mov ecx, LENGTHOF buffergame			; set REP counter
		mov esi, OFFSET buffergame
		mov edi, OFFSET src
		rep movsb

		mov edx ,  offset  solf3_2
		mov esi , offset buffersol
		call readfil
	ret 
	hard_lvl2 endp

;/**************************************************************/
;                   load hard level 3 
		
	hard_lvl3 proc 			
		mov edx, offset f3_1 
		mov esi , offset buffergame
		call readfil
  
        mov ecx, LENGTHOF buffergame			; set REP counter
		mov esi, OFFSET buffergame
		mov edi, OFFSET src
		rep movsb

		mov edx ,  offset  solf3_1
		mov esi , offset buffersol
		call readfil
	ret 
	hard_lvl3 endp
;/*************************************************************/


END main