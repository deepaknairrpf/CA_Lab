
public class MultiplyFunctionalUnit extends FunctionalUnit{//data structure for multply commands

    public MultiplyFunctionalUnit() {
	super("Mult");//call parent constructor to setup with proper data type
	this.delay = 6;
	this.type = 2;
    }

    public MultiplyFunctionalUnit(String unitName){
        super(unitName);//call parent constructor to setup with proper data type
	this.delay = 6;
	this.type = 2;
    }

}
