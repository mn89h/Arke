-------------------------------------------------------------------------------
-- Title      : Testbench for design "Mem_Ifc"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Mem_Ifc_tb.vhd
-- Author     : Malte Nilges  <malte@DESKTOP-TF6PRO>
-- Company    : 
-- Created    : 2019-12-16
-- Last update: 2019-12-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-12-16  1.0      malte	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Arke_pkg.all;
use work.NIC_pkg.all;

-------------------------------------------------------------------------------

entity Mem_Ifc_tb is

end entity Mem_Ifc_tb;

-------------------------------------------------------------------------------

architecture tb1 of Mem_Ifc_tb is

  -- component generics
  constant DIM_X_W    : integer := Log2(DIM_X);
  constant DIM_Y_W    : integer := Log2(DIM_Y);
  constant DIM_Z_W    : integer := Log2(DIM_Z);
  constant ADDR_W     : integer := DIM_X_W + DIM_Y_W + DIM_Z_W;

  type ADDR_MAP_TYPE is array (0 to DIM_X * DIM_Y * DIM_Z - 1) of std_logic_vector(ADDR_W - 1 downto 0);
  constant address : std_logic_vector := "000000";
  constant address_map : std_logic_vector := "001110010110000111110001111100111010110000001100000110000011101101101101111000101001111001101010010011000111010010001001100101000101011110111101000111111001111010";

  -- component ports
  signal clk         : std_logic := '1';
  signal rst         : std_logic := '1';
  signal AXI_arvalid : std_logic;
  signal AXI_arready : std_logic;
  signal AXI_araddr  : std_logic_vector(39 downto 32);
  signal AXI_arid    : std_logic_vector(31 downto 20);
  signal AXI_arlen   : std_logic_vector(19 downto 16);
  signal AXI_arsize  : std_logic_vector(15 downto 13);
  signal AXI_arburst : std_logic_vector(12 downto 11);
  signal AXI_arlock  : std_logic_vector(10 downto 9);
  signal AXI_arcache : std_logic_vector(8 downto 6);
  signal AXI_arprot  : std_logic_vector(5 downto 3);
  signal AXI_arqos   : std_logic_vector(2 downto 0);
  signal AXI_awvalid : std_logic;
  signal AXI_awready : std_logic;
  signal AXI_awaddr  : std_logic_vector(39 downto 32);
  signal AXI_awid    : std_logic_vector(31 downto 20);
  signal AXI_awlen   : std_logic_vector(19 downto 16);
  signal AXI_awsize  : std_logic_vector(15 downto 13);
  signal AXI_awburst : std_logic_vector(12 downto 11);
  signal AXI_awlock  : std_logic_vector(10 downto 9);
  signal AXI_awcache : std_logic_vector(8 downto 6);
  signal AXI_awprot  : std_logic_vector(5 downto 3);
  signal AXI_awqos   : std_logic_vector(2 downto 0);
  signal AXI_wvalid  : std_logic;
  signal AXI_wready  : std_logic;
  signal AXI_wdata   : std_logic_vector(24 downto 17);
  signal AXI_wid     : std_logic_vector(16 downto 5);
  signal AXI_wstrb   : std_logic_vector(4 downto 1);
  signal AXI_wlast   : std_logic_vector(0 downto 0);
  signal AXI_rready  : std_logic;
  signal AXI_rvalid  : std_logic;
  signal AXI_rdata   : std_logic_vector(22 downto 15);
  signal AXI_rid     : std_logic_vector(14 downto 3);
  signal AXI_rresp   : std_logic_vector(2 downto 1);
  signal AXI_rlast   : std_logic_vector(0 downto 0);
  signal AXI_bready  : std_logic;
  signal AXI_bvalid  : std_logic;
  signal AXI_bid     : std_logic_vector(13 downto 2);
  signal AXI_bresp   : std_logic_vector(1 downto 0);

  signal dataOut     : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal controlOut  : std_logic_vector(CONTROL_WIDTH - 1 downto 0);
  signal dataIn      : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal controlIn   : std_logic_vector(CONTROL_WIDTH - 1 downto 0);

  signal Cycle       : natural := 1;


  function to_ADDR_MAP_TYPE (
      slv : std_logic_vector
      ) return ADDR_MAP_TYPE is
      variable result : ADDR_MAP_TYPE := (others => (others => '0'));
  begin
      for i in 0 to DIM_X * DIM_Y * DIM_Z - 1 loop
          result(i) := slv(i * ADDR_W to (i+1) * ADDR_W - 1);
      end loop;
      return result;
  end function;

  constant address_map_c : ADDR_MAP_TYPE := to_ADDR_MAP_TYPE(address_map);

begin  -- architecture tb1

  -- component instantiation
  DUT: entity work.Mem_Ifc
    generic map (
      address     => address,
      address_map => address_map)
    port map (
      clk         => clk,
      rst         => rst,
      AXI_arvalid => AXI_arvalid,
      AXI_arready => AXI_arready,
      AXI_araddr  => AXI_araddr,
      AXI_arid    => AXI_arid,
      AXI_arlen   => AXI_arlen,
      AXI_arsize  => AXI_arsize,
      AXI_arburst => AXI_arburst,
      AXI_arlock  => AXI_arlock,
      AXI_arcache => AXI_arcache,
      AXI_arprot  => AXI_arprot,
      AXI_arqos   => AXI_arqos,
      AXI_awvalid => AXI_awvalid,
      AXI_awready => AXI_awready,
      AXI_awaddr  => AXI_awaddr,
      AXI_awid    => AXI_awid,
      AXI_awlen   => AXI_awlen,
      AXI_awsize  => AXI_awsize,
      AXI_awburst => AXI_awburst,
      AXI_awlock  => AXI_awlock,
      AXI_awcache => AXI_awcache,
      AXI_awprot  => AXI_awprot,
      AXI_awqos   => AXI_awqos,
      AXI_wvalid  => AXI_wvalid,
      AXI_wready  => AXI_wready,
      AXI_wdata   => AXI_wdata,
      AXI_wid     => AXI_wid,
      AXI_wstrb   => AXI_wstrb,
      AXI_wlast   => AXI_wlast,
      AXI_rready  => AXI_rready,
      AXI_rvalid  => AXI_rvalid,
      AXI_rdata   => AXI_rdata,
      AXI_rid     => AXI_rid,
      AXI_rresp   => AXI_rresp,
      AXI_rlast   => AXI_rlast,
      AXI_bready  => AXI_bready,
      AXI_bvalid  => AXI_bvalid,
      AXI_bid     => AXI_bid,
      AXI_bresp   => AXI_bresp,
      dataOut     => dataOut,
      controlOut  => controlOut,
      dataIn      => dataIn,
      controlIn   => controlIn);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process

  variable vec_wrrqa      : std_logic_vector(AXI4_Lite_Wr_RqA_WIDTH - 1 downto 0);
  variable vec_wrrqd      : std_logic_vector(AXI4_Lite_Wr_RqD_WIDTH - 1 downto 0);
  variable vec_rdrqa      : std_logic_vector(AXI4_Lite_Rd_RqA_WIDTH - 1 downto 0);
  variable address        : std_logic_vector(ADDR_W - 1 downto 0);

  --req in
  variable AXI_arvalid_value    : std_logic;
  variable AXI_araddr_value     : std_logic_vector( 7 downto 0 );
  variable AXI_arprot_value     : std_logic_vector( 2 downto 0 );
  variable AXI_awvalid_value    : std_logic;
  variable AXI_awaddr_value     : std_logic_vector( 7 downto 0 );
  variable AXI_awprot_value     : std_logic_vector( 2 downto 0 );
  variable AXI_wvalid_value     : std_logic;
  variable AXI_wdata_value      : std_logic_vector( 7 downto 0 );
  variable AXI_wstrb_value      : std_logic_vector( 3 downto 0 );

  --req out
  variable AXI_arready_value    : std_logic;
  variable AXI_awready_value    : std_logic;
  variable AXI_wready_value     : std_logic;

  --data out
  variable dataOut_value        : std_logic_vector(DATA_WIDTH - 1 downto 0);
  variable controlOut_value     : std_logic_vector(CONTROL_WIDTH - 1 downto 0);
  
  --data in
  variable dataIn_value         : std_logic_vector(DATA_WIDTH - 1 downto 0);
  variable controlIn_value      : std_logic_vector(CONTROL_WIDTH - 1 downto 0);

  --rsp in
  variable AXI_rready_value     : std_logic;
  variable AXI_bready_value     : std_logic;

  --rsp out
  variable AXI_rvalid_value     : std_logic;
  variable AXI_rdata_value      : std_logic_vector( 7 downto 0 );
  variable AXI_rresp_value      : std_logic_vector( 1 downto 0 );
  variable AXI_bvalid_value     : std_logic;
  variable AXI_bresp_value      : std_logic_vector( 1 downto 0 );
  
  procedure check_cycle is
  begin
    report "CYCLE " & to_string(Cycle) & " --------------------------------------";
    Cycle <= Cycle + 1;

    --req in
    AXI_arready     <= AXI_arready_value;
    AXI_awready     <= AXI_awready_value;
    AXI_wready      <= AXI_wready_value;

    --data in
    dataIn          <= dataIn_value;
    controlIn       <= controlIn_value;

    --rsp in
    AXI_rvalid      <= AXI_rvalid_value;
    AXI_rdata       <= AXI_rdata_value;
    AXI_bvalid      <= AXI_bvalid_value;
    AXI_bresp       <= AXI_bresp_value;
    wait until rising_edge(clk);

    --req out
    if (AXI_arvalid_value /= 'X') then
      assert AXI_arvalid = AXI_arvalid_value
      report "AXI_arvalid - expected '" & to_string(AXI_arvalid_value) &
          "' got '" & to_string(AXI_arvalid) & "'";
    end if;
    if (AXI_araddr_value /= "XXXXXXXX") then
      assert AXI_araddr = AXI_araddr_value
      report "AXI_araddr - expected '" & to_string(AXI_araddr_value) &
          "' got '" & to_string(AXI_araddr) & "'";
    end if;
    if (AXI_arprot_value /= "XXX") then
      assert AXI_arprot = AXI_arprot_value
      report "AXI_arprot - expected '" & to_string(AXI_arprot_value) &
          "' got '" & to_string(AXI_arprot) & "'";
    end if;
    if (AXI_awvalid_value /= 'X') then
      assert AXI_awvalid = AXI_awvalid_value
      report "AXI_awvalid - expected '" & to_string(AXI_awvalid_value) &
          "' got '" & to_string(AXI_awvalid) & "'";
    end if;
    if (AXI_awaddr_value /= "XXXXXXXX") then
      assert AXI_awaddr = AXI_awaddr_value
      report "AXI_awaddr - expected '" & to_string(AXI_awaddr_value) &
          "' got '" & to_string(AXI_awaddr) & "'";
    end if;
    if (AXI_awprot_value /= "XXX") then
      assert AXI_awprot = AXI_awprot_value
      report "AXI_awprot - expected '" & to_string(AXI_awprot_value) &
          "' got '" & to_string(AXI_awprot) & "'";
    end if;
    if (AXI_wvalid_value /= 'X') then
      assert AXI_wvalid = AXI_wvalid_value
      report "AXI_wvalid - expected '" & to_string(AXI_wvalid_value) &
          "' got '" & to_string(AXI_wvalid) & "'";
    end if;
    if (AXI_wdata_value /= "XXXXXXXX") then
      assert AXI_wdata = AXI_wdata_value
      report "AXI_wdata - expected '" & to_string(AXI_wdata_value) &
          "' got '" & to_string(AXI_wdata) & "'";
    end if;
    if (AXI_wstrb_value /= "XXXX") then
      assert AXI_wstrb = AXI_wstrb_value
      report "AXI_wstrb - expected '" & to_string(AXI_wstrb_value) &
          "' got '" & to_string(AXI_wstrb) & "'";
    end if;

    --data out
    if (dataOut_value /= "XXXXXXXX") then
      assert dataOut = dataOut_value
      report "dataOut - expected '" & to_string(dataOut_value) &
          "' got '" & to_string(dataOut) & "'";
    end if;
    if (controlOut_value /= "XXX") then
      assert controlOut = controlOut_value
      report "controlOut - expected '" & to_string(controlOut_value) &
          "' got '" & to_string(controlOut) & "'";
    end if;

    --rsp out
    if (AXI_rready_value /= 'X') then
      assert AXI_rready = AXI_rready_value
      report "AXI_rready - expected '" & to_string(AXI_rready_value) &
          "' got '" & to_string(AXI_rready) & "'";
    end if;
    if (AXI_bready_value /= 'X') then
      assert AXI_bready = AXI_bready_value
      report "AXI_bready - expected '" & to_string(AXI_bready_value) &
          "' got '" & to_string(AXI_bready) & "'";
    end if;
  end procedure check_cycle;

  begin
    -- insert signal assignments here

    wait for 30 ns;
    rst <= '0';
    wait until rising_edge(clk);

    -------------------------------------------------------------- 001
    -- in
    AXI_arready_value     := '1';
    AXI_awready_value     := '1';
    AXI_wready_value      := '1';

    dataIn_value          := (others => '1');
    controlIn_value       := "111";

    AXI_rvalid_value      := '1';
    AXI_rdata_value       := "11111111";
    AXI_rresp_value       := "11";
    AXI_bvalid_value      := '0';
    AXI_bresp_value       := "11";

    -- out
    AXI_arvalid_value     := 'X';
    AXI_araddr_value      := "XXXXXXXX";
    AXI_arprot_value      := "XXX";
    AXI_awvalid_value     := 'X';
    AXI_awaddr_value      := "XXXXXXXX";
    AXI_awprot_value      := "XXX";
    AXI_wvalid_value      := 'X';
    AXI_wdata_value       := "XXXXXXXX";
    AXI_wstrb_value       := "XXXX";
    
    dataOut_value         := (others => '0');
    controlOut_value      := "100";

    AXI_rready_value      := 'X';
    AXI_bready_value      := 'X';

    check_cycle;
    wait until Clk = '1';
  end process WaveGen_Proc;

  

end architecture tb1;

-------------------------------------------------------------------------------

configuration Mem_Ifc_tb_tb1_cfg of Mem_Ifc_tb is
  for tb1
  end for;
end Mem_Ifc_tb_tb1_cfg;

-------------------------------------------------------------------------------
