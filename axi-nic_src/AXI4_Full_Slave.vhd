-------------------------------------------------------------------------------
-- Title      : AXI4_Full_Slave
-- Project    : TaPaSCo
-------------------------------------------------------------------------------
-- File       : AXI4_Full_Slave.vhd
-- Author     : Malte Nilges
-- Standard   : VHDL-2008
-------------------------------------------------------------------------------
-- Description: Provides simple serialization mechanism
-------------------------------------------------------------------------------
--
--    This library is free software; you can redistribute it and/or
--    modify it under the terms of the GNU Lesser General Public
--    License as published by the Free Software Foundation; either
--    version 2.1 of the License, or (at your option) any later version.

--    This library is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--    Lesser General Public License for more details.

--    You should have received a copy of the GNU Lesser General Public
--    License along with this library; if not, write to the Free Software
--    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;

entity AXI4_Full_Slave is
  port (
    ------------------------
    -- Incoming system clock
    ------------------------
    clk         : in std_logic;
    rst         : in std_logic; 

    -- ------------------------
    -- -- Write address channel    
    -- ------------------------
    -- AXI_awready : out std_logic := '0';
    -- AXI_awvalid : in  std_logic;    
    -- AXI_awid    : in  std_logic_vector ( 11 downto 0 );
    -- AXI_awaddr  : in  std_logic_vector ( 31 downto 0 );
    -- AXI_awlen   : in  std_logic_vector (  3 downto 0 );
    -- AXI_awsize  : in  std_logic_vector (  2 downto 0 );
    -- AXI_awburst : in  std_logic_vector (  1 downto 0 );
    -- AXI_awlock  : in  std_logic_vector (  1 downto 0 );
    -- AXI_awcache : in  std_logic_vector (  3 downto 0 );
    -- AXI_awprot  : in  std_logic_vector (  2 downto 0 );
    -- AXI_awqos   : in  std_logic_vector (  3 downto 0 );

    -- ------------------------
    -- -- Write Data channel    
    -- ------------------------
    -- AXI_wready  : out std_logic := '0';
    -- AXI_wvalid  : in  std_logic;
    -- AXI_wid     : in  std_logic_vector ( 11 downto 0 );
    -- AXI_wdata   : in  std_logic_vector ( 31 downto 0 );
    -- AXI_wstrb   : in  std_logic_vector (  3 downto 0 );
    -- AXI_wlast   : in  std_logic;

    -- ------------------------
    -- -- Read address channel
    -- ------------------------
    -- AXI_arready : out std_logic := '0';
    -- AXI_arvalid : in  std_logic;
    -- AXI_arid    : in  std_logic_vector ( 11 downto 0 );
    -- AXI_araddr  : in  std_logic_vector ( 31 downto 0 );
    -- AXI_arlen   : in  std_logic_vector (  3 downto 0 );
    -- AXI_arsize  : in  std_logic_vector (  2 downto 0 );
    -- AXI_arburst : in  std_logic_vector (  1 downto 0 );
    -- AXI_arlock  : in  std_logic_vector (  1 downto 0 );
    -- AXI_arcache : in  std_logic_vector (  3 downto 0 );
    -- AXI_arprot  : in  std_logic_vector (  2 downto 0 );
    -- AXI_arqos   : in  std_logic_vector (  3 downto 0 );

    -- ------------------------
    -- -- Read data channel
    -- ------------------------
    -- AXI_rready  : in  std_logic;
    -- AXI_rvalid  : out std_logic := '0';
    -- AXI_rid     : out std_logic_vector ( 11 downto 0 ) := (others => '0');
    -- AXI_rdata   : out std_logic_vector ( 31 downto 0 ) := (others => '0');
    -- AXI_rresp   : out std_logic_vector (  1 downto 0 ) := (others => '0');
    -- AXI_rlast   : out std_logic := '0';

    -- ------------------------
    -- -- Write status channel 
    -- ------------------------
    -- AXI_bready  : in  std_logic;
    -- AXI_bvalid  : out std_logic := '0';
    -- AXI_bid     : out std_logic_vector ( 11 downto 0 ) := (others => '0');
    -- AXI_bresp   : out std_logic_vector (  1 downto 0 ) := (others => '0');

    
    ---------------------------------
    -- System interface
    -- Connect to a Master Interface
    ---------------------------------
    AXI_arvalid     : in  std_logic;
    AXI_arready     : out std_logic;
    AXI_rdrqA_data  : in  AXI4_Full_Rd_RqA;

    AXI_awvalid     : in  std_logic;
    AXI_awready     : out std_logic;
    AXI_wrrqA_data  : in  AXI4_Full_Wr_RqA;

    AXI_wvalid      : in  std_logic;
    AXI_wready      : out std_logic;
    AXI_wrrqD_data  : in  AXI4_Full_Wr_RqD;

    AXI_rready      : in  std_logic;
    AXI_rvalid      : out std_logic;
    AXI_rdrsp_data  : out AXI4_Full_Rd_Rsp;

    AXI_bready      : in  std_logic;
    AXI_bvalid      : out std_logic;
    AXI_wrrsp_data  : out AXI4_Full_Wr_Rsp;

    ---------------------------------
    -- User interface
    -- Access GET Ifc: Enable the get request and validate the received data
    -- Access PUT Ifc: Check the ready signal and enable the data transfer
    ---------------------------------
    rdrqA_get_valid : out std_logic;
    rdrqA_get_en    : in  std_logic;
    rdrqA_get_data  : out AXI4_Full_Rd_RqA;

    wrrqA_get_valid : out std_logic;
    wrrqA_get_en    : in  std_logic;
    wrrqA_get_data  : out AXI4_Full_Wr_RqA;

    wrrqD_get_valid : out std_logic;
    wrrqD_get_en    : in  std_logic;
    wrrqD_get_data  : out AXI4_Full_Wr_RqD;

    rdrsp_put_ready : out std_logic;
    rdrsp_put_en    : in  std_logic;
    rdrsp_put_data  : in  AXI4_Full_Rd_Rsp;

    wrrsp_put_ready : out std_logic;
    wrrsp_put_en    : in  std_logic;
    wrrsp_put_data  : in  AXI4_Full_Wr_Rsp
    );
end AXI4_Full_Slave;

architecture Behavioral of AXI4_Full_Slave is
    signal wrrqa_dataIn     : std_logic_vector(AXI4_Full_Wr_RqA_WIDTH - 1 downto 0);
    signal wrrqa_dataOut    : std_logic_vector(AXI4_Full_Wr_RqA_WIDTH - 1 downto 0);
    signal wrrqd_dataIn     : std_logic_vector(AXI4_Full_Wr_RqD_WIDTH - 1 downto 0);
    signal wrrqd_dataOut    : std_logic_vector(AXI4_Full_Wr_RqD_WIDTH - 1 downto 0);
    signal rdrqa_dataIn     : std_logic_vector(AXI4_Full_Rd_RqA_WIDTH - 1 downto 0);
    signal rdrqa_dataOut    : std_logic_vector(AXI4_Full_Rd_RqA_WIDTH - 1 downto 0);
    signal rdrsp_dataIn     : std_logic_vector(AXI4_Full_Rd_Rsp_WIDTH - 1 downto 0);
    signal rdrsp_dataOut    : std_logic_vector(AXI4_Full_Rd_Rsp_WIDTH - 1 downto 0);
    signal wrrsp_dataIn     : std_logic_vector(AXI4_Full_Wr_Rsp_WIDTH - 1 downto 0);
    signal wrrsp_dataOut    : std_logic_vector(AXI4_Full_Wr_Rsp_WIDTH - 1 downto 0);
begin
    
    wrrqa_dataIn    <= serialize_A4F_Wr_RqA(AXI_wrrqA_data);
    wrrqd_dataIn    <= serialize_A4F_Wr_RqD(AXI_wrrqD_data);
    rdrqa_dataIn    <= serialize_A4F_Rd_RqA(AXI_rdrqA_data);
    rdrsp_dataIn    <= serialize_A4F_Rd_Rsp(rdrsp_put_data);
    wrrsp_dataIn    <= serialize_A4F_Wr_Rsp(wrrsp_put_data);
    wrrqA_get_data  <= deserialize_A4F_Wr_RqA(wrrqa_dataOut);
    wrrqD_get_data  <= deserialize_A4F_Wr_RqD(wrrqd_dataOut);
    rdrqA_get_data  <= deserialize_A4F_Rd_RqA(rdrqa_dataOut);
    AXI_rdrsp_data  <= deserialize_A4F_Rd_Rsp(rdrsp_dataOut);
    AXI_wrrsp_data  <= deserialize_A4F_Wr_Rsp(wrrsp_dataOut);

    FIFO_WRRQA: STD_FIFO
    generic map(
        data_width      => AXI4_Full_Wr_RqA_WIDTH,
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WriteEn         => AXI_awvalid,     --in awvalid
		DataIn          => wrrqa_dataIn,    --in awaddr, etc
		ReadEn          => wrrqA_get_en,    --in external_ifc
		DataOut         => wrrqa_dataOut,   --out external_ifc
		"NOT"(Empty)    => wrrqA_get_valid, --out external_ifc
        "NOT"(Full)     => AXI_awready      --out awready
    );

    FIFO_WRRQD: STD_FIFO
    generic map(
        data_width      => AXI4_Full_Wr_RqD_WIDTH,
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WriteEn         => AXI_wvalid,      --in awvalid
		DataIn          => wrrqd_dataIn,    --in awaddr, etc
		ReadEn          => wrrqD_get_en,    --in external_ifc
		DataOut         => wrrqd_dataOut,   --out external_ifc
		"NOT"(Empty)    => wrrqD_get_valid, --out external_ifc
        "NOT"(Full)     => AXI_wready       --out awready
    );
    
    FIFO_RDRQA: STD_FIFO
    generic map(
        data_width      => AXI4_Full_Rd_RqA_WIDTH,
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WriteEn         => AXI_arvalid,     --in awvalid
		DataIn          => rdrqa_dataIn,    --in awaddr, etc
		ReadEn          => rdrqA_get_en,    --in external_ifc
		DataOut         => rdrqa_dataIn,    --out external_ifc
		"NOT"(Empty)    => rdrqA_get_valid, --out external_ifc
        "NOT"(Full)     => AXI_arready      --out awready
    );

    FIFO_RDRSP: STD_FIFO
    generic map(
        data_width      => AXI4_Full_Rd_Rsp_WIDTH,
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WriteEn         => rdrsp_put_en,    --in external_ifc
		DataIn          => rdrsp_dataIn,    --in external_ifc
		ReadEn          => AXI_rready,      --in rready
		DataOut         => rdrsp_dataOut,   --out rdata, rresp, etc
		"NOT"(Empty)    => AXI_rvalid,      --out rvalid
        "NOT"(Full)     => rdrsp_put_ready  --out external_ifc
    );

    FIFO_WRRSP: STD_FIFO
    generic map(
        data_width      => AXI4_Full_Wr_Rsp_WIDTH,
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WriteEn         => wrrsp_put_en,    --in external_ifc
		DataIn          => wrrsp_dataIn,    --in external_ifc
		ReadEn          => AXI_bready,      --in bready
		DataOut         => wrrsp_dataOut,   --out bresp, etc
		"NOT"(Empty)    => AXI_bvalid,      --out bvalid
        "NOT"(Full)     => wrrsp_put_ready  --out external_ifc
    );


end Behavioral;

