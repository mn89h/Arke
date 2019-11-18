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
use work.FIFO_pkg.all;

entity AXI4_Full_Master is
  port (
    ------------------------
    -- Incoming system clock
    ------------------------
    clk         : in std_logic;
    rst         : in std_logic; 

    -- ------------------------
    -- -- Write address channel    
    -- ------------------------
    -- AXI_awready : in  std_logic := '0';
    -- AXI_awvalid : out std_logic;    
    -- AXI_awid    : out std_logic_vector ( 11 downto 0 );
    -- AXI_awaddr  : out std_logic_vector ( 31 downto 0 );
    -- AXI_awlen   : out std_logic_vector (  3 downto 0 );
    -- AXI_awsize  : out std_logic_vector (  2 downto 0 );
    -- AXI_awburst : out std_logic_vector (  1 downto 0 );
    -- AXI_awlock  : out std_logic_vector (  1 downto 0 );
    -- AXI_awcache : out std_logic_vector (  3 downto 0 );
    -- AXI_awprot  : out std_logic_vector (  2 downto 0 );
    -- AXI_awqos   : out std_logic_vector (  3 downto 0 );

    -- ------------------------
    -- -- Write Data channel    
    -- ------------------------
    -- AXI_wready  : in  std_logic := '0';
    -- AXI_wvalid  : out std_logic;
    -- AXI_wid     : out std_logic_vector ( 11 downto 0 );
    -- AXI_wdata   : out std_logic_vector ( 31 downto 0 );
    -- AXI_wstrb   : out std_logic_vector (  3 downto 0 );
    -- AXI_wlast   : out std_logic;

    -- ------------------------
    -- -- Read address channel
    -- ------------------------
    -- AXI_arready : in  std_logic := '0';
    -- AXI_arvalid : out std_logic;
    -- AXI_arid    : out std_logic_vector ( 11 downto 0 );
    -- AXI_araddr  : out std_logic_vector ( 31 downto 0 );
    -- AXI_arlen   : out std_logic_vector (  3 downto 0 );
    -- AXI_arsize  : out std_logic_vector (  2 downto 0 );
    -- AXI_arburst : out std_logic_vector (  1 downto 0 );
    -- AXI_arlock  : out std_logic_vector (  1 downto 0 );
    -- AXI_arcache : out std_logic_vector (  3 downto 0 );
    -- AXI_arprot  : out std_logic_vector (  2 downto 0 );
    -- AXI_arqos   : out std_logic_vector (  3 downto 0 );

    -- ------------------------
    -- -- Read data channel
    -- ------------------------
    -- AXI_rready  : out std_logic;
    -- AXI_rvalid  : in  std_logic := '0';
    -- AXI_rid     : in  std_logic_vector ( 11 downto 0 ) := (others => '0');
    -- AXI_rdata   : in  std_logic_vector ( 31 downto 0 ) := (others => '0');
    -- AXI_rresp   : in  std_logic_vector (  1 downto 0 ) := (others => '0');
    -- AXI_rlast   : in  std_logic := '0';

    -- ------------------------
    -- -- Write status channel 
    -- ------------------------
    -- AXI_bready  : out std_logic;
    -- AXI_bvalid  : in  std_logic := '0';
    -- AXI_bid     : in  std_logic_vector ( 11 downto 0 ) := (others => '0');
    -- AXI_bresp   : in  std_logic_vector (  1 downto 0 ) := (others => '0');

    
    ---------------------------------
    -- System interface
    -- Connect to a Master Interface
    ---------------------------------
    AXI_arvalid     : out std_logic;
    AXI_arready     : in  std_logic;
    AXI_rdrqA_data  : out AXI4_Full_Rd_RqA;

    AXI_awvalid     : out std_logic;
    AXI_awready     : in  std_logic;
    AXI_wrrqA_data  : out AXI4_Full_Wr_RqA;

    AXI_wvalid      : out std_logic;
    AXI_wready      : in  std_logic;
    AXI_wrrqD_data  : out AXI4_Full_Wr_RqD;

    AXI_rready      : out std_logic;
    AXI_rvalid      : in  std_logic;
    AXI_rdrsp_data  : in  AXI4_Full_Rd_Rsp;

    AXI_bready      : out std_logic;
    AXI_bvalid      : in  std_logic;
    AXI_wrrsp_data  : in  AXI4_Full_Wr_Rsp;

    ---------------------------------
    -- User interface
    -- Access GET Ifc: Enable the get request and validate the received data
    -- Access PUT Ifc: Check the ready signal and enable the data transfer
    ---------------------------------
    rdrqA_put_ready : in  std_logic;
    rdrqA_put_en    : out std_logic;
    rdrqA_put_data  : in  AXI4_Full_Rd_RqA;

    wrrqA_put_ready : in  std_logic;
    wrrqA_put_en    : out std_logic;
    wrrqA_put_data  : in  AXI4_Full_Wr_RqA;

    wrrqD_put_ready : in  std_logic;
    wrrqD_put_en    : out std_logic;
    wrrqD_put_data  : in  AXI4_Full_Wr_RqD;

    rdrsp_get_valid : in  std_logic;
    rdrsp_get_en    : out std_logic;
    rdrsp_get_data  : out AXI4_Full_Rd_Rsp;

    wrrsp_get_valid : in  std_logic;
    wrrsp_get_en    : out std_logic;
    wrrsp_get_data  : out AXI4_Full_Wr_Rsp
    );
end AXI4_Full_Master;

architecture Behavioral of AXI4_Full_Master is
begin

    FIFO_WRRQA: STD_FIFO
    generic map(
        data_type       => AXI4_Full_Wr_RqA;
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WriteEn         => wrrqA_put_en,    --in user_ifc
        DataIn          => wrrqA_put_data,  --in user_ifc
		ReadEn          => AXI_awready,     --in awready
		DataOut         => AXI_wrrqA_data,  --out axi data
		"NOT"(Empty)    => AXI_awvalid,     --out awvalid
        "NOT"(Full)     => wrrqA_put_ready  --out user_ifc
    );

    FIFO_WRRQD: STD_FIFO
    generic map(
        data_type       => AXI4_Full_Wr_RqD;
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WriteEn         => wrrqD_put_en,    --in user_ifc
		DataIn          => wrrqD_put_data,  --in user_ifc
		ReadEn          => AXI_wready,      --in wready
		DataOut         => AXI_wrrqD_data,  --out axi data
		"NOT"(Empty)    => AXI_wvalid,      --out wvalid
        "NOT"(Full)     => wrrqD_put_ready  --out user_ifc
    );
    
    FIFO_RDRQA: STD_FIFO
    generic map(
        data_type       => AXI4_Full_Rd_RqA;
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WriteEn         => rdrqA_put_en,    --in user_ifc
		DataIn          => rdrqA_put_data,  --in user_ifc
		ReadEn          => AXI_arready,     --in wready
		DataOut         => AXI_rdrqA_data,  --out axi data
		"NOT"(Empty)    => AXI_arvalid,     --out wvalid
        "NOT"(Full)     => rdrqA_put_ready  --out user_ifc
    );

    FIFO_RDRSP: STD_FIFO
    generic map(
        data_type       => AXI4_Full_Rd_Rsp;
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WriteEn         => AXI_rvalid,      --in rvalid
		DataIn          => AXI_rdrsp_data,  --in axi data
		ReadEn          => rdrsp_get_en,    --in user_ifc
		DataOut         => rdrsp_get_data,  --out user_ifc
		"NOT"(Empty)    => rdrsp_get_valid, --out user_ifc
        "NOT"(Full)     => AXI_rready       --out rready
    );

    FIFO_WRRSP: STD_FIFO
    generic map(
        data_type       => AXI4_Full_Wr_Rsp;
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WriteEn         => AXI_bvalid,      --in bvalid
		DataIn          => AXI_wrrsp_data,  --in axi data
		ReadEn          => wrrsp_get_en,    --in user_ifc
		DataOut         => wrrsp_get_data,  --out user_ifc
		"NOT"(Empty)    => wrrsp_get_valid, --out user_ifc
        "NOT"(Full)     => AXI_bready       --out bready
    );

end Behavioral;

