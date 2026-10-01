# syntax=docker/dockerfile:1

FROM python:3.14-slim

LABEL version="1.0.0"
LABEL description="Example processing of YAML file"
LABEL author="Frank H Jung"

WORKDIR app

RUN pip install pyyaml==5.4.1

ADD  employees employees
ADD  utils utils

COPY logger.properties .
COPY read_yaml.py .

ENTRYPOINT ["./read_yaml.py"]

CMD ["--help"]
