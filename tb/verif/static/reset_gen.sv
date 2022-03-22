module reset_gen
    (
        output reg  RESET,
        input  reg  CLK_IN
    );
        
        initial
        begin
            RESET = 1;
            
            RESET = ~RESET;
            
            repeat ( 2 )
            begin
                @(posedge CLK_IN);
            end
            
            RESET = ~RESET;
        end
        
    
    endmodule: reset_gen
    