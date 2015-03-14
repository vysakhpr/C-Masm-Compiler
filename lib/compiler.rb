require_relative "compiler/version"
require_relative "compiler/symbol_tables"
require_relative "compiler/scanner"
require_relative "compiler/parser"
require_relative "compiler/semantic_analyzer"
require_relative "compiler/intermediate_code"
require_relative "compiler/code_generator"

module Compiler
  #ruby lib/compiler.rb --parse filename for parsing with parse table generation
  #ruby lib/compiler.rb filename for parsing with out parse table generation
  if ARGV.length==1
    filename=ARGV[0]
    generate_parse_table=false
  elsif ARGV.length==2
    filename=ARGV[1]
    if(ARGV[0]=="--parse")
      generate_parse_table=true
    else
      puts "Unknown Argument"
      generate_parse_table=false
    end
  else
    puts "File not Specified"
    exit
  end
  if filename.nil?
    puts "File not Specified";
    exit;
  end
  unless filename.end_with?(".c")
    puts "Incompatible File";
    exit;
  end
  #---------------------------------------------LEXICAL-ANALYSIS-------------------------------------------
  
  mode = "r";
  file = File.open("#{filename}", mode);
  words= file.read;
  file.close;
  words=words.split("\n")
  tokens=scanner(words)
  tokens=tokens.gsub("[","`")
  tokens=tokens.gsub("]","`")
  puts tokens
  #p $NUM
  #p $ID
  #p $CHARLIT
  #---------------------------------------------SYNTACTIC-ANALYSIS-----------------------------------------
  tokens=tokens.split("\n").join(" ");#
  tokens=tokens+" "
  p tokens
  productions=parser(tokens,generate_parse_table);
  puts productions
  #tree=parse_tree(productions);

  #---------------------------------------------SEMANTIC-ANALYSIS-------------------------------------------
  #semantic(productions)
  #----------------------------------------INTERMEDIATE-CODE-GENERATION-------------------------------------
  intermediate_code=intergen(productions)
  puts intermediate_code
  #p $ID.uniq
  #---------------------------------------------CODE OPTIMIZATION-------------------------------------------

  #----------------------------------------------CODE GENERATION--------------------------------------------
  #code=codegen(intermediate_code)
  #puts code
  #mode = "w";
  #file = File.open("masm/8086/out.asm", mode);
  #code.each do |c|
   #file.write(c);
   #file.write("\n")
  #end
  #file.close;
end
