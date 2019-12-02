-------------------------------------------------------------------------------
-- Title      : AXI4_Lite_Master
-- Project    : TaPaSCo
-------------------------------------------------------------------------------
-- File       : AXI4_Lite_Master.vhd
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

entity AXI4_Lite_Master is
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
    AXI_arvalid     : out std_logic;
    AXI_arready     : in  std_logic;
    AXI_rdrqA_data  : out AXI4_Lite_Rd_RqA;

    AXI_awvalid     : out std_logic;
    AXI_awready     : in  std_logic;
    AXI_wrrqA_data  : out AXI4_Lite_Wr_RqA;

    AXI_wvalid      : out std_logic;
    AXI_wready      : in  std_logic;
    AXI_wrrqD_data  : out AXI4_Lite_Wr_RqD;

    AXI_rready      : out std_logic;
    AXI_rvalid      : in  std_logic;
    AXI_rdrsp_data  : in  AXI4_Lite_Rd_Rsp;

    AXI_bready      : out std_logic;
    AXI_bvalid      : in  std_logic;
    AXI_wrrsp_data  : in  AXI4_Lite_Wr_Rsp;

    ---------------------------------
    -- User interface
    -- Access GET Ifc: Enable the get request and validate the received data
    -- Access PUT Ifc: Check the ready signal and enable the data transfer
    ---------------------------------
    rdrqA_put_en    : in  std_logic;
    rdrqA_put_ready : out std_logic;
    rdrqA_put_data  : in  AXI4_Lite_Rd_RqA;

    wrrqA_put_en    : in  std_logic;
    wrrqA_put_ready : out std_logic;
    wrrqA_put_data  : in  AXI4_Lite_Wr_RqA;

    wrrqD_put_en    : in  std_logic;
    wrrqD_put_ready : out std_logic;
    wrrqD_put_data  : in  AXI4_Lite_Wr_RqD;

    rdrsp_get_valid : out std_logic;
    rdrsp_get_en    : in  std_logic;
    rdrsp_get_data  : out AXI4_Lite_Rd_Rsp; -- := ((others => '0'), (others => '0')); instantly overwritten

    wrrsp_get_valid : out std_logic;
    wrrsp_get_en    : in  std_logic;
    wrrsp_get_data  : out AXI4_Lite_Wr_Rsp
    );
end AXI4_Lite_Master;

architecture Behavioral of AXI4_Lite_Master is
    signal wrrqa_dataIn     : std_logic_vector(AXI4_Lite_Wr_RqA_WIDTH - 1 downto 0);
    signal wrrqa_dataOut    : std_logic_vector(AXI4_Lite_Wr_RqA_WIDTH - 1 downto 0);
    signal wrrqd_dataIn     : std_logic_vector(AXI4_Lite_Wr_RqD_WIDTH - 1 downto 0);
    signal wrrqd_dataOut    : std_logic_vector(AXI4_Lite_Wr_RqD_WIDTH - 1 downto 0);
    signal rdrqa_dataIn     : std_logic_vector(AXI4_Lite_Rd_RqA_WIDTH - 1 downto 0);
    signal rdrqa_dataOut    : std_logic_vector(AXI4_Lite_Rd_RqA_WIDTH - 1 downto 0);
    signal rdrsp_dataIn     : std_logic_vector(AXI4_Lite_Rd_Rsp_WIDTH - 1 downto 0);
    signal rdrsp_dataOut    : std_logic_vector(AXI4_Lite_Rd_Rsp_WIDTH - 1 downto 0);
    signal wrrsp_dataIn     : std_logic_vector(AXI4_Lite_Wr_Rsp_WIDTH - 1 downto 0);
    signal wrrsp_dataOut    : std_logic_vector(AXI4_Lite_Wr_Rsp_WIDTH - 1 downto 0);
begin
    
    wrrqa_dataIn    <= serialize_A4L_Wr_RqA(wrrqA_put_data);
    wrrqd_dataIn    <= serialize_A4L_Wr_RqD(wrrqD_put_data);
    rdrqa_dataIn    <= serialize_A4L_Rd_RqA(rdrqA_put_data);
    rdrsp_dataIn    <= serialize_A4L_Rd_Rsp(AXI_rdrsp_data);
    wrrsp_dataIn    <= serialize_A4L_Wr_Rsp(AXI_wrrsp_data);
    AXI_wrrqA_data  <= deserialize_A4L_Wr_RqA(wrrqa_dataOut);
    AXI_wrrqD_data  <= deserialize_A4L_Wr_RqD(wrrqd_dataOut);
    AXI_rdrqA_data  <= deserialize_A4L_Rd_RqA(rdrqa_dataOut);
    rdrsp_get_data  <= deserialize_A4L_Rd_Rsp(rdrsp_dataOut);
    wrrsp_get_data  <= deserialize_A4L_Wr_Rsp(wrrsp_dataOut);

    FIFO_WRRQA: STD_FIFO
    generic map(
        data_width      => AXI4_Lite_Wr_RqA_WIDTH,
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WrValid_in      => wrrqA_put_en,
        WrReady_out     => wrrqA_put_ready,
		WrData_in       => wrrqa_dataIn,
		RdValid_out     => AXI_awvalid,
		RdReady_in      => AXI_awready,
		RdData_out      => wrrqa_dataOut
    );

    FIFO_WRRQD: STD_FIFO
    generic map(
        data_width      => AXI4_Lite_Wr_RqD_WIDTH,
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WrValid_in      => wrrqD_put_en,
        WrReady_out     => wrrqD_put_ready,
		WrData_in       => wrrqd_dataIn,
		RdValid_out     => AXI_wvalid,
		RdReady_in      => AXI_wready,
		RdData_out      => wrrqd_dataOut
    );
    
    FIFO_RDRQA: STD_FIFO
    generic map(
        data_width      => AXI4_Lite_Rd_RqA_WIDTH,
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

        WrValid_in      => rdrqA_put_en,
        WrReady_out     => rdrqA_put_ready,
		WrData_in       => rdrqa_dataIn,
		RdValid_out     => AXI_arvalid,
		RdReady_in      => AXI_arready,
		RdData_out      => rdrqa_dataOut
    );

    FIFO_RDRSP: STD_FIFO
    generic map(
        data_width      => AXI4_Lite_Rd_Rsp_WIDTH,
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WrValid_in      => AXI_rvalid,
        WrReady_out     => AXI_rready,
		WrData_in       => rdrsp_dataIn,
		RdValid_out     => rdrsp_get_valid,
		RdReady_in      => rdrsp_get_en,
		RdData_out      => rdrsp_dataOut
    );

    FIFO_WRRSP: STD_FIFO
    generic map(
        data_width      => AXI4_Lite_Wr_Rsp_WIDTH,
        fifo_depth      => 2
    )
    port map(
        clk             => clk,
        rst             => rst,

		WrValid_in      => AXI_bvalid,
        WrReady_out     => AXI_bready,
		WrData_in       => wrrsp_dataIn,
		RdValid_out     => rdrsp_get_valid,
		RdReady_in      => rdrsp_get_en,
		RdData_out      => wrrsp_dataOut
    );

end Behavioral;

