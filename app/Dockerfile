# Use the official .NET SDK image from the Docker Hub
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY app/src/*.csproj ./src/
RUN dotnet restore ./src/SeleniumDocker.csproj

# Copy everything else and build
COPY app/src/ ./src/
WORKDIR /app/src
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app
COPY --from=build-env /app/src/out .

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    libglib2.0-0 \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1 \
    libx11-6 \
    libxext6 \
    libxrandr2 \
    libasound2 \
    libatk1.0-0 \
    libgtk-3-0 \
    libdbus-1-3 \
    xvfb \
    x11vnc \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Download and install ChromeDriver to /app/drivers directory
# Chromedriver script is HARDCODED. See ReadMe and future considerations: chromedriver script
RUN mkdir -p /app/drivers && \
    wget -O /tmp/chromedriver-linux64.zip https://storage.googleapis.com/chrome-for-testing-public/125.0.6422.76/linux64/chromedriver-linux64.zip && \
    unzip /tmp/chromedriver-linux64.zip -d /tmp/ && \
    mv /tmp/chromedriver-linux64/chromedriver /app/drivers/chromedriver && \
    chmod +x /app/drivers/chromedriver && \
    rm -rf /tmp/chromedriver-linux64.zip /tmp/chromedriver-linux64

# Set environment variable to indicate running in Docker
ENV RUNNING_IN_DOCKER=true
ENV DISPLAY=:99

COPY app/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Expose the VNC port
EXPOSE 5900

ENTRYPOINT ["/app/entrypoint.sh"]
