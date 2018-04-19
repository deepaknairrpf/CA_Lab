
public class AddFunctionalUnit extends FunctionalUnit{//data structure for add commands
    public AddFunctionalUnit(){
	super("Add"); //call parent constructor to setup with proper data type
        this.delay=3;
	this.type = 1;
    }

    public AddFunctionalUnit(String unitName){
        super(unitName);//call parent constructor to setup with proper data type
        this.delay=3;
	this.type =1;
    }
}
