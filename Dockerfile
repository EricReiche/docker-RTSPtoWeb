FROM golang:alpine

ARG COMMIT=1e9c2b7f48d0ff0c7a5c43e1eca1f8611877fad8

# Set necessary environmet variables needed for our image
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Move to working directory /build
WORKDIR /build

# Get Git
RUN apk add --no-cache git

# Copy and download dependency using go mod
RUN git clone https://github.com/deepch/RTSPtoWeb.git && cd RTSPtoWeb && git checkout $COMMIT && go build

# Move to /dist directory as the place for resulting binary folder
WORKDIR /dist

COPY config/config.json /dist/
COPY start.sh /

# Copy binary from build to main folder
RUN cp /build/RTSPtoWeb/RTSPtoWeb .
RUN cp -r /build/RTSPtoWeb/web .
RUN chmod a+x /dist/RTSPtoWeb

# Export necessary port & volume
EXPOSE 8083
VOLUME /config

# Command to run when starting the container
ENTRYPOINT "/start.sh"