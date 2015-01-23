require_relative "compiler/version"
require_relative "compiler/symbol_tables"
require_relative "compiler/scanner"
require_relative "compiler/parser"
require_relative "compiler/semantic_analyzer"
require_relative "compiler/intermediate_code"
require_relative "compiler/code_generator"

module Compiler
  if ARGV[0].nil?
    puts "File not Specified";
    exit;
  end
  unless ARGV[0].end_with?(".c")
    puts "Incompatible File";
    exit;
  end

  #---------------------------------------------LEXICAL-ANALYSIS-------------------------------------------
  
  mode = "r";
  file = File.open("#{ARGV[0]}", mode);
  words= file.read;
  file.close;
  words=words.split("\n")
  tokens=scanner(words)
  #p $NUM
  #p $ID
  #---------------------------------------------SYNTACTIC-ANALYSIS-----------------------------------------
  tokens=tokens.split("\n").join(" ");
  tokens=tokens+" "
  #p tokens
  productions=parser(tokens);
  #puts productions
  #tree=parse_tree(productions);

  #---------------------------------------------SEMANTIC-ANALYSIS-------------------------------------------
  semantic(productions)
  #----------------------------------------INTERMEDIATE-CODE-GENERATION-------------------------------------
  intermediate_code=intergen(productions)
  puts intermediate_code
  #p $ID.uniq
  #---------------------------------------------CODE OPTIMIZATION-------------------------------------------

  #----------------------------------------------CODE GENERATION--------------------------------------------
  code=codegen(intermediate_code)
  #puts code
  mode = "w";
  file = File.open("masm/8086/out.asm", mode);
  code.each do |c|
    file.write(c+"\n");
  end
  file.close;
  #puts $PRINTBUF
end
