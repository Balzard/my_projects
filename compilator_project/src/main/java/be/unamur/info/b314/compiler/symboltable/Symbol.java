package be.unamur.info.b314.compiler.symboltable;

public class Symbol {
    private String name;
    private String type;

    public Symbol(String name, String type){
        this.name = name;
        this.type = type;
    }

    public String name(){
        return this.name;
    }

    public String type(){
        return this.type;
    }
}
