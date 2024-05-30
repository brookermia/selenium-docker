using System;
using System.Threading;
namespace SeleniumDocker
{
    public class TestRdbrck : BasePage
    {
        public TestRdbrck(bool headless = true) : base(headless) { }

        public void TestRdbrckHomepage()
        {
            try
            {

                // Navigate to Google
                driver.Navigate().GoToUrl("https://www.rdbrck.com/");

                // Assert that the title is correct
                if (driver.Title.Contains("Redbrick"))
                {
                    Console.WriteLine("Test Passed: Redbrick homepage title is correct.");
                }
                else
                {
                    Console.WriteLine("Test Failed: Redbrick homepage title is incorrect.");
                }
            }
            catch (Exception e)
            {
                Console.WriteLine($"Test Failed: {e.Message}");
            }

            finally
            {
                CloseBrowser();
            }
        }
    }
}
