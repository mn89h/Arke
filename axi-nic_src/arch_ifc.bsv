package arch_ifc;

import GetPut :: *;
import ClientServer :: *;
import Vector :: *;
import AXI4Lite :: *;

typedef 3 DIM_X;
typedef 3 DIM_Y;
typedef 2 DIM_Z;

interface ArchIfc;
	(*prefix=""*) interface AXI4_Lite_Slave_Wr_Fab  val_wr;
	(*prefix=""*) interface AXI4_Lite_Slave_Rd_Fab  val_rd;

	method Bit#(64) dataOut;
	method Bit#(3)  controlOut;
	method Action   dataIn    (Bit#(64) data_in);
	method Action   controlIn (Bit#(3)  ctrl_in);
endinterface

//modul parametrisieren
module 	mkArch#(parameter UInt#(4) DIM_X,
				parameter UInt#(4) DIM_Y, 
				parameter UInt#(2) DIM_Z) (ArchIfc);

	//Variante 1: Slave - NoC - Master
	Wire#(Bit#(64))   dataOut_w <- mkDWire(0);
	Wire#(Bit#(3))    ctrlOut_w <- mkDWire(0);
	Wire#(Bit#(64))   dataIn_w  <- mkDWire(0);
	Wire#(Bit#(3))    ctrlIn_w  <- mkDWire(0);
	
	AXI4_Lite32_Slave_Rd  val_rdS <- mkAXI4_Lite32_Slave_Rd;
	AXI4_Lite32_Slave_Wr  val_wrS <- mkAXI4_Lite32_Slave_Wr;
	

	//set rules exclusive, so no error because of simultaneous writes
	rule processRdRq (ctrlIn_w[2]);
	
		let r <- val_rdS.bus.request.get();
		let addr = r.data;
		let prot = r.prot;

		//extract router address from AXI address
		UInt#(12)             coreNr  = unpack(addr[27:16]);
		UInt#(sizeOf(DIM_Z))  zA      = coreNr / (fromInteger(valueOf(DIM_X)) * fromInteger(valueOf(DIM_Y)));
		UInt#(sizeOf(DIM_Y))  yA      = (coreNr % (fromInteger(valueOf(DIM_X)) * fromInteger(valueOf(DIM_Y)))) / fromInteger(valueOf(DIM_X)); 
		UInt#(sizeOf(DIM_X))  xA      = (coreNr % (fromInteger(valueOf(DIM_X)) * fromInteger(valueOf(DIM_Y)))) % fromInteger(valueOf(DIM_X)); 
		
		//prepare dataOut
		Bit#(128) dataOut_tmp = {'0, prot, addr, pack(xA), pack(yA), pack(zA)};
		
		//prepare controlOut
		Bit#(3)  controlOut_tmp = 3'b011;

		dataOut_w <= dataOut_tmp;
		ctrlOut_w <= controlOut_tmp;
	
	endrule
	
	rule processWrRq (ctrlIn_w[2]);
	
		let r <- val_wrS.bus.request.get();
		let addr = r.data;
		let prot = r.prot;
		let data = r.data;
		let strb = r.strb;

		//extract router address from AXI address
		UInt#(12)             coreNr  = unpack(addr[27:16]);
		UInt#(sizeOf(DIM_Z))  zA      = coreNr / (fromInteger(valueOf(DIM_X)) * fromInteger(valueOf(DIM_Y)));
		UInt#(sizeOf(DIM_Y))  yA      = (coreNr % (fromInteger(valueOf(DIM_X)) * fromInteger(valueOf(DIM_Y)))) / fromInteger(valueOf(DIM_X)); 
		UInt#(sizeOf(DIM_X))  xA      = (coreNr % (fromInteger(valueOf(DIM_X)) * fromInteger(valueOf(DIM_Y)))) % fromInteger(valueOf(DIM_X)); 
		
		//prepare dataOut
		Bit#(128) dataOut_tmp = {'1, strb, data, prot, addr, pack(xA), pack(yA), pack(zA)};
		
		//prepare controlOut
		Bit#(3)  controlOut_tmp = 3'b011;

		dataOut_w <= dataOut_tmp;
		ctrlOut_w <= controlOut_tmp;
	
	endrule

	//no simultaneous requests, waits for resp before next request, so no ids needed
	rule processRsp (ctrlIn_w[1]);
	Integer address_range = sizeOf(DIM_Z) + sizeOf(DIM_Y) + sizeOf(DIM_X)
	//TODO: resp code redirection
	if(dataIn_w[127]) begin //wr and rd seperation
		val_wrS.bus.response.put(AXI4_Lite32_Rsp_Wr(resp: 'b0));
	end else begin
		let data = dataIn_w[addr_range + 63 : addr_range]
		val_rdS.bus.response.put(AXI4_Lite32_Rsp_Rd(resp: 'b0, data: extend(pack(data))));
	end
	endrule


	interface AXI4_Lite32_Slave_Wr_Fab  val_wr = val_wrS.fab;
	interface AXI4_Lite32_Slave_Rd_Fab  val_rd = val_rdS.fab;
	method Bit#(64) dataOut                       = pack(dataOut_w);
	method Bit#(3)  controlOut                    = pack(ctrlOut_w);
	method Action   dataIn    (Bit#(64) data_in)  = dataIn_w.write(data_in);
	method Action   controlIn (Bit#(3)  ctrl_in)  = ctrlIn_w.write(ctrl_in);


	//Variante 2: working on the fab

endmodule