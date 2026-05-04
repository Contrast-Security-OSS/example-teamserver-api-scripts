FROM python:3.10-alpine@sha256:b974a5de91b4ac6da8313502cd5bfe65c499e390d32658e1f2deea26fa5afb14

WORKDIR /usr/src/app
RUN mkdir output

ADD requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
ADD *.py ./

CMD ["echo", "Please refer to README for use of available scripts in this container."]
