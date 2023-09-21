FROM python:3.9-alpine3.17 as builder

ARG BW_VERSION="v0.6.3"

ENV APP="/app/bookwyrm"
ENV VENV="/venv/bookwyrm"
ENV BW_URL="https://github.com/bookwyrm-social/bookwyrm.git"

WORKDIR $APP

RUN apk add --no-cache alpine-sdk linux-headers git libffi-dev && \
    apk add --no-cache gettext gettext-libs tidyhtml libpq-dev && \
    git clone --depth 1 --branch $BW_VERSION $BW_URL . && \
    python -m venv $VENV && \
    $VENV/bin/pip install --no-cache-dir -U "setuptools>=65.5.1" && \
    $VENV/bin/pip install --no-cache-dir -U -r requirements.txt

RUN $VENV/bin/pip list


FROM python:3.9-alpine3.17

ARG USERNAME=bookwyrm
ENV VENV="/venv/bookwyrm"
ENV APP="/app/bookwyrm"
ENV PATH="${VENV}/bin:${PATH}"

RUN adduser -DH $USERNAME && \
    apk add --no-cache gettext gettext-libs libffi libpq

USER $USERNAME

WORKDIR $APP

COPY --from=builder --chown=$USERNAME:$USERNAME $VENV $VENV
COPY --from=builder --chown=$USERNAME:$USERNAME $APP $APP
COPY ./entrypoint.sh $APP/entrypoint.sh

RUN mkdir ${APP}/static ${APP}/images

ENTRYPOINT ["/app/bookwyrm/entrypoint.sh"]
