-------------------------------------------------------------------------------
-- Title      : Testbench for design "Arch_Ifc"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Arch_Ifc_tb.vhd
-- Author     : malte  <malte@linux.fritz.box>
-- Company    : 
-- Created    : 2019-11-24
-- Last update: 2019-11-24
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-11-24  1.0      malte	Created
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
  constant address : std_logic_vector := "000000";
  constant address_map : std_logic_vector := "001110010110000111110001111100111010110000001100000110000011101101101101111000101001111001101010010011000111010010001001100101000101011110111101000111111001111010";



  -- component ports
  signal clk              : std_logic := '1';
    signal rst            : std_logic := '1';
    signal AXI_arvalid    : std_logic;
    signal AXI_arready    : std_logic;
    signal AXI_rdrqA_data : AXI4_Lite_Rd_RqA;
    signal AXI_awvalid    : std_logic;
    signal AXI_awready    : std_logic;
    signal AXI_wrrqA_data : AXI4_Lite_Wr_RqA;
    signal AXI_wvalid     : std_logic;
    signal AXI_wready     : std_logic;
    signal AXI_wrrqD_data : AXI4_Lite_Wr_RqD;
    signal AXI_rready     : std_logic;
    signal AXI_rvalid     : std_logic;
    signal AXI_rdrsp_data : AXI4_Lite_Rd_Rsp;
    signal AXI_bready     : std_logic;
    signal AXI_bvalid     : std_logic;
    signal AXI_wrrsp_data : AXI4_Lite_Wr_Rsp;
    signal dataOut        : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal controlOut     : std_logic_vector(CONTROL_WIDTH - 1 downto 0);
    signal dataIn         : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal controlIn      : std_logic_vector(CONTROL_WIDTH - 1 downto 0);

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
      AXI_rdrqA_data => AXI_rdrqA_data,
      AXI_awvalid    => AXI_awvalid,
      AXI_awready    => AXI_awready,
      AXI_wrrqA_data => AXI_wrrqA_data,
      AXI_wvalid     => AXI_wvalid,
      AXI_wready     => AXI_wready,
      AXI_wrrqD_data => AXI_wrrqD_data,
      AXI_rready     => AXI_rready,
      AXI_rvalid     => AXI_rvalid,
      AXI_rdrsp_data => AXI_rdrsp_data,
      AXI_bready     => AXI_bready,
      AXI_bvalid     => AXI_bvalid,
      AXI_wrrsp_data => AXI_wrrsp_data,
      dataOut        => dataOut,
      controlOut     => controlOut,
      dataIn         => dataIn,
      controlIn      => controlIn);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  procedure check_cycle (
    --request check
    constant AXI_arvalid_value    : in std_logic;
    constant AXI_rdrqA_data_value : in AXI4_Lite_Rd_RqA;
    constant AXI_awvalid_value    : in std_logic;
    constant AXI_wrrqA_data_value : in AXI4_Lite_Wr_RqA;
    constant AXI_wvalid_value     : in std_logic;
    constant AXI_wrrqD_data_value : in AXI4_Lite_Wr_RqD;

    --response check
    constant AXI_rready_value     : in std_logic;
    constant AXI_bready_value     : in std_logic;
    constant dataIn_value         : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    constant controlIn_value      : in std_logic_vector(CONTROL_WIDTH - 1 downto 0)
  ) is
  begin
    AXI_arvalid     <= AXI_arvalid_value;
    AXI_rdrqA_data  <= AXI_rdrqA_data_value;
    AXI_awvalid     <= AXI_awvalid_value;
    AXI_wrrqA_data  <= AXI_wrrqA_data_value;
    AXI_wvalid      <= AXI_wvalid_value;
    AXI_wrrqD_data  <= AXI_wrrqD_data_value;
    
    AXI_rready      <= AXI_rready_value;
    AXI_bready      <= AXI_bready_value;
    dataIn          <= dataIn_value;
    controlIn       <= controlIn_value;
    wait until rising_edge(clk);

    while (AXI_arready = '0') loop
      wait until rising_edge(clk);
    end loop;
  end procedure check_cycle;
  begin
    -- insert signal assignments here

    wait for 30 ns;
    rst <= '0';
    wait until rising_edge(clk);

    ---controlIn <= "100" after 100 ns;
    
    check_cycle (
      AXI_arvalid_value => '1',
      AXI_rdrqA_data_value => (
        addr => std_logic_vector(to_unsigned(25, 8)),
        prot => "000"
      ),
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
      AXI_rready_value => '1',
      AXI_bready_value => '1',
      dataIn_value  => (others => '1'),
      controlIn_value => "011"
    );
    check_cycle (
      AXI_arvalid_value => '1',
      AXI_rdrqA_data_value => (
        addr => std_logic_vector(to_unsigned(20, 8)),
        prot => "000"
      ),
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
      AXI_rready_value => '1',
      AXI_bready_value => '1',
      dataIn_value  => (others => '0'),
      controlIn_value => "011"
    );
    check_cycle (
      AXI_arvalid_value => '1',
      AXI_rdrqA_data_value => (
        addr => std_logic_vector(to_unsigned(1, 8)),
        prot => "000"
      ),
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
      AXI_rready_value => '1',
      AXI_bready_value => '1',
      dataIn_value  => (others => '0'),
      controlIn_value => "000"
    );
    check_cycle (
      AXI_arvalid_value => '1',
      AXI_rdrqA_data_value => (
        addr => std_logic_vector(to_unsigned(10, 8)),
        prot => "000"
      ),
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
      AXI_rready_value => '1',
      AXI_bready_value => '1',
      dataIn_value  => (others => '0'),
      controlIn_value => "000"
    );
    check_cycle (
      AXI_arvalid_value => '1',
      AXI_rdrqA_data_value => (
        addr => std_logic_vector(to_unsigned(5, 8)),
        prot => "111"
      ),
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
      AXI_rready_value => '0',
      AXI_bready_value => '0',
      dataIn_value  => (others => '0'),
      controlIn_value => "100"
    );
    check_cycle (
      AXI_arvalid_value => '1',
      AXI_rdrqA_data_value => (
        addr => std_logic_vector(to_unsigned(15, 8)),
        prot => "000"
      ),
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
      AXI_rready_value => '0',
      AXI_bready_value => '0',
      dataIn_value  => (others => '0'),
      controlIn_value => "100"
    );
    --if(AXI_arready = '1') then
    --  AXI_arvalid <= '0';
    --end if;
    --wait until rising_edge(clk);
    wait for 100 ns * 10;
  end process WaveGen_Proc;

end architecture tb1;

-------------------------------------------------------------------------------

configuration Arch_Ifc_tb_tb1_cfg of Arch_Ifc_tb is
  for tb1
  end for;
end Arch_Ifc_tb_tb1_cfg;

-------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
