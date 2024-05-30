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

Navigate to the `app/` directory

`docker build -t selenium-container .`

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
