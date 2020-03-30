package be.unamur.info.b314.compiler.symboltable;

import com.google.common.collect.Maps;

import java.util.HashMap;
import java.util.Map;

public class SymbolTable {
    private final Map<String, Symbol> symTable;
    private SymbolTable enclosingScope;
    private Worldmap worldmap;

    public SymbolTable(SymbolTable enclosingScope){
        this.enclosingScope = enclosingScope;
        symTable = new HashMap<String, Symbol>();
    }

    public Map<String, Symbol> getSymTable() {
        return symTable;
    }

    /**
     * Check if symbol named has been declared in this
     * @param name the name of the symbol we are looking for
     * @return the symbol if found, otherwise, return null
     */
    public Symbol checkHere(String name){
        if(symTable.containsKey(name)){
            return symTable.get(name);
        }
        return null;
    }

    /**
     * Check if a symbol name has been declared in this or in a enclosing scope
     * @param name the name of the symbol
     * @return the symbol if found, null otherwise
     */
    public Symbol checkEnclosing(String name){
        //If the symbol has been declared in this, return the symbol
        if(checkHere(name) != null){ return checkHere(name); }
        //If enclosingScope is null, there is no enclosing scope to this
        if(enclosingScope == null){ return null; }
        //Check in the enclosing scope
        return enclosingScope.checkEnclosing(name);
    }

    public void add(Symbol symbol){
        String name = symbol.name();
        symTable.put(name, symbol);
    }

    public void add(Worldmap map){
        this.worldmap = map;
    }

    public SymbolTable enclosingScope(){
        return enclosingScope;
    }
}
