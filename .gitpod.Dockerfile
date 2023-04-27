# this project uses workspace-full but if you only want to run Starlark
# use workspace-base instead
# can't use that here as this needs Go and TS
FROM gitpod/workspace-base

RUN echo "deb [trusted=yes] https://apt.fury.io/kurtosis-tech/ /" | sudo tee /etc/apt/sources.list.d/kurtosis.list
RUN sudo apt update
RUN sudo apt install kurtosis-cli:0.76.3

RUN kurtosis analytics enable