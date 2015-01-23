def codegen(intercode)
	finalcode=Array.new
	data_segment=Array.new
	code_segment=Array.new
	finalcode<<"assume cs:code,ds:data"
	dataseg(data_segment)
	codeseg(code_segment,data_segment,intercode)
	finalcode.push(*data_segment)
	finalcode.push(*code_segment)
	return finalcode
end

def dataseg(data_segment)
	data_segment<<"data segment"
	$PRINTBUF.each do |string|
		k=$PRINTBUF.index(string)
		data_segment<<"cmc_msg#{k} db 0ah,0dh,#{string}$\""
	end
    data_segment<<"cmc_out db '        $'"
	variables=$ID.uniq
	variables.each do |variable|
		case variable.type_value
		when "%d"
			data_segment<<"#{variable.lex_value} dw 02"
		when "%c"
			data_segment<<"#{variable.lex_value} dw 01"
		end
	end
end

def codeseg(code_segment,data_segment,intercode)
	code_segment<<"code segment"
	code_segment<<"start:"
    code_segment<<"mov dx,data"
    code_segment<<"mov ds,dx"
	temp_cnt=0
	string_count=0
    label_count_for_display=1
	intercode.each do |inter|
        if !(inter=~/^_t[0-9]+=[0-9]+$/).nil?
        	eq=inter.index("=")
            rvalue=inter[eq+1..-1]
            if !(rvalue=~/^[0-9]+$/).nil?
            	lvalue=inter[0..eq-1]
            	if temp_cnt==0
            		data_segment<<"cmc#{lvalue} dw 02"
            		temp_cnt=1
            	end
                code_segment<<"mov ax,#{rvalue}"
            	code_segment<<"mov cmc#{lvalue},ax"
            	#temp_cnt=temp_cnt+1
            end
        elsif !(inter=~/[a-zA-Z][a-zA-Z0-9]*=_t[0-9]+$/).nil?
        	eq=inter.index("=")
        	lvalue=inter[0..eq-1]
        	rvalue=inter[eq+1..-1]
        	if !data_segment.include?("#{lvalue} dw 02")
        	 	data_segment<<"#{lvalue} dw 02"
        	elsif !data_segment.include?("cmc#{rvalue} dw 02")
        		data_segment<<"cmc#{rvalue} dw 02"
        	end
            code_segment<<"mov ax,cmc#{rvalue}"
 			code_segment<<"mov #{lvalue},ax"
 		elsif !(inter=~/_t[0-9]+=_t[0-9]+[*+-]_t[0-9]+/).nil?
             #puts inter
             eq=inter.index('=')
             lvalue=inter[0..eq-1]
             rvalue=inter[eq+1..-1]
            if rq=rvalue.index("+")
             	first_rvalue=rvalue[0..rq-1]
             	second_rvalue=rvalue[rq+1..-1]
                code_segment<<"mov ax,cmc#{first_rvalue}"
                code_segment<<"mov bx,cmc#{second_rvalue}"
             	code_segment<<"add ax,bx"
             	code_segment<<"mov cmc#{lvalue},ax" 
            elsif rq=rvalue.index("-")
             	first_rvalue=rvalue[0..rq-1]
             	second_rvalue=rvalue[rq+1..-1]
             	code_segment<<"mov ax,cmc#{first_rvalue}"
                code_segment<<"mov bx,cmc#{second_rvalue}"
                code_segment<<"sub ax,bx"
                code_segment<<"mov cmc#{lvalue},ax"
            elsif rq=rvalue.index("*")
             	first_rvalue=rvalue[0..rq-1]
             	second_rvalue=rvalue[rq+1..-1]
                code_segment<<"mov ax,cmc#{first_rvalue}"
                code_segment<<"mov bx,cmc#{second_rvalue}"
             	code_segment<<"mul bx"
             	code_segment<<"mov cmc#{lvalue},ax"	
             end
            if !data_segment.include?("cmc#{first_rvalue} dw 02")
             	data_segment<<"cmc#{first_rvalue} dw 02"
            elsif !data_segment.include?("cmc#{second_rvalue} dw 02")
             	data_segment<<"cmc#{second_rvalue} dw 02"
            elsif !data_segment.include?("cmc#{lvalue} dw 02")
             	data_segment<<"cmc#{lvalue} dw 02"
            end
         else
         	#puts inter
         	if !(inter=~/^_t[0-9]+=[a-zA-Z0-9][a-zA-Z0-9_]*/).nil?
                eq=inter.index("=")
        		lvalue=inter[0..eq-1]
        		rvalue=inter[eq+1..-1]
                code_segment<<"mov ax,#{rvalue}"
        		code_segment<<"mov cmc#{lvalue},ax"
                if !data_segment.include?("#{rvalue} dw 02")
             		data_segment<<"#{rvalue} dw 02"
             	elsif !data_segment.include?("cmc#{lvalue} dw 02")
             		data_segment<<"cmc#{lvalue} dw 02"
             	end
            elsif !(inter=~/^_printString_/).nil?
            	#print inter
            	code_segment<<"lea dx,cmc_msg#{string_count}"
            	code_segment<<"mov ah,09h"
            	code_segment<<"int 21h"
            	string_count=string_count+1
            elsif !(inter=~/^_printInteger_/).nil?
                code_segment<<"lea di,cmc_out"
                code_segment<<"add di,0007h"
                code_segment<<"mov ax,#{inter[15..-1]}"
                code_segment<<"mov bx,000ah"
                code_segment<<"out#{label_count_for_display}: xor dx,dx"
                code_segment<<"div bx"
                code_segment<<"add dx,0030h"
                code_segment<<"dec di"
                code_segment<<"mov [di],dl"
                code_segment<<"test ax,ax"
                code_segment<<"jnz out#{label_count_for_display}"
                code_segment<<"mov ah,09h"
                code_segment<<"mov dx, offset cmc_out"
                code_segment<<"int 21h"
                code_segment<<"lea si,cmc_out"
                code_segment<<"mov cx,08h"
                code_segment<<"ou#{label_count_for_display}: mov al,32"
                code_segment<<"mov [si],al"
                code_segment<<"inc si"
                code_segment<<"dec cx"
                code_segment<<"jnz ou#{label_count_for_display}"
                code_segment<<"mov al,36"
                code_segment<<"mov [si],al"
                label_count_for_display=label_count_for_display+1
            end
        end
	end
	

    data_segment<<"data ends"
    code_segment<<"mov ah,4ch"
    code_segment<<"int 21h"
    code_segment<<"code ends"
    code_segment<<"end start"
end
