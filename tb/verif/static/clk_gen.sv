module clk_gen
    (
        output reg  CLK
    );
        
        timeunit 1ns;
        timeprecision 1ns;
        
        initial
        begin
            CLK = 0;
            forever
            begin
                #5 CLK = ~CLK;
            end
        end
        
    
endmodule: clk_gen