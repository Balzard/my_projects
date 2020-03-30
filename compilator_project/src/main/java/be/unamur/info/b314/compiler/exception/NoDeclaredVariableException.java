package be.unamur.info.b314.compiler.exception;

public class NoDeclaredVariableException extends RuntimeException {
    public  NoDeclaredVariableException(String message, Exception e) {
        super(message, e);
    }

    public  NoDeclaredVariableException(String message){
        super(message);
    }
}
