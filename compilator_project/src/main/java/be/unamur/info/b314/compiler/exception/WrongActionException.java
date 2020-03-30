package be.unamur.info.b314.compiler.exception;

public class WrongActionException extends RuntimeException{
    public  WrongActionException(String message, Exception e) {
        super(message, e);
    }

    public  WrongActionException(String message){
        super(message);
    }
}
