public class Recursive_Check {

    // Static variables are local to the context of a Web request
    // (or testMethod during a runTests call)
    // Therefore, this variable will be initialized as false
    // at the beginning of each Web request which accesses it.

    private static boolean alreadyRan = false;

    public static boolean hasAlreadyRan() {
        return alreadyRan;
    }

    // By setting the variable to true, it maintains this
    // new value throughout the duration of the request
    // (or testMethod)

    public static void setAlreadyRan() {
        alreadyRan = true;
    }


//******************
//Test Method 
//******************
  static testMethod void TestMe() {
    System.assertEquals(false,hasAlreadyRan());
    setAlreadyRan();
    System.assertEquals(true,hasAlreadyRan());
  }

//The End
}