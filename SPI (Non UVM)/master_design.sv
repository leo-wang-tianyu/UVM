module spi(
  input clk, //clock
  input newd, //new data
  input rst, //reset 
  input [11:0] din, //data in from user
  output reg sclk, cs, mosi //synchorized clock, chip select, master out slave in
);
  typedef enum bit [1:0] {idle = 2'b00, enable = 2'b01, comp = 2'b11 } state_type;
  state_type state = idle;
  
  int countc = 0;
  int cout = 0;
  
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
                temp <= 8'h00;
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
      
