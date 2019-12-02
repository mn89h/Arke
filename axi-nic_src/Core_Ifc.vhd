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
        signal AXI_arvalid      : out std_logic;
        signal AXI_arready      : in  std_logic;
        signal AXI_rdrqA_data   : out AXI4_Lite_Rd_RqA;
        signal AXI_awvalid      : out std_logic;
        signal AXI_awready      : in  std_logic;
        signal AXI_wrrqA_data   : out AXI4_Lite_Wr_RqA;
        signal AXI_wvalid       : out std_logic;
        signal AXI_wready       : in  std_logic;
        signal AXI_wrrqD_data   : out AXI4_Lite_Wr_RqD;
        signal AXI_rready       : out std_logic;
        signal AXI_rvalid       : in  std_logic;
        signal AXI_rdrsp_data   : in  AXI4_Lite_Rd_Rsp;
        signal AXI_bready       : out std_logic;
        signal AXI_bvalid       : in  std_logic;
        signal AXI_wrrsp_data   : in  AXI4_Lite_Wr_Rsp;

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


    signal rdrqA_put_ready : std_logic;
    signal rdrqA_put_en    : std_logic;
    signal rdrqA_put_data  : AXI4_Lite_Rd_RqA;
    signal wrrqA_put_ready : std_logic;
    signal wrrqA_put_en    : std_logic;
    signal wrrqA_put_data  : AXI4_Lite_Wr_RqA;
    signal wrrqD_put_ready : std_logic;
    signal wrrqD_put_en    : std_logic;
    signal wrrqD_put_data  : AXI4_Lite_Wr_RqD;
    signal rdrsp_get_valid : std_logic;
    signal rdrsp_get_en    : std_logic;
    signal rdrsp_get_data  : AXI4_Lite_Rd_Rsp;
    signal wrrsp_get_valid : std_logic;
    signal wrrsp_get_en    : std_logic;
    signal wrrsp_get_data  : AXI4_Lite_Wr_Rsp;

    signal rsp_put_stalled : std_logic;

    --constant address_map_c : ADDR_MAP_TYPE := (others => (others => '0'));


    function f_getRouterAdress (
        aIn : unsigned(AXI4_LITE_ADDR_WIDTH - 1 downto 0)) 
        return std_logic_vector is
        variable xA : unsigned(DIM_X_W - 1 downto 0) := (others => '0');
        variable yA : unsigned(DIM_Y_W - 1 downto 0) := (others => '0');
        variable zA : unsigned(DIM_Z_W - 1 downto 0) := (others => '0');
        --variable xA : unsigned(AXI4_LITE_ADDR_WIDTH - 1 downto 0) := (others => '0');
        --variable yA : unsigned(AXI4_LITE_ADDR_WIDTH - 1 downto 0) := (others => '0');
        --variable zA : unsigned(AXI4_LITE_ADDR_WIDTH - 1 downto 0) := (others => '0');
        --variable test : unsigned(5 downto 0) := (others => '0'); works
        begin
            --zA := resize(aIn / (DIM_X * DIM_Y), DIM_Z_W);
            --yA := resize((aIn mod (DIM_X * DIM_Y)) / DIM_X, DIM_Y_W);
            --xA := resize((aIn mod (DIM_X * DIM_Y)) mod DIM_X, DIM_X_W);
            --zA := aIn / (DIM_X * DIM_Y);
            --yA := (aIn mod (DIM_X * DIM_Y)) / DIM_X;
            --xA := (aIn mod (DIM_X * DIM_Y)) mod DIM_X;
            --return std_logic_vector( xA(DIM_X_W - 1 downto 0) & yA(DIM_Y_W - 1 downto 0) & zA(DIM_Z_W - 1 downto 0) );
            return std_logic_vector(aIn(5 downto 0));
    end f_getRouterAdress;

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

        AXI_Master : AXI4_Master_Slave
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
            rdrqA_put_en    => rdrqA_put_en,
            rdrqA_put_ready => rdrqA_put_ready,
            rdrqA_put_data  => rdrqA_put_data,
            wrrqA_put_en    => wrrqA_put_en,
            wrrqA_put_ready => wrrqA_put_ready,
            wrrqA_put_data  => wrrqA_put_data,
            wrrqD_put_en    => wrrqD_put_en,
            wrrqD_put_ready => wrrqD_put_ready,
            wrrqD_put_data  => wrrqD_put_data,
            rdrsp_get_valid => rdrsp_get_valid,
            rdrsp_get_en    => rdrsp_get_en,
            rdrsp_get_data  => rdrsp_get_data,
            wrrsp_get_valid => wrrsp_get_valid,
            wrrsp_get_en    => wrrsp_get_en,
            wrrsp_get_data  => wrrsp_get_data
        );
                    
        process(clk)

            variable wrrqA_put_data_tmp : AXI4_Lite_Wr_RqA;
            variable wrrqD_put_data_tmp : AXI4_Lite_Wr_RqD;
            variable rdrqA_put_data_tmp : AXI4_Lite_Rd_RqA;
            variable wrrsp_get_data_tmp : AXI4_Lite_Wr_Rsp;
            variable rdrsp_get_data_tmp : AXI4_Lite_Rd_Rsp;
            
            --TODO: check if needed, actual width
            variable vec_wrrsp      : std_logic_vector(AXI4_Lite_Wr_Rsp_WIDTH - 1 downto 0);
            variable vec_rdrsp      : std_logic_vector(AXI4_Lite_Rd_Rsp_WIDTH - 1 downto 0);
            variable address        : std_logic_vector(ADDR_W - 1 downto 0);
        begin if rising_edge(clk) then
            if (rst = '1') then
                controlOut <= "100";
                dataOut <= (others => '0');
            else
                ---------------------------------
                -- A4L R/W RESPONSE TO NETWORK --
                ---------------------------------
                if(controlIn(STALL_GO) = '1') then
                    wrrsp_get_en <= '1';
                    rdrsp_get_en <= '1';
                            
                    if(wrrsp_get_valid = '1') then
                        wrrsp_get_data_tmp  := wrrsp_get_data;
                        vec_wrrsp           := serialize_A4L_Wr_Rsp(wrrsp_get_data_tmp);
                        address             := ZERO(ADDR_W - 1 downto 0);
                        dataOut             <= '0' & "10" & ZERO(dataOut'left - 3 downto vec_wrrsp'length + ADDR_W) & vec_wrrsp & address;
                        controlOut(TX)      <= '1';
                        controlOut(EOP)     <= '1';
                    elsif(rdrqA_get_valid = '1') then
                        rdrsp_get_data_tmp  := rdrsp_get_data;
                        vec_rdrsp           := serialize_A4L_Rd_Rsp(rdrsp_get_data_tmp);
                        address             := ZERO(ADDR_W - 1 downto 0);
                        dataOut             <= '0' & "00" & ZERO(dataOut'left - 2 downto vec_rdrsp'length + ADDR_W) & vec_rdrsp & address;
                        controlOut(TX)      <= '1';
                        controlOut(EOP)     <= '1';
                    else
                        controlOut(TX)      <= '0';
                        controlOut(EOP)     <= '0';
                    end if;
                else
                    controlOut(TX)      <= '0';
                    controlOut(EOP)     <= '0';
                end if;

                --TODO: seperate rd/wr channels further by making STALL_GO dependant from channel?
                
                ---------------------------
                -- A4L R/W REQUEST TO PE --
                ---------------------------
                if ((controlIn(RX) = '1') or (rsp_put_stalled = '1')) then
                    if (dataIn(dataIn'left downto dataIn'left - 2) = "010") then
                        wrrqA_put_en            <= '1';
                        wrrqA_put_data_tmp      := deserialize_A4L_Wr_RqA(dataIn(AXI4_Lite_Wr_RqA_WIDTH + ADDR_W - 1 downto ADDR_W));
                        wrrqA_put_data          <= wrrqA_put_data_tmp;
                        if(wrrqA_put_ready = '1') then
                            controlOut(STALL_GO)    <= '1';
                            req_put_stalled         <= '0';
                        else
                            controlOut(STALL_GO)    <= '0';
                            req_put_stalled         <= '1';
                        end if;
                    elsif (dataIn(dataIn'left downto dataIn'left - 2) = "011") then
                        wrrqD_put_en            <= '1';
                        wrrqD_put_data_tmp      := deserialize_A4L_Wr_RqD(dataIn(AXI4_Lite_Wr_RqD_WIDTH + ADDR_W - 1 downto ADDR_W));
                        wrrqD_put_data          <= wrrqD_put_data_tmp;
                        if(wrrqD_put_ready = '1') then
                            controlOut(STALL_GO)    <= '1';
                            req_put_stalled         <= '0';
                        else
                            controlOut(STALL_GO)    <= '0';
                            req_put_stalled         <= '1';
                        end if;
                    elsif (dataIn(dataIn'left downto dataIn'left - 2) = "000") then
                        rdrqA_put_en            <= '1';
                        rdrqA_put_data_tmp      := deserialize_A4L_Rd_RqA(dataIn(AXI4_Lite_Rd_RqA_WIDTH + ADDR_W - 1 downto ADDR_W));
                        rdrqA_put_data          <= rdrqA_put_data_tmp;
                        if(rdrqA_put_ready = '1') then
                            controlOut(STALL_GO)    <= '1';
                            req_put_stalled         <= '0';
                        else
                            controlOut(STALL_GO)    <= '0';
                            req_put_stalled         <= '1';
                        end if;
                    end if;
                elsif (rsp_put_stalled = '0') then
                    controlOut(STALL_GO)    <= '1';
                    rsp_put_stalled         <= '0';
                end if;
            end if;
        end if;
    end process;
end architecture;


            