-------------------------------------------------------------------------------
-- Title      : Testbench for design "Arch_Ifc"
-- Project    : TaPaSCo NoC Integration
-------------------------------------------------------------------------------
-- File       : Arch_Ifc_tb.vhd
-- Author     : Malte Nilges
-- Company    : 
-- Created    : 2019-11-24
-- Last update: 2019-12-09
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Testbench for Arch_Ifc
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Arke_pkg.all;
use work.NIC_pkg.all;

-------------------------------------------------------------------------------

entity Arch_Ifc_tb is

end entity Arch_Ifc_tb;


architecture tb1 of Arch_Ifc_tb is 

  -- component generics
  constant DIM_X_W    : integer := Log2(DIM_X);
  constant DIM_Y_W    : integer := Log2(DIM_Y);
  constant DIM_Z_W    : integer := Log2(DIM_Z);
  constant ADDR_W     : integer := DIM_X_W + DIM_Y_W + DIM_Z_W;

  type ADDR_MAP_TYPE is array (0 to DIM_X * DIM_Y * DIM_Z - 1) of std_logic_vector(ADDR_W - 1 downto 0);
  constant address : std_logic_vector := "000000";
  constant address_map : std_logic_vector := "001110010110000111110001111100111010110000001100000110000011101101101101111000101001111001101010010011000111010010001001100101000101011110111101000111111001111010";



  -- component ports
  signal clk              : std_logic := '1';
  signal rst              : std_logic := '1';
  signal AXI_arvalid      : std_logic;
  signal AXI_arready      : std_logic;
  signal AXI_araddr       : std_logic_vector( 7 downto 0 );
  signal AXI_arprot       : std_logic_vector( 2 downto 0 );
  signal AXI_awvalid      : std_logic;
  signal AXI_awready      : std_logic;
  signal AXI_awaddr       : std_logic_vector( 7 downto 0 );
  signal AXI_awprot       : std_logic_vector( 2 downto 0 );
  signal AXI_wvalid       : std_logic;
  signal AXI_wready       : std_logic;
  signal AXI_wdata        : std_logic_vector( 7 downto 0 );
  signal AXI_wstrb        : std_logic_vector( 3 downto 0 );
  signal AXI_rready       : std_logic;
  signal AXI_rvalid       : std_logic;
  signal AXI_rdata        : std_logic_vector( 7 downto 0 );
  signal AXI_rresp        : std_logic_vector( 1 downto 0 );
  signal AXI_bready       : std_logic;
  signal AXI_bvalid       : std_logic;
  signal AXI_bresp        : std_logic_vector( 1 downto 0 );

  signal dataOut          : std_logic_vector(    DATA_WIDTH - 1 downto 0 );
  signal controlOut       : std_logic_vector( CONTROL_WIDTH - 1 downto 0 );
  signal dataIn           : std_logic_vector(    DATA_WIDTH - 1 downto 0 );
  signal controlIn        : std_logic_vector( CONTROL_WIDTH - 1 downto 0 );

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
  DUT: entity work.Arch_Ifc
    generic map (
      address => address,
      address_map => address_map)
    port map (
      clk            => clk,
      rst            => rst,
      AXI_arvalid    => AXI_arvalid,
      AXI_arready    => AXI_arready,
      AXI_araddr     => AXI_araddr,
      AXI_arprot     => AXI_arprot,
      AXI_awvalid    => AXI_awvalid,
      AXI_awready    => AXI_awready,
      AXI_awaddr     => AXI_awaddr,
      AXI_awprot     => AXI_awprot,
      AXI_wvalid     => AXI_wvalid,
      AXI_wready     => AXI_wready,
      AXI_wdata      => AXI_wdata,
      AXI_wstrb      => AXI_wstrb,
      AXI_rready     => AXI_rready,
      AXI_rvalid     => AXI_rvalid,
      AXI_rdata      => AXI_rdata,
      AXI_rresp      => AXI_rresp,
      AXI_bready     => AXI_bready,
      AXI_bvalid     => AXI_bvalid,
      AXI_bresp      => AXI_bresp,
      dataOut        => dataOut,
      controlOut     => controlOut,
      dataIn         => dataIn,
      controlIn      => controlIn);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc : process

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
    AXI_arvalid     <= AXI_arvalid_value;
    AXI_araddr      <= AXI_araddr_value;
    AXI_arprot      <= AXI_arprot_value;
    AXI_awvalid     <= AXI_awvalid_value;
    AXI_awaddr      <= AXI_awaddr_value;
    AXI_awprot      <= AXI_awprot_value;
    AXI_wvalid      <= AXI_wvalid_value;
    AXI_wdata       <= AXI_wdata_value;
    AXI_wstrb       <= AXI_wstrb_value;
    
    --data in
    dataIn          <= dataIn_value;
    controlIn       <= controlIn_value;

    --rsp in
    AXI_rready      <= AXI_rready_value;
    AXI_bready      <= AXI_bready_value;
    wait until rising_edge(clk);

    --req out
    if (AXI_arready_value /= 'X') then
      assert AXI_arready = AXI_arready_value
      report "AXI_arready - expected '" & to_string(AXI_arready_value) &
          "' got '" & to_string(AXI_arready) & "'";
    end if;
    if (AXI_awready_value /= 'X') then
      assert AXI_awready = AXI_awready_value
      report "AXI_awready - expected '" & to_string(AXI_awready_value) &
          "' got '" & to_string(AXI_awready) & "'";
    end if;
    if (AXI_wready_value /= 'X') then
      assert AXI_wready = AXI_wready_value
      report "AXI_wready - expected '" & to_string(AXI_wready_value) &
          "' got '" & to_string(AXI_wready) & "'";
    end if;

    --data out
    if (dataOut_value /= "XXX") then
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
    if (AXI_rvalid_value /= 'X') then
      assert AXI_rvalid = AXI_rvalid_value
      report "AXI_rvalid - expected '" & to_string(AXI_rvalid_value) &
          "' got '" & to_string(AXI_rvalid) & "'";
    end if;
    if (AXI_rdata_value /= "XXXXXXXX") then
      assert AXI_rdata = AXI_rdata_value
      report "AXI_rdata - expected '" & to_string(AXI_rdata_value) &
          "' got '" & to_string(AXI_rdata) & "'";
    end if;
    if (AXI_bvalid_value /= 'X') then
      assert AXI_bvalid = AXI_bvalid_value
      report "AXI_bvalid - expected '" & to_string(AXI_bvalid_value) &
          "' got '" & to_string(AXI_bvalid) & "'";
    end if;
    if (AXI_bresp_value /= "XX") then
      assert AXI_bresp = AXI_bresp_value
      report "AXI_bresp - expected '" & to_string(AXI_bresp_value) &
          "' got '" & to_string(AXI_bresp) & "'";
    end if;
  end procedure check_cycle;

  begin
    -- insert signal assignments here

    wait for 30 ns;
    rst <= '0';
    wait until rising_edge(clk);

    -------------------------------------------------------------- 001
    -- in
    AXI_arvalid_value     := '1';
    AXI_araddr_value      := "00000001";
    AXI_arprot_value      := "111";
    AXI_awvalid_value     := '0';
    AXI_awaddr_value      := "00000000";
    AXI_awprot_value      := "000";
    AXI_wvalid_value      := '0';
    AXI_wdata_value       := "00000000";
    AXI_wstrb_value       := "0000";

    dataIn_value          := (others => '1');
    controlIn_value       := "111";

    AXI_rready_value      := '1';
    AXI_bready_value      := '1';

    -- out
    AXI_arready_value     := '1';
    AXI_awready_value     := '1';
    AXI_wready_value      := '1';
    
    dataOut_value         := (others => '0');
    controlOut_value      := "100";

    AXI_rvalid_value      := '0';
    AXI_rdata_value       := "XXXXXXXX";
    AXI_rresp_value       := "XX";
    AXI_bvalid_value      := '0';
    AXI_bresp_value       := "XX";

    check_cycle;
    -------------------------------------------------------------- 002
    -- in
    AXI_araddr_value      := "00010001";
    AXI_arprot_value      := "111";

    dataIn_value          := (others => '0');
    controlIn_value       := "101";
    -- out

    check_cycle;
    -------------------------------------------------------------- 003
    vec_rdrqa             := "00000001111";
    address               := address_map_c(to_Integer(unsigned(vec_rdrqa(10 downto 3))) + 1);
    -- in
    AXI_araddr_value      := "00001100";
    AXI_arprot_value      := "000";

    dataIn_value          := '0' & "00" & ZERO(dataOut'left - 3 downto vec_rdrqa'length + ADDR_W) & vec_rdrqa & address;

    AXI_rready_value      := '0';
    AXI_bready_value      := '0';
    -- out
    AXI_arready_value     := '0';
    dataOut_value         := '0' & "00" & ZERO(dataOut'left - 3 downto vec_rdrqa'length + ADDR_W) & vec_rdrqa & address;
    controlOut_value      := "111";

    AXI_bvalid_value      := '1';
    AXI_bresp_value       := "11";

    check_cycle;
    -------------------------------------------------------------- 004
    vec_rdrqa             := "00010001111";
    address               := address_map_c(to_Integer(unsigned(vec_rdrqa(10 downto 3))) + 1);
    -- in
    AXI_awvalid_value     := '1';
    AXI_awaddr_value      := "00000010";
    AXI_awprot_value      := "010";
    AXI_wvalid_value      := '1';
    AXI_wdata_value       := "00100000";
    AXI_wstrb_value       := "0011";

    dataIn_value          := '0' & "00" & ZERO(dataOut'left - 3 downto vec_rdrqa'length + ADDR_W) & vec_rdrqa & address;
    -- out

    AXI_rvalid_value      := '1';
    AXI_rdata_value       := "00000000";
    AXI_rresp_value       := "00";

    check_cycle;
    -------------------------------------------------------------- 005
    vec_rdrqa             := "00000010010";
    address               := address_map_c(to_Integer(unsigned(vec_rdrqa(10 downto 3))) + 1);
    -- in
    AXI_awvalid_value     := '0';
    AXI_wvalid_value      := '0';

    dataIn_value          := '0' & "10" & ZERO(dataOut'left - 3 downto vec_rdrqa'length + ADDR_W) & vec_rdrqa & address;
    controlIn_value       := "111";

    AXI_rready_value      := '1';
    AXI_bready_value      := '1';
    -- out

    AXI_rdata_value       := "00000011";
    AXI_rresp_value       := "11";

    check_cycle;
    -------------------------------------------------------------- 006
    vec_rdrqa             := "00000111011";
    address               := address_map_c(to_Integer(unsigned(vec_rdrqa(10 downto 3))) + 1);
    -- in
    AXI_rready_value      := '1';
    AXI_bready_value      := '1';

    dataIn_value          := '0' & "10" & ZERO(dataOut'left - 3 downto vec_rdrqa'length + ADDR_W) & vec_rdrqa & address;
    controlIn_value       := "111";
    -- out

    check_cycle;
    -------------------------------------------------------------- 007
    vec_rdrqa             := "00000010010";
    address               := address_map_c(to_Integer(unsigned(vec_rdrqa(10 downto 3))) + 1);
    -- in
    dataIn_value          := '0' & "00" & ZERO(dataOut'left - 3 downto vec_rdrqa'length + ADDR_W) & vec_rdrqa & address;
    controlIn_value       := "111";
    -- out

    AXI_rdata_value       := "00000011";
    AXI_rresp_value       := "11";

    check_cycle;
    
    wait for 100 ns * 10;
  end process WaveGen_Proc;

end architecture tb1;

-------------------------------------------------------------------------------

configuration Arch_Ifc_tb_tb1_cfg of Arch_Ifc_tb is
  for tb1
  end for;
end Arch_Ifc_tb_tb1_cfg;

-------------------------------------------------------------------------------
