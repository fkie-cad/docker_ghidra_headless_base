FROM openjdk:jdk-slim


ENV GHIDRA_VERSION ghidra_9.2.1_PUBLIC_20201215

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://ghidra-sre.org/${GHIDRA_VERSION}.zip && \
    unzip -d ghidra ${GHIDRA_VERSION}.zip && \
    rm ${GHIDRA_VERSION}.zip && \
    mv ghidra/ghidra_* /opt/ghidra

ENV PATH="/opt/ghidra:/opt/ghidra/support:${PATH}"
