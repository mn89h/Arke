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
            variable address        : std_logic_vector(ADDR_W -1 downto 0);
        begin
            
            if rising_edge(clk) then
            if rst = '1' then
                    controlOut <= "100";
                    dataOut <= (others => '0');
            else
                wrrqA_get_en <= '1';
                wrrqD_get_en <= '1';
                rdrqA_get_en <= '1';
                    
                if((wrrqA_get_valid = '1') and (controlIn(STALL_GO) = '1')) then
                    wrrqA_get_data_tmp  := wrrqA_get_data;
                    vec_wrrqa           := serialize_A4L_Wr_RqA(wrrqA_get_data_tmp);
                    address             := f_getRouterAdress(unsigned(wrrqA_get_data_tmp.addr));
                    dataOut             <= '0' & '1' & ZERO(dataOut'left - 2 downto vec_wrrqa'length + ADDR_W) & vec_wrrqa & address;
                    controlOut(TX)      <= '1';
                    controlOut(EOP)     <= '0';
                elsif((wrrqD_get_valid = '1') and (controlIn(STALL_GO) = '1')) then --expect that after wrrqA, wrrqA is invalid and wrrqD is valid
                    wrrqD_get_data_tmp  := wrrqD_get_data;
                    vec_wrrqd           := serialize_A4L_Wr_RqD(wrrqD_get_data_tmp);
                    dataOut             <= '0' & '1' & ZERO(dataOut'left - 2 downto vec_wrrqd'length) & vec_wrrqd;
                    controlOut(TX)      <= '1';
                    controlOut(EOP)     <= '1';
                elsif((rdrqA_get_valid = '1') and (controlIn(STALL_GO) = '1')) then
                    rdrqA_get_data_tmp  := rdrqA_get_data;
                    vec_rdrqa           := serialize_A4L_Rd_RqA(rdrqA_get_data_tmp);
                    --address             := f_getRouterAdress(unsigned(rdrqA_get_data_tmp.addr));
                    address             := address_map_c(to_Integer(unsigned(rdrqA_get_data_tmp.addr)) + 1);
                    dataOut             <= '0' & '0' & ZERO(dataOut'left - 2 downto vec_rdrqa'length + ADDR_W) & vec_rdrqa & address;
                    controlOut(TX)      <= '1';
                    controlOut(EOP)     <= '1';
                else
                    controlOut(TX)      <= '0';
                    controlOut(EOP)     <= '0';
                end if;

                --TODO: wrrsp_put_ready check where to place, combinate with STALL_GO?
                if(controlIn(RX) = '1') then
                    if((dataIn(dataIn'length - 2) = '1') and (wrrsp_put_ready = '1')) then
                        wrrsp_put_en            <= '1';
                        wrrsp_put_data_tmp      := deserialize_A4L_Wr_Rsp(dataIn(ADDR_W + AXI4_Lite_Wr_Rsp_WIDTH - 1 downto ADDR_W));
                        wrrsp_put_data          <= wrrsp_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                    elsif((dataIn(dataIn'length - 2) = '0') and (rdrsp_put_ready = '1')) then
                        rdrsp_put_en            <= '1';
                        rdrsp_put_data_tmp      := deserialize_A4L_Rd_Rsp(dataIn(ADDR_W + AXI4_Lite_Rd_Rsp_WIDTH - 1 downto ADDR_W));
                        rdrsp_put_data          <= rdrsp_put_data_tmp;
                        controlOut(STALL_GO)    <= '1';
                    else
                        --rdrsp/wrrsp full, but local router is sending
                        --TODO: store until free?
                        controlOut(STALL_GO)    <= '0';
                    end if;
                else
                    controlOut(STALL_GO)    <= '1';
                end if;
            end if;
            end if;
        end process;
    end architecture;


            