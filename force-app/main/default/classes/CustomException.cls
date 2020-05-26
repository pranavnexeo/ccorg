public class CustomException extends Exception {

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }
    
    public static void throwException(List<String> msgs) {
        String msg = '';
        for (String m : msgs) {
            msg += m + '\n';
        }
        debug(msg);
        throw new CustomException(msg);
    }
    
    public static void throwException(Exception e) {
        throwException(new List<String>{e.getMessage()});
    }
    
}