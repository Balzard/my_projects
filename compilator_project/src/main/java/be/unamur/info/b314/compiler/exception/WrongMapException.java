package be.unamur.info.b314.compiler.exception;

public class WrongMapException extends RuntimeException {

    public  WrongMapException(String message, Exception e) {
        super(message, e);
    }

    public  WrongMapException(String message){
        super(message);
    }

}
