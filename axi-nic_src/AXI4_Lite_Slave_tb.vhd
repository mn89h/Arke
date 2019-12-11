-------------------------------------------------------------------------------
-- Title      : Testbench for design "AXI4_Lite_Slave"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : AXI4_Lite_Slave_tb.vhd
-- Author     : malte  <malte@linux.fritz.box>
-- Company    : 
-- Created    : 2019-11-25
-- Last update: 2019-11-25
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-11-25  1.0      malte	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Arke_pkg.all;
use work.NIC_pkg.all;

-------------------------------------------------------------------------------

entity AXI4_Lite_Slave_tb is

end entity AXI4_Lite_Slave_tb;

-------------------------------------------------------------------------------

architecture tb1 of AXI4_Lite_Slave_tb is

  -- component ports
  signal clk             : std_logic := '1';
  signal rst             : std_logic := '1';
  signal AXI_arvalid     : std_logic;
  signal AXI_arready     : std_logic;
  signal AXI_rdrqA_data  : AXI4_Lite_Rd_RqA;
  signal AXI_awvalid     : std_logic;
  signal AXI_awready     : std_logic;
  signal AXI_wrrqA_data  : AXI4_Lite_Wr_RqA;
  signal AXI_wvalid      : std_logic;
  signal AXI_wready      : std_logic;
  signal AXI_wrrqD_data  : AXI4_Lite_Wr_RqD;
  signal AXI_rready      : std_logic;
  signal AXI_rvalid      : std_logic;
  signal AXI_rdrsp_data  : AXI4_Lite_Rd_Rsp;
  signal AXI_bready      : std_logic;
  signal AXI_bvalid      : std_logic;
  signal AXI_wrrsp_data  : AXI4_Lite_Wr_Rsp;
  signal rdrqA_get_valid : std_logic;
  signal rdrqA_get_en    : std_logic;
  signal rdrqA_get_data  : AXI4_Lite_Rd_RqA;
  signal wrrqA_get_valid : std_logic;
  signal wrrqA_get_en    : std_logic;
  signal wrrqA_get_data  : AXI4_Lite_Wr_RqA;
  signal wrrqD_get_valid : std_logic;
  signal wrrqD_get_en    : std_logic;
  signal wrrqD_get_data  : AXI4_Lite_Wr_RqD;
  signal rdrsp_put_ready : std_logic;
  signal rdrsp_put_en    : std_logic;
  signal rdrsp_put_data  : AXI4_Lite_Rd_Rsp;
  signal wrrsp_put_ready : std_logic;
  signal wrrsp_put_en    : std_logic;
  signal wrrsp_put_data  : AXI4_Lite_Wr_Rsp;

  signal Cycle       : natural := 1;


begin  -- architecture tb1

  -- component instantiation
  DUT: entity work.AXI4_Lite_Slave
    port map (
      clk             => clk,
      rst             => rst,
      AXI_arvalid     => AXI_arvalid,
      AXI_arready     => AXI_arready,
      AXI_rdrqA_data  => AXI_rdrqA_data,
      AXI_awvalid     => AXI_awvalid,
      AXI_awready     => AXI_awready,
      AXI_wrrqA_data  => AXI_wrrqA_data,
      AXI_wvalid      => AXI_wvalid,
      AXI_wready      => AXI_wready,
      AXI_wrrqD_data  => AXI_wrrqD_data,
      AXI_rready      => AXI_rready,
      AXI_rvalid      => AXI_rvalid,
      AXI_rdrsp_data  => AXI_rdrsp_data,
      AXI_bready      => AXI_bready,
      AXI_bvalid      => AXI_bvalid,
      AXI_wrrsp_data  => AXI_wrrsp_data,
      rdrqA_get_valid => rdrqA_get_valid,
      rdrqA_get_en    => rdrqA_get_en,
      rdrqA_get_data  => rdrqA_get_data,
      wrrqA_get_valid => wrrqA_get_valid,
      wrrqA_get_en    => wrrqA_get_en,
      wrrqA_get_data  => wrrqA_get_data,
      wrrqD_get_valid => wrrqD_get_valid,
      wrrqD_get_en    => wrrqD_get_en,
      wrrqD_get_data  => wrrqD_get_data,
      rdrsp_put_ready => rdrsp_put_ready,
      rdrsp_put_en    => rdrsp_put_en,
      rdrsp_put_data  => rdrsp_put_data,
      wrrsp_put_ready => wrrsp_put_ready,
      wrrsp_put_en    => wrrsp_put_en,
      wrrsp_put_data  => wrrsp_put_data);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  --rq put check
  variable AXI_arvalid_value    : std_logic;
  variable AXI_arready_value    : std_logic;
  variable AXI_rdrqA_data_value : AXI4_Lite_Rd_RqA;
  variable AXI_awvalid_value    : std_logic;
  variable AXI_awready_value    : std_logic;
  variable AXI_wrrqA_data_value : AXI4_Lite_Wr_RqA;
  variable AXI_wvalid_value     : std_logic;
  variable AXI_wready_value     : std_logic;
  variable AXI_wrrqD_data_value : AXI4_Lite_Wr_RqD;

  --rq get check
  variable rdrqA_get_en_value   : std_logic;
  variable rdrqA_get_valid_value: std_logic;
  variable rdrqA_get_data_value : AXI4_Lite_Rd_RqA;
  variable wrrqA_get_en_value   : std_logic;
  variable wrrqA_get_valid_value: std_logic;
  variable wrrqA_get_data_value : AXI4_Lite_Wr_RqA;
  variable wrrqD_get_en_value   : std_logic;
  variable wrrqD_get_valid_value: std_logic;
  variable wrrqD_get_data_value : AXI4_Lite_Wr_RqD;
  
  --rsp put check
  variable rdrsp_put_en_value   : std_logic;
  variable wrrsp_put_ready_value: std_logic;
  variable rdrsp_put_data_value : AXI4_Lite_Rd_Rsp;
  variable wrrsp_put_en_value   : std_logic;
  variable rdrsp_put_ready_value: std_logic;
  variable wrrsp_put_data_value : AXI4_Lite_Wr_Rsp;

  --rsp get check
  variable AXI_rvalid_value     : std_logic;
  variable AXI_rready_value     : std_logic;
  variable AXI_rdrsp_data_value : AXI4_Lite_Rd_Rsp;
  variable AXI_bvalid_value     : std_logic;
  variable AXI_bready_value     : std_logic;
  variable AXI_wrrsp_data_value : AXI4_Lite_Wr_Rsp;
  
  procedure check_cycle is
  begin
    report "CYCLE " & to_string(Cycle) & " --------------------------------------";
    Cycle <= Cycle + 1;
    --rq put valid
    AXI_arvalid     <= AXI_arvalid_value;
    AXI_rdrqA_data  <= AXI_rdrqA_data_value;
    AXI_awvalid     <= AXI_awvalid_value;
    AXI_wrrqA_data  <= AXI_wrrqA_data_value;
    AXI_wvalid      <= AXI_wvalid_value;
    AXI_wrrqD_data  <= AXI_wrrqD_data_value;

    --rq get ready
    rdrqA_get_en    <= rdrqA_get_en_value;
    wrrqA_get_en    <= wrrqA_get_en_value;
    wrrqD_get_en    <= wrrqD_get_en_value;
    
    --rsp put valid
    rdrsp_put_en    <= rdrsp_put_en_value;
    rdrsp_put_data  <= rdrsp_put_data_value;
    wrrsp_put_en    <= wrrsp_put_en_value;
    wrrsp_put_data  <= wrrsp_put_data_value;

    --rsp get ready
    AXI_rready      <= AXI_rready_value;
    AXI_bready      <= AXI_bready_value;
    wait until rising_edge(clk);

    --req put
    if (AXI_arready_value /= 'X') then
      assert AXI_arready = AXI_arready_value
      report "AXI_arready - expected '" & to_string(AXI_arready_value) &
          "' got '" & to_string(AXI_arready) & "'";
    end if;
    if (AXI_awready_value /= 'X') then
      assert AXI_awvalid = AXI_awvalid_value
      report "AXI_awvalid - expected '" & to_string(AXI_awvalid_value) &
          "' got '" & to_string(AXI_awvalid) & "'";
    end if;
    if (AXI_wready_value /= 'X') then
      assert AXI_wready = AXI_wready_value
      report "AXI_wready - expected '" & to_string(AXI_wready_value) &
          "' got '" & to_string(AXI_wready) & "'";
    end if;
    
    --req get
    if (rdrqA_get_valid_value /= 'X') then
      assert rdrqA_get_valid = rdrqA_get_valid_value
      report "rdrqA_get_valid - expected '" & to_string(rdrqA_get_valid_value) &
          "' got '" & to_string(rdrqA_get_valid) & "'";
    end if;
    if (rdrqA_get_data_value.addr /= "XXXXXXXX") then
      assert rdrqA_get_data.addr = rdrqA_get_data_value.addr
      report "rdrqA_get_data - expected '" & to_string(rdrqA_get_data_value.addr) &
          "' got '" & to_string(rdrqA_get_data.addr) & "'";
    end if;
    if (wrrqA_get_valid_value /= 'X') then
      assert wrrqA_get_valid = wrrqA_get_valid_value
      report "wrrqA_get_valid - expected '" & to_string(wrrqA_get_valid_value) &
          "' got '" & to_string(wrrqA_get_valid) & "'";
    end if;
    if (wrrqA_get_data_value.addr /= "XXXXXXXX") then
      assert wrrqA_get_data.addr = wrrqA_get_data_value.addr
      report "wrrqA_get_data - expected '" & to_string(wrrqA_get_data_value.addr) &
          "' got '" & to_string(wrrqA_get_data.addr) & "'";
    end if;
    if (wrrqD_get_valid_value /= 'X') then
      assert wrrqD_get_valid = wrrqD_get_valid_value
      report "wrrqD_get_valid - expected '" & to_string(wrrqD_get_valid_value) &
          "' got '" & to_string(wrrqD_get_valid) & "'";
    end if;
    if (wrrqD_get_data_value.data /= "XXXXXXXX") then
      assert wrrqD_get_data.data = wrrqD_get_data_value.data
      report "wrrqD_get_data - expected '" & to_string(wrrqD_get_data_value.data) &
          "' got '" & to_string(wrrqD_get_data.data) & "'";
    end if;

    --rsp put
    if (rdrsp_put_ready_value /= 'X') then
      assert rdrsp_put_ready = rdrsp_put_ready_value
      report "rdrsp_put_ready - expected '" & to_string(rdrsp_put_ready_value) &
          "' got '" & to_string(rdrsp_put_ready) & "'";
    end if;
    if (wrrsp_put_ready_value /= 'X') then
      assert wrrsp_put_ready = wrrsp_put_ready_value
      report "wrrsp_put_ready - expected '" & to_string(wrrsp_put_ready_value) &
          "' got '" & to_string(wrrsp_put_ready) & "'";
    end if;

    --rsp get
    if (AXI_rvalid_value /= 'X') then
      assert AXI_rvalid = AXI_rvalid_value
      report "AXI_rvalid - expected '" & to_string(AXI_rvalid_value) &
          "' got '" & to_string(AXI_rvalid) & "'";
    end if;
    if (AXI_rdrsp_data_value.data /= "XXXXXXXX") then
      assert AXI_rdrsp_data.data = AXI_rdrsp_data_value.data
      report "AXI_rdrsp_data - expected '" & to_string(AXI_rdrsp_data_value.data) &
          "' got '" & to_string(AXI_rdrsp_data.data) & "'";
    end if;
    if (AXI_bvalid_value /= 'X') then
      assert AXI_bvalid = AXI_bvalid_value
      report "AXI_bvalid - expected '" & to_string(AXI_bvalid_value) &
          "' got '" & to_string(AXI_bvalid) & "'";
    end if;
    if (AXI_wrrsp_data_value.resp /= "XX") then
      assert AXI_wrrsp_data.resp = AXI_wrrsp_data_value.resp
      report "AXI_wrrsp_data - expected '" & to_string(AXI_wrrsp_data_value.resp) &
          "' got '" & to_string(AXI_wrrsp_data.resp) & "'";
    end if;
  end procedure check_cycle;
  begin
    -- insert signal assignments here

    report "CYCLE SetUp";
    wait for 30 ns;
    rst <= '0';
    wait until rising_edge(clk);

    -------------------------------------------------------------- 001
    -- in
    AXI_arvalid_value     := '1';
    AXI_rdrqA_data_value  := deserialize_A4L_Rd_RqA("00000001111"); --max 2047
    AXI_awvalid_value     := '0';
    AXI_wrrqA_data_value  := deserialize_A4L_Wr_RqA("00000000000"); --max 2047
    AXI_wvalid_value      := '0';
    AXI_wrrqD_data_value  := deserialize_A4L_Wr_RqD("000000000000"); --max 4095

    rdrqA_get_en_value    := '1';
    wrrqA_get_en_value    := '1';
    wrrqD_get_en_value    := '1';

    rdrsp_put_en_value    := '0';
    rdrsp_put_data_value  := deserialize_A4L_Rd_Rsp("0000000000"); --max 1023
    wrrsp_put_en_value    := '0';
    wrrsp_put_data_value  := deserialize_A4L_Wr_Rsp("00"); --max 3

    AXI_rready_value      := '1';
    AXI_bready_value      := '1';

    -- out
    AXI_arready_value     := '1';
    AXI_awready_value     := '1';
    AXI_wready_value      := '1';

    rdrqA_get_valid_value := '0';
    rdrqA_get_data_value  := deserialize_A4L_Rd_RqA("XXXXXXXXXXX");
    wrrqA_get_valid_value := '0';
    wrrqA_get_data_value  := deserialize_A4L_Wr_RqA("XXXXXXXXXXX");
    wrrqD_get_valid_value := '0';
    wrrqD_get_data_value  := deserialize_A4L_Wr_RqD("XXXXXXXXXXXX");
    
    wrrsp_put_ready_value := '1';
    rdrsp_put_ready_value := '1';
    
    AXI_rvalid_value      := '0';
    AXI_rdrsp_data_value  := deserialize_A4L_Rd_Rsp("XXXXXXXXXX");
    AXI_bvalid_value      := '0';
    AXI_wrrsp_data_value  := deserialize_A4L_Wr_Rsp("XX");

    check_cycle;
    -------------------------------------------------------------- 002
    -- in
    AXI_arvalid_value     := '0';

    -- out
    AXI_arready_value     := '1';
    AXI_awready_value     := '1';
    AXI_wready_value      := '1';

    rdrqA_get_valid_value := '1';
    rdrqA_get_data_value  := deserialize_A4L_Rd_RqA("00000001111");
    wrrqA_get_valid_value := '0';
    wrrqA_get_data_value  := deserialize_A4L_Wr_RqA("00000000000");
    wrrqD_get_valid_value := '0';
    wrrqD_get_data_value  := deserialize_A4L_Wr_RqD("000000000000");
    
    wrrsp_put_ready_value := '1';
    rdrsp_put_ready_value := '1';
    
    AXI_rvalid_value      := '0';
    AXI_rdrsp_data_value  := deserialize_A4L_Rd_Rsp("0000000000");
    AXI_bvalid_value      := '0';
    AXI_wrrsp_data_value  := deserialize_A4L_Wr_Rsp("00");
    
    check_cycle;
    -------------------------------------------------------------- 003
    -- in
    rdrsp_put_en_value    := '1';
    rdrsp_put_data_value  := deserialize_A4L_Rd_Rsp("1111111111");
    -- out
    rdrqA_get_valid_value := '0';
    
    check_cycle;
    -------------------------------------------------------------- 004
    -- in
    rdrsp_put_en_value    := '0';
    -- out
    AXI_rvalid_value      := '1';
    AXI_rdrsp_data_value  := deserialize_A4L_Rd_Rsp("1111111111");
    
    check_cycle;
    -------------------------------------------------------------- 005
    -- in
    AXI_arvalid_value     := '1';
    AXI_rdrqA_data_value  := deserialize_A4L_Rd_RqA("11000001111");
    -- out
    AXI_rvalid_value      := '0';
    
    check_cycle;
    -------------------------------------------------------------- 006
    -- in
    AXI_rdrqA_data_value  := deserialize_A4L_Rd_RqA("11011001111");

    rdrqA_get_en_value    := '0';
    -- out
    rdrqA_get_valid_value := '1';
    rdrqA_get_data_value  := deserialize_A4L_Rd_RqA("11000001111");

    check_cycle;
    -------------------------------------------------------------- 007
    -- in
    AXI_rdrqA_data_value  := deserialize_A4L_Rd_RqA("10000000001");

    -- out
    AXI_arready_value     := '0';
    rdrqA_get_valid_value := '1';
    rdrqA_get_data_value  := deserialize_A4L_Rd_RqA("11000001111");

    check_cycle;
    -------------------------------------------------------------- 008
    -- in
    AXI_arvalid_value     := '0';

    rdrqA_get_en_value    := '1';
    -- out
    rdrqA_get_valid_value := '1';
    rdrqA_get_data_value  := deserialize_A4L_Rd_RqA("11000001111");

    check_cycle;
    -------------------------------------------------------------- 009
    -- in
    -- out
    AXI_arready_value     := '1';

    rdrqA_get_valid_value := '1';
    rdrqA_get_data_value  := deserialize_A4L_Rd_RqA("11011001111");

    check_cycle;
    -------------------------------------------------------------- 010
    -- in
    -- out
    rdrqA_get_valid_value := '0';
    rdrqA_get_data_value  := deserialize_A4L_Rd_RqA("10000000001");

    check_cycle;

    wait until rising_edge(clk);
    wait for 100 ns * 10;
    assert FALSE Report "Simulation Finished" severity FAILURE;
  end process WaveGen_Proc;

  

end architecture tb1;

-------------------------------------------------------------------------------

configuration AXI4_Lite_Slave_tb_tb1_cfg of AXI4_Lite_Slave_tb is
  for tb1
  end for;
end AXI4_Lite_Slave_tb_tb1_cfg;

-------------------------------------------------------------------------------
