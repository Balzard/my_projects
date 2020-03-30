package be.unamur.info.b314.compiler.symboltable;

public class VariableSymbol extends Symbol{
    private boolean isConst;
    private String value;

    public VariableSymbol(String name, String type, boolean IsConst){
        super(name, type);
        this.isConst = IsConst;
    }
    public VariableSymbol(String name, String type, boolean IsConst, String value){
        super(name, type);
        this.isConst = IsConst;
        this.value = value;
    }
    public boolean isConst(){
        return isConst;
    }
    public Object getValue(){
        return value;
    }
}
