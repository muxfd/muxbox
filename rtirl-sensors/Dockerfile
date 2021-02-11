FROM python:3-alpine

RUN apk add --no-cache gpsd

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./daemon.py" ]