package be.unamur.info.b314.compiler.exception;

public class WrongValueTypeException extends RuntimeException{
    public  WrongValueTypeException(String message, Exception e) {
        super(message, e);
    }

    public  WrongValueTypeException(String message){
        super(message);
    }
}
