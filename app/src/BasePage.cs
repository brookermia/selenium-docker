using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace SeleniumDocker
{
    [TestClass]
    public class BasePage
    {
        protected IWebDriver driver;
        protected static bool headless = false;

        [AssemblyInitialize]
        public static void AssemblyInit(TestContext context)
        {
            // Check if headless argument is passed through environment variable
            var headlessEnv = Environment.GetEnvironmentVariable("RUN_HEADLESS");
            if (!string.IsNullOrEmpty(headlessEnv) && headlessEnv.Equals("true", StringComparison.OrdinalIgnoreCase))
            {
                headless = true;
            }
        }

        public BasePage() : this(headless) { }

        public BasePage(bool headless)
        {
            var options = new ChromeOptions();
            if (headless)
            {
                options.AddArgument("--headless");
            }

            driver = new ChromeDriver(options);
        }

        public void CloseBrowser()
        {
            driver.Quit();
        }
    }
}
