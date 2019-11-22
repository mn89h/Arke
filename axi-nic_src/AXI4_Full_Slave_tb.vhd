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
use ieee.numeric_std.all;
use work.NIC_pkg.all;

library vunit_lib;
context vunit_lib.vunit_context;

-------------------------------------------------------------------------------

entity AXI4_Full_Slave_tb is
  generic (runner_cfg : string := runner_cfg_default);
end entity AXI4_Full_Slave_tb;

-------------------------------------------------------------------------------

architecture tb1 of AXI4_Full_Slave_tb is

  -- component ports
  signal clk             : std_logic := '1';
  signal rst             : std_logic := '1';
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

  signal counter : integer := 0;


begin  -- architecture tb1

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
  clk <= not clk after 10 ns;
  rst <= '0' after 22 ns;

  -- waveform generation
  WaveGen_Proc : process
  procedure check_cycle (
    constant AXI_arvalid_value      : in std_logic;
    constant AXI_arready_value      : in std_logic;
    constant AXI_rdrqA_data_value   : in AXI4_Full_Rd_RqA;
    constant rdrqA_get_valid_value  : in std_logic;
    constant rdrqA_get_en_value     : in std_logic;
    constant rdrqA_get_data_value   : in AXI4_Full_Rd_RqA
  ) is
  begin
    wait until rising_edge(clk);
    AXI_arvalid <= AXI_arvalid_value;
    AXI_rdrqA_data <= AXI_rdrqA_data_value;
    rdrqA_get_en <= rdrqA_get_en_value;
    report "Check #" & to_string(counter);
--    counter <= counter + 1;
--    if AXI_arready_value /= 'X' then
--        assert AXI_arready = AXI_arready_value
--        report "AXI_arready - expected '" & to_string(AXI_arready_value) &
--            "' got '" & to_string(AXI_arready) & "'. rst: " & to_string(rst);
--    end if;
--    if rdrqA_get_valid_value /= 'X' then
--        assert rdrqA_get_valid = rdrqA_get_valid_value
--        report "rdrqA_get_valid - expected '" & to_string(rdrqA_get_valid_value) &
--            "' got '" & to_string(rdrqA_get_valid) & "'. rst: " & to_string(rst);
--    end if;
--    if rdrqA_get_data_value /= (
--      id => "XXXXXXXXXXXX",
--      addr => "XXXXXXXX",
--      len => "XXXX",
--      size => "XXX",
--      burst => "XX",
--      lock => "XX",
--      cache => "XXX",
--      prot => "XXX",
--      qos => "XXX"
--    ) then
--        assert rdrqA_get_data = rdrqA_get_data_value
--        report "rdrqA_get_data - expected " & to_string(to_integer(signed(rdrqA_get_data_value.addr))) &
--            " got " & to_string(to_integer(signed(rdrqA_get_data.addr)));
--    end if;
  end procedure check_cycle;
    
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
    if run("runner_cfg_default") then
      --lol
      -- Cycle 0 - arready correct?
      check_cycle (
        AXI_arready_value => '1',
        AXI_arvalid_value => '1',
        AXI_rdrqA_data_value => (
          id => "000000000000",
          addr => "01010101",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        ),
        rdrqA_get_en_value => '0',
        rdrqA_get_valid_value => '0',
        rdrqA_get_data_value => (
          id => "XXXXXXXXXXXX",
          addr => "XXXXXXXX",
          len => "XXXX",
          size => "XXX",
          burst => "XX",
          lock => "XX",
          cache => "XXX",
          prot => "XXX",
          qos => "XXX"
        )
      );

      -- Cycle 1 - get_valid correct?
      check_cycle (
        AXI_arready_value => '1',
        AXI_arvalid_value => '0',
        AXI_rdrqA_data_value => (
          id => "000000000000",
          addr => "01010101",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        ),
        rdrqA_get_en_value => '1',
        rdrqA_get_valid_value => '0',
        rdrqA_get_data_value => (
          id => "XXXXXXXXXXXX",
          addr => "XXXXXXXX",
          len => "XXXX",
          size => "XXX",
          burst => "XX",
          lock => "XX",
          cache => "XXX",
          prot => "XXX",
          qos => "XXX"
        )
      );

      -- Cycle 2 get_valid and get_data correct? arready correct?.
      check_cycle (
        AXI_arready_value => '1',
        AXI_arvalid_value => '0',
        AXI_rdrqA_data_value => (
          id => "XXXXXXXXXXXX",
          addr => "XXXXXXXX",
          len => "XXXX",
          size => "XXX",
          burst => "XX",
          lock => "XX",
          cache => "XXX",
          prot => "XXX",
          qos => "XXX"
        ),
        rdrqA_get_en_value => '1',
        rdrqA_get_valid_value => '0',
        rdrqA_get_data_value => (
          id => "000000000000",
          addr => "01010101",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        )
      );
    end if;
  end loop;

end process WaveGen_Proc;



end architecture tb1;

-------------------------------------------------------------------------------

configuration AXI4_Full_Slave_tb_tb1_cfg of AXI4_Full_Slave_tb is
  for tb1
  end for;
end AXI4_Full_Slave_tb_tb1_cfg;

-------------------------------------------------------------------------------
