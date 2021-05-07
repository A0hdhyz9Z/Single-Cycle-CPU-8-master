module MUX2X5(A,B,Sel,Out);
            //insout[20:16],insout[15:11],RegDst,rw
    input [4:0]A,B;
    input Sel;
    output [4:0]Out;
    function [4:0]select;
        input [4:0]A,B;
        input Sel;
        case(Sel)
            1'b0:select = A;
            1'b1:select = B;
        endcase
    endfunction
    assign Out = select(A,B,Sel);
endmodule
