FROM alpine:latest AS downloader

# Set PocketBase version
ARG PB_VERSION=0.24.4

# Download PocketBase
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip \
    && unzip pocketbase_${PB_VERSION}_linux_amd64.zip \
    && chmod +x /pocketbase

# Create final minimal image
FROM scratch

# Copy PocketBase binary from downloader
COPY --from=downloader /pocketbase /pocketbase

# Create a non-root user
# often the first non-root user is id 1000
USER 1000:1000

# Expose the default PocketBase port
EXPOSE 8090

# Define volume for persistence
VOLUME /pb_data

# Set the entrypoint & command
ENTRYPOINT ["/pocketbase"]
CMD ["serve", "--http=0.0.0.0:8090"]
