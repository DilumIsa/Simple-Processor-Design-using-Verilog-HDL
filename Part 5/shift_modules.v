// Computer Architecture (CO224) - Lab 05 Part-5
// Design: Shiftting modules of Simple Processor
// Group: Group-49 
// Reg. No.: E/19/038 and E/19/256


//Left shift functional unit for ALU
//Does Logical left shift operation on data1 based on offset provided in data2
module LEFT_SHIFT(data1 , data2 , OutPut);

	//Declaration of input and output ports
    input [7:0] data1;
    input [7:0] data2;
    output  [7:0] OutPut;
    
	//Intermediate connections between MUX layers 
    wire [7:0] lOut [2:0];
    wire s[7:0];

	//MUX Layer 1
    mux2x1 layer00(lOut[0][0],data1[0],1'b0,data2[0]);
    mux2x1 layer01(lOut[0][1],data1[1],data1[0],data2[0]);
    mux2x1 layer02(lOut[0][2],data1[2],data1[1],data2[0]);
    mux2x1 layer03(lOut[0][3],data1[3],data1[2],data2[0]);
    mux2x1 layer04(lOut[0][4],data1[4],data1[3],data2[0]);
    mux2x1 layer05(lOut[0][5],data1[5],data1[4],data2[0]);
    mux2x1 layer06(lOut[0][6],data1[6],data1[5],data2[0]);
    mux2x1 layer07(lOut[0][7],data1[7],data1[6],data2[0]);
  
	//MUX Layer 2
    mux2x1 layer10(lOut[1][0],lOut[0][0],1'b0,data2[1]);    
    mux2x1 layer11(lOut[1][1],lOut[0][1],1'b0,data2[1]);
    mux2x1 layer12(lOut[1][2],lOut[0][2],lOut[0][0],data2[1]);
    mux2x1 layer13(lOut[1][3],lOut[0][3],lOut[0][1],data2[1]);
    mux2x1 layer14(lOut[1][4],lOut[0][4],lOut[0][2],data2[1]);
    mux2x1 layer15(lOut[1][5],lOut[0][5],lOut[0][3],data2[1]);
    mux2x1 layer16(lOut[1][6],lOut[0][6],lOut[0][4],data2[1]);
    mux2x1 layer17(lOut[1][7],lOut[0][7],lOut[0][5],data2[1]);
  
	//MUX Layer 3
    mux2x1 layer20(lOut[2][0],lOut[1][0],1'b0,data2[2]);    
    mux2x1 layer21(lOut[2][1],lOut[1][1],1'b0,data2[2]);
    mux2x1 layer22(lOut[2][2],lOut[1][2],1'b0,data2[2]);
    mux2x1 layer23(lOut[2][3],lOut[1][3],1'b0,data2[2]);
    mux2x1 layer24(lOut[2][4],lOut[1][4],lOut[1][0],data2[2]);
    mux2x1 layer25(lOut[2][5],lOut[1][5],lOut[1][1],data2[2]);
    mux2x1 layer26(lOut[2][6],lOut[1][6],lOut[1][2],data2[2]);
    mux2x1 layer27(lOut[2][7],lOut[1][7],lOut[1][3],data2[2]);

	//Assigning final output after 2 time unit delay
	//If shift amount is 0x08 output is all zeros
    //Contains a delay of #2 time units
    assign #2 OutPut= (data2==8'd8)? 8'd0:lOut[2];
	
endmodule

///////////////////////////////////////////////////////////////////////////////////////////////

//Right shift functional unit for ALU
module RIGHT_SHIFT(data1 , data2 , OutPut, RSC);

    // Declaration of input and output ports
    input [7:0] data1;
    input [7:0] data2;
    input [1:0] RSC;
    output reg [7:0] OutPut;

    // Intermediate connections between MUX layers
    wire [7:0] lOut [2:0]; // wire out for the logical right shift

    output [7:0] rotateOut;
    output [7:0] arithmeticOut;

    Rotate_RIGHT_SHIFT my_rotate(data1 , data2 , rotateOut);
    Arithmetic_RIGHT_SHIFT my_arithmetic(data1 , data2 , arithmeticOut);

    // Logic Right Shift Mux Layers
    // MUX Layer 1
    mux2x1 layer00(lOut[2][0], lOut[1][0], lOut[1][4], data2[2]);
    mux2x1 layer01(lOut[2][1], lOut[1][1], lOut[1][5], data2[2]);
    mux2x1 layer02(lOut[2][2], lOut[1][2], lOut[1][6], data2[2]);
    mux2x1 layer03(lOut[2][3], lOut[1][3], lOut[1][7], data2[2]);
    mux2x1 layer04(lOut[2][4], lOut[1][4], 1'b0, data2[2]);
    mux2x1 layer05(lOut[2][5], lOut[1][5], 1'b0, data2[2]);
    mux2x1 layer06(lOut[2][6], lOut[1][6], 1'b0, data2[2]);
    mux2x1 layer07(lOut[2][7], lOut[1][7], 1'b0, data2[2]);

    // MUX Layer 2
    mux2x1 layer08(lOut[1][0], lOut[0][0], lOut[0][2], data2[1]);
    mux2x1 layer09(lOut[1][1], lOut[0][1], lOut[0][3], data2[1]);
    mux2x1 layer10(lOut[1][2], lOut[0][2], lOut[0][4], data2[1]);
    mux2x1 layer11(lOut[1][3], lOut[0][3], lOut[0][5], data2[1]);
    mux2x1 layer12(lOut[1][4], lOut[0][4], lOut[0][6], data2[1]);
    mux2x1 layer13(lOut[1][5], lOut[0][5], lOut[0][7], data2[1]);
    mux2x1 layer14(lOut[1][6], lOut[0][6], 1'b0, data2[1]);
    mux2x1 layer15(lOut[1][7], lOut[0][7], 1'b0, data2[1]);

    // MUX Layer 3
    mux2x1 layer16(lOut[0][0], data1[0], data1[1], data2[0]);
    mux2x1 layer17(lOut[0][1], data1[1], data1[2], data2[0]);
    mux2x1 layer18(lOut[0][2], data1[2], data1[3], data2[0]);
    mux2x1 layer19(lOut[0][3], data1[3], data1[4], data2[0]);
    mux2x1 layer20(lOut[0][4], data1[4], data1[5], data2[0]);
    mux2x1 layer21(lOut[0][5], data1[5], data1[6], data2[0]);
    mux2x1 layer22(lOut[0][6], data1[6], data1[7], data2[0]);
    mux2x1 layer23(lOut[0][7], data1[7], 1'b0, data2[0]);


//Combination for the Right shifting Types
//Operation: RSC = 01 : Logical
//			 RSC = 10 : Arithmetic
//			 RSC = 11 : Rotate
    always @* begin
        case(RSC)
            2'b11: #2 OutPut = rotateOut; //gets output as the rotate right shifting
            2'b10: //#2 OutPut = rOut[2];
                if(data1[7] == 1'b1) begin // check the MSB of data1 is 1 or not
                    if(data2 > 8'd8) begin  // If the shifting value is greater than or equal to 8, it gets all ones due to MSB is 1
                        #2 OutPut = 8'b11111111; 
                    end else begin
                        #2 OutPut = arithmeticOut; // If the shifting value is less than 8, it gets output as the arithmetic right shifting due to MSB is 1
                    end
                end else begin
                    if(data2 >= 8'd8) begin // If the shifting value is greater than or equal to 8, it gets all zero due to MSB is 0
                        #2 OutPut = 8'b00000000;
                    end else begin
                        #2 OutPut = lOut[2]; // If the shifting value is less than 8, it gets output same as the logical right shifting due to MSB is 0
                    end
                end
            2'b01:
                if(data2 >= 8'd8) begin 
                    #2 OutPut = 8'b00000000; // If the shifting value is 8 or more than that it gets all zero
                end else begin
                    #2 OutPut = lOut[2]; // If the shifting value is less than 8, it gets output as the logical right shifting
                end
        endcase
    end

endmodule




//Rotate Right shift functional unit for Right shift module
module Rotate_RIGHT_SHIFT(data1 , data2 , OutPut);

  // Declaration of input and output ports
    input [7:0] data1;
    input [7:0] data2;
    output [7:0] OutPut;

    // Intermediate connections between MUX layers
    wire [7:0] rOut [2:0]; // wire out for the rotate right shift

     //Rotate Right Shift Mux Layers
    // MUX Layer 1
    mux2x1 layer48(rOut[2][0], rOut[1][0], rOut[1][4], data2[2]);
    mux2x1 layer49(rOut[2][1], rOut[1][1], rOut[1][5], data2[2]);
    mux2x1 layer50(rOut[2][2], rOut[1][2], rOut[1][6], data2[2]);
    mux2x1 layer51(rOut[2][3], rOut[1][3], rOut[1][7], data2[2]);
    mux2x1 layer52(rOut[2][4], rOut[1][4], rOut[1][0], data2[2]);
    mux2x1 layer53(rOut[2][5], rOut[1][5], rOut[1][1], data2[2]);
    mux2x1 layer54(rOut[2][6], rOut[1][6], rOut[1][2], data2[2]);
    mux2x1 layer55(rOut[2][7], rOut[1][7], rOut[1][3], data2[2]);

    // MUX Layer 2
    mux2x1 layer56(rOut[1][0], rOut[0][0], rOut[0][2], data2[1]);
    mux2x1 layer57(rOut[1][1], rOut[0][1], rOut[0][3], data2[1]);
    mux2x1 layer58(rOut[1][2], rOut[0][2], rOut[0][4], data2[1]);
    mux2x1 layer59(rOut[1][3], rOut[0][3], rOut[0][5], data2[1]);
    mux2x1 layer60(rOut[1][4], rOut[0][4], rOut[0][6], data2[1]);
    mux2x1 layer61(rOut[1][5], rOut[0][5], rOut[0][7], data2[1]);
    mux2x1 layer62(rOut[1][6], rOut[0][6], rOut[0][0], data2[1]);
    mux2x1 layer63(rOut[1][7], rOut[0][7], rOut[0][1], data2[1]);

    // MUX Layer 3
    mux2x1 layer64(rOut[0][0], data1[0], data1[1], data2[0]);
    mux2x1 layer65(rOut[0][1], data1[1], data1[2], data2[0]);
    mux2x1 layer66(rOut[0][2], data1[2], data1[3], data2[0]);
    mux2x1 layer67(rOut[0][3], data1[3], data1[4], data2[0]);
    mux2x1 layer68(rOut[0][4], data1[4], data1[5], data2[0]);
    mux2x1 layer69(rOut[0][5], data1[5], data1[6], data2[0]);
    mux2x1 layer70(rOut[0][6], data1[6], data1[7], data2[0]);
    mux2x1 layer71(rOut[0][7], data1[7], data1[0], data2[0]);

    assign #2 OutPut = rOut[2];

endmodule


//Arithmetic Right shift functional unit for Right shift module
module Arithmetic_RIGHT_SHIFT(data1 , data2 , OutPut);

// Declaration of input and output ports
    input [7:0] data1;
    input [7:0] data2;
    output [7:0] OutPut;

    // Intermediate connections between MUX layers
    wire [7:0] aOut [2:0]; // wire out for the arithmetic right shift
    

    //Arithmetic Right Shift Mux Layers
    // MUX Layer 1
    mux2x1 layer24(aOut[2][0], aOut[1][0], aOut[1][4], data2[2]);
    mux2x1 layer25(aOut[2][1], aOut[1][1], aOut[1][5], data2[2]);
    mux2x1 layer26(aOut[2][2], aOut[1][2], aOut[1][6], data2[2]);
    mux2x1 layer27(aOut[2][3], aOut[1][3], aOut[1][7], data2[2]);
    mux2x1 layer28(aOut[2][4], aOut[1][4], aOut[1][7], data2[2]);
    mux2x1 layer29(aOut[2][5], aOut[1][5], aOut[1][7], data2[2]);
    mux2x1 layer30(aOut[2][6], aOut[1][6], aOut[1][7], data2[2]);
    mux2x1 layer31(aOut[2][7], aOut[1][7], aOut[1][7], data2[2]);

    // MUX Layer 2
    mux2x1 layer32(aOut[1][0], aOut[0][0], aOut[0][2], data2[1]);
    mux2x1 layer33(aOut[1][1], aOut[0][1], aOut[0][3], data2[1]);
    mux2x1 layer34(aOut[1][2], aOut[0][2], aOut[0][4], data2[1]);
    mux2x1 layer35(aOut[1][3], aOut[0][3], aOut[0][5], data2[1]);
    mux2x1 layer36(aOut[1][4], aOut[0][4], aOut[0][6], data2[1]);
    mux2x1 layer37(aOut[1][5], aOut[0][5], aOut[0][7], data2[1]);
    mux2x1 layer38(aOut[1][6], aOut[0][6], aOut[0][7], data2[1]);
    mux2x1 layer39(aOut[1][7], aOut[0][7], aOut[0][7], data2[1]);

    // MUX Layer 3
    mux2x1 layer40(aOut[0][0], data1[0], data1[1], data2[0]);
    mux2x1 layer41(aOut[0][1], data1[1], data1[2], data2[0]);
    mux2x1 layer42(aOut[0][2], data1[2], data1[3], data2[0]);
    mux2x1 layer43(aOut[0][3], data1[3], data1[4], data2[0]);
    mux2x1 layer44(aOut[0][4], data1[4], data1[5], data2[0]);
    mux2x1 layer45(aOut[0][5], data1[5], data1[6], data2[0]);
    mux2x1 layer46(aOut[0][6], data1[6], data1[7], data2[0]);
    mux2x1 layer47(aOut[0][7], data1[7], data1[7], data2[0]);

    assign #2 OutPut= (data2==8'd8)? 8'b11111111:aOut[2];

endmodule


//2x1 MUX Module
module mux2x1(out,A,B,s);

	//Declaration of input and output ports
    input A, B, s;
    output out;
    wire y0, y1;

	//MUX implementation
    and (y0,A,!s);
    and (y1,B,s);
    or (out , y0,y1);
	
endmodule