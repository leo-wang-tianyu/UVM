//Transaction Class 
class transaction;
  
  rand bit newd;
  rand bit [11:0] din;
  bit cs;
  bit mosi;
  
  function void display (input string tag);
    $display("[%0s]: DATA_NEW: %0d DIN = %0d CS : %0b MOSI: %0b ", tag, newd, din, cs, mosi);
    //%0d decimal, %0b binary 
  endfunction 
  
  //deep copy
  function transaction copy();
    copy = new();
    copy.newd = this.newd;
    copy.din = this.din;
    copy.cs = this.cs;
    copy.mosi = this.mosi;
  endfunction
  
endclass 


//Generator Class 
class generator; 
  transaction tr;
  mailbox #(transaction) mbx; 
  event done;
  int count = 0;
  event drvnext;
  //driver has completed applying the stimuli from the genrator to the DUT 
  event sconext;
  //finsied comapring received response vs expected response 
  
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    tr = new();
  endfunction 
  
  task run();
    repeat(count) begin
      assert(tr.randomize) else $error("[GEN]: Randomization Failed");
      mbx.put(tr.copy);
      tr.display("GEN");
      @(drvnext);
      @(sconext);
    end 
    -> done;
    //finished generating the randomized value
  endtask 
  
endclass


//Driver Class
class driver; 
  
  //access to interface so you can access DUT pins 
  virtual spi_if vif;
  transaction tr;
  mailbox #(transaction) mbx;
  //receive data from generator 
  mailbox #(bit [11:0]) mbxds;
  //driver to the scoreboard
  event drvnext;
  
  bit [11:0] din;
  
  function new(mailbox #(bit [11:0]) mbxds, mailbox #(transaction) mbx);
    this.mbx = mbx;
    this.mbxds = mbxds;
  endfunction 
  
  task reset();
    vif.rst <= 1'b1;
    vif.cs <= 1'b1;
    vif.newd <= 1'b0;
    vif.din <= 1'b0;
    vif.mosi <= 1'b0;
    repeat(10) @(posedge vif.clk);
    vif.rst <= 1'b0;
    repeat(5) @(posedge vif.clk);
    
    $display("[DRV]: RESET DONE");
    $display("--------------------");
    
  endtask
  
  task run();
    forever begin 
      mbx.get(tr);
      //receive stimuli from the generator
      @(posedge vif.sclk);
      vif.newd <= 1'b1;
      vif.din <= tr.din;
      mbxds.put(tr.din);
      //send data to scoreboard
      @(posedge vif.sclk);
      vif.newd <= 1'b0;
      wait(vif.cs == 1'b1);
      $display("[DRV]: DATA SENT TO DAC: %0d", tr.din);
      ->drvnext;
      //finised applying the stimuli to the DUT
    end
  endtask 
  
endclass


//Monitor Class
class monitor; 
  transaction tr;
  mailbox #(bit [11:0]) mbx;
  //collect 
  bit [11:0] srx;
  //send to scoreboard
  
  virtual spi_if vif;
  
  function new(mailbox #(bit [11:0]) mbx);
    this.mbx = mbx;
  endfunction 
  
  task run();
    forever begin
      @(posedge vif.sclk);
      wait(vif.cs == 1'b0);
      //start of transaction
      @(posedge vif.sclk);
      
      for (int i = 0; i < 12; i++) begin 
        @(posedge vif.sclk);
        srx[i] = vif.mosi;
        //collecting bit by bit
      end 
      
      wait(vif.cs == 1'b1);
      //end of transaction
      
      $display("[MON]: DATA SENT: %0d", srx);
      mbx.put(srx);
      //send to scoreboard
    end 
  endtask
endclass

//Scoreboard Class
class scoreboard; 
  mailbox #(bit [11:0]) mbxds, mbxms;
  bit [11:0] ds; //data from driver
  bit [11:0] ms; //data from monitor
  event sconext;
  
  function new(mailbox #(bit [11:0]) mbxds, mailbox #(bit [11:0]) mbxms);
    this.mbxds = mbxds;
    this.mbxms = mbxms;
  endfunction 
  
  task run();
    forever begin 
      mbxds.get(ds);
      mbxms.get(ms);
      $display("[SCO] : DRV : %0d MON: %0d", ds, ms);
      
      if(ds == ms)
        $display("[SCO] : DATA MATCHED");
      else
        $display("[SCO] : DATA MISMATCHED");
      
      $display("----------------------");
      ->sconext;
      //Scoreboard done
    end 
  endtask 
endclass

//Enviroment Class
//connecting everything
class environment;
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  event nextgd;
  event nextgs;
  
  mailbox #(transaction) mbxgd; 
  mailbox #(bit [11:0]) mbxds;
  mailbox #(bit [11:0]) mbxms;
  
  virtual spi_if vif;
  
  function new(virtual spi_if vif);
    mbxgd = new();
    mbxms = new();
    mbxds = new();
    gen = new(mbxgd);
    drv = new(mbxds, mbxgd);
    mon = new(mbxms);
    sco = new(mbxds, mbxms);
    
    this.vif = vif;
    drv.vif = this.vif;
    mon.vif = this.vif;
    
    gen.sconext = nextgs;
    sco.sconext = nextgs;
    
    gen.drvnext = nextgd;
    drv.drvnext = nextgd;
    
  endfunction 
  
  task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork 
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_none
  endtask 
  
  task post_test();
    wait(gen.done.triggered);
    $finish();
  endtask 
  
  task run(); 
    pre_test();
    test();
    post_test();
  endtask 
endclass 

//testbench top 
module tb;
  spi_if vif();
  spi dut(vif.clk, vif.newd, vif.rst, vif.din, vif.sclk, vif.cs, vif.mosi);
  
  initial begin 
    vif.clk <= 0;
  end 
  
  always #10 vif.clk <= ~vif.clk;
  
  environment env;
  
  initial begin 
    env = new(vif);
    env.gen.count = 20; 
    env.run();
  end 
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end 
  
endmodule 
  
  
  
               
  
  
