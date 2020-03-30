package be.unamur.info.b314.compiler.symboltable;

public class Worldmap {
    private Integer columns;
    private Integer lines;

    public Worldmap(Integer lines, Integer columns){
        this.columns = columns;
        this.lines = lines;
    }

    public Integer lines(){
        return lines;
    }

    public Integer columns(){
        return columns;
    }
}
