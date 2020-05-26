/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        08/07/2018
*    Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Unit test for Wrapper newsWrapper
*   
*   
*	
*   **********************************************************************************************************************/
@IsTest
public class NewsWrapper_Test {

    @IsTest
    public static void wrapper() {
        newsWrapper news = new newsWrapper();
        news.News_Title = 'Title';
        news.Body_Content = 'Content';
        news.Button_Label = 'button label';
        news.Button_Link = 'button link';          
    }
}