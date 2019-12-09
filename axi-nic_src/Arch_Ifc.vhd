-------------------------------------------------------------------------------
-- Title      : Architecture Interface
-- Project    : TaPaSCo NoC Integration
-------------------------------------------------------------------------------
-- File       : Arch_Ifc.vhd
-- Author     : Malte Nilges
-- Company    : 
-- Created    : 2019-11-24
-- Last update: 2019-12-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Network interface for TaPaSCo's architecture sending data to 
--              and receiving data from PEs (processing elements).
--              Data received from AXI4 Lite Master is being received by a
--              Slave and converted to appropriate network data format and the 
--              other way round.
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.NIC_pkg.all;
use work.Arke_pkg.all;

entity Arch_Ifc is
    generic (
        address: std_logic_vector;
        address_map : std_logic_vector
    );
    port (
        signal clk              : in  std_logic := '1';
        signal rst              : in  std_logic := '1';
        signal AXI_arvalid      : in  std_logic;
        signal AXI_arready      : out std_logic;
        signal AXI_rdrqA_data   : in  AXI4_Lite_Rd_RqA;
        signal AXI_awvalid      : in  std_logic;
        signal AXI_awready      : out std_logic;
        signal AXI_wrrqA_data   : in  AXI4_Lite_Wr_RqA;
        signal AXI_wvalid       : in  std_logic;
        signal AXI_wready       : out std_logic;
        signal AXI_wrrqD_data   : in  AXI4_Lite_Wr_RqD;
        signal AXI_rready       : in  std_logic;
        signal AXI_rvalid       : out std_logic;
        signal AXI_rdrsp_data   : out AXI4_Lite_Rd_Rsp;
        signal AXI_bready       : in  std_logic;
        signal AXI_bvalid       : out std_logic;
        signal AXI_wrrsp_data   : out AXI4_Lite_Wr_Rsp;

        signal dataOut          : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        signal controlOut       : out std_logic_vector(CONTROL_WIDTH - 1 downto 0);
        signal dataIn           : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        signal controlIn        : in  std_logic_vector(CONTROL_WIDTH - 1 downto 0)
    );
end Arch_Ifc;

architecture Behavioral of Arch_Ifc is

    constant DIM_X_W    : integer := Log2(DIM_X);
    constant DIM_Y_W    : integer := Log2(DIM_Y);
    constant DIM_Z_W    : integer := Log2(DIM_Z);
    constant ADDR_W     : integer := DIM_X_W + DIM_Y_W + DIM_Z_W;

    type ADDR_MAP_TYPE is array (0 to DIM_X * DIM_Y * DIM_Z - 1) of std_logic_vector(ADDR_W - 1 downto 0);
    type State is (RdRqA, WrRqA, WrRqD);

    signal rdrqA_get_valid : std_logic;
    signal rdrqA_get_en    : std_logic;
    signal rdrqA_get_data  : AXI4_Lite_Rd_RqA;
    signal wrrqA_get_valid : std_logic;
    signal wrrqA_get_en    : std_logic;
    signal wrrqA_get_data  : AXI4_Lite_Wr_RqA;
    signal wrrqD_get_valid : std_logic;
    signal wrrqD_get_en    : std_logic;
    signal wrrqD_get_data  : AXI4_Lite_Wr_RqD;
    signal rdrsp_put_ready : std_logic;
    signal rdrsp_put_en    : std_logic;
    signal rdrsp_put_data  : AXI4_Lite_Rd_Rsp;
    signal wrrsp_put_ready : std_logic;
    signal wrrsp_put_en    : std_logic;
    signal wrrsp_put_data  : AXI4_Lite_Wr_Rsp;

    signal rsp_put_stalled : std_logic;
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

        AXI_Slave : AXI4_Lite_Slave
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
            wrrsp_put_data  => wrrsp_put_data
        );
                    
        process(clk)

            variable wrrqA_get_data_tmp : AXI4_Lite_Wr_RqA;
            variable wrrqD_get_data_tmp : AXI4_Lite_Wr_RqD;
            variable rdrqA_get_data_tmp : AXI4_Lite_Rd_RqA;
            variable wrrsp_put_data_tmp : AXI4_Lite_Wr_Rsp;
            variable rdrsp_put_data_tmp : AXI4_Lite_Rd_Rsp;
            
            --TODO: check if needed, actual width
            variable vec_wrrqa      : std_logic_vector(AXI4_Lite_Wr_RqA_WIDTH - 1 downto 0);
            variable vec_wrrqd      : std_logic_vector(AXI4_Lite_Wr_RqD_WIDTH - 1 downto 0);
            variable vec_rdrqa      : std_logic_vector(AXI4_Lite_Rd_RqA_WIDTH - 1 downto 0);
            variable address        : std_logic_vector(ADDR_W - 1 downto 0);
        begin if rising_edge(clk) then
            if (rst = '1') then
                controlOut          <= "100";
                dataOut             <= (others => '0');
                state_send          <= RdRqA;
                rsp_put_stalled     <= '0';
            else
            -------------------------------------
            -- A4L R/W REQUEST TO NETWORK DATA --
            -------------------------------------
            -- Incoming r/w requests are being handed over to the network as they are valid using round-robin.
            -- If a request is valid, but the local router isn't able to receive data, the state remains the same
            -- otherwise it changes to the next state to look for valid data.
            -- The network destination is chosen by a address map in conjunction with the AXI address.

            -- STATE 1: RDRQA
            if (state_send = RdRqA) then
                wrrqA_get_en        <= '0';
                wrrqD_get_en        <= '0';

                if (rdrqA_get_valid = '1') then
                    if (controlIn(STALL_GO) = '1') then
                        rdrqA_get_data_tmp  := rdrqA_get_data;
                        vec_rdrqa           := serialize_A4L_Rd_RqA(rdrqA_get_data_tmp);
                        address             := address_map_c(to_Integer(unsigned(rdrqA_get_data_tmp.addr)) + 1);
                        dataOut             <= '0' & "00" & ZERO(dataOut'left - 3 downto vec_rdrqa'length + ADDR_W) & vec_rdrqa & address;
                        controlOut(TX)      <= '1';
                        controlOut(EOP)     <= '1';

                        rdrqA_get_en        <= '1';
                        state_send          <= WrRqA;
                    else
                        rdrqA_get_en        <= '0';
                    end if;
                else
                    if (controlIn(STALL_GO) = '1') then
                        controlOut(TX)      <= '0';
                        controlOut(EOP)     <= '0';
                    end if;

                    rdrqA_get_en        <= '0';
                    state_send          <= WrRqA;
                end if;

            -- STATE 2: WRRQA
            elsif (state_send = WrRqA) then
                rdrqA_get_en        <= '0';
                wrrqD_get_en        <= '0';

                if (wrrqA_get_valid = '1') then
                    if (controlIn(STALL_GO) = '1') then
                        wrrqA_get_data_tmp  := wrrqA_get_data;
                        vec_wrrqa           := serialize_A4L_Wr_RqA(wrrqA_get_data_tmp);
                        address             := address_map_c(to_Integer(unsigned(rdrqA_get_data_tmp.addr)) + 1);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto vec_wrrqa'length + ADDR_W) & vec_wrrqa & address;
                        controlOut(TX)      <= '1';
                        controlOut(EOP)     <= '0';

                        wrrqA_get_en        <= '1';
                        state_send          <= WrRqD;
                    else
                        wrrqA_get_en        <= '0';
                    end if;
                else
                    if (controlIn(STALL_GO) = '1') then
                        controlOut(TX)      <= '0';
                        controlOut(EOP)     <= '0';
                    end if;

                    wrrqA_get_en        <= '0';
                    state_send          <= RdRqA; --if no valid wr address continue with rd
                end if;

            -- STATE 3: WRRQD
            else
                rdrqA_get_en        <= '0';
                wrrqA_get_en        <= '0';

                if (wrrqD_get_valid = '1') then
                    if (controlIn(STALL_GO) = '1') then
                        wrrqA_get_data_tmp  := wrrqA_get_data;
                        vec_wrrqa           := serialize_A4L_Wr_RqA(wrrqA_get_data_tmp);
                        address             := address_map_c(to_Integer(unsigned(rdrqA_get_data_tmp.addr)) + 1);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto vec_wrrqa'length + ADDR_W) & vec_wrrqa & address;
                        controlOut(TX)      <= '1';
                        controlOut(EOP)     <= '0';

                        wrrqD_get_en        <= '1';
                        state_send          <= RdRqA;
                    else
                        wrrqD_get_en        <= '0';
                    end if;
                else
                    if (controlIn(STALL_GO) = '1') then
                        controlOut(TX)      <= '0';
                        controlOut(EOP)     <= '0';
                    end if;

                    wrrqD_get_en        <= '0';
                    --if not valid remain until valid to complete the packet
                end if;
            end if;
            

            --------------------------------------
            -- NETWORK DATA TO A4L R/W RESPONSE --
            --------------------------------------
            -- If the network sends data or data transfer is stalled because of the receiver not being ready
            -- attempts are made to hand the data to the receiver until it is ready
            
            if ((controlIn(RX) = '1') or (rsp_put_stalled = '1')) then
                if (dataIn(dataIn'left - 1) = '1') then
                    if(wrrsp_put_ready = '1') then
                        wrrsp_put_en            <= '1';
                        wrrsp_put_data_tmp      := deserialize_A4L_Wr_Rsp(dataIn(ADDR_W + AXI4_Lite_Wr_Rsp_WIDTH - 1 downto ADDR_W));
                        wrrsp_put_data          <= wrrsp_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        rsp_put_stalled         <= '0';
                    else
                        controlOut(STALL_GO)    <= '0';
                        rsp_put_stalled         <= '1';
                    end if;
                elsif (dataIn(dataIn'left - 1) = '0') then
                    if (rdrsp_put_ready = '1') then
                        rdrsp_put_en            <= '1';
                        rdrsp_put_data_tmp      := deserialize_A4L_Rd_Rsp(dataIn(ADDR_W + AXI4_Lite_Rd_Rsp_WIDTH - 1 downto ADDR_W));
                        rdrsp_put_data          <= rdrsp_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                        rsp_put_stalled         <= '0';
                    else
                        controlOut(STALL_GO)    <= '0';
                        rsp_put_stalled         <= '1';
                    end if;
                end if;
            elsif (rsp_put_stalled = '0') then
                controlOut(STALL_GO)            <= '1';
                rsp_put_stalled                 <= '0';
            end if;
            end if;
        end if;
    end process;
end architecture;


            