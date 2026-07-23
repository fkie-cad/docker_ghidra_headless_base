FROM amazoncorretto:21.0.11-alpine3.20 AS builder

ENV GHIDRA_RELEASE_TAG=Ghidra_11.2.1_build
ENV GHIDRA_VERSION_NAME=ghidra_11.2.1_PUBLIC
ENV GHIDRA_VERSION_DATE=20241105
ENV GHIDRA_VERSION=${GHIDRA_VERSION_NAME}_${GHIDRA_VERSION_DATE}

RUN apk add --no-cache unzip curl bash build-base gcc g++ flex bison zlib-dev

RUN curl --proto '=https' --tlsv1.2 -LO https://github.com/NationalSecurityAgency/ghidra/releases/download/${GHIDRA_RELEASE_TAG}/${GHIDRA_VERSION}.zip \
    && unzip -d ghidra ${GHIDRA_VERSION}.zip > /dev/null \
    && rm ${GHIDRA_VERSION}.zip \
    && mv ghidra/ghidra_* /opt/ghidra \
    && rm -rf /opt/ghidra/docs /opt/ghidra/Ghidra/Debug \
    && find /opt/ghidra | grep -E "(win|mac|linux)_(x86|arm)_64\$" | xargs rm -rf

WORKDIR /opt/ghidra/support/gradle
RUN ./gradlew buildNatives

FROM amazoncorretto:21.0.11-alpine3.20

RUN apk add --no-cache bash libstdc++ libgcc

COPY --from=builder /opt/ghidra /opt/ghidra

ENV PATH="/opt/ghidra:/opt/ghidra/support:${PATH}"
