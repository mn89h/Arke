package arch_ifc;

import GetPut :: *;
import ClientServer :: *;
import Vector :: *;
import AXI4Lite :: *;

typedef 3 DIM_X;
typedef 3 DIM_Y;
typedef 2 DIM_Z;

interface ArchIfc;
	(*prefix=""*) interface AXI4_Lite_Master_Wr_Fab  val_wr;
	(*prefix=""*) interface AXI4_Lite_Master_Rd_Fab  val_rd;
	//(*prefix=""*) interface AXI4_Full_Slave_Wr_Fab   ref_wr;
	//(*prefix=""*) interface AXI4_Full_Slave_Rd_Fab   ref_rd;

	method Bit#(64) dataOut;
	method Bit#(3)  controlOut;
	method Action   dataIn    (Bit#(64) data_in);
	method Action   controlIn (Bit#(3)  ctrl_in);
endinterface

module mkCore(CoreIfc);

	//Variante 1: Slave - NoC - Master
	Wire#(Bit#(64))   dataOut_w <- mkDWire(0);
	Wire#(Bit#(3))    ctrlOut_w <- mkDWire(0);
	Wire#(Bit#(64))   dataIn_w  <- mkDWire(0);
	Wire#(Bit#(3))    ctrlIn_w  <- mkDWire(0);
	
	AXI4_Lite_Master_Rd  val_rdM <- mkAXI4_Lite_Master_Rd;
	AXI4_Lite_Master_Wr  val_wrM <- mkAXI4_Lite_Master_Wr;
	

	rule processArchRq (ctrlIn_w[1]);
		Integer address_range = sizeOf(DIM_Z) + sizeOf(DIM_Y) + sizeOf(DIM_X)
		
		//TODO: resp code redirection
		if(dataIn_w[127]) begin //wr and rd seperation
			let addr = dataIn_w[addr_range + 31 : addr_range];
			let prot = dataIn_w[addr_range + 34 : addr_range + 32];
			let data = dataIn_w[addr_range + 98 : addr_range + 35];
			let strb = dataIn_w[addr_range + 102: addr_range + 99];
			val_wrM.bus.request.put(AXI4_Lite32_Rq_Wr(addr: pack(addr), prot: pack(prot), data: pack(data), strb: pack(strb)));
		end else begin
			let addr = dataIn_w[addr_range + 31 : addr_range];
			let prot = dataIn_w[addr_range + 34 : addr_range + 32];
			val_rdM.bus.request.put(AXI4_Lite32_Rq_Rd(prot: pack(prot), addr: pack(addr)));
		end
	endrule

	rule processRdRsp (ctrlIn_w[2]);
		let r <- val_rdM.bus.response.get();
		let data = r.data;
		let resp = r.resp;

		UInt#(sizeOf(DIM_Z))  zA      = 0;
		UInt#(sizeOf(DIM_Y))  yA      = 0;
		UInt#(sizeOf(DIM_X))  xA      = 0;
		
		//prepare dataOut
		Bit#(128) dataOut_tmp = {'0, pack(resp), pack(data), pack(xA), pack(yA), pack(zA)};
		
		//prepare controlOut
		Bit#(3)  controlOut_tmp = 3'b111;

		dataOut_w <= dataOut_tmp;
		ctrlOut_w <= controlOut_tmp;
	
	endrule
	
	rule processWrRsp (ctrlIn_w[2]);
		let r <- val_wrM.bus.response.get();
		let resp = r.resp;

		UInt#(sizeOf(DIM_Z))  zA      = 0;
		UInt#(sizeOf(DIM_Y))  yA      = 0;
		UInt#(sizeOf(DIM_X))  xA      = 0;
		
		//prepare dataOut
		Bit#(128) dataOut_tmp = {'1, pack(resp), pack(xA), pack(yA), pack(zA)};
		
		//prepare controlOut
		Bit#(3)  controlOut_tmp = 3'b111;

		dataOut_w <= dataOut_tmp;
		ctrlOut_w <= controlOut_tmp;
	
	endrule


	
	interface AXI4_Lite32_Slave_Wr_Fab  val_wr = wrM.fab;
	interface AXI4_Lite32_Slave_Rd_Fab  val_rd = rdM.fab;
	method Bit#(64) dataOut                       = pack(dataOut_w);
	method Bit#(3)  controlOut                    = pack(ctrlOut_w);
	method Action   dataIn    (Bit#(64) data_in)  = dataIn_w._write(data_in);
	method Action   controlIn (Bit#(3)  ctrl_in)  = ctrlIn_w._write(ctrl_in);


	//Variante 2: working on the fab

endmodule