`timescale 1ns / 1ps

`include "uvm_macros.svh"
import uvm_pkg::*;


//config class
class uart_config extends uvm_object;
  `uvm_object_utils(uart_config)
  
  function new(string name = "uart_config");
    super.new(name);
  endfunction 
  
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  
endclass


//
typedef enum bit [3:0] {rand_baud_1_stop = 0, rand_length_1_stop = 1, length5wp = 2, length6wp = 3, length7wp = 4, length8wp = 5, length5wop = 6, length6wop = 7, length7wop = 8, length8wop = 9, rand_baud_2_stop = 11, rand_length_2_stop = 12} oper_mode;

//transaction class
class transaction extends uvm_sequence_item;
  `uvm_object_utils(transaction)
  
  rand oper_mode op;
  logic tx_start, rx_start;
  logic rst;
  rand logic [7:0] tx_data;
  rand logic [16:0] baud;
  rand logic [3:0] length;
  rand logic parity_type, parity_en;
  logic stop2;
  logic tx_done, rx_done, tx_err, rx_err;
  logic [7:0] rx_out;
  
  constraint baud_c { baud inside {17'd4800, 17'd9600, 17'd14400, 17'd19200, 17'd38400, 17'd57600};}
  
  constraint length_c { length inside {4'd5, 4'd6, 4'd7, 4'd8};}
  
  function new(string name = "transaction");
    super.new(name);
  endfunction 
  
endclass

//single stop
class rand_baud extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_baud)
  
  transaction tr;
  
  function new(string name = "rand_baud");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = rand_baud_1_stop;
        tr.length = 8;
        tr.rst = 1'b0;
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b1;
        tr.stop2 = 1'b0;
        finish_item(tr);
      end 
  endtask 
  
endclass 

//2 stops
class rand_baud_2stop extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_baud_2stop)
  
  transaction tr;
  
  function new(string name = "rand_baud_2stop");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = rand_baud_2_stop;
        tr.length = 8;
        tr.rst = 1'b0;
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b1;
        tr.stop2 = 1'b1;
        finish_item(tr);
      end 
  endtask 
  
endclass 

//mode: length5wp
class rand_baud_len5wp extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_baud_len5wp)
  
  transaction tr;
  
  function new(string name = "rand_baud_len5wp");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = length5wp;
        tr.length = 5;
        tr.rst = 1'b0;
		tr.tx_data = {3'b000, tr.tx_data[7:3]};
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b1;
        tr.stop2 = 1'b0;
        finish_item(tr);
      end 
  endtask 
  
endclass 

//mode: length6wp
class rand_baud_len6wp extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_baud_len6wp)
  
  transaction tr;
  
  function new(string name = "rand_baud_len6wp");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = length6wp;
        tr.length = 6;
        tr.rst = 1'b0;
        tr.tx_data = {2'b00, tr.tx_data[7:2]};
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b1;
        tr.stop2 = 1'b0;
        finish_item(tr);
      end 
  endtask 
  
endclass

//mode: length7wp
class rand_baud_len7wp extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_baud_len7wp)
  
  transaction tr;
  
  function new(string name = "rand_baud_len7wp");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = length7wp;
        tr.length = 7;
        tr.rst = 1'b0;
        tr.tx_data = {1'b0, tr.tx_data[7:1]};
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b1;
        tr.stop2 = 1'b0;
        finish_item(tr);
      end 
  endtask 
  
endclass 

//mode: length8wp
class rand_baud_len8wp extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_baud_len8wp)
  
  transaction tr;
  
  function new(string name = "rand_baud_len8wp");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = length8wp;
        tr.length = 8;
        tr.rst = 1'b0;
        tr.tx_data = tr.tx_data[7:0];
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b1;
        tr.stop2 = 1'b0;
        finish_item(tr);
      end 
  endtask 
  
endclass 

//With parity ^
//Without ↓
//mode: length5wop
class rand_baud_len5wop extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_baud_len5wop)
  
  transaction tr;
  
  function new(string name = "rand_baud_len5wop");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = length5wop;
        tr.length = 5;
        tr.rst = 1'b0;
		tr.tx_data = {3'b000, tr.tx_data[7:3]};
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b0;
        tr.stop2 = 1'b0;
        finish_item(tr);
      end 
  endtask 
  
endclass 

//mode: length6wop
class rand_baud_len6wop extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_baud_len6wop)
  
  transaction tr;
  
  function new(string name = "rand_baud_len6wop");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = length6wop;
        tr.length = 6;
        tr.rst = 1'b0;
        tr.tx_data = {2'b00, tr.tx_data[7:2]};
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b0;
        tr.stop2 = 1'b0;
        finish_item(tr);
      end 
  endtask 
  
endclass

//mode: length7wop
class rand_baud_len7wop extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_baud_len7wop)
  
  transaction tr;
  
  function new(string name = "rand_baud_len7wop");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = length7wop;
        tr.length = 7;
        tr.rst = 1'b0;
        tr.tx_data = {1'b0, tr.tx_data[7:1]};
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b0;
        tr.stop2 = 1'b0;
        finish_item(tr);
      end 
  endtask 
  
endclass 

//mode: length8wop
class rand_baud_len8wop extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_baud_len8wop)
  
  transaction tr;
  
  function new(string name = "rand_baud_len8wop");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = length8wop;
        tr.length = 8;
        tr.rst = 1'b0;
        tr.tx_data = tr.tx_data[7:0];
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b0;
        tr.stop2 = 1'b0;
        finish_item(tr);
      end 
  endtask 
  
endclass 

//mode: rand_length_1_stop
class rand_length_1stop extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_length_1stop)
  
  transaction tr;
  
  function new(string name = "rand_length_1stop");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize() with {length inside {5,6,7,8};
                                    parity_en == 1;});
        tr.op = rand_length_1_stop;
        tr.rst = 1'b0;
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b1;
        tr.stop2 = 1'b0;
        unique case(tr.length)
          5: tr.tx_data = {3'b000, tr.tx_data[7:3]};
          6: tr.tx_data = {2'b00, tr.tx_data[7:2]};
          7: tr.tx_data = {1'b0, tr.tx_data[7:1]};
          8: tr.tx_data = tr.tx_data[7:0];
          default: tr.tx_data = 8'h00; 
        endcase
        
        finish_item(tr);
      end 
  endtask 

endclass

//mode: rand_length_2_stop
class rand_length_2stop extends uvm_sequence#(transaction);
  `uvm_object_utils(rand_length_2stop)
  
  transaction tr;
  
  function new(string name = "rand_length_2stop");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(5)
      begin 
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize() with {length inside {5,6,7,8};
                                    parity_en == 1;});
        tr.op = rand_length_2_stop;
        tr.rst = 1'b0;
        tr.tx_start = 1'b1;
        tr.rx_start = 1'b1;
        tr.parity_en = 1'b1;
        tr.stop2 = 1'b1;
        unique case(tr.length)
          5: tr.tx_data = {3'b000, tr.tx_data[7:3]};
          6: tr.tx_data = {2'b00, tr.tx_data[7:2]};
          7: tr.tx_data = {1'b0, tr.tx_data[7:1]};
          8: tr.tx_data = tr.tx_data[7:0];
          default: tr.tx_data = 8'h00; 
        endcase
        
        finish_item(tr);
      end 
  endtask 

endclass

//Driver Class
class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)
  
  virtual interface uart_if vif;
  transaction tr; 
  
  function new(input string path = "drv", uvm_component parent = null);
    super.new(path, parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    
    if(!uvm_config_db# (virtual uart_if)::get(this,"","vif",vif))
      `uvm_fatal("DRV", "Unable to access Interface");
  endfunction
  
  
  task reset_dut();
    repeat(5)
      begin 
        vif.rst <= 1'b1;
        vif.tx_start <= 1'b0;
        vif.rx_start <= 1'b0;
        vif.tx_data <= 8'h00;
        vif.baud <= 17'h0;
        vif.length <= 4'h0;
        vif.parity_type <= 1'b0;
        vif.parity_en <= 1'b0;
        vif.stop2 <= 1'b0;
        `uvm_info("DRV", "System Reset: Start of Simulation ", UVM_MEDIUM);
        @(posedge vif.clk);
      end
    vif.rst <= 1'b0;
    @(posedge vif.clk);
    `uvm_info("DRV", "Reset deasserted, DUT ready", UVM_LOW);
  endtask
  
  task drive();
    reset_dut();
    forever begin 
      
      seq_item_port.get_next_item(tr);
      
      vif.rst <= 1'b0;
      vif.tx_start <= tr.tx_start;
      vif.rx_start <= tr.rx_start;
      vif.tx_data <= tr.tx_data;
      vif.baud <= tr.baud;
      vif.length <= tr.length;
      vif.parity_type <= tr.parity_type;
      vif.parity_en <= tr.parity_en;
      vif.stop2 <= tr.stop2;
      
      `uvm_info("DRV", $sformatf("BAUD: %0d, LEN: %0d, PAR_T: %0d, PAR_EN: %0d, STOP2: %0d, TX_DATA: %0h", tr.baud, tr.length, tr.parity_type, tr.parity_en, tr.stop2, tr.tx_data), UVM_LOW);
      @(posedge vif.clk);
      @(posedge vif.tx_done);
      @(posedge vif.rx_done);
      @(negedge vif.rx_done); //ensure it clears before next item
      
      seq_item_port.item_done();
      
    end 
  endtask
  
  virtual task run_phase(uvm_phase phase);
    drive();
  endtask 
  
endclass

//Monitor Class
class mon extends uvm_monitor;
  `uvm_component_utils(mon)
  
  uvm_analysis_port#(transaction) send;
  virtual interface uart_if vif;
  
  function new(input string inst = "mon", uvm_component parent = null);
    super.new(inst, parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    send = new("send", this);
    if(!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Unable to access Interface");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    transaction tr;
    forever begin 
      @(posedge vif.clk);
      if(vif.rst) 
        begin 
          tr = transaction::type_id::create("tr");
          tr.rst = 1'b1;
          `uvm_info("MON", "SYSTEM RESET DETECTED", UVM_LOW);
          send.write(tr);
      end else 
        begin 
          @(posedge vif.tx_done);
          @(posedge vif.rx_done);
          @(negedge vif.rx_done);
          tr = transaction::type_id::create("tr");
          tr.rst = 1'b0;
          tr.tx_start = vif.tx_start;
          tr.rx_start = vif.rx_start;
          tr.tx_data = vif.tx_data;
          tr.baud = vif.baud;
          tr.length = vif.length; 
          tr.parity_type = vif.parity_type;
          tr.parity_en = vif.parity_en;
          tr.stop2 = vif.stop2;
          
          tr.tx_done = 1'b1;
          tr.rx_done = 1'b1;
          tr.tx_err = vif.tx_err;
          tr.rx_err = vif.rx_err;
          tr.rx_out = vif.rx_out;
          `uvm_info("MON", $sformatf("BAUD: %0d, LEN: %0d, PAR_T: %0d, PAR_EN: %0d, STOP2: %0d, TX_DATA: %0h", tr.baud, tr.length, tr.parity_type, tr.parity_en, tr.stop2, tr.tx_data), UVM_LOW);
          send.write(tr);
        end     
    end 
  endtask 
  
endclass

//Scoreboard Class
class sco extends uvm_scoreboard;
  `uvm_component_utils(sco)
  
  uvm_analysis_imp#(transaction, sco) recv;
  bit[31:0] arr[32] = '{default: 0};
  bit[31:0] addr = 0;
  bit[31:0] data_rd = 0;
  
  function new(input string inst = "sco", uvm_component parent = null);
    super.new(inst, parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this); 
  endfunction 
  
  virtual function void write(transaction tr);
    `uvm_info("SCO", $sformatf("BAUD: %0d, LEN: %0d, PAR_T: %0d, PAR_EN: %0d, STOP2: %0d, TX_DATA: %0h", tr.baud, tr.length, tr.parity_type, tr.parity_en, tr.stop2, tr.tx_data), UVM_LOW);
    
    if(tr.rst == 1'b1) 
      begin 
        `uvm_info("SCO", "System Reset", UVM_LOW);
      end else if(tr.tx_data == tr.rx_out && !tr.tx_err && !tr.rx_err) 
        begin 
          `uvm_info("SCO", "Test Passed", UVM_LOW);
        end else 
          begin
            `uvm_error("SCO", "Test Failed");
          end 
    `uvm_info("SCO","-----------------------------------------------------------",UVM_LOW);
  endfunction 
  
endclass 

//Agent Class
class agent extends uvm_agent; 
  `uvm_component_utils(agent);
  
  uart_config cfg;
  virtual interface uart_if vif;
  
  function new(input string inst = "agent", uvm_component parent = null);
    super.new(inst, parent);
  endfunction 
  
  driver d; 
  uvm_sequencer#(transaction) seqr; 
  mon m;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(uart_config)::get(this, "", "cfg", cfg))
      cfg = uart_config::type_id::create("cfg");
    
    m = mon::type_id::create("m", this);
    
    if(cfg.is_active == UVM_ACTIVE)
      begin 
        d = driver::type_id::create("d", this);
        seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
      end 
    
    if(!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif)) begin 
      `uvm_fatal("AGT", "No uart_if(vif) set for agent")
    end 
    
    uvm_config_db#(virtual uart_if)::set(this, "m", "vif", vif);
      
    if(cfg.is_active == UVM_ACTIVE)
      uvm_config_db#(virtual uart_if)::set(this, "d", "vif", vif);
    
  endfunction 
  
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(cfg.is_active == UVM_ACTIVE) begin 
      d.seq_item_port.connect(seqr.seq_item_export);
    end 
  endfunction 
  
endclass 

//Environment Class
class env extends uvm_env;
  `uvm_component_utils(env)
  
  function new(input string inst = "env", uvm_component parent = null);
    super.new(inst, parent);
  endfunction 
  
  agent a; 
  sco s;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a = agent::type_id::create("a", this);
    s = sco::type_id::create("s", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a.m.send.connect(s.recv);
  endfunction 
  
endclass

//Test Class
class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(input string inst = "test", uvm_component c);
    super.new(inst, c);
  endfunction
  
  env e; 
  rand_baud rb;
  rand_baud_2stop rb2;
  rand_baud_len5wp rb5l;
  rand_baud_len6wp rb6l;
  rand_baud_len7wp rb7l;
  rand_baud_len8wp rb8l;
  rand_baud_len5wop rb5lwop;
  rand_baud_len6wop rb6lwop;
  rand_baud_len7wop rb7lwop;
  rand_baud_len8wop rb8lwop;
  rand_length_1stop rl1;
  rand_length_2stop rl2;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    e = env::type_id::create("env", this);
    rb = rand_baud::type_id::create("rb");
    rb2 = rand_baud_2stop::type_id::create("rb2");
    
    rb5l    = rand_baud_len5wp::type_id::create("rb5l");
    rb6l    = rand_baud_len6wp::type_id::create("rb6l");
    rb7l    = rand_baud_len7wp::type_id::create("rb7l");
    rb8l    = rand_baud_len8wp::type_id::create("rb8l");
    rb5lwop = rand_baud_len5wop::type_id::create("rb5lwop");
    rb6lwop = rand_baud_len6wop::type_id::create("rb6lwop");
    rb7lwop = rand_baud_len7wop::type_id::create("rb7lwop");
    rb8lwop = rand_baud_len8wop::type_id::create("rb8lwop");
    rl1 = rand_length_1stop::type_id::create("rl1");
    rl2 = rand_length_2stop::type_id::create("rl2");
  
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    //change testing sequence here
    //rb.start(e.a.seqr);
    //rb5l.start(e.a.seqr);
    //rb8lwop.start(e.a.seqr);
    rl2.start(e.a.seqr);
    #20;
    
    phase.drop_objection(this);
  endtask 
endclass


module tb;
  
  uart_if vif();
  
  uart_top dut(.clk(vif.clk), .rst(vif.rst), .tx_start(vif.tx_start), .rx_start(vif.rx_start), .tx_data(vif.tx_data), .baud(vif.baud), .length(vif.length), .parity_type(vif.parity_type), .parity_en(vif.parity_en),.stop2(vif.stop2),.tx_done(vif.tx_done), .rx_done(vif.rx_done), .tx_err(vif.tx_err), .rx_err(vif.rx_err), .rx_out(vif.rx_out));
  
  initial begin 
    vif.clk <= 0;
  end
  
  always #10 vif.clk <= ~vif.clk;
  
  initial begin
    uvm_config_db#(virtual uart_if)::set(null, "*", "vif", vif);
    run_test("test");
  end 
  
endmodule
