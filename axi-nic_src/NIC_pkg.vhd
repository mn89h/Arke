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
use work.Arke_pkg.all;

package NIC_pkg is
    
    ---------------
    -- Constants --
    ---------------


    constant ZERO : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');

    constant STD_FIFO_DATA_WIDTH    : integer := 16;
    constant STD_FIFO_FIFO_DEPTH    : integer := 8;

    type STD_FIFO_TYPE is (WrRqA, WrRqD, RdRqA, WrRsp, RdRsp);

    -- Optional TODO: partially constrained axi types using VHDL-2008:
    -- https://www.doulos.com/knowhow/vhdl_designers_guide/vhdl_2008/vhdl_200x_small/#composite
    -- https://forums.xilinx.com/t5/Simulation-and-Verification/generic-package-support-in-Vivado/td-p/895460 (last posts)
    -- generic packages propably not supported (would maybe be useful for Arke_pkg dimensions and helper functions depending on dims)
    constant AXI4_FULL_DATA_WIDTH   : integer := 128;
    constant AXI4_FULL_ADDR_WIDTH   : integer := 32;
    constant AXI4_LITE_DATA_WIDTH   : integer := 8;
    constant AXI4_LITE_ADDR_WIDTH   : integer := 8;



    --------------------
    -- AXI4Full Types --
    --------------------

    type AXI4_Full_Wr_RqA is record
        id      : std_logic_vector( AXI4_FULL_ADDR_WIDTH + 11 + 20 downto AXI4_FULL_ADDR_WIDTH + 20 );
        addr    : std_logic_vector( AXI4_FULL_ADDR_WIDTH - 1 + 20 downto 20 );
        len     : std_logic_vector( 19 downto 16 );
        size    : std_logic_vector( 15 downto 13 );
        burst   : std_logic_vector( 12 downto 11 );
        lock    : std_logic_vector( 10 downto 9 );
        cache   : std_logic_vector(  8 downto 6 );
        prot    : std_logic_vector(  5 downto 3 );
        qos     : std_logic_vector(  2 downto 0 );
    end record;
    constant AXI4_Full_Wr_RqA_WIDTH : integer := AXI4_FULL_ADDR_WIDTH + 32;
    function serialize_A4F_Wr_RqA(dIn : AXI4_Full_Wr_RqA) return std_logic_vector;
    function deserialize_A4F_Wr_RqA(dIn : std_logic_vector(AXI4_Full_Wr_RqA_WIDTH - 1 downto 0)) return AXI4_Full_Wr_RqA;

    type AXI4_Full_Wr_RqD is record
        id      : std_logic_vector( AXI4_FULL_DATA_WIDTH + 11 + 5 downto AXI4_FULL_DATA_WIDTH + 5 );
        data    : std_logic_vector( AXI4_FULL_DATA_WIDTH - 1 + 5 downto 5 );
        strb    : std_logic_vector(  4 downto 1 );
        last    : std_logic_vector(  0 downto 0 );
    end record;
    constant AXI4_Full_Wr_RqD_WIDTH : integer := AXI4_FULL_DATA_WIDTH + 17;
    function serialize_A4F_Wr_RqD(dIn : AXI4_Full_Wr_RqD) return std_logic_vector;
    function deserialize_A4F_Wr_RqD(dIn : std_logic_vector(AXI4_Full_Wr_RqD_WIDTH - 1 downto 0)) return AXI4_Full_Wr_RqD;
    
    type AXI4_Full_Wr_Rsp is record
        id      : std_logic_vector( 13 downto 2 );
        resp    : std_logic_vector(  1 downto 0 );
    end record;
    constant AXI4_Full_Wr_Rsp_WIDTH : integer := 14;
    function serialize_A4F_Wr_Rsp(dIn : AXI4_Full_Wr_Rsp) return std_logic_vector;
    function deserialize_A4F_Wr_Rsp(dIn : std_logic_vector(AXI4_Full_Wr_Rsp_WIDTH - 1 downto 0)) return AXI4_Full_Wr_Rsp;

    type AXI4_Full_Rd_RqA is record
        id      : std_logic_vector( AXI4_FULL_ADDR_WIDTH + 11 + 20 downto AXI4_FULL_ADDR_WIDTH + 20 );
        addr    : std_logic_vector( AXI4_FULL_ADDR_WIDTH - 1 + 20 downto 20 );
        len     : std_logic_vector( 19 downto 16 );
        size    : std_logic_vector( 15 downto 13 );
        burst   : std_logic_vector( 12 downto 11 );
        lock    : std_logic_vector( 10 downto 9 );
        cache   : std_logic_vector(  8 downto 6 );
        prot    : std_logic_vector(  5 downto 3 );
        qos     : std_logic_vector(  2 downto 0 );
    end record;
    constant AXI4_Full_Rd_RqA_WIDTH : integer := AXI4_FULL_ADDR_WIDTH + 32;
    function serialize_A4F_Rd_RqA(dIn : AXI4_Full_Rd_RqA) return std_logic_vector;
    function deserialize_A4F_Rd_RqA(dIn : std_logic_vector(AXI4_Full_Rd_RqA_WIDTH - 1 downto 0)) return AXI4_Full_Rd_RqA;

    type AXI4_Full_Rd_Rsp is record
        id      : std_logic_vector( AXI4_FULL_DATA_WIDTH + 11 + 3 downto AXI4_FULL_DATA_WIDTH + 3 );
        data    : std_logic_vector( AXI4_FULL_DATA_WIDTH - 1 + 3 downto 3 );
        resp    : std_logic_vector(  2 downto 1 );
        last    : std_logic_vector(  0 downto 0 );
    end record;
    constant AXI4_Full_Rd_Rsp_WIDTH : integer := AXI4_FULL_DATA_WIDTH + 15;
    function serialize_A4F_Rd_Rsp(dIn : AXI4_Full_Rd_Rsp) return std_logic_vector;
    function deserialize_A4F_Rd_Rsp(dIn : std_logic_vector(AXI4_Full_Rd_Rsp_WIDTH - 1 downto 0)) return AXI4_Full_Rd_Rsp;
    
    
    --------------------
    -- AXI4Lite Types --
    --------------------

    type AXI4_Lite_Wr_RqA is record
        addr    : std_logic_vector( AXI4_LITE_ADDR_WIDTH - 1 + 3 downto 3 );
        prot    : std_logic_vector(  2 downto 0 );
    end record;
    constant AXI4_Lite_Wr_RqA_WIDTH : integer := AXI4_LITE_ADDR_WIDTH + 3;
    function serialize_A4L_Wr_RqA(dIn : AXI4_Lite_Wr_RqA) return std_logic_vector;
    function deserialize_A4L_Wr_RqA(dIn : std_logic_vector(AXI4_Lite_Wr_RqA_WIDTH - 1 downto 0)) return AXI4_Lite_Wr_RqA;

    type AXI4_Lite_Wr_RqD is record
        data    : std_logic_vector( AXI4_LITE_DATA_WIDTH - 1 + 4 downto 4 );
        strb    : std_logic_vector(  3 downto 0 );
    end record;
    constant AXI4_Lite_Wr_RqD_WIDTH : integer := AXI4_LITE_DATA_WIDTH + 4;
    function serialize_A4L_Wr_RqD(dIn : AXI4_Lite_Wr_RqD) return std_logic_vector;
    function deserialize_A4L_Wr_RqD(dIn : std_logic_vector(AXI4_Lite_Wr_RqD_WIDTH - 1 downto 0)) return AXI4_Lite_Wr_RqD;

    type AXI4_Lite_Wr_Rsp is record
        resp    : std_logic_vector(  1 downto 0 );
    end record;
    constant AXI4_Lite_Wr_Rsp_WIDTH : integer := 2;
    function serialize_A4L_Wr_Rsp(dIn : AXI4_Lite_Wr_Rsp) return std_logic_vector;
    function deserialize_A4L_Wr_Rsp(dIn : std_logic_vector(AXI4_Lite_Wr_Rsp_WIDTH - 1 downto 0)) return AXI4_Lite_Wr_Rsp;

    type AXI4_Lite_Rd_RqA is record
        addr    : std_logic_vector( AXI4_LITE_ADDR_WIDTH - 1 + 3 downto 3 );
        prot    : std_logic_vector(  2 downto 0 );
    end record;
    constant AXI4_Lite_Rd_RqA_WIDTH : integer := AXI4_LITE_ADDR_WIDTH + 3;
    function serialize_A4L_Rd_RqA(dIn : AXI4_Lite_Rd_RqA) return std_logic_vector;
    function deserialize_A4L_Rd_RqA(dIn : std_logic_vector(AXI4_Lite_Rd_RqA_WIDTH - 1 downto 0)) return AXI4_Lite_Rd_RqA;

    type AXI4_Lite_Rd_Rsp is record
        data    : std_logic_vector( AXI4_LITE_DATA_WIDTH - 1 + 2 downto 2 );
        resp    : std_logic_vector(  1 downto 0 );
    end record;
    constant AXI4_Lite_Rd_Rsp_WIDTH : integer := AXI4_LITE_DATA_WIDTH + 2;
    function serialize_A4L_Rd_Rsp(dIn : AXI4_Lite_Rd_Rsp) return std_logic_vector;
    function deserialize_A4L_Rd_Rsp(dIn : std_logic_vector(AXI4_Lite_Rd_Rsp_WIDTH - 1 downto 0)) return AXI4_Lite_Rd_Rsp;

    





    component STD_FIFO is
        Generic (
            -- fifo_width  : positive := FIFO_WIDTH;
            data_width  : positive := AXI4_Full_Wr_RqA_WIDTH; -- VHDL-2008+ / Vivado 2019.1+ - replaces vectors w/ fifo_width generic and (de-)serialize functions
            fifo_depth	: positive
        );
        Port ( 
            clk			: in  std_logic;
            rst			: in  std_logic;
            WrValid_in	: in  std_logic;
            WrReady_out	: out std_logic;
            WrData_in	: in  std_logic_vector(data_width - 1 downto 0);
            RdReady_in	: in  std_logic;
            RdData_out  : out std_logic_vector(data_width - 1 downto 0);
            RdValid_out	: out std_logic 
        );
    end component;

    component STD_FIFO_WrRqA is
        Generic (
            fifo_depth	: positive
        );
        Port ( 
            clk		: in  std_logic;
            rst		: in  std_logic;
            WriteEn	: in  std_logic;
            DataIn	: in  AXI4_Full_Wr_RqA;
            ReadEn	: in  std_logic;
            DataOut	: out AXI4_Full_Wr_RqA;
            Empty	: out std_logic;
            Full	: out std_logic
        );
    end component;

    component STD_FIFO_WrRqD is
        Generic (
            fifo_depth	: positive
        );
        Port ( 
            clk		: in  std_logic;
            rst		: in  std_logic;
            WriteEn	: in  std_logic;
            DataIn	: in  AXI4_Full_Wr_RqD;
            ReadEn	: in  std_logic;
            DataOut	: out AXI4_Full_Wr_RqD;
            Empty	: out std_logic;
            Full	: out std_logic
        );
    end component;

    component STD_FIFO_RdRqA is
        Generic (
            fifo_depth	: positive
        );
        Port ( 
            clk		: in  std_logic;
            rst		: in  std_logic;
            WriteEn	: in  std_logic;
            DataIn	: in  AXI4_Full_Rd_RqA;
            ReadEn	: in  std_logic;
            DataOut	: out AXI4_Full_Rd_RqA;
            Empty	: out std_logic;
            Full	: out std_logic
        );
    end component;

    component STD_FIFO_RdRsp is
        Generic (
            fifo_depth	: positive
        );
        Port ( 
            clk		: in  std_logic;
            rst		: in  std_logic;
            WriteEn	: in  std_logic;
            DataIn	: in  AXI4_Full_Rd_Rsp;
            ReadEn	: in  std_logic;
            DataOut	: out AXI4_Full_Rd_Rsp;
            Empty	: out std_logic;
            Full	: out std_logic
        );
    end component;

    component STD_FIFO_WrRsp is
        Generic (
            fifo_depth	: positive
        );
        Port ( 
            clk		: in  std_logic;
            rst		: in  std_logic;
            WriteEn	: in  std_logic;
            DataIn	: in  AXI4_Full_Wr_Rsp;
            ReadEn	: in  std_logic;
            DataOut	: out AXI4_Full_Wr_Rsp;
            Empty	: out std_logic;
            Full	: out std_logic
        );
    end component;

    component AXI4_Full_Slave is
        Port (
            clk         : in std_logic;
            rst         : in std_logic; 

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
    end component;
    
    component AXI4_Lite_Slave is
        Port (
            clk         : in std_logic;
            rst         : in std_logic; 

            AXI_arvalid     : in  std_logic;
            AXI_arready     : out std_logic;
            AXI_rdrqA_data  : in  AXI4_Lite_Rd_RqA;

            AXI_awvalid     : in  std_logic;
            AXI_awready     : out std_logic;
            AXI_wrrqA_data  : in  AXI4_Lite_Wr_RqA;

            AXI_wvalid      : in  std_logic;
            AXI_wready      : out std_logic;
            AXI_wrrqD_data  : in  AXI4_Lite_Wr_RqD;

            AXI_rready      : in  std_logic;
            AXI_rvalid      : out std_logic;
            AXI_rdrsp_data  : out AXI4_Lite_Rd_Rsp;

            AXI_bready      : in  std_logic;
            AXI_bvalid      : out std_logic;
            AXI_wrrsp_data  : out AXI4_Lite_Wr_Rsp;

            rdrqA_get_valid : out std_logic;
            rdrqA_get_en    : in  std_logic;
            rdrqA_get_data  : out AXI4_Lite_Rd_RqA;

            wrrqA_get_valid : out std_logic;
            wrrqA_get_en    : in  std_logic;
            wrrqA_get_data  : out AXI4_Lite_Wr_RqA;

            wrrqD_get_valid : out std_logic;
            wrrqD_get_en    : in  std_logic;
            wrrqD_get_data  : out AXI4_Lite_Wr_RqD;

            rdrsp_put_ready : out std_logic;
            rdrsp_put_en    : in  std_logic;
            rdrsp_put_data  : in  AXI4_Lite_Rd_Rsp;

            wrrsp_put_ready : out std_logic;
            wrrsp_put_en    : in  std_logic;
            wrrsp_put_data  : in  AXI4_Lite_Wr_Rsp
        );
    end component;

end package NIC_pkg;

package body NIC_pkg is


    --------------------------------
    ------ AXI4Full functions ------
    --------------------------------

    function serialize_A4F_Wr_RqA(
        dIn : AXI4_Full_Wr_RqA
        ) return std_logic_vector is
        variable dOut: std_logic_vector(AXI4_Full_Wr_RqA_WIDTH - 1 downto 0);
    begin
        dOut                    := (others => '0');
        dOut(dIn.id'range)      := dIn.id;
        dOut(dIn.addr'range)    := dIn.addr;
        dOut(dIn.len'range)     := dIn.len;
        dOut(dIn.size'range)    := dIn.size;
        dOut(dIn.burst'range)   := dIn.burst;
        dOut(dIn.lock'range)    := dIn.lock;
        dOut(dIn.cache'range)   := dIn.cache;
        dOut(dIn.prot'range)    := dIn.prot;
        dOut(dIn.qos'range)     := dIn.qos;
        return(dOut);
    end function serialize_A4F_Wr_RqA;

    function deserialize_A4F_Wr_RqA(
        dIn : std_logic_vector(AXI4_Full_Wr_RqA_WIDTH - 1 downto 0)
        ) return AXI4_Full_Wr_RqA is
        variable dOut: AXI4_Full_Wr_RqA;
        variable dIn_tmp: std_logic_vector(AXI4_Full_Wr_RqA_WIDTH - 1 downto 0);
    begin
        dIn_tmp     := dIn;    
        dOut.id     := dIn_tmp(dOut.id'range);
        dOut.addr   := dIn_tmp(dOut.addr'range);
        dOut.len    := dIn_tmp(dOut.len'range);
        dOut.size   := dIn_tmp(dOut.size'range);
        dOut.burst  := dIn_tmp(dOut.burst'range);
        dOut.lock   := dIn_tmp(dOut.lock'range);
        dOut.cache  := dIn_tmp(dOut.cache'range);
        dOut.prot   := dIn_tmp(dOut.prot'range);
        dOut.qos    := dIn_tmp(dOut.qos'range);
        return(dOut);
    end function deserialize_A4F_Wr_RqA;

    function serialize_A4F_Wr_RqD(
        dIn : AXI4_Full_Wr_RqD
        ) return std_logic_vector is
        variable dOut: std_logic_vector(AXI4_Full_Wr_RqD_WIDTH - 1 downto 0);
    begin
        dOut                    := (others => '0');
        dOut(dIn.id'range)      := dIn.id;
        dOut(dIn.data'range)    := dIn.data;
        dOut(dIn.strb'range)    := dIn.strb;
        dOut(dIn.last'range)    := dIn.last;
        return(dOut);
    end function serialize_A4F_Wr_RqD;

    function deserialize_A4F_Wr_RqD(
        dIn : std_logic_vector(AXI4_Full_Wr_RqD_WIDTH - 1 downto 0)
        ) return AXI4_Full_Wr_RqD is
        variable dOut: AXI4_Full_Wr_RqD;
        variable dIn_tmp: std_logic_vector(AXI4_Full_Wr_RqD_WIDTH - 1 downto 0);
    begin
        dIn_tmp     := dIn;    
        dOut.id     := dIn_tmp(dOut.id'range);
        dOut.data   := dIn_tmp(dOut.data'range);
        dOut.strb   := dIn_tmp(dOut.strb'range);
        dOut.last   := dIn_tmp(dOut.last'range);
        return(dOut);
    end function deserialize_A4F_Wr_RqD;

    function serialize_A4F_Wr_Rsp(
        dIn : AXI4_Full_Wr_Rsp
        ) return std_logic_vector is
        variable dOut: std_logic_vector(AXI4_Full_Wr_Rsp_WIDTH - 1 downto 0);
    begin
        dOut                    := (others => '0');
        dOut(dIn.id'range)      := dIn.id;
        dOut(dIn.resp'range)    := dIn.resp;
        return(dOut);
    end function serialize_A4F_Wr_Rsp;

    function deserialize_A4F_Wr_Rsp(
        dIn : std_logic_vector(AXI4_Full_Wr_Rsp_WIDTH - 1 downto 0)
        ) return AXI4_Full_Wr_Rsp is
        variable dOut: AXI4_Full_Wr_Rsp;
        variable dIn_tmp: std_logic_vector(AXI4_Full_Wr_Rsp_WIDTH - 1 downto 0);
    begin
        dIn_tmp     := dIn;    
        dOut.id     := dIn_tmp(dOut.id'range);
        dOut.resp   := dIn_tmp(dOut.resp'range);
        return(dOut);
    end function deserialize_A4F_Wr_Rsp;

    function serialize_A4F_Rd_RqA(
        dIn : AXI4_Full_Rd_RqA
        ) return std_logic_vector is
        variable dOut: std_logic_vector(AXI4_Full_Rd_RqA_WIDTH - 1 downto 0);
    begin
        dOut                    := (others => '0');
        dOut(dIn.id'range)      := dIn.id;
        dOut(dIn.addr'range)    := dIn.addr;
        dOut(dIn.len'range)     := dIn.len;
        dOut(dIn.size'range)    := dIn.size;
        dOut(dIn.burst'range)   := dIn.burst;
        dOut(dIn.lock'range)    := dIn.lock;
        dOut(dIn.cache'range)   := dIn.cache;
        dOut(dIn.prot'range)    := dIn.prot;
        dOut(dIn.qos'range)     := dIn.qos;
        return(dOut);
    end function serialize_A4F_Rd_RqA;

    function deserialize_A4F_Rd_RqA(
        dIn : std_logic_vector(AXI4_Full_Rd_RqA_WIDTH - 1 downto 0)
        ) return AXI4_Full_Rd_RqA is
        variable dOut: AXI4_Full_Rd_RqA;
        variable dIn_tmp: std_logic_vector(AXI4_Full_Rd_RqA_WIDTH - 1 downto 0);
    begin
        dIn_tmp     := dIn;    
        dOut.id     := dIn_tmp(dOut.id'range);
        dOut.addr   := dIn_tmp(dOut.addr'range);
        dOut.len    := dIn_tmp(dOut.len'range);
        dOut.size   := dIn_tmp(dOut.size'range);
        dOut.burst  := dIn_tmp(dOut.burst'range);
        dOut.lock   := dIn_tmp(dOut.lock'range);
        dOut.cache  := dIn_tmp(dOut.cache'range);
        dOut.prot   := dIn_tmp(dOut.prot'range);
        dOut.qos    := dIn_tmp(dOut.qos'range);
        return(dOut);
    end function deserialize_A4F_Rd_RqA;

    function serialize_A4F_Rd_Rsp(
        dIn : AXI4_Full_Rd_Rsp
        ) return std_logic_vector is
        variable dOut: std_logic_vector(AXI4_Full_Rd_Rsp_WIDTH - 1 downto 0);
    begin
        dOut                    := (others => '0');
        dOut(dIn.id'range)      := dIn.id;
        dOut(dIn.data'range)    := dIn.data;
        dOut(dIn.resp'range)    := dIn.resp;
        dOut(dIn.last'range)    := dIn.last;
        return(dOut);
    end function serialize_A4F_Rd_Rsp;

    function deserialize_A4F_Rd_Rsp(
        dIn : std_logic_vector(AXI4_Full_Rd_Rsp_WIDTH - 1 downto 0)
        ) return AXI4_Full_Rd_Rsp is
        variable dOut: AXI4_Full_Rd_Rsp;
        variable dIn_tmp: std_logic_vector(AXI4_Full_Rd_Rsp_WIDTH - 1 downto 0);
    begin
        dIn_tmp     := dIn;    
        dOut.id     := dIn_tmp(dOut.id'range);
        dOut.data   := dIn_tmp(dOut.data'range);
        dOut.resp   := dIn_tmp(dOut.resp'range);
        dOut.last   := dIn_tmp(dOut.last'range);
        return(dOut);
    end function deserialize_A4F_Rd_Rsp;


    --------------------------------
    ------ AXI4Lite Functions ------
    --------------------------------

    function serialize_A4L_Wr_RqA(
        dIn : AXI4_Lite_Wr_RqA
        ) return std_logic_vector is
        variable dOut: std_logic_vector(AXI4_Lite_Wr_RqA_WIDTH - 1 downto 0);
    begin
        dOut                    := (others => '0');
        dOut(dIn.addr'range)    := dIn.addr;
        dOut(dIn.prot'range)    := dIn.prot;
        return(dOut);
    end function serialize_A4L_Wr_RqA;

    function deserialize_A4L_Wr_RqA(
        dIn : std_logic_vector(AXI4_Lite_Wr_RqA_WIDTH - 1 downto 0)
        ) return AXI4_Lite_Wr_RqA is
        variable dOut: AXI4_Lite_Wr_RqA;
        variable dIn_tmp: std_logic_vector(AXI4_Lite_Wr_RqA_WIDTH - 1 downto 0);
    begin
        dIn_tmp     := dIn;
        dOut.addr   := dIn_tmp(dOut.addr'range);
        dOut.prot   := dIn_tmp(dOut.prot'range);
        return(dOut);
    end function deserialize_A4L_Wr_RqA;

    function serialize_A4L_Wr_RqD(
        dIn : AXI4_Lite_Wr_RqD
        ) return std_logic_vector is
        variable dOut: std_logic_vector(AXI4_Lite_Wr_RqD_WIDTH - 1 downto 0);
    begin
        dOut                    := (others => '0');
        dOut(dIn.data'range)    := dIn.data;
        dOut(dIn.strb'range)    := dIn.strb;
        return(dOut);
    end function serialize_A4L_Wr_RqD;

    function deserialize_A4L_Wr_RqD(
        dIn : std_logic_vector(AXI4_Lite_Wr_RqD_WIDTH - 1 downto 0)
        ) return AXI4_Lite_Wr_RqD is
        variable dOut: AXI4_Lite_Wr_RqD;
        variable dIn_tmp: std_logic_vector(AXI4_Lite_Wr_RqD_WIDTH - 1 downto 0);
    begin
        dIn_tmp     := dIn;
        dOut.data   := dIn_tmp(dOut.data'range);
        dOut.strb   := dIn_tmp(dOut.strb'range);
        return(dOut);
    end function deserialize_A4L_Wr_RqD;

    function serialize_A4L_Wr_Rsp(
        dIn : AXI4_Lite_Wr_Rsp
        ) return std_logic_vector is
        variable dOut: std_logic_vector(AXI4_Lite_Wr_Rsp_WIDTH - 1 downto 0);
    begin
        dOut                    := (others => '0');
        dOut(dIn.resp'range)    := dIn.resp;
        return(dOut);
    end function serialize_A4L_Wr_Rsp;

    function deserialize_A4L_Wr_Rsp(
        dIn : std_logic_vector(AXI4_Lite_Wr_Rsp_WIDTH - 1 downto 0)
        ) return AXI4_Lite_Wr_Rsp is
        variable dOut: AXI4_Lite_Wr_Rsp;
        variable dIn_tmp: std_logic_vector(AXI4_Lite_Wr_Rsp_WIDTH - 1 downto 0);
    begin
        dIn_tmp     := dIn;
        dOut.resp   := dIn_tmp(dOut.resp'range);
        return(dOut);
    end function deserialize_A4L_Wr_Rsp;

    function serialize_A4L_Rd_RqA(
        dIn : AXI4_Lite_Rd_RqA
        ) return std_logic_vector is
        variable dOut: std_logic_vector(AXI4_Lite_Rd_RqA_WIDTH - 1 downto 0);
    begin
        dOut                    := (others => '0');
        dOut(dIn.addr'range)    := dIn.addr;
        dOut(dIn.prot'range)    := dIn.prot;
        return(dOut);
    end function serialize_A4L_Rd_RqA;

    function deserialize_A4L_Rd_RqA(
        dIn : std_logic_vector(AXI4_Lite_Rd_RqA_WIDTH - 1 downto 0)
        ) return AXI4_Lite_Rd_RqA is
        variable dOut: AXI4_Lite_Rd_RqA;
        variable dIn_tmp: std_logic_vector(AXI4_Lite_Rd_RqA_WIDTH - 1 downto 0);
    begin
        dIn_tmp     := dIn;
        dOut.addr   := dIn_tmp(dOut.addr'range);
        dOut.prot   := dIn_tmp(dOut.prot'range);
        return(dOut);
    end function deserialize_A4L_Rd_RqA;

    function serialize_A4L_Rd_Rsp(
        dIn : AXI4_Lite_Rd_Rsp
        ) return std_logic_vector is
        variable dOut: std_logic_vector(AXI4_Lite_Rd_Rsp_WIDTH - 1 downto 0);
    begin
        dOut                    := (others => '0');
        dOut(dIn.data'range)    := dIn.data;
        dOut(dIn.resp'range)    := dIn.resp;
        return(dOut);
    end function serialize_A4L_Rd_Rsp;

    function deserialize_A4L_Rd_Rsp(
        dIn : std_logic_vector(AXI4_Lite_Rd_Rsp_WIDTH - 1 downto 0)
        ) return AXI4_Lite_Rd_Rsp is
        variable dOut: AXI4_Lite_Rd_Rsp;
        variable dIn_tmp: std_logic_vector(AXI4_Lite_Rd_Rsp_WIDTH - 1 downto 0);
    begin
        dIn_tmp     := dIn;
        dOut.data   := dIn_tmp(dOut.data'range);
        dOut.resp   := dIn_tmp(dOut.resp'range);
        return(dOut);
    end function deserialize_A4L_Rd_Rsp;


end package body NIC_pkg;