def printbuffer(production)
    literal=$LIT.dup
    printbuff=[]
    for x in production
        if x.include? " string "
            l=literal.shift
            if x.include? " printf "
                printbuff<<l
            end
        end
    end
    return printbuff
end

def intergen(production)
	number=$NUM.dup
    identifier=$ID.dup
    inter_code=Array.new
    temp=Array.new
    print_var=Array.new
    #fact_value=Array.new
    #term_value=Array.new
    #expr_value=Array.new
    printbuff=printbuffer(production)
    switch_stack=Array.new 
    switch_count=0
    is_switch_statement=0
    break_flag=0
    break_label=0
    is_default_flag=0
    loop_stack=Array.new
	for x in production
        #if x.start_with?("STMT@@")
         #   if is_switch_statement==1
          #      inter_code<<"_switch_label_#{switch_count-1}:"
           #     is_switch_statement=0
            #end
        #end
        if x.start_with?("STMTS@@ IFSTMT ")
            inter_code<<"_end_if_"
        end
        if x.start_with?("STMTS@@ SWITCHSTMT ")
            inter_code<<"_end_if_"
            if break_flag==1
                inter_code<<"_break_label_#{break_label}"
                break_label=break_label+1
                break_flag=0
            end
        end
        case x
        when "NAME@@ main "
            temp_count=0;
        when "FNAME@@ NAME ( ) "
            
        when "DATATYPE@@ char "
            
        when "DATATYPE@@ void "
            
        when "DATATYPE@@ int "

        when "DATATYPE@@ float " 
            
        when "IDS@@ id "
            id_object=identifier.shift
            print_var.push(id_object)
        when "IDS@@ ID , IDS "
                    
        when "STMT@@ DATATYPE IDS "
            print_var=[]
        when "ID@@ id "
        	id_object=identifier.shift
            print_var.push(id_object)
        when "FACTOR@@ num "
            num_object=number.shift
            inter_code<< "_t#{temp_count}=#{num_object.value}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
            #fact_value.push(num_object.value)
        when "FACTOR@@ id "
            ids_object=identifier.shift;
            inter_code<< "_t#{temp_count}=#{ids_object.lex_value}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
            #fact_value.push(ids_object.lex_value);
        when "TERM@@ FACTOR "
            #term_value.push(fact_value.pop)
        when "EXPR@@ TERM "
            #expr_value.push(term_value.pop)
        when "EXPR@@ EXPR + TERM "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}+#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "EXPR@@ EXPR - TERM "           
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}-#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "TERM@@ TERM / FACTOR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}/#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "TERM@@ TERM * FACTOR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}*#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "FACTOR@@ ( EXPR ) "
        	fact_value.push(expr_value.pop)
        when "STMT@@ ID = EXPR "
        	id_lexeme=id_object.lex_value
            inter_code<< "#{id_lexeme}=#{temp.pop}";
            temp_count=0;
            print_var=[]
        when "RELNEG@@ RELNEG < RELNEG "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}<#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ EXPR < EXPR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}<#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ RELNEG > RELNEG "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}>#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ EXPR > EXPR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}>#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ RELNEG < = RELNEG "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}<=#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ EXPR < = EXPR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}<=#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ RELNEG > = RELNEG "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}>=#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ EXPR > = EXPR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}>=#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ RELNEG = = RELNEG "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}==#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ EXPR = = EXPR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}==#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ RELNEG ! = RELNEG "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}!=#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELNEG@@ EXPR ! = EXPR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}!=#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELEXPR@@ RELEXPR | | RELTERM "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}||#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=0;
        when "RELEXPR@@ RELTERM "
            temp_count=0
        when "RELTERM@@ RELTERM & & RELFACTOR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}&&#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "RELFACTOR@@ ! RELNEG "
            t0=temp.pop
            inter_code<<"_t#{temp_count}=_not_ #{t0}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1
        when "IFSTMT@@ if ( RELEXPR ) "
            t0=temp.pop
            inter_code<<"_if_ #{t0} _then"
        when "ELSEIFSTMT@@ else if ( RELEXPR ) "
            t0=temp.pop
            inter_code<<"_else_if_ #{t0} _then"
        when "ELSE@@ else "
        when "IFBLOCK@@ { STMTS } "
        when "ELSEIFBLOCK@@ { STMTS } "
        when "ELSEBLOCK@@ { STMTS } "
        when "SWITCHEXPR@@ num "
            num_object=number.shift
            switch_stack.push(num_object.value);
            #fact_value.push(num_object.value)
        when "SWITCHEXPR@@ id "
            ids_object=identifier.shift;
            switch_stack.push(ids_object.lex_value);
        when "SWITCHSTMT@@ switch ( SWITCHEXPR ) " 
            switch_var=switch_stack.pop
            switch_stack.push(switch_var)
        when "IDNUM@@ num "
            num_object=number.shift
            inter_code<< "_t#{temp_count}=#{num_object.value}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
            #fact_value.push(num_object.value)
        when "IDNUM@@ id "
            ids_object=identifier.shift;
            inter_code<< "_t#{temp_count}=#{ids_object.lex_value}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "CASEBLOCK@@ case IDNUM : "
            t0=temp.pop
            switch_var=switch_stack.pop
            inter_code<<"_s=#{t0}!=#{switch_var}"
            inter_code<<"_if_ _s"
            inter_code<<"_goto_ _switch_label_#{switch_count}"
            inter_code<<"_end_if_"
            is_switch_statement=1
            switch_count=switch_count+1
            switch_stack.push(switch_var)
        when "STMTS@@ SWITCHSTMT SWITCHBLOCK "
            switch_stack.pop
        when "STMTS@@ SWITCHSTMT SWITCHBLOCK STMTS "
            switch_stack.pop
        when "CASEBLOCK@@ default : " 
            is_default_flag=1
            switch_count=switch_count+1
            is_switch_statement=1
        when "STMT@@ printf ( string , IDS ) "
            string=printbuff.shift.lit_value
            string_array=string.split(/%[dcfu]/)
            format=string.scan(/%[dcfu]/)
            length=string_array.length
            inter_code<<"_printString_ #{string_array[0]}\""
            $PRINTBUF<<string_array[0]
            for i in  (1..length-1)
                object=print_var.shift
                case format.pop
                when "%d"
                    inter_code<<"_printInteger_ #{object.value}" if object.is_number?
                    inter_code<<"_printInteger_ #{object.lex_value}" if object.is_id?
                when "%f"
                    inter_code<<"_printFloat_ #{object.value}" if object.is_number?
                    inter_code<<"_printFloat_ #{object.lex_value}" if object.is_id?
                when "%c"
                    inter_code<<"_printChar_ #{object.value}" if object.is_number?
                    inter_code<<"_printChar_ #{object.lex_value}" if object.is_id?
                end
                if i!=length-1
                    inter_code<<"_printString_ \"#{string_array[i]}\"" 
                    $PRINTBUF<<"\"#{string_array[i]}"
                else
                    inter_code<<"_printString_ \"#{string_array[i]}"
                    string_array[i][-1]=" "
                    $PRINTBUF<<"\"#{string_array[i]}" 
                end
            end
        when "STMT@@ printf ( string ) "
            string=printbuff.shift.lit_value
            inter_code<<"_printString_ #{string}"
            $PRINTBUF<<string

        when "STMT-> break "
            break_flag=1
        end

        if x.start_with?("CASESTMTS@@ CASEBLOCK ") or x.start_with?("CASESTMTS@@ CASESTMTS CASEBLOCK ")
            if is_default_flag==1
                is_default_flag=0
            else
                inter_code<<"_switch_label_#{switch_count-1}:"
            end
        end

    end 
    return inter_code   
end
