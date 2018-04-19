package entries;

public class InstructionEntry implements Entry {

	private int rs, rt; // Address is rt in case of load/store
	private int rd;

	private InstructionType type;
	private int instructionAddress; // for branching

	public InstructionType getType() {
		return type;
	}

	public int getRS() {
		return rs;
	}

	public int getRT() {
		return rt;
	}

	public int getRD() {
		return rd;
	}

	public int getInstAddress() {
		return instructionAddress;
	}
	
	public void setPcAddress(int address){
		instructionAddress = address;
	}

	public void setRS(int rs) {
		this.rs = rs;
	}

	public void setRT(int rt) {
		this.rt = rt;
	}

	public void setRD(int rd) {
		this.rd = rd;
	}

	public void setType(InstructionType type) {
		this.type = type;
	}

}
