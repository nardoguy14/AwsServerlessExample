FROM python:3.8
WORKDIR /src
COPY /src ./src/
RUN pip3 install -r ./src/requirements.txt
CMD ["uvicorn", "src.app:app"]
EXPOSE 8000
