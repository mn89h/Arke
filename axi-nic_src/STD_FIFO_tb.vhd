-------------------------------------------------------------------------------
-- Title      : Testbench for design "STD_FIFO"
-- Project    : TaPaSCo NoC Integration
-------------------------------------------------------------------------------
-- File       : STD_FIFO_tb.vhd
-- Author     : Malte Nilges
-- Company    : 
-- Created    : 2019-11-19
-- Last update: 2019-12-09
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Testbench for STD_FIFO w/ alternating and concurrent r/w access
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;

-------------------------------------------------------------------------------

entity STD_FIFO_tb is

end entity STD_FIFO_tb;

-------------------------------------------------------------------------------

architecture tb1 of STD_FIFO_tb is

  -- component generics
  constant data_width : positive := AXI4_Lite_Wr_RqA_WIDTH;
  constant fifo_depth : positive := 2;

  -- component ports
  signal clk         : std_logic := '1';
  signal rst         : std_logic := '1';
  signal WrValid_in  : std_logic;
  signal WrReady_out : std_logic;
  signal WrData_in   : std_logic_vector(data_width - 1 downto 0);
  signal RdReady_in  : std_logic;
  signal RdData_out  : std_logic_vector(data_width - 1 downto 0);
  signal RdValid_out : std_logic;

  signal Cycle       : natural := 1;

begin  -- architecture tb1

  -- component instantiation
  DUT: entity work.STD_FIFO
    generic map (
      data_width => data_width,
      fifo_depth => fifo_depth)
    port map (
      clk         => clk,
      rst         => rst,
      WrValid_in  => WrValid_in,
      WrReady_out => WrReady_out,
      WrData_in   => WrData_in,
      RdReady_in  => RdReady_in,
      RdData_out  => RdData_out,
      RdValid_out => RdValid_out);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  procedure check_cycle (
      constant WrValid_in_value   : in std_logic;
      constant WrReady_out_value  : in std_logic;
      constant WrData_in_value    : in std_logic_vector(data_width - 1 downto 0);
      constant RdReady_in_value   : in std_logic;
      constant RdData_out_value   : in std_logic_vector(data_width - 1 downto 0);
      constant RdValid_out_value  : in std_logic
    ) is
    begin
        report "CYCLE " & to_string(Cycle) & " --------------------------------------";
        Cycle <= Cycle + 1;
        WrValid_in   <= WrValid_in_value;
        WrData_in    <= WrData_in_value;  
        RdReady_in   <= RdReady_in_value;
        wait until rising_edge(clk);
        if (WrReady_out_value /= 'X') then
          assert WrReady_out = WrReady_out_value
          report "WrReady_out - expected '" & to_string(WrReady_out_value) &
              "' got '" & to_string(WrReady_out) & "'";
        end if;
        if RdValid_out_value /= 'X' then
          assert RdValid_out = RdValid_out_value
          report "RdValid_out - expected '" & to_string(RdValid_out_value) &
              "' got '" & to_string(RdValid_out) & "'";
        end if;
        if RdData_out_value /= "XXXXXXXXXXX" then
          assert RdData_out = RdData_out_value
          report "RdData_out - expected " & to_string(to_integer(signed(RdData_out_value))) &
              " got " & to_string(to_integer(signed(RdData_out)));
        end if;
        
    end procedure;
    begin
      -- insert signal assignments here
      report "CYCLE SetUp";
      wait for 30 ns;
      rst <= '0';
      wait until rising_edge(clk);

      check_cycle(        --001
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "01000000000",
        RdReady_in_value   => '0',
        RdData_out_value   => "UUUUUUUUUUU",
        RdValid_out_value  => '0'
      );
      check_cycle(        --002
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "10000000000",
        RdReady_in_value   => '0',
        RdData_out_value   => "01000000000",
        RdValid_out_value  => '1'
      );
      check_cycle(        --003
        WrValid_in_value   => '1',
        WrReady_out_value  => '0',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '0',
        RdData_out_value   => "01000000000",
        RdValid_out_value  => '1'
      );
      check_cycle(        --004
        WrValid_in_value   => '1',
        WrReady_out_value  => '0',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "01000000000",
        RdValid_out_value  => '1'
      );
      check_cycle(        --005
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "10000000000",
        RdValid_out_value  => '1'
      );
      check_cycle(        --006
        WrValid_in_value   => '0',
        WrReady_out_value  => '1',
        WrData_in_value    => "10101000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "00000000000",
        RdValid_out_value  => '1'
      );
      check_cycle(        --007
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "10101000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "10101000000",
        RdValid_out_value  => '0'
      );
      check_cycle(        --008
        WrValid_in_value   => '0',
        WrReady_out_value  => '1',
        WrData_in_value    => "10101010101",
        RdReady_in_value   => '1',
        RdData_out_value   => "10101000000",
        RdValid_out_value  => '1'
      );
      check_cycle(        --009
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "10101010101",
        RdReady_in_value   => '1',
        RdData_out_value   => "10101010101",
        RdValid_out_value  => '0'
      );
      check_cycle(        --010
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "10101010101",
        RdValid_out_value  => '1'
      );
      check_cycle(        --011
        WrValid_in_value   => '0',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000100000",
        RdReady_in_value   => '1',
        RdData_out_value   => "00000000000",
        RdValid_out_value  => '1'
      );
      check_cycle(        --012
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "11111111111",
        RdReady_in_value   => '0',
        RdData_out_value   => "00000100000",
        RdValid_out_value  => '0'
      );
      check_cycle(        --013
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "11001100110",
        RdReady_in_value   => '0',
        RdData_out_value   => "11111111111",
        RdValid_out_value  => '1'
      );
      check_cycle(        --014
        WrValid_in_value   => '1',
        WrReady_out_value  => '0',
        WrData_in_value    => "00110000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "11111111111",
        RdValid_out_value  => '1'
      );
      check_cycle(        --015
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "10000000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "11001100110",
        RdValid_out_value  => '1'
      );
      check_cycle(        --016
        WrValid_in_value   => '0',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "10000000000",
        RdValid_out_value  => '1'
      );
      check_cycle(        --017
        WrValid_in_value   => '0',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '0',
        RdData_out_value   => "00000000000",
        RdValid_out_value  => '0'
      );
      check_cycle(        --018
        WrValid_in_value   => '0',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '0',
        RdData_out_value   => "00000000000",
        RdValid_out_value  => '0'
      );
      check_cycle(        --019
        WrValid_in_value   => '0',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '0',
        RdData_out_value   => "00000000000",
        RdValid_out_value  => '0'
      );
      check_cycle(        --020
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "01111111110",
        RdReady_in_value   => '1',
        RdData_out_value   => "00000000000",
        RdValid_out_value  => '0'
      );
      check_cycle(        --021
        WrValid_in_value   => '0',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "01111111110",
        RdValid_out_value  => '1'
      );
      check_cycle(        --022
        WrValid_in_value   => '0',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "00000000000",
        RdValid_out_value  => '0'
      );
      check_cycle(        --023
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "01100000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "00000000000",
        RdValid_out_value  => '0'
      );
      check_cycle(        --024
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "01100000000",
        RdValid_out_value  => '1'
      );
      check_cycle(        --025
        WrValid_in_value   => '1',
        WrReady_out_value  => '1',
        WrData_in_value    => "10000000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "00000000000",
        RdValid_out_value  => '1'
      );
      check_cycle(        --026
        WrValid_in_value   => '0',
        WrReady_out_value  => '1',
        WrData_in_value    => "00000000000",
        RdReady_in_value   => '1',
        RdData_out_value   => "10000000000",
        RdValid_out_value  => '1'
      );
      wait for 3000 ns;
      assert FALSE Report "Simulation Finished" severity FAILURE;
    end process WaveGen_Proc;
  

end architecture tb1;

-------------------------------------------------------------------------------

configuration STD_FIFO_tb_tb1_cfg of STD_FIFO_tb is
  for tb1
  end for;
end STD_FIFO_tb_tb1_cfg;

-------------------------------------------------------------------------------
