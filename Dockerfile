FROM ubuntu:24.04

# Install dependencies
RUN echo "Etc/UTC" > /etc/timezone
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    golang-go \
    python3.12-venv \
    pip\
    # Helm specific:
    && curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    # Kubectl specific:
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
    && chmod 644 /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -y \
    # Install bash-completion
    bash-completion \
    # Install jq & nano
    jq \
    nano \
    # Install helm
    helm \
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

RUN python3 -m venv .venv
RUN echo "alias python3=/app/.venv/bin/python3" >> ~/.bashrc
RUN /app/.venv/bin/python3 -m pip install -r /app/requirements.txt

# Source interact script
RUN echo "source /app/interact.sh" >> ~/.bashrc
# Setup Bash-completion for kubectl
RUN echo "source <(kubectl completion bash)" >> ~/.bashrc
RUN echo "source /etc/bash_completion" >> ~/.bashrc
# Fix permission if not fixed already 
RUN echo 'if [ ! -f "/tmp/.permissions-fixed" ]; then chmod -R a+w /app && touch /tmp/.permissions-fixed; fi' >> ~/.bashrc
RUN echo "source /app/entrypoint.sh" >> ~/.bashrc

CMD [ "/bin/bash" ]
