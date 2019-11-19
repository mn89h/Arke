-------------------------------------------------------------------------------
-- Title      : Testbench for design "AXI4_Full_Slave"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : AXI4_Full_Slave_tb.vhd
-- Author     : malte  <malte@linux.fritz.box>
-- Company    : 
-- Created    : 2019-11-19
-- Last update: 2019-11-19
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-11-19  1.0      malte   Created
-------------------------------------------------------------------------------


-- https://vunit.github.io/run/user_guide.html
-- https://www.itdev.co.uk/content/vhdl-testbench-generator-example
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity AXI4_Full_Slave_tb is

end entity AXI4_Full_Slave_tb;

-------------------------------------------------------------------------------

architecture lol of AXI4_Full_Slave_tb is

  -- component ports
  signal clk             : std_logic;
  signal rst             : std_logic;
  signal AXI_arvalid     : std_logic;
  signal AXI_arready     : std_logic;
  signal AXI_rdrqA_data  : AXI4_Full_Rd_RqA;
  signal AXI_awvalid     : std_logic;
  signal AXI_awready     : std_logic;
  signal AXI_wrrqA_data  : AXI4_Full_Wr_RqA;
  signal AXI_wvalid      : std_logic;
  signal AXI_wready      : std_logic;
  signal AXI_wrrqD_data  : AXI4_Full_Wr_RqD;
  signal AXI_rready      : std_logic;
  signal AXI_rvalid      : std_logic;
  signal AXI_rdrsp_data  : AXI4_Full_Rd_Rsp;
  signal AXI_bready      : std_logic;
  signal AXI_bvalid      : std_logic;
  signal AXI_wrrsp_data  : AXI4_Full_Wr_Rsp;
  signal rdrqA_get_valid : std_logic;
  signal rdrqA_get_en    : std_logic;
  signal rdrqA_get_data  : AXI4_Full_Rd_RqA;
  signal wrrqA_get_valid : std_logic;
  signal wrrqA_get_en    : std_logic;
  signal wrrqA_get_data  : AXI4_Full_Wr_RqA;
  signal wrrqD_get_valid : std_logic;
  signal wrrqD_get_en    : std_logic;
  signal wrrqD_get_data  : AXI4_Full_Wr_RqD;
  signal rdrsp_put_ready : std_logic;
  signal rdrsp_put_en    : std_logic;
  signal rdrsp_put_data  : AXI4_Full_Rd_Rsp;
  signal wrrsp_put_ready : std_logic;
  signal wrrsp_put_en    : std_logic;
  signal wrrsp_put_data  : AXI4_Full_Wr_Rsp;

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture lol

  -- component instantiation
  DUT : entity work.AXI4_Full_Slave
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
  WaveGen_Proc : process
  procedure check_cycle (
    constant axis_in_tready_value:  in std_logic;
    constant axis_in_tvalid_value:  in std_logic;
    constant axis_in_tdata_value:   in AXI4_Full_Rd_RqA;
    constant axis_out_tready_value: in std_logic;
    constant axis_out_tvalid_value: in std_logic;
    constant axis_out_tdata_value:  in AXI4_Full_Rd_RqA
) is
begin
    axis_in_tvalid <= axis_in_tvalid_value;
    axis_in_tdata <= axis_in_tdata_value;
    axis_out_tready <= axis_out_tready_value;
    wait until rising_edge(clk);
    if axis_in_tready_value /= 'X' then
        assert axis_in_tready = axis_in_tready_value
        report "axis_in_tready - expected '" & to_string(axis_in_tready_value) &
            "' got '" & to_string(axis_in_tready) & "'";
    end if;
    if axis_out_tvalid_value /= 'X' then
        assert axis_out_tvalid = axis_out_tvalid_value
        report "axis_out_tvalid - expected '" & to_string(axis_out_tvalid_value) &
            "' got '" & to_string(axis_out_tvalid) & "'";
    end if;
    if axis_out_tdata_value /= "XXXXXXXX" then
        assert axis_out_tdata = axis_out_tdata_value
        report "axis_out_tdata - expected " & to_string(to_integer(signed(axis_out_tdata_value))) &
            " got " & to_string(to_integer(signed(axis_out_tdata)));
    end if;
end procedure check_cycle;
    
  begin
    -- insert signal assignments here

    wait until Clk = '1';
  end process WaveGen_Proc;



end architecture lol;

-------------------------------------------------------------------------------

configuration AXI4_Full_Slave_tb_lol_cfg of AXI4_Full_Slave_tb is
  for lol
  end for;
end AXI4_Full_Slave_tb_lol_cfg;

-------------------------------------------------------------------------------
