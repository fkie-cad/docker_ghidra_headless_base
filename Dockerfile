FROM amazoncorretto:21.0.11-alpine3.20

ENV GHIDRA_RELEASE_TAG=Ghidra_11.3.2_build
ENV GHIDRA_VERSION_NAME=ghidra_11.3.2_PUBLIC
ENV GHIDRA_VERSION_DATE=20250415
ENV GHIDRA_VERSION=${GHIDRA_VERSION_NAME}_${GHIDRA_VERSION_DATE}

RUN apk add --no-cache unzip curl

RUN curl --proto '=https' --tlsv1.2 -LO https://github.com/NationalSecurityAgency/ghidra/releases/download/${GHIDRA_RELEASE_TAG}/${GHIDRA_VERSION}.zip \
    && unzip -d ghidra ${GHIDRA_VERSION}.zip > /dev/null \
    && rm ${GHIDRA_VERSION}.zip \
    && mv ghidra/ghidra_* /opt/ghidra

ENV PATH="/opt/ghidra:/opt/ghidra/support:${PATH}"
