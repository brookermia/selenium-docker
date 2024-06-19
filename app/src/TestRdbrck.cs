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
        public TestRdbrck() : base() { }

        // Constructor with parameters (optional)
        public TestRdbrck(bool headless) : base(headless) { }

        [TestMethod]
        public void TestRdbrckHomepage()
        {
            try
            {
                driver.Navigate().GoToUrl("https://www.rdbrck.com/");
                Assert.IsTrue(driver.Title.Contains("Redbrick"), "Test Failed: Redbrick homepage title is incorrect.");
            }
            catch (Exception e)
            {
                Assert.Fail($"Test Failed: {e.Message}");
            }
            finally
            {
                CloseBrowser();
            }
        }
    }
}
