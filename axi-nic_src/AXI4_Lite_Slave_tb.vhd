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
  procedure check_cycle (
    --rq put check
    constant AXI_arvalid_value    : in std_logic;
    constant AXI_rdrqA_data_value : in AXI4_Lite_Rd_RqA;
    constant AXI_awvalid_value    : in std_logic;
    constant AXI_wrrqA_data_value : in AXI4_Lite_Wr_RqA;
    constant AXI_wvalid_value     : in std_logic;
    constant AXI_wrrqD_data_value : in AXI4_Lite_Wr_RqD;

    --rq get check
    constant rdrqA_get_en_value   : in std_logic;
    constant wrrqA_get_en_value   : in std_logic;
    constant wrrqD_get_en_value   : in std_logic;
    
    --rsp put check
    constant rdrsp_put_en_value   : in std_logic;
    constant rdrsp_put_data_value : in AXI4_Lite_Rd_Rsp;
    constant wrrsp_put_en_value   : in std_logic;
    constant wrrsp_put_data_value : in AXI4_Lite_Wr_Rsp;
    
    --rsp get check
    constant AXI_rready_value     : in std_logic;
    constant AXI_bready_value     : in std_logic
  ) is
  begin
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

  end procedure check_cycle;
  begin
    -- insert signal assignments here

    wait for 40 ns;
    rst <= '0';

    check_cycle (
      AXI_arvalid_value => '1',
      AXI_rdrqA_data_value => deserialize_A4L_Rd_RqA(std_logic_vector(to_unsigned(27, 11))),
      --(
      --  addr => std_logic_vector(to_unsigned(27, 8)),
      --  prot => "000"
      --),
      AXI_awvalid_value => '0',
      AXI_wrrqA_data_value => (
        addr => "00000000",
        prot => "000"
      ),
      AXI_wvalid_value => '0',
      AXI_wrrqD_data_value => (
        data => "00000000",
        strb => "0000"
      ),
      rdrqA_get_en_value => '1',
      wrrqA_get_en_value => '0',
      wrrqD_get_en_value => '0',
      rdrsp_put_en_value => '0',
      rdrsp_put_data_value => (
        data => "00000000",
        resp => "00"
      ),
      wrrsp_put_en_value => '0',
      wrrsp_put_data_value => (
        resp => "00"
      ),
      AXI_rready_value => '0',
      AXI_bready_value => '0'
    );
    AXI_arvalid <= '0';
    rdrqA_get_en <= '1';
    if (rdrqA_get_valid = '1') then
      rdrqA_get_en <= '0';
    end if;
    wait until rising_edge(clk);
    if (rdrqA_get_valid = '1') then
      rdrqA_get_en <= '0';
    end if;
    wait until rising_edge(clk);
    if (rdrqA_get_valid = '1') then
      rdrqA_get_en <= '0';
    end if;
    wait until rising_edge(clk);
    if (rdrqA_get_valid = '1') then
      rdrqA_get_en <= '0';
    end if;
    wait until rising_edge(clk);
    wait for 100 ns * 10;
  end process WaveGen_Proc;

  

end architecture tb1;

-------------------------------------------------------------------------------

configuration AXI4_Lite_Slave_tb_tb1_cfg of AXI4_Lite_Slave_tb is
  for tb1
  end for;
end AXI4_Lite_Slave_tb_tb1_cfg;

-------------------------------------------------------------------------------
