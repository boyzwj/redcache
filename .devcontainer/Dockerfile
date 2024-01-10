FROM 192.168.15.200:80/library/asdf-env:1.3

ARG GIT_USER_NAME
ARG SVN_USER_NAME
ARG SVN_PASSWORD
ENV GIT_USER_NAME=${GIT_USER_NAME}\
    ERL_AFLAGS="-kernel shell_history enabled"

RUN git config --global --add safe.directory /ws/redcache
RUN git config --global --add safe.directory /ws/m1x/redcache

WORKDIR /ws/m1x
