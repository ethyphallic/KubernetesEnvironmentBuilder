FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    golang-go \
    && rm -rf /var/lib/apt/lists/*

# Install jsonnet
RUN go install github.com/google/go-jsonnet/cmd/jsonnet@latest
ENV PATH="/root/go/bin:${PATH}"

# Install kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
    && chmod 644 /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y nano

RUN mkdir -p /root/.kube
WORKDIR /app

COPY . /app

ENTRYPOINT [ "/bin/bash" ]
