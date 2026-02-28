module spi_master(
  input clk, //clock
  input newd, //new data
  input rst, //reset 
  input [11:0] din, //data in from user
  output reg sclk, cs, mosi //synchorized clock, chip select, master out slave in
);
  typedef enum bit [1:0] {idle = 2'b00, send = 2'b01, comp = 2'b11 } state_type;
  state_type state = idle;
  
  int countc = 0;
  int count = 0;
  
  //sclk genration
  always@(posedge clk)
    begin 
      if(rst == 1'b1) begin 
        countc <= 0;
        sclk <= 1'b0;
      end 
      else begin
        if(countc < 10)   /// fsclk = fclk / 20
          countc <= countc + 1;
        else begin 
          countc <= 0;
          sclk <= ~sclk;
        end 
      end 
    end 
  
  
  //state machine 
  reg [11:0] temp;
  
  always@(posedge sclk)
    begin 
      if(rst == 1'b1) begin 
        cs <= 1'b1; 
        mosi <= 1'b0;
        //idle state values
      end 
      else begin 
        case(state)
          idle: 
            begin 
              if(newd == 1'b1) begin
                //if new data coming in then go to send state with cs to activate low
                // din to temp vaiable
                state <= send;
                temp <= din;
                cs <= 1'b0;
              end 
              else begin 
                //or else stay here
                state <= idle;
                temp <= 12'h000;
              end 
            end 
          send: 
            begin 
              if(count <= 11) begin 
                //send 12 bit serially, lsb first 
                mosi <= temp[count];
                count <= count + 1;
              end 
              else begin 
                //if no more 
                //go back to idle cs activate high 
                count <= 0;
                state <= idle;
                cs <= 1'b1;
                mosi <= 1'b0;
              end
            end 
          
          default: state <= idle;
          
        endcase
      end 
    end 
endmodule 

module spi_slave(
  input sclk, cs, mosi,
  output [11:0] dout,
  output reg done
);
  
  typedef enum bit {detect_start = 1'b0, read_data = 1'b1} state_type;
  state_type state = detect_start;
  
  reg [11:0] temp = 12'h000;
  int count = 0;
  
  always@(posedge sclk)
    begin 
      case(state)
        detect_start:
          begin
            done <= 1'b0;
            if (cs == 1'b0) begin 
              state <= read_data; 
            end 
            else begin 
              state <= detect_start;
              //stays here until cs active low
            end 
          end 
        
        read_data: begin 
          if(count < 12)begin 
            count <= count + 1;
            temp <= {mosi, temp[11:1]};
            //since transmitting LSB data first in the Master
            end 
          else begin 
            count <=0;
            done <= 1'b1;
            state <= detect_start;
          end 
        end 
      endcase
              
    end 
  
  assign dout = temp;

endmodule


module top (
  input clk, rst, newd,
  input [11:0] din, 
  output [11:0] dout, 
  output done
); 
  
  wire sclk, cs, mosi;
  
  spi_master m1 (clk, newd, rst, din, sclk, cs, mosi);
  spi_slave s1 (sclk, cs, mosi, dout, done);
  
endmodule 
  

interface spi_if;
  
  logic clk;
  logic newd;
  logic rst;
  logic [11:0] din;
  logic sclk;
  logic cs;
  logic mosi;
  
endinterface
      
