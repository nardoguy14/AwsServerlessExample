FROM python:3.8
WORKDIR /src
COPY /src ./src/
RUN pip3 install -r ./src/requirements.txt
CMD gunicorn --bind 0.0.0.0:80 src.app:app -k uvicorn.workers.UvicornWorker