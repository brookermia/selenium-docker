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

            if (Environment.GetEnvironmentVariable("RUNNING_IN_DOCKER_WINDOWS") == "true")
            {
                chromeDriverPath = @"C:\app\drivers\chromedriver.exe"; // Path inside Docker
            }
            else if (Environment.GetEnvironmentVariable("RUNNING_IN_DOCKER_LINUX") == "true")
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
            chromeOptions.AddArgument("--headless");  // Enables headless mode.
            chromeOptions.AddArgument("--disable-gpu");  // Disables GPU hardware acceleration.
            chromeOptions.AddArgument("--no-sandbox");  // Disables the sandbox for all process types.
            chromeOptions.AddArgument("--disable-dev-shm-usage");  // Uses /tmp instead of /dev/shm.
            chromeOptions.AddArgument("--disable-features=NetworkService,NetworkServiceInProcess");  // Disables specific features.
            chromeOptions.AddArgument("--disable-infobars");  // Prevents infobars from appearing.
            chromeOptions.AddArgument("--remote-debugging-port=9222");

            var service = ChromeDriverService.CreateDefaultService(Path.GetDirectoryName(chromeDriverPath), Path.GetFileName(chromeDriverPath));
            driver = new ChromeDriver(service, chromeOptions);
        }

        public void CloseBrowser()
        {
            driver.Quit();
        }
    }
}
