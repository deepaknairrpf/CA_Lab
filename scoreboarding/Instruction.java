
public class Instruction {
    String rawCommand;
    String opcodeMneumonic; //e.g. LD
    Register r1, r2, r3;
    String opcodeString; //e.g. LD = Load
    int issue, readOper, execComp, writeResult;
    int delay ;
    int typeOfFUUsed; // 1 = Sub-Add ; 2 - Mult; 3 - Div
    FunctionalUnit fuUsed;   

    public Instruction(String rawCommand) throws Exception{
	issue = readOper = execComp = writeResult = 0;  //initialized all stages

        r1 = new Register(); //src/dest 1
        r2 = new Register(); //src/dest 2
        r3 = new Register(); //src/dest 3

	String [] instructionOperandsValuesSplit = null;

        String [] instructionCommentSplit = rawCommand.split(";");  //split instruction data from comment
        this.rawCommand = instructionCommentSplit[0];               //set the instruction content apart from the comment
        String [] instructionOperandsSplit = instructionCommentSplit[0].split("[\\s]+",2);          //split LD from 34,R2
        String [] operandSplit = instructionOperandsSplit[1].split(",",3); //splits the F2 34(R2) #1
        opcodeMneumonic = instructionOperandsSplit[0];
        r1.name = operandSplit[0];

        //clean up leading and trailing superfluous spaces in operands
        for(int operandI=operandSplit.length-1; operandI>=0; operandI--){operandSplit[operandI] = operandSplit[operandI].trim();}
        


        if(operandSplit.length > 2){
		r2.name = operandSplit[1];
		// handle immediates DADDI

                //search for an offset '#' character
		boolean foundPoundSign = false; //set this var if found
		for(int character=0; character<operandSplit[2].length(); character++) {//cycle through all characters in the portion of the instruction
			if (operandSplit[2].charAt(character)=='#'){foundPoundSign = true;break;} //if we find a pound sign, set a bool for use below
		}
	        if(foundPoundSign){ //get rid of the hash symbol if found and just pull the int value
                    r3.value += Integer.parseInt(operandSplit[2].replaceFirst("#","")); //get the int value after replacing the pound/hash
		}else {
                    r3.name = operandSplit[2];}
	}   	
        else {// less than two operands
		boolean foundPar = false; //we found a parenthesis?
		boolean foundPou = false; //we found a pound/hash symbol?
		for (int i =0; i<operandSplit[1].length();i++) {
			if (operandSplit[1].charAt(i)=='('){foundPar = true;} //we found a paren!
			if (operandSplit[1].charAt(i)=='#'){foundPou = true;} //we found a hash!
		}
		// handle Offset
		if (foundPar) {
	        	String [] withOperandDisplacement = operandSplit[1].split("\\("); //delimit offset value and parens
	                int displ = Integer.parseInt(withOperandDisplacement[0]); //get the numerical value of the offset
	                r2.value += displ;
	                r2.name = withOperandDisplacement[1].replaceFirst("\\)",""); //get rid of closing paren
	        } else if ( foundPou) { //extract the value from an immediate
	         	r2.value += Integer.parseInt(operandSplit[1].replaceFirst("#","")); //get rid of pound sign
	        } else{
	                r2.name = operandSplit[1];
	        }
	}


	// Set register types
	if( opcodeMneumonic.equals("S.D") || opcodeMneumonic.equals("SD")) {
		r1.type = 1; // source
		r2.type = 1; // source
		r3.type = 1; // source
	} else {
		r1.type = 0; // destination
		r2.type = 1; // source
		r3.type = 1; // source
	}

	//associate register values
	if (instructionCommentSplit.length > 1) {
	        instructionOperandsValuesSplit = instructionCommentSplit[1].split(" ");          //split R2=11111 R3=01010101010
		if (instructionOperandsValuesSplit.length != 0) {
			for (int i =0; i< instructionOperandsValuesSplit.length; i++) {
				// TODO - what if it does not match
                            
                                //remove extra comma that is appended if multiple init values are set
                                instructionOperandsValuesSplit[i] = instructionOperandsValuesSplit[i].replace(",","");

				String [] regNameValueSplit = instructionOperandsValuesSplit[i].split("=");
				if (regNameValueSplit.length > 1) {
					if (r1.name.equals(regNameValueSplit[0])) {
						r1.value += Integer.parseInt(regNameValueSplit[1],10);
					} else if (r2.name.equals(regNameValueSplit[0])) {
						r2.value += Integer.parseInt(regNameValueSplit[1],10);
					} else {	
						r3.value += Integer.parseInt(regNameValueSplit[1],10);
					}
					//TODO - what if he inputs a value for a register not among the registers
				}
			}
		}
	}

       //associate type of functional unit used w/ instruction
        if(opcodeMneumonic.equals("L.D") || opcodeMneumonic.equals("S.D") || opcodeMneumonic.equals("DADD") || opcodeMneumonic.equals("DADDI") || opcodeMneumonic.equals("DADDUI") || opcodeMneumonic.equals("DSUB") || opcodeMneumonic.equals("LD") || opcodeMneumonic.equals("SD") || opcodeMneumonic.equals("DMUL") || opcodeMneumonic.equals("DDIV") ){
		typeOfFUUsed = 0;
		delay = 0;
	} else if(opcodeMneumonic.equals("SUB.D") || opcodeMneumonic.equals("ADD.D")) {
		typeOfFUUsed = 1;
		delay = 3;  //per spec, adders have latency of 3
	} else if(opcodeMneumonic.equals("MUL.D") || opcodeMneumonic.equals("MULT.D")) {
		typeOfFUUsed = 2;
		delay = 6;  //per spec, multiplier has latency of 6
	} else if(opcodeMneumonic.equals("DIV.D")){
		typeOfFUUsed = 3;
		delay = 24; //per spec, divider has latency of 24
        } else {
            throw new Exception("Error trying to figure out function unit for instruction"+operandSplit[0]);
        }

       //translate opcodeMneumonics to human readable strings
        if(opcodeMneumonic.equals("L.D") || opcodeMneumonic.equals("LD")){opcodeString = "Load";}
        else if(opcodeMneumonic.equals("S.D") || opcodeMneumonic.equals("SD")){opcodeString = "Store";}
        else if(opcodeMneumonic.equals("MUL.D") || opcodeMneumonic.equals("DMUL") || opcodeMneumonic.equals("DMULI") || opcodeMneumonic.equals("MULT.D")){opcodeString = "Mult";}
        else if(opcodeMneumonic.equals("SUB.D") || opcodeMneumonic.equals("DSUB") || opcodeMneumonic.equals("DSUBI") ){opcodeString = "Sub";}
        else if(opcodeMneumonic.equals("DIV.D") || opcodeMneumonic.equals("DDIV") || opcodeMneumonic.equals("DDIVI") ){opcodeString = "Div";}
        else if(opcodeMneumonic.equals("ADD.D") || opcodeMneumonic.equals("DADD") || opcodeMneumonic.equals("DADDI") || opcodeMneumonic.equals("DADDUI") ){opcodeString = "Add";}
        else {throw new UnrecognizedOperationException();}
    }

    public Instruction(String command, String op1, String op2){
       
    }

    public Register dest() { //return the appropriate register based on the type of instruction
	if (r1.type == 0)   {return r1;} //first register is destination
        else                {return r3;} //third register contains destination register
    }

    public Register sourcej() {//return the appropriate register based on the type of instruction
	if (r1.type == 0)   {return r2;} //first source is found in second register
        else                {return r1;} //first source is found in first register
    }

    public Register sourcek() {//return the appropriate register based on the type of instruction
	if (r1.type == 0)   {return r3;} //second source is found in third register
        else                {return r2;} //second source if found in second register
    }

    @Override
    public String toString(){
        String ret =  rawCommand + " Issue: " + issue + " ReadOper: " + readOper + " ExecComp:  " + execComp + " WriteResult: " + writeResult + " Type of FU needed: " + typeOfFUUsed + "\n\t" + r1 + "\n\t" + r2 + "\n\t" + r3; 
	if (fuUsed != null) {
		ret = "FuUsed: " + fuUsed.functionalUnitName + ret;
	} else {
		ret = "No FU assigned "  + ret;
	}
	return ret;
    }


}


class UnrecognizedOperationException extends Exception{
    public UnrecognizedOperationException(){
     System.out.println("You tried to execute an assembly operation that this code doesn't know."); 
    }
    public UnrecognizedOperationException(String msg){
        super(msg);
    }


}
