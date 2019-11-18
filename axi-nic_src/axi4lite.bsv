package AXI4Lite;


// Uses package Bus::*
// Interfaces BusSender and BusReceiver carry the bus and additionally a fifo for access
// Interface BusSend/BusRecv carry data (V/A), valid (V/A) and ready (A/V) 
//  (last two realized by fifof methods) methods for communication
// to ensure no_implicit_conditions and execution on every clock is possible, they contain dfifof and bypasswire 
import Bus::*;
import ClientServer::*;
import Connectable::*;
import FIFO::*;	
import FIFOF::*;	
import GetPut::*;

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////READ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

typedef struct {  //READ - Rq
  Bit#(3)  prot;
  Bit#(32) addr;
} AXI4_Lite_Rq_Rd deriving (Bits, Eq);
AXI4_Lite_Rq_Rd defRqRd = AXI4_Lite_Rq_Rd{prot:'0,addr:'0}; 

typedef struct {  //READ - Rsp
  Bit#(2)  resp;
  Bit#(64) data;
} AXI4_Lite_Rsp_Rd deriving (Bits, Eq);
AXI4_Lite_Rsp_Rd defRspRd = AXI4_Lite_Rsp_Rd{resp:'0,data:'0}; 


(* always_ready *)                 
interface AXI4_Lite_Master_Rd_Fab;  //READ - MasterFab
  (* prefix="", result="M_AXI_ARVALID" *)   method Bit#(1)  mARVALID;
  (* prefix="", enable="M_AXI_ARREADY" *)   method Action   sARREADY;
  (* prefix="", result="M_AXI_ARADDR"  *)   method Bit#(32) mARADDR;
  (* prefix="", result="M_AXI_ARPROT"  *)   method Bit#(3)  mARPROT;

  (* prefix="", enable="M_AXI_RVALID"  *)   method Action   sRVALID;
  (* prefix="", result="M_AXI_RREADY"  *)   method Bit#(1)  mRREADY;
  (* prefix="", always_enabled         *)   method Action   sRDATA  ((* port="M_AXI_RDATA" *) Bit#(64) rdata_in);
  (* prefix="", always_enabled         *)   method Action   sRRESP  ((* port="M_AXI_RRESP" *) Bit#(2)  rresp_in);
endinterface

(* always_ready *)                 
interface AXI4_Lite_Slave_Rd_Fab;   //READ - SlaveFab
  (* prefix="", enable="S_AXI_ARVALID" *)   method Action   mARVALID;
  (* prefix="", result="S_AXI_ARREADY" *)   method Bit#(1)  sARREADY;
  (* prefix="", always_enabled         *)   method Action   mARADDR ((* port="S_AXI_ARADDR" *) Bit#(32) araddr_in);
  (* prefix="", always_enabled         *)   method Action   mARPROT ((* port="S_AXI_ARPROT" *) Bit#(3)  arprot_in);

  (* prefix="", result="S_AXI_RVALID"  *)   method Bit#(1)  sRVALID;
  (* prefix="", enable="S_AXI_RREADY"  *)   method Action   mRREADY;
  (* prefix="", result="S_AXI_RDATA"   *)   method Bit#(64) sRDATA;
  (* prefix="", result="S_AXI_RRESP"   *)   method Bit#(2)  sRRESP;
endinterface


interface AXI4_Lite_Master_Rd;  //READ - MasterIfc
  interface AXI4_Lite_Master_Rd_Fab                     fab;
  interface Server#(AXI4_Lite_Rq_Rd, AXI4_Lite_Rsp_Rd)  bus;
endinterface

interface AXI4_Lite_Slave_Rd;   //READ - SlaveIfc
  interface AXI4_Lite_Slave_Rd_Fab                      fab;
  interface Client#(AXI4_Lite_Rq_Rd, AXI4_Lite_Rsp_Rd)  bus;
endinterface


module mkAXI4_Lite_Master_Rd (AXI4_Lite_Master_Rd); //READ - mkMasterIfc
  BusSender#  (AXI4_Lite_Rq_Rd)     a4rdReq       <- mkBusSender(defRqRd);
  BusReceiver#(AXI4_Lite_Rsp_Rd)    a4rdRsp       <- mkBusReceiver;
  Wire#(Bool)                       rdAddrRdy_w   <- mkDWire(False);
  Wire#(Bool)                       rdRespVal_w   <- mkDWire(False);
  Wire#(Bit#(64))                   rdData_w      <- mkDWire(0);
  Wire#(Bit#(2))                    rdResp_w      <- mkDWire(0);

  (* no_implicit_conditions, fire_when_enabled *) //ensure execution on every clock
  rule doAlways (True);
    a4rdReq.out.ready (rdAddrRdy_w); //deq on senders fifof only when receiver is ready
    a4rdRsp.in.valid  (rdRespVal_w); //enq of data in bypasswire on receivers fifof only when data is valid
    a4rdRsp.in.data   (AXI4_Lite_Rsp_Rd{  data:rdData_w, resp:rdResp_w  }); //data to receivers bypasswire
  endrule

  interface AXI4_Lite_Master_Rd_Fab fab;
    method Bit#(1)  mARVALID = pack(a4rdReq.out.valid);
    method Action   sARREADY = rdAddrRdy_w._write(True);
    method Bit#(32) mARADDR  = pack(a4rdReq.out.data.addr);
    method Bit#(3)  mARPROT  = pack(a4rdReq.out.data.prot);   

    method Action   sRVALID  = rdRespVal_w._write(True);
    method Bit#(1)  mRREADY  = pack(a4rdRsp.in.ready);
    method Action   sRDATA   (Bit#(64) rdata_in) = rdData_w._write(rdata_in);
    method Action   sRRESP   (Bit#(2)  rresp_in) = rdResp_w._write(rresp_in);
  endinterface

  interface Server bus;
    interface Put request   = toPut(a4rdReq.in);
    interface Get response  = toGet(a4rdRsp.out);
  endinterface
endmodule

module mkAXI4_Lite_Slave_Rd (AXI4_Lite_Slave_Rd); //READ - mkSlaveIfc
  BusReceiver#(AXI4_Lite_Rq_Rd)     a4rdReq      <- mkBusReceiver;
  BusSender#  (AXI4_Lite_Rsp_Rd)    a4rdRsp      <- mkBusSender(defRspRd);
  Wire#(Bool)                       rdAddrVal_w  <- mkDWire(False);
  Wire#(Bool)                       rdRespRdy_w  <- mkDWire(False);
  Wire#(Bit#(32))                   rdAddr_w     <- mkDWire(0);
  Wire#(Bit#(3))                    rdProt_w     <- mkDWire(0);

  (* no_implicit_conditions, fire_when_enabled *) 
  rule doAlways (True);
    a4rdReq.in.valid  (rdAddrVal_w);
    a4rdReq.in.data   (AXI4_Lite_Rq_Rd{  addr:rdAddr_w, prot:unpack(rdProt_w)  });
    a4rdRsp.out.ready (rdRespRdy_w);
  endrule

  interface AXI4_Lite_Slave_Rd_Fab fab;
    method Action   mARVALID = rdAddrVal_w._write(True);
    method Bit#(1)  sARREADY = pack(a4rdReq.in.ready);
    method Action   mARADDR  (Bit#(32) araddr_in) = rdAddr_w._write(araddr_in);
    method Action   mARPROT  (Bit#(3)  arprot_in) = rdProt_w._write(arprot_in);

    method Bit#(1)  sRVALID  = pack(a4rdRsp.out.valid);
    method Action   mRREADY  = rdRespRdy_w._write(True);
    method Bit#(64) sRDATA   = pack(a4rdRsp.out.data.data);
    method Bit#(2)  sRRESP   = pack(a4rdRsp.out.data.resp);
  endinterface

  interface Client bus;
    interface Get request   = toGet(a4rdReq.out);
    interface Put response  = toPut(a4rdRsp.in);
  endinterface
endmodule

instance Connectable#(AXI4_Lite_Master_Rd_Fab, AXI4_Lite_Slave_Rd_Fab); //READ - Connectable
  module mkConnection#(AXI4_Lite_Master_Rd_Fab m, AXI4_Lite_Slave_Rd_Fab s) (Empty);
    (* no_implicit_conditions, fire_when_enabled *) 
    rule connectRdFab (True);
      if (unpack(m.mARVALID)) s.mARVALID;
      if (unpack(s.sARREADY)) m.sARREADY;
      s.mARADDR(m.mARADDR);
      s.mARPROT(m.mARPROT);
      if (unpack(s.sRVALID)) m.sRVALID;
      if (unpack(m.mRREADY)) s.mRREADY;
      m.sRDATA(s.sRDATA);
      m.sRRESP(s.sRRESP);
    endrule
  endmodule
endinstance


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////WRITE//////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


typedef struct {  //WRITE - Rq
  Bit#(3)  prot;
  Bit#(32) addr;
  Bit#(4)  strb;
  Bit#(32) data;
} AXI4_Lite_Rq_Wr deriving (Bits, Eq);

typedef struct {
  Bit#(3)  prot;
  Bit#(32) addr;
} AXI4_Lite_RqA_Wr deriving (Bits, Eq);
AXI4_Lite_RqA_Wr defRqWrA = AXI4_Lite_RqA_Wr{prot:'0,addr:'0}; 

typedef struct {
  Bit#(4)  strb;
  Bit#(64) data;
} AXI4_Lite_RqD_Wr deriving (Bits, Eq);
AXI4_Lite_RqD_Wr defRqWrD = AXI4_Lite_RqD_Wr{strb:'0,data:'0}; 

typedef struct {  //WRITE - Rsp
  Bit#(2)  resp;
} AXI4_Lite_Rsp_Wr deriving (Bits, Eq);
AXI4_Lite_Rsp_Wr defRspWr = AXI4_Lite_Rsp_Wr{resp:'0}; 

(* always_ready *)                 
interface AXI4_Lite_Master_Wr_Fab;  //WRITE - Master Fab
  (* prefix="", result="M_AXI_AWVALID" *)   method Bit#(1)  mAWVALID;
  (* prefix="", enable="M_AXI_AWREADY" *)   method Action   sAWREADY;
  (* prefix="", result="M_AXI_AWADDR"  *)   method Bit#(32) mAWADDR;
  (* prefix="", result="M_AXI_AWPROT"  *)   method Bit#(3)  mAWPROT;
  
  (* prefix="", result="M_AXI_WVALID"  *)   method Bit#(1)  mWVALID;
  (* prefix="", enable="M_AXI_WREADY"  *)   method Action   sWREADY;
  (* prefix="", result="M_AXI_WDATA"   *)   method Bit#(64) mWDATA;
  (* prefix="", result="M_AXI_WSTRB"   *)   method Bit#(4)  mWSTRB;
  
  (* prefix="", enable="M_AXI_BVALID"  *)   method Action   sBVALID;
  (* prefix="", result="M_AXI_BREADY"  *)   method Bit#(1)  mBREADY;
  (* prefix="", always_enabled         *)   method Action   sBRESP  ((* port="M_AXI_BRESP" *) Bit#(2)  wresp_in);
endinterface

(* always_ready *)                 
interface AXI4_Lite_Slave_Wr_Fab; //WRITE - Slave Fab
  (* prefix="", enable="S_AXI_AWVALID" *)   method Action   mAWVALID;
  (* prefix="", result="S_AXI_AWREADY" *)   method Bit#(1)  sAWREADY;
  (* prefix="", always_enabled         *)   method Action   mAWADDR ((* port="S_AXI_AWADDR" *) Bit#(32) awaddr_in);
  (* prefix="", always_enabled         *)   method Action   mAWPROT ((* port="S_AXI_AWPROT" *) Bit#(3)  awprot_in);
  
  (* prefix="", enable="S_AXI_WVALID"  *)   method Action   mWVALID;
  (* prefix="", result="S_AXI_WREADY"  *)   method Bit#(1)  sWREADY;
  (* prefix="", always_enabled         *)   method Action   mWDATA  ((* port="S_AXI_WDATA" *) Bit#(64) wdata_in);
  (* prefix="", always_enabled         *)   method Action   mWSTRB  ((* port="S_AXI_WSTRB" *) Bit#(4)  wstrb_in);
  
  (* prefix="", result="S_AXI_BVALID"  *)   method Bit#(1)  sBVALID;
  (* prefix="", enable="S_AXI_BREADY"  *)   method Action   mBREADY;
  (* prefix="", result="S_AXI_BRESP"   *)   method Bit#(2)  sBRESP;
endinterface


interface AXI4_Lite_Master_Wr;  //WRITE - Master Ifc
  interface AXI4_Lite_Master_Wr_Fab                     fab;
  interface Server#(AXI4_Lite_Rq_Wr, AXI4_Lite_Rsp_Wr)  bus;
endinterface

interface AXI4_Lite_Slave_Wr;   //WRITE - Slave Ifc 
  interface AXI4_Lite_Slave_Wr_Fab                      fab;
  interface Client#(AXI4_Lite_Rq_Wr, AXI4_Lite_Rsp_Wr)  bus;
endinterface

module mkAXI4_Lite_Master_Wr(AXI4_Lite_Master_Wr);  //WRITE - mkMasterIfc
  BusSender#  (AXI4_Lite_RqA_Wr)    a4wrRqA       <- mkBusSender(defRqWrA);
  BusSender#  (AXI4_Lite_RqD_Wr)    a4wrRqD       <- mkBusSender(defRqWrD);
  BusReceiver#(AXI4_Lite_Rsp_Wr)    a4wrRsp       <- mkBusReceiver;
  Wire#(Bool)                       wrAddrRdy_w   <- mkDWire(False);
  Wire#(Bool)                       wrDataRdy_w   <- mkDWire(False);
  Wire#(Bool)                       wrRespVal_w   <- mkDWire(False);
  Wire#(Bit#(2))                    wrResp_w      <- mkDWire(0);

  (* no_implicit_conditions, fire_when_enabled *) 
  rule doAlways (True);
    a4wrRqA.out.ready (wrAddrRdy_w);
    a4wrRqD.out.ready (wrDataRdy_w);
    a4wrRsp.in.valid  (wrRespVal_w);
    a4wrRsp.in.data   (AXI4_Lite_Rsp_Wr{ resp:wrResp_w });
  endrule

  interface AXI4_Lite_Master_Wr_Fab fab;
    method Bit#(1)  mAWVALID = pack(a4wrRqA.out.valid);
    method Action   sAWREADY = wrAddrRdy_w._write(True);
    method Bit#(32) mAWADDR  = a4wrRqA.out.data.addr;
    method Bit#(3)  mAWPROT  = a4wrRqA.out.data.prot;   

    method Bit#(1)  mWVALID  = pack(a4wrRqD.out.valid);
    method Action   sWREADY  = wrDataRdy_w._write(True);
    method Bit#(64) mWDATA   = a4wrRqD.out.data.data;
    method Bit#(4)  mWSTRB   = a4wrRqD.out.data.strb;

    method Action   sBVALID  = wrRespVal_w._write(True);
    method Bit#(1)  mBREADY  = pack(a4wrRsp.in.ready);
    method Action   sBRESP   (Bit#(2)  wresp_in) = wrResp_w._write(wresp_in);
  endinterface

  interface Server bus;
    interface Put request;
      method Action put (AXI4_Lite_Rq_Wr req);
        a4wrRqA.in.enq(AXI4_Lite_RqA_Wr{ addr: req.addr, prot: req.prot });
        a4wrRqD.in.enq(AXI4_Lite_RqD_Wr{ data: req.data, strb: req.strb });
      endmethod
    endinterface
    interface Get response  = toGet(a4wrRsp.out);
  endinterface
endmodule


  module mkAXI4_Lite_Slave_Wr(AXI4_Lite_Slave_Wr);  //WRITE - mkSlaveIfc
  BusReceiver#(AXI4_Lite_RqA_Wr)    a4wrRqA       <- mkBusReceiver;
  BusReceiver#(AXI4_Lite_RqD_Wr)    a4wrRqD       <- mkBusReceiver;
  BusSender#  (AXI4_Lite_Rsp_Wr)    a4wrRsp       <- mkBusSender(defRspWr);
  Wire#(Bool)                       wrAddrVal_w   <- mkDWire(False);
  Wire#(Bool)                       wrDataVal_w   <- mkDWire(False);
  Wire#(Bool)                       wrRespRdy_w   <- mkDWire(False);
  Wire#(Bit#(32))                   wrAddr_w      <- mkDWire(0);
  Wire#(Bit#(3))                    wrProt_w      <- mkDWire(0);
  Wire#(Bit#(64))                   wrData_w      <- mkDWire(0);
  Wire#(Bit#(4))                    wrStrb_w      <- mkDWire(0);

  (* no_implicit_conditions, fire_when_enabled *) 
  rule doAlways (True);
    a4wrRqA.in.valid  (wrAddrVal_w);
    a4wrRqD.in.valid  (wrDataVal_w);
    a4wrRqA.in.data   (AXI4_Lite_RqA_Wr{ addr:wrAddr_w, prot:wrProt_w });
    a4wrRqD.in.data   (AXI4_Lite_RqD_Wr{ data:wrData_w, strb:wrStrb_w });
    a4wrRsp.out.ready (wrRespRdy_w);
  endrule

  interface AXI4_Lite_Slave_Wr_Fab fab; 
    method Action   mAWVALID = wrAddrVal_w._write(True);
    method Bit#(1)  sAWREADY = pack(a4wrRqA.in.ready);
    method Action   mAWADDR  (Bit#(32) awaddr_in) = wrAddr_w._write(awaddr_in);
    method Action   mAWPROT  (Bit#(3)  awprot_in) = wrProt_w._write(awprot_in);

    method Action   mWVALID  = wrDataVal_w._write(True);
    method Bit#(1)  sWREADY  = pack(a4wrRqD.in.ready);
    method Action   mWDATA   (Bit#(64) wdata_in) = wrData_w._write(wdata_in);
    method Action   mWSTRB   (Bit#(4)  wstrb_in) = wrStrb_w._write(wstrb_in);

    method Bit#(1)  sBVALID  = pack(a4wrRsp.out.valid);
    method Action   mBREADY  = wrRespRdy_w._write(True);
    method Bit#(2)  sBRESP   = pack(a4wrRsp.out.data);
  endinterface

  interface Client bus;
    interface Get request;
      method ActionValue#(AXI4_Lite_Rq_Wr) get();
        let reqA = a4wrRqA.out.first(); a4wrRqA.out.deq();
        let reqD = a4wrRqD.out.first(); a4wrRqD.out.deq();
        return AXI4_Lite_Rq_Wr{ addr: reqA.addr, prot: reqA.prot, data: reqD.data, strb: reqD.strb };
      endmethod
    endinterface
    interface Put response  = toPut(a4wrRsp.in);
  endinterface
endmodule

instance Connectable#(AXI4_Lite_Master_Wr_Fab, AXI4_Lite_Slave_Wr_Fab); //WRITE - Connectable
  module mkConnection#(AXI4_Lite_Master_Wr_Fab m, AXI4_Lite_Slave_Wr_Fab s) (Empty);
    (* no_implicit_conditions, fire_when_enabled *) 
    rule connectWrFab (True);
      if (unpack(m.mAWVALID)) s.mAWVALID;
      if (unpack(s.sAWREADY)) m.sAWREADY;
      s.mAWADDR(m.mAWADDR);
      s.mAWPROT(m.mAWPROT);
      if (unpack(m.mWVALID)) s.mWVALID;
      if (unpack(s.sWREADY)) m.sWREADY;
      s.mWDATA(m.mWDATA);
      s.mWSTRB(m.mWSTRB);
      if (unpack(s.sBVALID)) m.sBVALID;
      if (unpack(m.mBREADY)) s.mBREADY;
      m.sBRESP(s.sBRESP);
    endrule
  endmodule
endinstance

endpackage
