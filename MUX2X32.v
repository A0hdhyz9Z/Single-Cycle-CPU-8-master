module MUX2X32(A,B,Sel,Out);
            //M2: busB,busE,ALUSrc,busB1
            //M3: busO,DataO,MemtoReg,busW
    input [31:0]A,B;
    input Sel;
    output [31:0]Out;
    function [31:0]select;
        input [31:0]A,B;
        input Sel;
        case(Sel)
            1'b0:select = A;
            1'b1:select = B;
        endcase
    endfunction
    assign Out = select(A,B,Sel);
endmodule