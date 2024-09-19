FROM openjdk:jdk-slim

ENV GHIDRA_RELEASE_TAG Ghidra_11.0.3_build
ENV GHIDRA_VERSION ghidra_11.0.3_PUBLIC_20240410
ENV GRADLE_VERSION gradle-8.10.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget unzip fontconfig make gcc g++ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/NationalSecurityAgency/ghidra/releases/download/${GHIDRA_RELEASE_TAG}/${GHIDRA_VERSION}.zip && \
    unzip -d ghidra ${GHIDRA_VERSION}.zip && \
    rm ${GHIDRA_VERSION}.zip && \
    mv ghidra/ghidra_* /opt/ghidra

RUN wget https://services.gradle.org/distributions/${GRADLE_VERSION}-bin.zip && \
    unzip -d gradle ${GRADLE_VERSION}-bin.zip && \
    rm ${GRADLE_VERSION}-bin.zip && \
    mv gradle /opt && \
    PATH=$PATH:/opt/gradle/${GRADLE_VERSION}/bin /opt/ghidra/support/buildNatives && \
    rm -rf /opt/gradle && \
    apt-get remove -y make gcc g++ && \
    apt-get autoremove -y

ENV PATH="/opt/ghidra:/opt/ghidra/support:${PATH}"
