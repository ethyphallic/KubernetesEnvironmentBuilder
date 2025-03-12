FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    golang-go \
    # Kubectl specific:
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
    && chmod 644 /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -y \
    # Install jq & nano
    jq \
    nano \
    # Install kubectl
    kubectl \
    # Install k9s
    && curl -sS https://webinstall.dev/k9s | bash \
    # Install jsonnet
    && go install github.com/google/go-jsonnet/cmd/jsonnet@latest \
    # Cleanup
    && apt-get purge -y golang-go \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /root/.cache /tmp/* /var/tmp/* \
    && rm -rf /root/go/pkg /root/go/src/* \
    && rm -rf /root/.kube

ENV PATH="/root/go/bin:${PATH}"

RUN mkdir -p /root/.kube
WORKDIR /app

COPY . /app

RUN echo "source /app/interact.sh" >> ~/.bashrc
# Fix permission if not fixed already 
RUN echo 'if [ ! -f "/tmp/.permissions-fixed" ]; then chmod -R a+w /app && touch /tmp/.permissions-fixed; fi' >> ~/.bashrc

ENTRYPOINT [ "/bin/bash" ]
