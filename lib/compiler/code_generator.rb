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
    k=0
    $PRINTBUF.each do |string|
        #k=$PRINTBUF.index(string)
        if string.length==1
            string="\" "
        end
        string[-1]="$\""
        string_array=string.split(/\\[nrt]/)
        format=string.scan(/\\[nrt]/)
        length=string_array.length
        split_array=[]
        p string_array
        p format
        if format.empty?
            data_segment<<"cmc_msg#{k} db #{string}"
        else
            temp_string="cmc_msg#{k} db "
            for i in  (0..length-1)
                split_array<<string_array[i]
                split_array<<format[i] if format[i]!=nil
            end
            
            p split_array   
            for x in split_array
                f=0
                if !x.empty?
                    case x
                    when "\\n"
                        x="10"
                        f=1
                    when "\\r"
                        x="13"
                        f=1
                    when "\\t"
                        x="9"
                        f=1
                    end
                    if f==0
                        if  x==split_array.first 
                            if x != "\""
                                temp_string=temp_string+x+"\"" 
                                temp_string=temp_string+"," if x !=split_array.last
                            end
                        elsif x==split_array.last
                            temp_string=temp_string+"\""+x  
                            temp_string=temp_string+"," if x !=split_array.last
                        else
                            temp_string=temp_string+"\""+x+"\""  
                            temp_string=temp_string+"," if x !=split_array.last
                        end
                    else
                        temp_string=temp_string+x  
                        temp_string=temp_string+"," if x !=split_array.last
                    end
                     
                end
            end
            data_segment<<temp_string
        end
        k=k+1
    end
    data_segment<<"cmc_out db '        $'"
    data_segment<<"cmc_in db '        $'"
    data_segment<<"cmc_temp db 01"
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
    rel_expr_count=0
    not_count=0
    if_count=0
    total_if_count=0
    label_count_for_display=1
    label_count_for_scan=1
    intercode.each do |inter|
        if !(inter=~/^_t[0-9]+=[0-9]+$/).nil?
            eq=inter.index("=")
            rvalue=inter[eq+1..-1]
            lvalue=inter[0..eq-1]
            if !(rvalue=~/^[0-9]+$/).nil?
                if temp_cnt==0
                    temp_cnt=1
                end
                code_segment<<"mov ax,#{rvalue}"
                code_segment<<"mov cmc#{lvalue},ax"
                #temp_cnt=temp_cnt+1
            end
            if !data_segment.include?("cmc#{lvalue} dw 02")
                data_segment<<"cmc#{lvalue} dw 02"
            end
            #print inter
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
        #relational expression evaluation(&&,||)
        elsif !(inter=~/^_t[0-9]+=_t[0-9]+([&][&]|[|][|])_t[0-9]+$/).nil?
            eq=inter.index('=')
            lvalue=inter[0..eq-1]
            rvalue=inter[eq+1..-1]
            relop=rvalue.index(/([&][&]|[|][|])/)
            llt=rvalue[0..relop-1]
            rlt=rvalue[relop+1..-1]
            rlt=rlt.gsub(/([&]|[|])/,"")
            code_segment<<"mov ax,cmc#{llt}"
            code_segment<<"mov bx,cmc#{rlt}"
            if !data_segment.include?("cmc#{llt} dw 02")
                data_segment<<"cmc#{llt} dw 02"
            elsif !data_segment.include?("cmc#{rlt} dw 02")
                data_segment<<"cmc#{rlt} dw 02"    
            end
            if rvalue.index(/[&][&]/)
               code_segment<<"and ax,bx"
               code_segment<<"mov cmc#{lvalue},ax"
            elsif rvalue.index(/[|][|]/)
               code_segment<<"or ax,bx"
               code_segment<<"mov cmc#{lvalue},ax"
            end      
        #relational expression evaluation(<,<=,>,>=,==,!=)
        elsif !(inter=~/^_t[0-9]+=_t[0-9]+([<>]|[<>=]=)_t[0-9]+$/).nil?
            eq=inter.index('=')
            lvalue=inter[0..eq-1]
            rvalue=inter[eq+1..-1]
            relop=rvalue.index(/([<>=]|[<>]=)/)
            llt=rvalue[0..relop-1]
            rlt=rvalue[relop+1..-1]
            rlt=rlt.gsub(/([<>=]|[<>]=)/,"")
            code_segment<<"mov ax,cmc#{llt}"
            code_segment<<"mov bx,cmc#{rlt}"
            if !data_segment.include?("cmc#{llt} dw 02")
                data_segment<<"cmc#{llt} dw 02"
            elsif !data_segment.include?("cmc#{rlt} dw 02")
                data_segment<<"cmc#{rlt} dw 02"    
            end          
            code_segment<<"cmp ax,bx"
            if rvalue.index(/([>][=])/)
                code_segment<<"jge cmc_rel#{rel_expr_count}" 
            elsif rvalue.index(/[>]/)   
                code_segment<<"jg cmc_rel#{rel_expr_count}"
            elsif rvalue.index(/[<][=]/)
                code_segment<<"jle cmc_rel#{rel_expr_count}"
            elsif rvalue.index(/[<]/)
                code_segment<<"jl cmc_rel#{rel_expr_count}"
            elsif rvalue.index(/[=][=]/)
                code_segment<<"je cmc_rel#{rel_expr_count}"
            elsif rvalue.index(/[!][=]/)
                code_segment<<"jne cmc_rel#{rel_expr_count}"          
            end 
                code_segment<<"mov cmc#{lvalue},0000h"
                code_segment<<"jmp cmc_rel#{rel_expr_count+1}"
                code_segment<<"cmc_rel#{rel_expr_count}:"
                code_segment<<"mov cmc#{lvalue},0001h"
                code_segment<<"cmc_rel#{rel_expr_count+1}:"
                rel_expr_count=rel_expr_count+2
                if !data_segment.include?("cmc#{lvalue} dw 02")
                    data_segment<<"cmc#{lvalue} dw 02"
                    #print "hrk"
                end
        #negation evaluation
        elsif !(inter=~/^_t[0-9]+=_not_ _t[0-9]+/).nil?
            eq=inter.index('=')
            lvalue=inter[1..eq-1]
            rvalue=inter[eq+1..-1]
            rvalue=rvalue.gsub("_not_ _","")#do not change space of code {_not_ } 
            code_segment<<"cmp cmc_#{rvalue},0000h"
            code_segment<<"jz cmc_not#{not_count}"
            code_segment<<"mov cmc_#{lvalue},0000h"
            code_segment<<"jmp cmc_not#{not_count+1}"
            code_segment<<"cmc_not#{not_count}:"
            code_segment<<"mov cmc_#{lvalue},0001h"
            code_segment<<"cmc_not#{not_count+1}:"
            not_count=not_count+2
            if !data_segment.include?("cmc_#{rvalue} dw 02")
                data_segment<<"cmc_#{rvalue} dw 02"                 
            end  
        #if-elseif-else evaluation-----------------------------------------#
        elsif !(inter=~/^_if_ _t[0-9]+ _then$/).nil?                         #
            value=inter[5..-1].gsub(" _then","")                             #
            code_segment<<"cmp cmc#{value},0001h"                           #
            code_segment<<"jnge cmc_if#{if_count}"
            if !data_segment.include?("cmc#{value} dw 02")
                data_segment<<"cmc#{value} dw 02"
            end
            #print inter                               #
        elsif !(inter=~/^_end_if_$/).nil?
            code_segment<<"jmp cmc#{total_if_count}"                                   #
            code_segment<<"cmc_if#{if_count}:"
            if !intercode.include?("_end_else_")
                code_segment<<"cmc#{total_if_count}:"
                total_if_count=total_if_count+1
            end
            if_count=if_count+1
        elsif !(inter=~/^_else_if_ _t[0-9]+ _then$/).nil?
            value=inter[10..-1].gsub(" _then","")
            code_segment<<"cmp cmc#{value},0001h"
            code_segment<<"jnge cmc_if#{if_count}"
            if !data_segment.include?("cmc#{value} dw 02")
                data_segment<<"cmc#{value} dw 02"
            end                              #
            #print inter
        elsif !(inter=~/^_end_elseif_$/).nil?
            code_segment<<"jmp cmc#{total_if_count}"                               #
            code_segment<<"cmc_if#{if_count}:"                                  #
            if_count=if_count+1
            if !intercode.include?("_end_else_")
                code_segment<<"cmc#{total_if_count}:"
                total_if_count=total_if_count+1
            end
        elsif !(inter=~/^_end_else/).nil?
            code_segment<<"cmc#{total_if_count}:"
            total_if_count=total_if_count+1                                                                                             #
        #-------------------------------------------------------------------                             
        elsif !(inter=~/^_goto_ _switch_label_[0-9]+$/).nil?
            code_segment<<"jmp cmc#{inter.gsub('_goto_ ','')}"
        elsif !(inter=~/^_goto_ _break_label_[0-9]+$/).nil?
            code_segment<<"jmp cmc#{inter.gsub('_goto_ ','')}"
        elsif !(inter=~/^_switch_label_[0-9]+:$/).nil?
            code_segment<<"cmc#{inter}"
        elsif !(inter=~/^_break_label_[0-9]+:$/).nil?
            code_segment<<"cmc#{inter}"
        else
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
            elsif !(inter=~/^_printChar_/).nil?
                code_segment<<"mov bx,#{inter[12..-1]}"
                code_segment<<"mov ah,02h"
                code_segment<<"mov dl,al"
                code_segment<<"int 21h"
            elsif !(inter=~/^_scanInteger_/).nil?
                code_segment<<"lea si,cmc_in"               
                code_segment<<"mov dl,00h"
                code_segment<<"ins#{label_count_for_scan}:"
                code_segment<<"mov ah,01h"
                code_segment<<"int 21h"
                code_segment<<"cmp al,0dh"
                code_segment<<"jz insert#{label_count_for_scan}"
                code_segment<<"sub al,30h"
                code_segment<<"mov [si],al"
                code_segment<<"inc dl"
                code_segment<<"inc si"
                code_segment<<"jmp ins#{label_count_for_scan}"
                code_segment<<"insert#{label_count_for_scan}:"
                code_segment<<"dec si"
                code_segment<<"mov cx,0000h"
                code_segment<<"mov bx,0001h"
                code_segment<<"in#{label_count_for_scan}:"
                code_segment<<"mov al,[si]"
                code_segment<<"mov ah,00h"
                code_segment<<"dec si"
                code_segment<<"mov cmc_temp,dl"
                code_segment<<"mul bx"
                code_segment<<"mov dl,cmc_temp"
                code_segment<<"add cx,ax"
                code_segment<<"mov ax,000ah"
                code_segment<<"mov cmc_temp,dl"
                code_segment<<"mul bx"
                code_segment<<"mov dl,cmc_temp"
                code_segment<<"mov bx,ax"
                code_segment<<"dec dl"
                code_segment<<"jnz in#{label_count_for_scan}"
                code_segment<<"mov #{inter[14..-1]},cx"
                label_count_for_scan=label_count_for_scan+1
            elsif !(inter=~/^_scanChar_/).nil?
                code_segment<<"mov ah,01h"
                code_segment<<"int 21h"
                code_segment<<"mov ah,00h"
                code_segment<<"mov #{inter[11..-1]},al"
            elsif !(inter=~/^_scanFloat_/).nil?
            end

        end
    end
    data_segment<<"data ends"
    code_segment<<"mov ah,4ch"
    code_segment<<"int 21h"
    code_segment<<"code ends"
    code_segment<<"end start"
end