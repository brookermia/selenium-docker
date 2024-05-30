using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.IO;

namespace SeleniumDocker
{
    public class BasePage
    {
        protected IWebDriver driver;

        public BasePage(bool headless = true)
        {
            string chromeDriverPath;

            if (Environment.GetEnvironmentVariable("RUNNING_IN_DOCKER") == "true")
            {
                chromeDriverPath = "/app/drivers/chromedriver"; // Path inside Docker
            }
            else
            {
                var projectRootDirectory = Path.GetFullPath(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, @"..\..\..\.."));
                var chromeDriverDirectory = Path.Combine(projectRootDirectory, "drivers");
                var chromeDriverFileName = "chromedriver.exe"; // Assuming Windows environment
                chromeDriverPath = Path.Combine(chromeDriverDirectory, chromeDriverFileName);
            }

            if (!File.Exists(chromeDriverPath))
            {
                throw new FileNotFoundException($"ChromeDriver not found at {chromeDriverPath}. Please ensure ChromeDriver version 125 is placed in the directory.");
            }

            var chromeOptions = new ChromeOptions();
            if (headless)
            {
                chromeOptions.AddArgument("--headless");
            }

            chromeOptions.AddArgument("--disable-dev-shm-usage");
            chromeOptions.AddArgument("--no-sandbox");
            chromeOptions.AddArgument("--disable-extensions");
            chromeOptions.AddArgument("--disable-gpu");
            chromeOptions.AddArgument("--window-size=1280,1024");

            var service = ChromeDriverService.CreateDefaultService(Path.GetDirectoryName(chromeDriverPath), Path.GetFileName(chromeDriverPath));
            driver = new ChromeDriver(service, chromeOptions);
        }

        public void CloseBrowser()
        {
            driver.Quit();
        }
    }
}
