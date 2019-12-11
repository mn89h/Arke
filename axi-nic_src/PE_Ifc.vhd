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
        address: std_logic_vector;
        address_map : std_logic_vector
    );
    port (
        signal clk                  : in  std_logic := '1';
        signal rst                  : in  std_logic := '1';
        signal A4L_AXI_arvalid      : out std_logic;
        signal A4L_AXI_arready      : in  std_logic;
        signal A4L_AXI_rdrqA_data   : out AXI4_Lite_Rd_RqA;
        signal A4L_AXI_awvalid      : out std_logic;
        signal A4L_AXI_awready      : in  std_logic;
        signal A4L_AXI_wrrqA_data   : out AXI4_Lite_Wr_RqA;
        signal A4L_AXI_wvalid       : out std_logic;
        signal A4L_AXI_wready       : in  std_logic;
        signal A4L_AXI_wrrqD_data   : out AXI4_Lite_Wr_RqD;
        signal A4L_AXI_rready       : out std_logic;
        signal A4L_AXI_rvalid       : in  std_logic;
        signal A4L_AXI_rdrsp_data   : in  AXI4_Lite_Rd_Rsp;
        signal A4L_AXI_bready       : out std_logic;
        signal A4L_AXI_bvalid       : in  std_logic;
        signal A4L_AXI_wrrsp_data   : in  AXI4_Lite_Wr_Rsp;

        signal A4F_AXI_arvalid      : in  std_logic;
        signal A4F_AXI_arready      : out std_logic;
        signal A4F_AXI_rdrqA_data   : in  AXI4_Full_Rd_RqA;
        signal A4F_AXI_awvalid      : in  std_logic;
        signal A4F_AXI_awready      : out std_logic;
        signal A4F_AXI_wrrqA_data   : in  AXI4_Full_Wr_RqA;
        signal A4F_AXI_wvalid       : in  std_logic;
        signal A4F_AXI_wready       : out std_logic;
        signal A4F_AXI_wrrqD_data   : in  AXI4_Full_Wr_RqD;
        signal A4F_AXI_rready       : in  std_logic;
        signal A4F_AXI_rvalid       : out std_logic;
        signal A4F_AXI_rdrsp_data   : out AXI4_Full_Rd_Rsp;
        signal A4F_AXI_bready       : in  std_logic;
        signal A4F_AXI_bvalid       : out std_logic;
        signal A4F_AXI_wrrsp_data   : out AXI4_Full_Wr_Rsp;

        signal dataOut          : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        signal controlOut       : out std_logic_vector(CONTROL_WIDTH - 1 downto 0);
        signal dataIn           : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        signal controlIn        : in  std_logic_vector(CONTROL_WIDTH - 1 downto 0)
    );
end PE_Ifc;

-------------------------------------------------------------------------------

architecture Behavioral of PE_Ifc is

    constant DIM_X_W    : integer := Log2(DIM_X);
    constant DIM_Y_W    : integer := Log2(DIM_Y);
    constant DIM_Z_W    : integer := Log2(DIM_Z);
    constant ADDR_W     : integer := DIM_X_W + DIM_Y_W + DIM_Z_W;

    type ADDR_MAP_TYPE is array (0 to DIM_X * DIM_Y * DIM_Z - 1) of std_logic_vector(ADDR_W - 1 downto 0);
    type State is (RdRsp, WrRsp, RdRqA, WrRqA, WrRqD);

    signal A4L_rdrqA_put_ready : std_logic;
    signal A4L_rdrqA_put_en    : std_logic;
    signal A4L_rdrqA_put_data  : AXI4_Lite_Rd_RqA;
    signal A4L_wrrqA_put_ready : std_logic;
    signal A4L_wrrqA_put_en    : std_logic;
    signal A4L_wrrqA_put_data  : AXI4_Lite_Wr_RqA;
    signal A4L_wrrqD_put_ready : std_logic;
    signal A4L_wrrqD_put_en    : std_logic;
    signal A4L_wrrqD_put_data  : AXI4_Lite_Wr_RqD;
    signal A4L_rdrsp_get_valid : std_logic;
    signal A4L_rdrsp_get_en    : std_logic;
    signal A4L_rdrsp_get_data  : AXI4_Lite_Rd_Rsp;
    signal A4L_wrrsp_get_valid : std_logic;
    signal A4L_wrrsp_get_en    : std_logic;
    signal A4L_wrrsp_get_data  : AXI4_Lite_Wr_Rsp;

    signal A4F_rdrqA_get_valid : std_logic;
    signal A4F_rdrqA_get_en    : std_logic;
    signal A4F_rdrqA_get_data  : AXI4_Full_Rd_RqA;
    signal A4F_wrrqA_get_valid : std_logic;
    signal A4F_wrrqA_get_en    : std_logic;
    signal A4F_wrrqA_get_data  : AXI4_Full_Wr_RqA;
    signal A4F_wrrqD_get_valid : std_logic;
    signal A4F_wrrqD_get_en    : std_logic;
    signal A4F_wrrqD_get_data  : AXI4_Full_Wr_RqD;
    signal A4F_rdrsp_put_ready : std_logic;
    signal A4F_rdrsp_put_en    : std_logic;
    signal A4F_rdrsp_put_data  : AXI4_Full_Rd_Rsp;
    signal A4F_wrrsp_put_ready : std_logic;
    signal A4F_wrrsp_put_en    : std_logic;
    signal A4F_wrrsp_put_data  : AXI4_Full_Wr_Rsp;

    signal req_put_stalled : std_logic;
    signal state_send      : State;

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


    begin

        AXI_Master : AXI4_Lite_Master
        port map (
            clk             => clk,
            rst             => rst,
            AXI_arvalid     => A4L_AXI_arvalid,
            AXI_arready     => A4L_AXI_arready,
            AXI_rdrqA_data  => A4L_AXI_rdrqA_data,
            AXI_awvalid     => A4L_AXI_awvalid,
            AXI_awready     => A4L_AXI_awready,
            AXI_wrrqA_data  => A4L_AXI_wrrqA_data,
            AXI_wvalid      => A4L_AXI_wvalid,
            AXI_wready      => A4L_AXI_wready,
            AXI_wrrqD_data  => A4L_AXI_wrrqD_data,
            AXI_rready      => A4L_AXI_rready,
            AXI_rvalid      => A4L_AXI_rvalid,
            AXI_rdrsp_data  => A4L_AXI_rdrsp_data,
            AXI_bready      => A4L_AXI_bready,
            AXI_bvalid      => A4L_AXI_bvalid,
            AXI_wrrsp_data  => A4L_AXI_wrrsp_data,
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
        port map (
            clk             => clk,
            rst             => rst,
            AXI_arvalid     => A4F_AXI_arvalid,
            AXI_arready     => A4F_AXI_arready,
            AXI_rdrqA_data  => A4F_AXI_rdrqA_data,
            AXI_awvalid     => A4F_AXI_awvalid,
            AXI_awready     => A4F_AXI_awready,
            AXI_wrrqA_data  => A4F_AXI_wrrqA_data,
            AXI_wvalid      => A4F_AXI_wvalid,
            AXI_wready      => A4F_AXI_wready,
            AXI_wrrqD_data  => A4F_AXI_wrrqD_data,
            AXI_rready      => A4F_AXI_rready,
            AXI_rvalid      => A4F_AXI_rvalid,
            AXI_rdrsp_data  => A4F_AXI_rdrsp_data,
            AXI_bready      => A4F_AXI_bready,
            AXI_bvalid      => A4F_AXI_bvalid,
            AXI_wrrsp_data  => A4F_AXI_wrrsp_data,
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

            variable A4F_wrrqA_get_data_tmp : AXI4_Full_Wr_RqA;
            variable A4F_wrrqD_get_data_tmp : AXI4_Full_Wr_RqD;
            variable A4F_rdrqA_get_data_tmp : AXI4_Full_Rd_RqA;
            variable A4L_rdrsp_get_data_tmp : AXI4_Lite_Rd_Rsp;
            variable A4L_wrrsp_get_data_tmp : AXI4_Lite_Wr_Rsp;
            variable A4L_wrrqA_put_data_tmp : AXI4_Lite_Wr_RqA;
            variable A4L_wrrqD_put_data_tmp : AXI4_Lite_Wr_RqD;
            variable A4L_rdrqA_put_data_tmp : AXI4_Lite_Rd_RqA;
            variable A4F_wrrsp_put_data_tmp : AXI4_Full_Wr_Rsp;
            variable A4F_rdrsp_put_data_tmp : AXI4_Full_Rd_Rsp;
            
            --TODO: check if needed, actual width
            variable vec_A4F_rdrqA  : std_logic_vector(AXI4_Full_Rd_RqA_WIDTH - 1 downto 0);
            variable vec_A4F_wrrqA  : std_logic_vector(AXI4_Full_Wr_RqA_WIDTH - 1 downto 0);
            variable vec_A4F_wrrqD  : std_logic_vector(AXI4_Full_Wr_RqD_WIDTH - 1 downto 0);
            variable vec_A4L_wrrsp  : std_logic_vector(AXI4_Lite_Wr_Rsp_WIDTH - 1 downto 0);
            variable vec_A4L_rdrsp  : std_logic_vector(AXI4_Lite_Rd_Rsp_WIDTH - 1 downto 0);
            variable address        : std_logic_vector(ADDR_W - 1 downto 0);

        begin if rising_edge(clk) then
            -----------
            -- RESET --
            -----------
            if (rst = '1') then
                controlOut          <= "100";
                dataOut             <= (others => '0');
                state_send          <= RdRsp;
                req_put_stalled     <= '0';
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
                        vec_A4L_rdrsp       := serialize_A4L_Rd_Rsp(A4L_rdrsp_get_data_tmp);
                        address             := ZERO(ADDR_W - 1 downto 0);
                        dataOut             <= '0' & "00" & ZERO(dataOut'left - 3 downto vec_A4L_rdrsp'length + ADDR_W) & vec_A4L_rdrsp & address;
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
                        vec_A4L_wrrsp       := serialize_A4L_Wr_Rsp(A4L_wrrsp_get_data_tmp);
                        address             := ZERO(ADDR_W - 1 downto 0);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto vec_A4L_wrrsp'length + ADDR_W) & vec_A4L_wrrsp & address;
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
                        vec_A4F_rdrqA       := serialize_A4F_Rd_RqA(A4F_rdrqA_get_data_tmp);
                        address             := ZERO(ADDR_W - 1 downto 0);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto vec_A4F_rdrqA'length + ADDR_W) & vec_A4F_rdrqA & address;
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
                        vec_A4F_wrrqA       := serialize_A4F_Wr_RqA(A4F_wrrqA_get_data_tmp);
                        address             := ZERO(ADDR_W - 1 downto 0);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto vec_A4F_wrrqA'length + ADDR_W) & vec_A4F_wrrqA & address;
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
                        vec_A4F_wrrqD       := serialize_A4F_Wr_RqD(A4F_wrrqD_get_data_tmp);
                        address             := ZERO(ADDR_W - 1 downto 0);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto vec_A4F_wrrqD'length + ADDR_W) & vec_A4F_wrrqD & address;
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

            if ((controlIn(RX) = '1') or (req_put_stalled = '1')) then
                -- A4L WRRQA
                if (dataIn(dataIn'left downto dataIn'left - 2) = "010") then
                    if(A4L_wrrqA_put_ready = '1') then
                        A4L_wrrqA_put_en            <= '1';
                        A4L_wrrqA_put_data_tmp      := deserialize_A4L_Wr_RqA(dataIn(AXI4_Lite_Wr_RqA_WIDTH + ADDR_W - 1 downto ADDR_W));
                        A4L_wrrqA_put_data          <= A4L_wrrqA_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        req_put_stalled         <= '0';
                    else
                        controlOut(STALL_GO)    <= '0';
                        req_put_stalled         <= '1';
                    end if;
                -- A4L WRRQD
                elsif (dataIn(dataIn'left downto dataIn'left - 2) = "011") then
                    if(A4L_wrrqD_put_ready = '1') then
                        A4L_wrrqD_put_en            <= '1';
                        A4L_wrrqD_put_data_tmp      := deserialize_A4L_Wr_RqD(dataIn(AXI4_Lite_Wr_RqD_WIDTH + ADDR_W - 1 downto ADDR_W));
                        A4L_wrrqD_put_data          <= A4L_wrrqD_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        req_put_stalled         <= '0';
                    else
                        controlOut(STALL_GO)    <= '0';
                        req_put_stalled         <= '1';
                    end if;
                -- A4L RDRQA
                elsif (dataIn(dataIn'left downto dataIn'left - 2) = "000") then
                    if(A4L_rdrqA_put_ready = '1') then
                        A4L_rdrqA_put_en            <= '1';
                        A4L_rdrqA_put_data_tmp      := deserialize_A4L_Rd_RqA(dataIn(AXI4_Lite_Rd_RqA_WIDTH + ADDR_W - 1 downto ADDR_W));
                        A4L_rdrqA_put_data          <= A4L_rdrqA_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        req_put_stalled         <= '0';
                    else
                        controlOut(STALL_GO)    <= '0';
                        req_put_stalled         <= '1';
                    end if;
                -- A4F WRRSP
                elsif (dataIn(dataIn'left downto dataIn'left - 2) = "110") then
                    if(A4F_wrrsp_put_ready = '1') then
                        A4F_wrrsp_put_en            <= '1';
                        A4F_wrrsp_put_data_tmp      := deserialize_A4F_Wr_Rsp(dataIn(AXI4_Full_Wr_Rsp_WIDTH + ADDR_W - 1 downto ADDR_W));
                        A4F_wrrsp_put_data          <= A4F_wrrsp_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        req_put_stalled         <= '0';
                    else
                        controlOut(STALL_GO)    <= '0';
                        req_put_stalled         <= '1';
                    end if;
                -- A4F RDRSP
                elsif (dataIn(dataIn'left downto dataIn'left - 2) = "100") then
                    if(A4F_rdrsp_put_ready = '1') then
                        A4F_rdrsp_put_en            <= '1';
                        A4F_rdrsp_put_data_tmp      := deserialize_A4F_Rd_Rsp(dataIn(AXI4_Full_Rd_Rsp_WIDTH + ADDR_W - 1 downto ADDR_W));
                        A4F_rdrsp_put_data          <= A4F_rdrsp_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        req_put_stalled         <= '0';
                    else
                        controlOut(STALL_GO)    <= '0';
                        req_put_stalled         <= '1';
                    end if;
                end if;
            elsif (req_put_stalled = '0') then
                controlOut(STALL_GO)    <= '1';
                req_put_stalled         <= '0';
            end if;
            end if;
        end if;
    end process;
end architecture;

-------------------------------------------------------------------------------
