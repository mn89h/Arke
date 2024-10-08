-------------------------------------------------------------------------------
-- Title      : PE (Processing Element) Interface
-- Project    : TaPaSCo NoC Integration
-------------------------------------------------------------------------------
-- File       : PE_Ifc.vhd
-- Author     : Malte Nilges
-- Company    : 
-- Created    : 2019-12-02
-- Last update: 2019-12-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Network interface for TaPaSCo's processing elements sending
--              data to and receiving data from architecture/memory interface.
--              Data received from PEs AXI4 Master is converted to appropriate
--              network data format and the other way round.
--              Same procedure is applied for data from/to PEs AXI4 Lite Slave.
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;
use work.Arke_pkg.all;

-------------------------------------------------------------------------------

entity PE_Ifc is
    generic (
        A4L_addr_width  : integer;
        A4L_data_width  : integer;
        A4F_addr_width  : integer;
        A4F_data_width  : integer;
        A4F_id_width    : integer;
        NoC_address     : std_logic_vector;
        NoC_address_map : std_logic_vector
    );
    port (
        signal clk                  : in  std_logic := '1';
        signal rst                  : in  std_logic := '1';
        signal A4L_AXI_arvalid      : out std_logic;
        signal A4L_AXI_arready      : in  std_logic;
        signal A4L_AXI_araddr       : out std_logic_vector( A4L_addr_width - 1 + 3 downto 3 );
        signal A4L_AXI_arprot       : out std_logic_vector( 2 downto 0 );
        signal A4L_AXI_awvalid      : out std_logic;
        signal A4L_AXI_awready      : in  std_logic;
        signal A4L_AXI_awaddr       : out std_logic_vector( A4L_addr_width - 1 + 3 downto 3 );
        signal A4L_AXI_awprot       : out std_logic_vector( 2 downto 0 );
        signal A4L_AXI_wvalid       : out std_logic;
        signal A4L_AXI_wready       : in  std_logic;
        signal A4L_AXI_wdata        : out std_logic_vector( A4L_data_width - 1 + 4 downto 4 );
        signal A4L_AXI_wstrb        : out std_logic_vector( 3 downto 0 );
        signal A4L_AXI_rready       : out std_logic;
        signal A4L_AXI_rvalid       : in  std_logic;
        signal A4L_AXI_rdata        : in  std_logic_vector( A4L_data_width - 1 + 2 downto 2 );
        signal A4L_AXI_rresp        : in  std_logic_vector( 1 downto 0 );
        signal A4L_AXI_bready       : out std_logic;
        signal A4L_AXI_bvalid       : in  std_logic;
        signal A4L_AXI_bresp        : in  std_logic_vector( 1 downto 0 );

        signal A4F_AXI_arvalid      : in  std_logic;
        signal A4F_AXI_arready      : out std_logic;
        signal A4F_AXI_araddr       : in  std_logic_vector( A4F_addr_width - 1 + A4F_id_width + NoC_addr_width + 20 downto A4F_id_width + NoC_addr_width + 20 );
        signal A4F_AXI_arid         : in  std_logic_vector( A4F_id_width + NoC_addr_width - 1 + 20 downto 20 );
        signal A4F_AXI_arlen        : in  std_logic_vector( 19 downto 16 );
        signal A4F_AXI_arsize       : in  std_logic_vector( 15 downto 13 );
        signal A4F_AXI_arburst      : in  std_logic_vector( 12 downto 11 );
        signal A4F_AXI_arlock       : in  std_logic_vector( 10 downto 9 );
        signal A4F_AXI_arcache      : in  std_logic_vector(  8 downto 6 );
        signal A4F_AXI_arprot       : in  std_logic_vector(  5 downto 3 );
        signal A4F_AXI_arqos        : in  std_logic_vector(  2 downto 0 );
        signal A4F_AXI_awvalid      : in  std_logic;
        signal A4F_AXI_awready      : out std_logic;
        signal A4F_AXI_awaddr       : in  std_logic_vector( A4F_addr_width - 1 + A4F_id_width + NoC_addr_width + 20 downto A4F_id_width + NoC_addr_width + 20 );
        signal A4F_AXI_awid         : in  std_logic_vector( A4F_id_width + NoC_addr_width - 1 + 20 downto 20 );
        signal A4F_AXI_awlen        : in  std_logic_vector( 19 downto 16 );
        signal A4F_AXI_awsize       : in  std_logic_vector( 15 downto 13 );
        signal A4F_AXI_awburst      : in  std_logic_vector( 12 downto 11 );
        signal A4F_AXI_awlock       : in  std_logic_vector( 10 downto 9 );
        signal A4F_AXI_awcache      : in  std_logic_vector(  8 downto 6 );
        signal A4F_AXI_awprot       : in  std_logic_vector(  5 downto 3 );
        signal A4F_AXI_awqos        : in  std_logic_vector(  2 downto 0 );
        signal A4F_AXI_wvalid       : in  std_logic;
        signal A4F_AXI_wready       : out std_logic;
        signal A4F_AXI_wdata        : in  std_logic_vector( A4F_data_width - 1 + A4F_id_width + NoC_addr_width + 5 downto A4F_id_width + NoC_addr_width + 5 );
        signal A4F_AXI_wid          : in  std_logic_vector( A4F_id_width + NoC_addr_width - 1 + 5 downto 5 );
        signal A4F_AXI_wstrb        : in  std_logic_vector(  4 downto 1 );
        signal A4F_AXI_wlast        : in  std_logic_vector(  0 downto 0 );
        signal A4F_AXI_rready       : in  std_logic;
        signal A4F_AXI_rvalid       : out std_logic;
        signal A4F_AXI_rdata        : out std_logic_vector( A4F_data_width - 1 + A4F_id_width + NoC_addr_width + 3 downto A4F_id_width + NoC_addr_width + 3 );
        signal A4F_AXI_rid          : out std_logic_vector( A4F_id_width + NoC_addr_width - 1 + 3 downto 3 );
        signal A4F_AXI_rresp        : out std_logic_vector(  2 downto 1 );
        signal A4F_AXI_rlast        : out std_logic_vector(  0 downto 0 );
        signal A4F_AXI_bready       : in  std_logic;
        signal A4F_AXI_bvalid       : out std_logic;
        signal A4F_AXI_bid          : out std_logic_vector( A4F_id_width + NoC_addr_width - 1 + 2 downto 2 );
        signal A4F_AXI_bresp        : out std_logic_vector(  1 downto 0 );

        signal dataOut          : out std_logic_vector(    DATA_WIDTH - 1 downto 0 );
        signal controlOut       : out std_logic_vector( CONTROL_WIDTH - 1 downto 0 );
        signal dataIn           : in  std_logic_vector(    DATA_WIDTH - 1 downto 0 );
        signal controlIn        : in  std_logic_vector( CONTROL_WIDTH - 1 downto 0 )
    );
end PE_Ifc;

-------------------------------------------------------------------------------

architecture Behavioral of PE_Ifc is

    constant A4L_rdrqa_width    : natural := A4L_addr_width + 3;
    constant A4L_wrrqa_width    : natural := A4L_addr_width + 3;
    constant A4L_wrrqd_width    : natural := A4L_data_width + 4;
    constant A4L_rdrsp_width    : natural := A4L_data_width + 2;
    constant A4L_wrrsp_width    : natural := 2;

    constant A4F_rdrqa_width    : natural := A4F_addr_width + A4F_id_width + NoC_addr_width + 20;
    constant A4F_wrrqa_width    : natural := A4F_addr_width + A4F_id_width + NoC_addr_width + 20;
    constant A4F_wrrqd_width    : natural := A4F_data_width + A4F_id_width + NoC_addr_width + 5;
    constant A4F_rdrsp_width    : natural := A4F_data_width + A4F_id_width + NoC_addr_width + 3;
    constant A4F_wrrsp_width    : natural := A4F_id_width + 2;

    constant DIM_X_W    : integer := Log2(DIM_X);
    constant DIM_Y_W    : integer := Log2(DIM_Y);
    constant DIM_Z_W    : integer := Log2(DIM_Z);
    constant ADDR_W     : integer := DIM_X_W + DIM_Y_W + DIM_Z_W;

    type ADDR_MAP_TYPE is array (0 to DIM_X * DIM_Y * DIM_Z - 1) of std_logic_vector(ADDR_W - 1 downto 0);
    type State is (RdRsp, WrRsp, RdRqA, WrRqA, WrRqD);
    type StallState is (None, RdRsp, WrRsp, RdRqA, WrRqA, WrRqD);

    function to_ADDR_MAP_TYPE (
        slv : std_logic_vector
        ) return ADDR_MAP_TYPE is
        variable result : ADDR_MAP_TYPE := (others => (others => '0'));
    begin
        for i in 0 to DIM_X * DIM_Y * DIM_Z - 1 loop
            result(i) := slv(i * NoC_addr_width to (i+1) * NoC_addr_width - 1);
        end loop;
        return result;
    end function;

    constant address_map_c : ADDR_MAP_TYPE := to_ADDR_MAP_TYPE(NoC_address_map);

    signal A4L_rdrqA_put_ready : std_logic;
    signal A4L_rdrqA_put_en    : std_logic;
    signal A4L_rdrqA_put_data  : std_logic_vector(A4L_rdrqa_width - 1 downto 0);
    signal A4L_wrrqA_put_ready : std_logic;
    signal A4L_wrrqA_put_en    : std_logic;
    signal A4L_wrrqA_put_data  : std_logic_vector(A4L_wrrqa_width - 1 downto 0);
    signal A4L_wrrqD_put_ready : std_logic;
    signal A4L_wrrqD_put_en    : std_logic;
    signal A4L_wrrqD_put_data  : std_logic_vector(A4L_wrrqd_width - 1 downto 0);
    signal A4L_rdrsp_get_valid : std_logic;
    signal A4L_rdrsp_get_en    : std_logic;
    signal A4L_rdrsp_get_data  : std_logic_vector(A4L_rdrsp_width - 1 downto 0);
    signal A4L_wrrsp_get_valid : std_logic;
    signal A4L_wrrsp_get_en    : std_logic;
    signal A4L_wrrsp_get_data  : std_logic_vector(A4L_wrrsp_width - 1 downto 0);

    signal A4F_rdrqA_get_valid : std_logic;
    signal A4F_rdrqA_get_en    : std_logic;
    signal A4F_rdrqA_get_data  : std_logic_vector(A4F_rdrqa_width - 1 downto 0);
    signal A4F_wrrqA_get_valid : std_logic;
    signal A4F_wrrqA_get_en    : std_logic;
    signal A4F_wrrqA_get_data  : std_logic_vector(A4F_wrrqa_width - 1 downto 0);
    signal A4F_wrrqD_get_valid : std_logic;
    signal A4F_wrrqD_get_en    : std_logic;
    signal A4F_wrrqD_get_data  : std_logic_vector(A4F_wrrqd_width - 1 downto 0);
    signal A4F_rdrsp_put_ready : std_logic;
    signal A4F_rdrsp_put_en    : std_logic;
    signal A4F_rdrsp_put_data  : std_logic_vector(A4F_rdrsp_width - 1 downto 0);
    signal A4F_wrrsp_put_ready : std_logic;
    signal A4F_wrrsp_put_en    : std_logic;
    signal A4F_wrrsp_put_data  : std_logic_vector(A4F_wrrsp_width - 1 downto 0);

    signal dataInStalled   : std_logic_vector(dataIn'range);
    signal put_last_state  : StallState;
    signal put_stalled     : std_logic;
    signal state_send      : State;

    begin

        AXI_Master : AXI4_Lite_Master
        generic map (
            A4L_addr_width  => A4L_addr_width,
            A4L_data_width  => A4L_data_width
        )
        port map (
            clk             => clk,
            rst             => rst,
            AXI_arvalid     => A4L_AXI_arvalid,
            AXI_arready     => A4L_AXI_arready,
            AXI_araddr      => A4L_AXI_araddr,
            AXI_arprot      => A4L_AXI_arprot,
            AXI_awvalid     => A4L_AXI_awvalid,
            AXI_awready     => A4L_AXI_awready,
            AXI_awaddr      => A4L_AXI_awaddr,
            AXI_awprot      => A4L_AXI_awprot,
            AXI_wvalid      => A4L_AXI_wvalid,
            AXI_wready      => A4L_AXI_wready,
            AXI_wdata       => A4L_AXI_wdata,
            AXI_wstrb       => A4L_AXI_wstrb,
            AXI_rready      => A4L_AXI_rready,
            AXI_rvalid      => A4L_AXI_rvalid,
            AXI_rdata       => A4L_AXI_rdata,
            AXI_rresp       => A4L_AXI_rresp,
            AXI_bready      => A4L_AXI_bready,
            AXI_bvalid      => A4L_AXI_bvalid,
            AXI_bresp       => A4L_AXI_bresp,
            rdrqA_put_en    => A4L_rdrqA_put_en,
            rdrqA_put_ready => A4L_rdrqA_put_ready,
            rdrqA_put_data  => A4L_rdrqA_put_data,
            wrrqA_put_en    => A4L_wrrqA_put_en,
            wrrqA_put_ready => A4L_wrrqA_put_ready,
            wrrqA_put_data  => A4L_wrrqA_put_data,
            wrrqD_put_en    => A4L_wrrqD_put_en,
            wrrqD_put_ready => A4L_wrrqD_put_ready,
            wrrqD_put_data  => A4L_wrrqD_put_data,
            rdrsp_get_valid => A4L_rdrsp_get_valid,
            rdrsp_get_en    => A4L_rdrsp_get_en,
            rdrsp_get_data  => A4L_rdrsp_get_data,
            wrrsp_get_valid => A4L_wrrsp_get_valid,
            wrrsp_get_en    => A4L_wrrsp_get_en,
            wrrsp_get_data  => A4L_wrrsp_get_data
        );

        AXI_Slave : AXI4_Full_Slave
        generic map (
            A4F_addr_width  => A4F_addr_width,
            A4F_data_width  => A4F_data_width,
            A4F_id_width    => A4F_id_width + NoC_addr_width 
        )
        port map (
            clk             => clk,
            rst             => rst,
            AXI_arvalid     => A4F_AXI_arvalid,
            AXI_arready     => A4F_AXI_arready,
            AXI_araddr      => A4F_AXI_araddr,
            AXI_arid        => A4F_AXI_arid,
            AXI_arlen       => A4F_AXI_arlen,
            AXI_arsize      => A4F_AXI_arsize,
            AXI_arburst     => A4F_AXI_arburst,
            AXI_arlock      => A4F_AXI_arlock,
            AXI_arcache     => A4F_AXI_arcache,
            AXI_arprot      => A4F_AXI_arprot,
            AXI_arqos       => A4F_AXI_arqos,
            AXI_awvalid     => A4F_AXI_awvalid,
            AXI_awready     => A4F_AXI_awready,
            AXI_awaddr      => A4F_AXI_awaddr,
            AXI_awid        => A4F_AXI_awid,
            AXI_awlen       => A4F_AXI_awlen,
            AXI_awsize      => A4F_AXI_awsize,
            AXI_awburst     => A4F_AXI_awburst,
            AXI_awlock      => A4F_AXI_awlock,
            AXI_awcache     => A4F_AXI_awcache,
            AXI_awprot      => A4F_AXI_awprot,
            AXI_awqos       => A4F_AXI_awqos,
            AXI_wvalid      => A4F_AXI_wvalid,
            AXI_wready      => A4F_AXI_wready,
            AXI_wdata       => A4F_AXI_wdata,
            AXI_wid         => A4F_AXI_wid,
            AXI_wstrb       => A4F_AXI_wstrb,
            AXI_wlast       => A4F_AXI_wlast,
            AXI_rready      => A4F_AXI_rready,
            AXI_rvalid      => A4F_AXI_rvalid,
            AXI_rdata       => A4F_AXI_rdata,
            AXI_rid         => A4F_AXI_rid,
            AXI_rresp       => A4F_AXI_rresp,
            AXI_rlast       => A4F_AXI_rlast,
            AXI_bready      => A4F_AXI_bready,
            AXI_bvalid      => A4F_AXI_bvalid,
            AXI_bid         => A4F_AXI_bid,
            AXI_bresp       => A4F_AXI_bresp,
            rdrqA_get_valid => A4F_rdrqA_get_valid,
            rdrqA_get_en    => A4F_rdrqA_get_en,
            rdrqA_get_data  => A4F_rdrqA_get_data,
            wrrqA_get_valid => A4F_wrrqA_get_valid,
            wrrqA_get_en    => A4F_wrrqA_get_en,
            wrrqA_get_data  => A4F_wrrqA_get_data,
            wrrqD_get_valid => A4F_wrrqD_get_valid,
            wrrqD_get_en    => A4F_wrrqD_get_en,
            wrrqD_get_data  => A4F_wrrqD_get_data,
            rdrsp_put_ready => A4F_rdrsp_put_ready,
            rdrsp_put_en    => A4F_rdrsp_put_en,
            rdrsp_put_data  => A4F_rdrsp_put_data,
            wrrsp_put_ready => A4F_wrrsp_put_ready,
            wrrsp_put_en    => A4F_wrrsp_put_en,
            wrrsp_put_data  => A4F_wrrsp_put_data
        );
                    
        process(clk)

            variable A4F_wrrqA_get_data_tmp : std_logic_vector(A4F_rdrqa_width - 1 downto 0);
            variable A4F_wrrqD_get_data_tmp : std_logic_vector(A4F_wrrqa_width - 1 downto 0);
            variable A4F_rdrqA_get_data_tmp : std_logic_vector(A4F_wrrqd_width - 1 downto 0);
            variable A4L_rdrsp_get_data_tmp : std_logic_vector(A4L_rdrsp_width - 1 downto 0);
            variable A4L_wrrsp_get_data_tmp : std_logic_vector(A4L_wrrsp_width - 1 downto 0);
            variable A4L_wrrqA_put_data_tmp : std_logic_vector(A4L_rdrqa_width - 1 downto 0);
            variable A4L_wrrqD_put_data_tmp : std_logic_vector(A4L_wrrqa_width - 1 downto 0);
            variable A4L_rdrqA_put_data_tmp : std_logic_vector(A4L_wrrqd_width - 1 downto 0);
            variable A4F_rdrsp_put_data_tmp : std_logic_vector(A4F_wrrsp_width - 1 downto 0);
            variable A4F_wrrsp_put_data_tmp : std_logic_vector(A4F_rdrsp_width - 1 downto 0);
            
            variable dest_address       : std_logic_vector(NoC_addr_width - 1 downto 0);

        begin if rising_edge(clk) then
            -----------
            -- RESET --
            -----------
            if (rst = '1') then
                controlOut          <= "100";
                dataOut             <= (others => '0');
                state_send          <= RdRsp;
                put_last_state      <= RdRsp;
                put_stalled         <= '0';
            else

            --------------------------------------------------------
            -- A4L R/W RESPONSE & A4F R/W REQUEST TO NETWORK DATA --
            --------------------------------------------------------
            -- Incoming r/w requests are being handed over to the network as they are valid using round-robin.
            -- If a request is valid, but the local router isn't able to receive data, the state remains the same
            -- otherwise it changes to the next state to look for valid data.
            -- Same procedure is applied for r/w responses.
            -- The network destination is chosen by a address map in conjunction with the AXI address.
            --------------------------------------------------------
            
            -- STATE 1: RDRSP
            if (state_send = RdRsp) then
                A4L_wrrsp_get_en        <= '0';
                A4F_rdrqA_get_en        <= '0';
                A4F_wrrqA_get_en        <= '0';
                A4F_wrrqD_get_en        <= '0';

                if (A4L_rdrsp_get_valid = '1') then
                    if (controlIn(STALL_GO) = '1') then
                        A4L_rdrsp_get_data_tmp  := A4L_rdrsp_get_data;
                        dest_address        := ZERO(NoC_addr_width - 1 downto 0);
                        dataOut             <= '0' & "00" & ZERO(dataOut'left - 3 downto A4L_rdrsp_get_data_tmp'length + NoC_addr_width) & A4L_rdrsp_get_data_tmp & dest_address;
                        controlOut(TX)      <= '1';
                        controlOut(EOP)     <= '1';

                        A4L_rdrsp_get_en    <= '1';
                        state_send          <= WrRsp;
                    else
                        A4L_rdrsp_get_en    <= '0';
                    end if;
                else
                    if (controlIn(STALL_GO) = '1') then
                        controlOut(TX)      <= '0';
                        controlOut(EOP)     <= '0';
                    end if;

                    A4L_rdrsp_get_en        <= '0';
                    state_send              <= WrRsp;
                end if;

            -- STATE 2: WRRSP
            elsif (state_send = WrRsp) then
                A4L_rdrsp_get_en        <= '0';
                A4F_rdrqA_get_en        <= '0';
                A4F_wrrqA_get_en        <= '0';
                A4F_wrrqD_get_en        <= '0';

                if (A4L_wrrsp_get_valid = '1') then
                    if (controlIn(STALL_GO) = '1') then
                        A4L_wrrsp_get_data_tmp  := A4L_wrrsp_get_data;
                        dest_address        := ZERO(NoC_addr_width - 1 downto 0);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto A4L_wrrsp_get_data_tmp'length + NoC_addr_width) & A4L_wrrsp_get_data_tmp & dest_address;
                        controlOut(TX)      <= '1';
                        controlOut(EOP)     <= '0';

                        A4L_wrrsp_get_en    <= '1';
                        state_send          <= RdRqA;
                    else
                        A4L_wrrsp_get_en    <= '0';
                    end if;
                else
                    if (controlIn(STALL_GO) = '1') then
                        controlOut(TX)      <= '0';
                        controlOut(EOP)     <= '0';
                    end if;

                    A4L_wrrsp_get_en        <= '0';
                    state_send              <= RdRqA;
                end if;

            -- STATE 3: RDRQA
            elsif (state_send = RdRqA) then
                A4L_rdrsp_get_en        <= '0';
                A4L_wrrsp_get_en        <= '0';
                A4F_wrrqA_get_en        <= '0';
                A4F_wrrqD_get_en        <= '0';

                if (A4F_rdrqA_get_valid = '1') then
                    if (controlIn(STALL_GO) = '1') then
                        A4F_rdrqA_get_data_tmp  := A4F_rdrqA_get_data;
                        dest_address        := A4F_rdrqA_get_data(A4F_AXI_arid'left downto A4F_AXI_arid'right + A4F_id_width);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto A4F_rdrqA_get_data_tmp'length + NoC_addr_width) & A4F_rdrqA_get_data_tmp & dest_address;
                        controlOut(TX)      <= '1';
                        controlOut(EOP)     <= '0';

                        A4F_rdrqA_get_en    <= '1';
                        state_send          <= WrRqA;
                    else
                        A4F_rdrqA_get_en    <= '0';
                    end if;
                else
                    if (controlIn(STALL_GO) = '1') then
                        controlOut(TX)      <= '0';
                        controlOut(EOP)     <= '0';
                    end if;

                    A4F_rdrqA_get_en        <= '0';
                    state_send              <= WrRqA;
                end if;

            -- STATE 4: WRRQA
            elsif (state_send = WrRqA) then
                A4L_rdrsp_get_en        <= '0';
                A4L_wrrsp_get_en        <= '0';
                A4F_rdrqA_get_en        <= '0';
                A4F_wrrqD_get_en        <= '0';

                if (A4F_wrrqA_get_valid = '1') then
                    if (controlIn(STALL_GO) = '1') then
                        A4F_wrrqA_get_data_tmp  := A4F_wrrqA_get_data;
                        dest_address        := A4F_wrrqA_get_data(A4F_AXI_awid'left downto A4F_AXI_awid'right + A4F_id_width);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto A4F_wrrqA_get_data_tmp'length + NoC_addr_width) & A4F_wrrqA_get_data_tmp & dest_address;
                        controlOut(TX)      <= '1';
                        controlOut(EOP)     <= '0';

                        A4F_wrrqA_get_en    <= '1';
                        state_send          <= WrRqD;
                    else
                        A4F_wrrqA_get_en    <= '0';
                    end if;
                else
                    if (controlIn(STALL_GO) = '1') then
                        controlOut(TX)      <= '0';
                        controlOut(EOP)     <= '0';
                    end if;

                    A4F_wrrqA_get_en        <= '0';
                    state_send              <= RdRsp;
                end if;

            -- STATE 5: WRRQD --TODO: implement 'last' check to stay in same state
            elsif (state_send = WrRqD) then
                A4L_rdrsp_get_en        <= '0';
                A4L_wrrsp_get_en        <= '0';
                A4F_rdrqA_get_en        <= '0';
                A4F_wrrqA_get_en        <= '0';

                if (A4F_wrrqD_get_valid = '1') then
                    if (controlIn(STALL_GO) = '1') then
                        A4F_wrrqD_get_data_tmp  := A4F_wrrqD_get_data;
                        dest_address        := A4F_wrrqD_get_data(A4F_AXI_wid'left downto A4F_AXI_wid'right + A4F_id_width);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto A4F_wrrqD_get_data_tmp'length + NoC_addr_width) & A4F_wrrqD_get_data_tmp & dest_address;
                        controlOut(TX)      <= '1';
                        controlOut(EOP)     <= '0';

                        A4F_wrrqD_get_en    <= '1';
                        state_send          <= RdRsp;
                    else
                        A4F_wrrqD_get_en    <= '0';
                    end if;
                else
                    if (controlIn(STALL_GO) = '1') then
                        controlOut(TX)      <= '0';
                        controlOut(EOP)     <= '0';
                    end if;

                    A4F_wrrqD_get_en        <= '0';
                    state_send              <= RdRsp;
                end if;
            end if;

            
            --------------------------------------
            -- NETWORK DATA TO A4L R/W RESPONSE --
            --------------------------------------
            -- If the network sends data or data transfer is stalled because of the receiver not being ready
            -- attempts are made to hand the data to the receiver until it is ready
            --------------------------------------
            
            if (put_stalled = '1') then
                if ((put_last_state = WrRsp and A4F_wrrsp_put_ready = '1') or
                    (put_last_state = RdRsp and A4F_rdrsp_put_ready = '1') or
                    (put_last_state = WrRqA and A4L_wrrqA_put_ready = '1') or
                    (put_last_state = WrRqD and A4L_wrrqD_put_ready = '1') or
                    (put_last_state = RdRqA and A4L_rdrqA_put_ready = '1')) then
                    if (dataInStalled(dataIn'left downto dataIn'left - 2) = "110") then
                        A4F_wrrsp_put_en            <= '1';
                        A4F_rdrsp_put_en            <= '0';
                        A4L_rdrqA_put_en            <= '0';
                        A4L_wrrqA_put_en            <= '0';
                        A4L_wrrqD_put_en            <= '0';
                        A4F_wrrsp_put_data_tmp      := dataInStalled(NoC_addr_width + A4F_wrrsp_width - 1 downto NoC_addr_width);
                        A4F_wrrsp_put_data          <= A4F_wrrsp_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        put_last_state          <= WrRsp;
                        put_stalled             <= '0';
                    elsif (dataInStalled(dataIn'left downto dataIn'left - 2) = "100") then
                        A4F_wrrsp_put_en            <= '0';
                        A4F_rdrsp_put_en            <= '1';
                        A4L_rdrqA_put_en            <= '0';
                        A4L_wrrqA_put_en            <= '0';
                        A4L_wrrqD_put_en            <= '0';
                        A4F_rdrsp_put_data_tmp      := dataInStalled(NoC_addr_width + A4F_rdrsp_width - 1 downto NoC_addr_width);
                        A4F_rdrsp_put_data          <= A4F_rdrsp_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        put_last_state          <= RdRsp;
                        put_stalled             <= '0';
                    elsif (dataInStalled(dataIn'left downto dataIn'left - 2) = "010") then
                        A4F_wrrsp_put_en            <= '0';
                        A4F_rdrsp_put_en            <= '0';
                        A4L_rdrqA_put_en            <= '0';
                        A4L_wrrqA_put_en            <= '1';
                        A4L_wrrqD_put_en            <= '0';
                        A4L_wrrqA_put_data_tmp      := dataIn(NoC_addr_width + A4L_wrrqA_width - 1 downto NoC_addr_width);
                        A4L_wrrqA_put_data          <= A4L_wrrqA_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        put_last_state          <= WrRqA;
                        put_stalled             <= '0';
                    elsif (dataInStalled(dataIn'left downto dataIn'left - 2) = "011") then
                        A4F_wrrsp_put_en            <= '0';
                        A4F_rdrsp_put_en            <= '0';
                        A4L_rdrqA_put_en            <= '0';
                        A4L_wrrqA_put_en            <= '0';
                        A4L_wrrqD_put_en            <= '1';
                        A4L_wrrqD_put_data_tmp      := dataIn(NoC_addr_width + A4L_wrrqD_width - 1 downto NoC_addr_width);
                        A4L_wrrqD_put_data          <= A4L_wrrqD_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        put_last_state          <= WrRqD;
                        put_stalled             <= '0';
                    elsif (dataInStalled(dataIn'left downto dataIn'left - 2) = "000") then
                        A4F_wrrsp_put_en            <= '0';
                        A4F_rdrsp_put_en            <= '0';
                        A4L_rdrqA_put_en            <= '1';
                        A4L_wrrqA_put_en            <= '0';
                        A4L_wrrqD_put_en            <= '0';
                        A4L_rdrqA_put_data_tmp      := dataIn(NoC_addr_width + A4L_rdrqA_width - 1 downto NoC_addr_width);
                        A4L_rdrqA_put_data          <= A4L_rdrqA_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        put_last_state          <= WrRqA;
                        put_stalled             <= '0';
                    end if;
                end if;
            elsif (controlIn(RX) = '1') then
                if (dataIn(dataIn'left downto dataIn'left - 2) = "100") then
                    if ((put_last_state = WrRsp and A4F_wrrsp_put_ready = '1') or
                        (put_last_state = RdRsp and A4F_rdrsp_put_ready = '1') or
                        (put_last_state = WrRqA and A4L_wrrqA_put_ready = '1') or
                        (put_last_state = WrRqD and A4L_wrrqD_put_ready = '1') or
                        (put_last_state = RdRqA and A4L_rdrqA_put_ready = '1')) then
                        A4F_wrrsp_put_en            <= '1';
                        A4F_rdrsp_put_en            <= '0';
                        A4L_rdrqA_put_en            <= '0';
                        A4L_wrrqA_put_en            <= '0';
                        A4L_wrrqD_put_en            <= '0';
                        A4F_wrrsp_put_data_tmp      := dataIn(NoC_addr_width + A4F_wrrsp_width - 1 downto NoC_addr_width);
                        A4F_wrrsp_put_data          <= A4F_wrrsp_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                    else
                        dataInStalled           <= dataIn;
                        controlOut(STALL_GO)    <= '0';
                        put_last_state          <= WrRsp;
                        put_stalled             <= '1';
                    end if;
                elsif (dataIn(dataIn'left downto dataIn'left - 2) = "110") then
                    if ((put_last_state = WrRsp and A4F_wrrsp_put_ready = '1') or
                        (put_last_state = RdRsp and A4F_rdrsp_put_ready = '1') or
                        (put_last_state = WrRqA and A4L_wrrqA_put_ready = '1') or
                        (put_last_state = WrRqD and A4L_wrrqD_put_ready = '1') or
                        (put_last_state = RdRqA and A4L_rdrqA_put_ready = '1')) then
                        A4F_wrrsp_put_en            <= '0';
                        A4F_rdrsp_put_en            <= '1';
                        A4L_rdrqA_put_en            <= '0';
                        A4L_wrrqA_put_en            <= '0';
                        A4L_wrrqD_put_en            <= '0';
                        A4F_rdrsp_put_data_tmp      := dataIn(NoC_addr_width + A4F_rdrsp_width - 1 downto NoC_addr_width);
                        A4F_rdrsp_put_data          <= A4F_rdrsp_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                    else
                        dataInStalled           <= dataIn;
                        controlOut(STALL_GO)    <= '0';
                        put_last_state          <= RdRsp;
                        put_stalled             <= '1';
                    end if;
                elsif (dataIn(dataIn'left downto dataIn'left - 2) = "010") then
                    if ((put_last_state = WrRsp and A4F_wrrsp_put_ready = '1') or
                        (put_last_state = RdRsp and A4F_rdrsp_put_ready = '1') or
                        (put_last_state = WrRqA and A4L_wrrqA_put_ready = '1') or
                        (put_last_state = WrRqD and A4L_wrrqD_put_ready = '1') or
                        (put_last_state = RdRqA and A4L_rdrqA_put_ready = '1')) then
                        A4F_wrrsp_put_en            <= '0';
                        A4F_rdrsp_put_en            <= '0';
                        A4L_rdrqA_put_en            <= '0';
                        A4L_wrrqA_put_en            <= '1';
                        A4L_wrrqD_put_en            <= '0';
                        A4L_wrrqA_put_data_tmp      := dataIn(NoC_addr_width + A4L_wrrqA_width - 1 downto NoC_addr_width);
                        A4L_wrrqA_put_data          <= A4L_wrrqA_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                    else
                        dataInStalled           <= dataIn;
                        controlOut(STALL_GO)    <= '0';
                        put_last_state          <= WrRqA;
                        put_stalled             <= '1';
                    end if;
                elsif (dataIn(dataIn'left downto dataIn'left - 2) = "011") then
                    if ((put_last_state = WrRsp and A4F_wrrsp_put_ready = '1') or
                        (put_last_state = RdRsp and A4F_rdrsp_put_ready = '1') or
                        (put_last_state = WrRqA and A4L_wrrqA_put_ready = '1') or
                        (put_last_state = WrRqD and A4L_wrrqD_put_ready = '1') or
                        (put_last_state = RdRqA and A4L_rdrqA_put_ready = '1')) then
                        A4F_wrrsp_put_en            <= '0';
                        A4F_rdrsp_put_en            <= '0';
                        A4L_rdrqA_put_en            <= '0';
                        A4L_wrrqA_put_en            <= '0';
                        A4L_wrrqD_put_en            <= '1';
                        A4L_wrrqD_put_data_tmp      := dataIn(NoC_addr_width + A4L_wrrqD_width - 1 downto NoC_addr_width);
                        A4L_wrrqD_put_data          <= A4L_wrrqD_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                    else
                        dataInStalled           <= dataIn;
                        controlOut(STALL_GO)    <= '0';
                        put_last_state          <= WrRqD;
                        put_stalled             <= '1';
                    end if;
                elsif (dataIn(dataIn'left downto dataIn'left - 2) = "000") then
                    if ((put_last_state = WrRsp and A4F_wrrsp_put_ready = '1') or
                        (put_last_state = RdRsp and A4F_rdrsp_put_ready = '1') or
                        (put_last_state = WrRqA and A4L_wrrqA_put_ready = '1') or
                        (put_last_state = WrRqD and A4L_wrrqD_put_ready = '1') or
                        (put_last_state = RdRqA and A4L_rdrqA_put_ready = '1')) then
                        A4F_wrrsp_put_en            <= '0';
                        A4F_rdrsp_put_en            <= '0';
                        A4L_rdrqA_put_en            <= '1';
                        A4L_wrrqA_put_en            <= '0';
                        A4L_wrrqD_put_en            <= '0';
                        A4L_rdrqA_put_data_tmp      := dataIn(NoC_addr_width + A4L_rdrqA_width - 1 downto NoC_addr_width);
                        A4L_rdrqA_put_data          <= A4L_rdrqA_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                    else
                        dataInStalled           <= dataIn;
                        controlOut(STALL_GO)    <= '0';
                        put_last_state          <= RdRqA;
                        put_stalled             <= '1';
                    end if;
                end if;
            elsif (controlIn(RX) = '0') then
                if(A4F_wrrsp_put_ready = '1') then
                    A4F_wrrsp_put_en    <= '0';
                end if;
                if(A4F_rdrsp_put_ready = '1') then
                    A4F_rdrsp_put_en    <= '0';
                end if;
                if(A4L_wrrqA_put_ready = '1') then
                    A4L_wrrqA_put_en    <= '0';
                end if;
                if(A4L_wrrqD_put_ready = '1') then
                    A4L_wrrqA_put_en    <= '0';
                end if;
                if(A4L_rdrqA_put_ready = '1') then
                    A4L_rdrqA_put_en    <= '0';
                end if;
            end if;
        end if;
        end if;
    end process;
end architecture;

-------------------------------------------------------------------------------
