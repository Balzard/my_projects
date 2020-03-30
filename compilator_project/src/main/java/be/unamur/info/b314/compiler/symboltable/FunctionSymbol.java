package be.unamur.info.b314.compiler.symboltable;


import be.unamur.info.b314.compiler.PlayPlusParser;

import java.util.ArrayList;
import java.util.List;

public class FunctionSymbol extends Symbol{
    private SymbolTable symTable;
    private List<Symbol> parameters;
    private PlayPlusParser.FCT_DECLARATIONContext context;

    public FunctionSymbol(SymbolTable symTable, String name, String type, PlayPlusParser.FCT_DECLARATIONContext context) {
        super(name, type);
        this.symTable = symTable;
        this.parameters = new ArrayList<>();
        this.context = context;
    }

    public void addParameter(Symbol parameter){ parameters.add(parameter); }

    public List<Symbol> parameters(){ return parameters; }

    public SymbolTable symTable(){ return symTable; }

    public PlayPlusParser.FCT_DECLARATIONContext context(){ return context; }
}
