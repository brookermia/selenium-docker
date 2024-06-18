using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace SeleniumDocker
{
    [TestClass]
    public class TestRdbrck : BasePage
    {
        // Parameterless constructor required by MSTest
        public TestRdbrck() : base(true) { }

        // Constructor with parameters (optional)
        public TestRdbrck(bool headless) : base(headless) { }

        [TestMethod]
        public void TestRdbrckHomepage()
        {
            Console.WriteLine("I have hit the test file");
            try
            {
                // Navigate to Redbrick homepage
                driver.Navigate().GoToUrl("https://www.rdbrck.com/");
                Console.WriteLine("I have navigated");

                // Assert that the title is correct
                Assert.IsTrue(driver.Title.Contains("POPCORN"), "Test Failed: Redbrick homepage title is incorrect.");
                // Console.WriteLine("Test Passed: Redbrick homepage title is correct.");
            }
            catch (Exception e)
            {
                Assert.Fail($"Test Failed: {e.Message}");
            }
            finally
            {
                Console.WriteLine("I have closed the browser");
                CloseBrowser();
            }
        }
    }
}
