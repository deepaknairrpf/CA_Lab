import java.util.ArrayList;

public class FunctionalUnit {
    public boolean Busy = false;
    int releaseTime = 0;
    public String Op = "",
            Fi = "", Fj = "", Fk = "", Qj = "", Qk = "", Rj = "", Rk = "",
            functionalUnitName = "";
    public int time = -1; // default is -1
    public int delay = 0;
    public int type = 0;

    public FunctionalUnit(String fuName) { //constructor sets name on creation
		functionalUnitName = fuName; //allows for dynamic extension of this class
    }

    public FunctionalUnit(){} //default constructor - not used

    public void resetValues(){ //reset all value of the functional unit
        this.Fi = "";
        this.Fj = this.Fk = this.Qj = this.Qk = this.Rj = this.Rk = this.Op = "";
        this.Busy = false;
	this.time = -1;
    }

    @Override
    public String toString(){//this function is used for debugging, gets all values of fu and outputs
        String ret = "";
	if (this.time == -1) {ret += " ";}
	else { ret += Integer.toString(this.time);}
        ret += this.time + " ";
        ret += this.functionalUnitName + this.spaces(8-this.functionalUnitName.length())+"| ";
        ret += this.Op + " ";
        ret += this.Fi + " ";
        ret += this.Fj + " ";
        ret += this.Fk + " ";
        ret += this.Qj + " ";
        ret += this.Qk + " ";
        ret += this.Rj + " ";
        ret += this.Rk + " ";
        return ret;
    }

    public ArrayList toArray(){
        ArrayList a = new ArrayList(11);
	if (this.time == -1) {a.add(0,"");}
	else {a.add(0,Integer.toString(this.time));}
        a.add(1,this.functionalUnitName);
        if(this.Busy){a.add(2,"Yes");}
        else {a.add(2,"No");}
        a.add(3,this.Op);
        a.add(4,this.Fi);
        a.add(5,this.Fj);
        a.add(6,this.Fk);
        a.add(7,this.Qj);
        a.add(8,this.Qk);
        a.add(9,this.Rj);
        a.add(10,this.Rk);
        return a;
    }

    public String spaces(int n){
        String s = "";
        for(int i=n; i>0; i--){s+=" ";}
        return s;
    }
}
