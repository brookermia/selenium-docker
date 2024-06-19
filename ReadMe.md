# 👟GitHub Runner POV

GitHub runner has officially been chosen to host our test framework in the CI/CD pipeline. At least for Windows UI tests. See the confluence Doc for all the findings

[🔁Test Automation Docker CI/CD Proof of Concept](https://redbrickmedia.atlassian.net/wiki/spaces/TRON/pages/3032416262/Test+Automation+Docker+CI+CD+Proof+of+Concept)

### ✅Acceptance Criteria:

1. Dependencies are installed (Shift, WinAppDriver…)
2. Shift product can be installed
3. The steps are documented steps to install or be installed

We are using the `Windows-latest` runner image which come installed with chrome, chrome driver and chocolatey. Winappdriver and ShiftX are installed using scripts found in the scripts directory.

The runner can be run by navigating to the Windows Runner in the Actions tab of the Repo and clicking `Run Workflow` on the `main` branch

[Windows Runner · Workflow runs · brookermia/selenium-docker](https://github.com/brookermia/selenium-docker/actions/workflows/runner.yml)

### 🏠Running Locally

At this time you _can_ run the tests manually however, it’s a bit clunky.

1. You have to make sure you have dotnet version 5 installed or simply change the `SeleniumDocker.csproj` to use the version of dotnet you have.
2. Navigate to the app/src directory and run `dotnet build` —> `dotnet test ../SeleniumDocker.sln --no-build --verbosity normal`

### 🤯Headless Option

You can run the tests headless or with UI by changing the ENV variable in powershell before running the test:

`$env:RUN_HEADLESS = "false"` = UI

`$env:RUN_HEADLESS = "true"` = Headless

See what it is currently set to using `echo $env:RUN_HEADLESS`

_I dont know if we need this fuctionality but it was more experimenting with using env variables to pass in arguments_

**Archived Docker ReadMe**

# SPIKE - setup docker and run automated test and view test running

https://redbrickmedia.atlassian.net/browse/ST-1699
SPIKE for getting a webdriver running in a Docker env with options to:

1. Run locally
2. Run headless in Docker
3. Run in Docker with the ability to view GUI

## 🐳Docker

### 💻Running docker with GUI

Docker is typically headless but potentially can use something like XVBF and VNC for non-headless mode. Pairing Xvfb (X Virtual Framebuffer) with VNC (Virtual Network Computing) allows you to create a virtual desktop that can be accessed remotely. This setup is useful for running GUI applications on headless servers and accessing them via a VNC client.

**Install a VNC client:**

I used [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/?__lai_s=0.14206349206349206&__lai_sr=10-14&__lai_sl=l) but it made me make an account (free). If there are better options I think they would be easy to implement since the ports are all exposed and and VNC clients could open a GUI.

You may be able to use my RealVNC Viewer account:

username: `mia@tryshift.com`

pw: `uxj_rpb3veu-AMT_vxt`

### 🏃‍♀️How to run in Docker

You need [docker desktop](https://www.docker.com/products/docker-desktop/) running

`docker build -t selenium-container . -f app/Dockerfile`

_Needed to add `-f app/Dockerfile` because `app/` isn’t my root directory_

**Non-headless:**

`docker run  --rm -p 5900:5900 selenium-container`

Once the test is running open your VNC client, click new connection and enter the address `localhost:5900`

**NOTE:** the tests must be running in order for the connection to work as the image is removed once tests run. I have been adding a long sleep to `TestRdbrck.cs` in order to test the VNC Viewer

**Headless:**

`docker run --rm -p 5900:5900 selenium-container --headless`

## 🏡How to run locally

First you need to manually download the correct [chrome driver](https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json). Place the `exe` file into the `app/drivers` directory.

Navigate to the `src/` directory

`dotnet clean`

`dotnet build`

`dotnet run`

### 🔮Future Considerations

**scripts directory**

In the future when the test suite is hooked up to the dockerfile and constant changes are being made to the `src/` file, we may want to consider using volumes to map the docker directory to our local directory. (So we don’t need to rebuild the image each time).
This results in an annoyingly long run command as we need to include the file path. A consideration for this is creating a `scripts` directory. This will also help for when we set up other OS and have different run commands for each.

```bash
scripts/
├── run_mac_x86.sh
├── run_mac_ARM.sh
├── run_windows.sh
├── run_linux.sh
```

```bash
run_windows.sh
#!/bin/bash

*docker run --rm -v "C:\Users\Mia Brooker\dv\seleniu*m-docker\app\src" -p 5900:5900 selenium-container

```

**chromedriver script**

Using the webdriver is tricky as the latest stable build is for chrome 114. Instead I hard coded the latest linux chromedriver from this chromedriver repo:

[`https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json`](https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json)

Docker: the zip url is hard coded in the Dockerfile

Locally: the exe is unpacked and placed in the drivers/ directory

A possible future consideration is creating a script that fetches the chromedriver itself and placed it in the locations mentioned.

**Different VNC Client**

As I mentioned above, the VNC client I used RealVNC Viewer, made me make a free account which could be annoying. There might be better options for us out there. However, since all the ports are opened you could probably use any VNC Client

**Installing WinAppDriver**

To install WinAppDriver in your Dockerfile, we need to make sure the Docker container has a Windows base image, as WinAppDriver is designed to run on Windows. Since the current Dockerfile is based on Linux (using a .NET SDK and runtime), you'll need to adjust it to use a Windows base image.

So We will need to do something like this:

```
FROM mcr.microsoft.com/dotnet/sdk:8.0-windowsservercore-ltsc2019 AS build-env
WORKDIR /app

...

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0-windowsservercore-ltsc2019
WORKDIR /app
COPY --from=build-env /app/src/out .
```

We can use multiple dockerfiles so a separate one will need to be made for Mac🍎capability.
