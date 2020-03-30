package be.unamur.info.b314.compiler;

import be.unamur.info.b314.compiler.exception.*;
import com.google.common.collect.Maps;
import java.util.Map;
import be.unamur.info.b314.compiler.symboltable.*;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;



/**
 * Fills a symbol table using ANTLR listener .
 * @author James Ortiz - james.ortizvega@unamur.be
 */
public class SymTableFiller extends PlayPlusBaseListener {

    private String currentType;
    private SymbolTable currentScope;
    private SymbolTable symTable;
    private Worldmap map;

    private int nId = 0; //

    public SymTableFiller() {
        this.symTable = new SymbolTable(null);
        this.currentScope = symTable;
    }

    public Map<String, Symbol> getSymTable() {
        return symTable.getSymTable();
    }

    @Override
    public void enterRoot(PlayPlusParser.RootContext ctx) { }

    @Override
    public void exitRoot(PlayPlusParser.RootContext ctx) { }

    @Override
    public void enterMap_declaration(PlayPlusParser.Map_declarationContext ctx) {
        int lines = Integer.parseInt(ctx.NUMBER(0).getText());
        int columns = Integer.parseInt(ctx.NUMBER(1).getText());
        map = new Worldmap(lines, columns);
        symTable.add(map);
    }

    @Override
    public void exitMap_declaration(PlayPlusParser.Map_declarationContext ctx) { }

    @Override
    public void enterSymbols(PlayPlusParser.SymbolsContext ctx){
        int expected = map.lines() * map.columns();
        int actual = ctx.SYMBOLES().size();

        if(actual != expected){
            String message = "Wrong size of map !";
            throw new WrongMapException(message);
        }
    }

    @Override
    public void exitSymbols(PlayPlusParser.SymbolsContext ctx) { }

    @Override
    public void enterMain(PlayPlusParser.MainContext ctx) {
        SymbolTable st = new SymbolTable(currentScope);
        String name = "main";
        String type = "void";

        FunctionSymbol fs = new FunctionSymbol(st, name, type, null);
        currentScope.add(fs);
        currentScope = st;
    }

    @Override
    public void exitMain(PlayPlusParser.MainContext ctx) {
        currentScope = currentScope.enclosingScope();
    }
    @Override
    public void enterBOOLEAN(PlayPlusParser.BOOLEANContext ctx) { }

    @Override
    public void exitBOOLEAN(PlayPlusParser.BOOLEANContext ctx) { }

    @Override
    public void enterIMPORT_DECLARATION(PlayPlusParser.IMPORT_DECLARATIONContext ctx) { }

    @Override
    public void exitIMPORT_DECLARATION(PlayPlusParser.IMPORT_DECLARATIONContext ctx) { }

    @Override
    public void enterFILE_DECLARATION(PlayPlusParser.FILE_DECLARATIONContext ctx) { }

    @Override
    public void exitFILE_DECLARATION(PlayPlusParser.FILE_DECLARATIONContext ctx) { }

    @Override
    public void enterDECLARATION(PlayPlusParser.DECLARATIONContext ctx) { }

    @Override
    public void exitDECLARATION(PlayPlusParser.DECLARATIONContext ctx) { }

    @Override
    public void enterFCT_DECLARATION(PlayPlusParser.FCT_DECLARATIONContext ctx) {
        SymbolTable st = new SymbolTable(currentScope);
        String name = ctx.ID().getSymbol().getText();
        String type;
        if(ctx.VOID() != null){
            type = "void";
        }
        else{
            type = ctx.sCALAR().getText();
        }

        FunctionSymbol fs = new FunctionSymbol(st, name, type, ctx);
        currentScope.add(fs);
        currentScope = st;
    }

    @Override
    public void exitFCT_DECLARATION(PlayPlusParser.FCT_DECLARATIONContext ctx) {
        currentScope = currentScope.enclosingScope();
    }

    @Override
    public void enterCONST_DECLARATION(PlayPlusParser.CONST_DECLARATIONContext ctx) {
        currentType = ctx.tYPE().getText();
        String name = ctx.ID().getSymbol().getText();
        VariableSymbol symbol = new VariableSymbol(name, currentType, true ,ctx.iNIT_VAR().getText());

        //Check that if the init value is true or false, the type is BOOL
        if((symbol.getValue() == "true" || symbol.getValue() == "false") && (ctx.tYPE().sCALAR().BOOL() != null)){
            String message = "Declaration type and real type don't match !";
            throw new WrongValueTypeException(message);
        }
        // TODO - check the other type !!
        symTable.add(symbol);
    }

    @Override
    public void exitCONST_DECLARATION(PlayPlusParser.CONST_DECLARATIONContext ctx) { }

    @Override
    public void enterSTRUCT_DECLARATION(PlayPlusParser.STRUCT_DECLARATIONContext ctx) { }

    @Override
    public void exitSTRUCT_DECLARATION(PlayPlusParser.STRUCT_DECLARATIONContext ctx) { }

    @Override
    public void enterENUM_DECLARATION(PlayPlusParser.ENUM_DECLARATIONContext ctx) { }

    @Override
    public void exitENUM_DECLARATION(PlayPlusParser.ENUM_DECLARATIONContext ctx) { }

    @Override
    public void enterVAR_DECLARATION(PlayPlusParser.VAR_DECLARATIONContext ctx) { }

    @Override
    public void exitVAR_DECLARATION(PlayPlusParser.VAR_DECLARATIONContext ctx) { }

    @Override
    public void enterARG_LIST(PlayPlusParser.ARG_LISTContext ctx) { }

    @Override
    public void exitARG_LIST(PlayPlusParser.ARG_LISTContext ctx) { }

    @Override
    public void enterINSTRUCTION_BLOCK(PlayPlusParser.INSTRUCTION_BLOCKContext ctx) { }

    @Override
    public void exitINSTRUCTION_BLOCK(PlayPlusParser.INSTRUCTION_BLOCKContext ctx) { }

    @Override
    public void enterINIT_VAR(PlayPlusParser.INIT_VARContext ctx) { }

    @Override
    public void exitINIT_VAR(PlayPlusParser.INIT_VARContext ctx) { }

    @Override
    public void enterINIT_ARRAY(PlayPlusParser.INIT_ARRAYContext ctx) { }

    @Override
    public void exitINIT_ARRAY(PlayPlusParser.INIT_ARRAYContext ctx) { }

    @Override
    public void enterInteger(PlayPlusParser.IntegerContext ctx) { }

    @Override
    public void exitInteger(PlayPlusParser.IntegerContext ctx) { }

    @Override
    public void enterINT_EXPRESSION(PlayPlusParser.INT_EXPRESSIONContext ctx) { }

    @Override
    public void exitINT_EXPRESSION(PlayPlusParser.INT_EXPRESSIONContext ctx) { }

    @Override
    public void enterOp(PlayPlusParser.OpContext ctx) { }

    @Override
    public void exitOp(PlayPlusParser.OpContext ctx) { }

    @Override
    public void enterIEPRIM(PlayPlusParser.IEPRIMContext ctx) { }

    @Override
    public void exitIEPRIM(PlayPlusParser.IEPRIMContext ctx) { }

    @Override
    public void enterRIGHT_EXPRESSION(PlayPlusParser.RIGHT_EXPRESSIONContext ctx) { }

    @Override
    public void exitRIGHT_EXPRESSION(PlayPlusParser.RIGHT_EXPRESSIONContext ctx) { }

    @Override
    public void enterOp_bool(PlayPlusParser.Op_boolContext ctx) { }

    @Override
    public void exitOp_bool(PlayPlusParser.Op_boolContext ctx) { }

    @Override
    public void enterBOOL_EXPRESSION(PlayPlusParser.BOOL_EXPRESSIONContext ctx) { }

    @Override
    public void exitBOOL_EXPRESSION(PlayPlusParser.BOOL_EXPRESSIONContext ctx) { }

    @Override
    public void enterRIGHT_EXP_BOOL(PlayPlusParser.RIGHT_EXP_BOOLContext ctx) { }

    @Override
    public void exitRIGHT_EXP_BOOL(PlayPlusParser.RIGHT_EXP_BOOLContext ctx) { }

    @Override
    public void enterBEPRIM(PlayPlusParser.BEPRIMContext ctx) { }

    @Override
    public void exitBEPRIM(PlayPlusParser.BEPRIMContext ctx) { }

    @Override
    public void enterLEFT_EXPRESSION(PlayPlusParser.LEFT_EXPRESSIONContext ctx) { }

    @Override
    public void exitLEFT_EXPRESSION(PlayPlusParser.LEFT_EXPRESSIONContext ctx) { }

    @Override
    public void enterLEPRIM(PlayPlusParser.LEPRIMContext ctx) { }

    @Override
    public void exitLEPRIM(PlayPlusParser.LEPRIMContext ctx) { }

    @Override
    public void enterTYPE(PlayPlusParser.TYPEContext ctx) { }

    @Override
    public void exitTYPE(PlayPlusParser.TYPEContext ctx) { }

    @Override
    public void enterSCALAR(PlayPlusParser.SCALARContext ctx) { }

    @Override
    public void exitSCALAR(PlayPlusParser.SCALARContext ctx) { }

    @Override
    public void enterARRAY(PlayPlusParser.ARRAYContext ctx) { }

    @Override
    public void exitARRAY(PlayPlusParser.ARRAYContext ctx) { }

    @Override
    public void enterSTRUCTURE(PlayPlusParser.STRUCTUREContext ctx) { }

    @Override
    public void exitSTRUCTURE(PlayPlusParser.STRUCTUREContext ctx) { }

    @Override
    public void enterINSTRUCTION(PlayPlusParser.INSTRUCTIONContext ctx) {
        if(ctx.lEFT_EXPRESSION() != null){
            //Simple left expression, check if the variable exists
            if(ctx.lEFT_EXPRESSION().ID() != null && ctx.lEFT_EXPRESSION().lEPRIM() == null){
                String nameofvariable = ctx.lEFT_EXPRESSION().ID().getText();
                //Check if the symbol has been declared
                if(currentScope.checkHere(nameofvariable) == null){
                    String message = "Variable doesn't exists !";
                    throw new NoDeclaredVariableException(message);
                }
            }
        }
    }

    @Override
    public void exitINSTRUCTION(PlayPlusParser.INSTRUCTIONContext ctx) { }

    @Override
    public void enterFUNCTION_CALL(PlayPlusParser.FUNCTION_CALLContext ctx) { }

    @Override
    public void exitFUNCTION_CALL(PlayPlusParser.FUNCTION_CALLContext ctx) { }

    @Override
    public void enterACTION_TYPE(PlayPlusParser.ACTION_TYPEContext ctx) {
        if(ctx.JUMP() != null || ctx.LEFT() != null || ctx.RIGHT() != null || ctx.UP() != null || ctx.DOWN() != null){
            if (ctx.rIGHT_EXPRESSION().STRING() != null){
                String message = "Argument should be an integer !";
                throw new WrongActionException(message);
            }
            else if(ctx.rIGHT_EXPRESSION().CHARACTER() != null){
                String message = "Argument should be an integer !";
                throw new WrongActionException(message);
            }
        }
    }

    @Override
    public void exitACTION_TYPE(PlayPlusParser.ACTION_TYPEContext ctx) {
    }

    @Override
    public void enterEveryRule(ParserRuleContext ctx) { }

    @Override
    public void exitEveryRule(ParserRuleContext ctx) { }

    @Override
    public void visitTerminal(TerminalNode node) { }

    @Override
    public void visitErrorNode(ErrorNode node) { }
    
}
