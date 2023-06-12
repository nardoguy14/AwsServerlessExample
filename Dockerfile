FROM --platform=linux/amd64 python:3.8 as build
WORKDIR /src
COPY /src ./src/
RUN pip3 install -r ./src/requirements.txt
CMD gunicorn --bind 0.0.0.0:80 src.app:app -k uvicorn.workers.UvicornWorker