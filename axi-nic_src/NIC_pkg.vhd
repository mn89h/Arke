--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Arke Package                                                       --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : v1.0                                                             --
-- HISTORY      : Version 0.1 - Apr 8th, 2015                                       --
--              : Version 0.2.1 - Set 18th, 2015                                    --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SERIALIZE_pkg.all;

package NIC_pkg is
    
    ---------------
    -- Constants --
    ---------------

    component STD_FIFO is
        Generic (
            -- fifo_width  : positive := FIFO_WIDTH;
            type		  data_type; -- VHDL-2008+ / Vivado 2019.1+ - replaces vectors w/ fifo_width generic and (de-)serialize functions
            fifo_depth	: positive
        );
        Port ( 
            clk		: in  std_logic;
            rst		: in  std_logic;
            WriteEn	: in  std_logic;
            DataIn	: in  data_type;
            ReadEn	: in  std_logic;
            DataOut	: out data_type;
            Empty	: out std_logic;
            Full	: out std_logic
        );
    end component;


    constant STD_FIFO_DATA_WIDTH    : integer := 16;
    constant STD_FIFO_FIFO_DEPTH    : integer := 8;

    -- Optional TODO: partially constrained axi types using VHDL-2008:
    -- https://www.doulos.com/knowhow/vhdl_designers_guide/vhdl_2008/vhdl_200x_small/#composite
    -- https://forums.xilinx.com/t5/Simulation-and-Verification/generic-package-support-in-Vivado/td-p/895460 (last posts)
    -- generic packages propably not supported (would maybe be useful for Arke_pkg dimensions and helper functions depending on dims)
    constant AXI4_FULL_DATA_WIDTH   : integer := 64;
    constant AXI4_FULL_ADDR_WIDTH   : integer := 32;

    type AXI4_Full_Wr_RqA is record
        id      : std_logic_vector( 11 downto 0 );
        addr    : std_logic_vector( AXI4_FULL_ADDR_WIDTH-1 downto 0 );
        len     : std_logic_vector(  3 downto 0 );
        size    : std_logic_vector(  2 downto 0 );
        burst   : std_logic_vector(  1 downto 0 );
        lock    : std_logic_vector(  1 downto 0 );
        cache   : std_logic_vector(  2 downto 0 );
        prot    : std_logic_vector(  2 downto 0 );
        qos     : std_logic_vector(  2 downto 0 );
    end record;
    constant AXI4_Full_Wr_RqA_WIDTH : integer := AXI4_FULL_ADDR_WIDTH + 32;

    type AXI4_Full_Wr_RqD is record
        id      : std_logic_vector( 11 downto 0 );
        data    : std_logic_vector( AXI4_FULL_DATA_WIDTH-1 downto 0 );
        strb    : std_logic_vector(  3 downto 0 );
        last    : std_logic;
    end record;
    constant AXI4_Full_Wr_RqD_WIDTH : integer := AXI4_FULL_DATA_WIDTH + 17;

    type AXI4_Full_Wr_Rsp is record
        id      : std_logic_vector( 11 downto 0 );
        resp    : std_logic_vector(  1 downto 0 );
    end record;
    constant AXI4_Full_Wr_Rsp_WIDTH : integer := 14;

    type AXI4_Full_Rd_RqA is record
        id      : std_logic_vector( 11 downto 0 );
        addr    : std_logic_vector( AXI4_FULL_ADDR_WIDTH-1 downto 0 );
        len     : std_logic_vector(  3 downto 0 );
        size    : std_logic_vector(  2 downto 0 );
        burst   : std_logic_vector(  1 downto 0 );
        lock    : std_logic_vector(  1 downto 0 );
        cache   : std_logic_vector(  2 downto 0 );
        prot    : std_logic_vector(  2 downto 0 );
        qos     : std_logic_vector(  2 downto 0 );
    end record;
    constant AXI4_Full_Rd_RqA_WIDTH : integer := AXI4_FULL_ADDR_WIDTH + 32;

    type AXI4_Full_Rd_Rsp is record
        id      : std_logic_vector( 11 downto 0 );
        data    : std_logic_vector( AXI4_FULL_DATA_WIDTH-1 downto 0 );
        resp    : std_logic_vector(  1 downto 0 );
        last    : std_logic;
    end record;
    constant AXI4_Full_Rd_Rsp_WIDTH : integer := AXI4_FULL_DATA_WIDTH + 17;
    
    -- NOTE: Legacy, needed for <VHDL2008 / <Vivado2019.1
    -- as discussed in https://stackoverflow.com/questions/3985694/serialize-vhdl-record
    -- function serialize (
    --     input : AXI4_Full_Wr_RqA
    --     )
    --     return std_logic_vector is
    --         variable ser : serializer_t(AXI4_Full_Wr_RqA_WIDTH-1 downto 0);
    --         variable r   : std_logic_vector(AXI4_Full_Wr_RqA_WIDTH-1 downto 0);
    --     begin
    --         serialize_init(ser);
    --         serialize(ser, input.id);
    --         serialize(ser, input.addr);
    --         serialize(ser, input.len);
    --         serialize(ser, input.size);
    --         serialize(ser, input.burst);
    --         serialize(ser, input.lock);
    --         serialize(ser, input.cache);
    --         serialize(ser, input.prot);
    --         serialize(ser, input.qos);
    --         r := serialize_get(ser);
    --         return r;
    -- end function serialize;


    -- function deserialize (
    --     input : std_logic_vector
    --     )
    --     return AXI4_Full_Wr_RqA is
    --         variable ser : serializer_t(AXI4_Full_Wr_RqA_WIDTH-1 downto 0);
    --         variable r   : AXI4_Full_Wr_RqA;
    --     begin
    --         ser := serialize_set(input);
    --         deserialize(ser, r.id);
    --         deserialize(ser, r.addr);
    --         deserialize(ser, r.len);
    --         deserialize(ser, r.size);
    --         deserialize(ser, r.burst);
    --         deserialize(ser, r.lock);
    --         deserialize(ser, r.cache);
    --         deserialize(ser, r.prot);
    --         deserialize(ser, r.qos);
    --         return r;
    -- end function deserialize;

end NIC_pkg;