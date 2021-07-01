FROM registry.fedoraproject.org/fedora-minimal:33 AS build

ARG VERSION=0.10.0

RUN microdnf -y --nodocs install libolm python sqlite-libs \
    gcc libolm-devel python-devel python-wheel sqlite-devel
RUN install -d /opt/wheels
RUN python -m pip wheel --wheel-dir=/opt/wheels --find-links=/opt/wheels "pantalaimon==${VERSION}"

FROM registry.fedoraproject.org/fedora-minimal:33

ARG UID=1000
ARG HOMEDIR=/opt/pantalaimon

RUN microdnf -y --nodocs install libolm python sqlite-libs \
    && microdnf -y clean all

RUN useradd -rU -md "/opt/pantalaimon" -u ${UID} pantalaimon

USER pantalaimon
WORKDIR /opt/pantalaimon

COPY --from=build --chown=pantalaimon:pantalaimon /opt/wheels /tmp/wheels
COPY --chown=pantalaimon:pantalaimon matrix.conf /opt/pantalaimon

RUN python -m venv --prompt=pantalaimon /opt/pantalaimon/.venv
RUN /opt/pantalaimon/.venv/bin/python -m pip --no-cache-dir install \
    --no-index --find-links=/tmp/wheels pantalaimon
RUN install -d /opt/pantalaimon/data
RUN rm -rf /tmp/wheels

ENV PATH=/opt/pantalaimon/.venv/bin:${PATH}

CMD ["pantalaimon", "-c", "/opt/pantalaimon/matrix.conf", "--data-path", "/opt/pantalaimon/data"]

VOLUME ["/opt/pantalaimon/data"]
EXPOSE 8008/tcp

