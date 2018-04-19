
public class DivideFunctionalUnit extends FunctionalUnit{//data structure for divide commands
    public DivideFunctionalUnit() {
	super("Divide");//call parent constructor to setup with proper data type
	this.delay = 24;
	this.type = 3;
    }

    public DivideFunctionalUnit(String unitName) {
        super(unitName);//call parent constructor to setup with proper data type
        this.delay = 24;
	this.type = 3;
        //TODO verify that this is the correct latency for DIVD operations
    }
}
