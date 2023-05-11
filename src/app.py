import csv
from io import StringIO
import os

from pokemontcgsdk import Card
from mangum import Mangum
from fastapi import FastAPI, UploadFile
from pokemontcgsdk import RestClient
from starlette.middleware.cors import CORSMiddleware

RestClient.configure(os.environ.get("PokemonTgcApiKey"))
app = FastAPI()

origins = [
    "*"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/dragonshield/cards/details")
async def upload_dragonshield_file(file: UploadFile):
    json_output_for_dex = []
    json_output_for_selling = []

    rows = getPokemonFromDragonShield(file)

    line_count = 0
    for row in rows:
        #headers
        if line_count == 0:
            print(f'{", ".join(row)}')
            line_count += 1
        else:
            #pokemon rows
            print(f'{row}')
            id = f"{row[3]}-{row[2]}"
            id, tcgplayer, images, name = validateCardAgainstTgc(row, id)
            if id is None:
                continue
            json_output_for_dex.append({
                "id": id,
                "quantity":1
            })
            json_output_for_selling.append({
                "id": id,
                "tgcplayer": tcgplayer,
                "images": images,
                "name": name
            })
            line_count += 1
    print(f'Processed {line_count} lines.')
    print(json_output_for_dex)
    return json_output_for_selling

def getPokemonFromDragonShield(file: UploadFile):
    rows = []
    exportedfile = StringIO(file.file.read().decode())
    csv_reader = csv.reader(exportedfile, delimiter=',')
    for row in csv_reader:
        rows.append(row)
        print(row)
    return rows

def validateCardAgainstTgc(row, id):
    card = Card.find(id)
    tcgplayer = card.tcgplayer
    images = card.images

    print(card)
    if card.name != row[1]:
        if int(row[2]) < 10:
            num = f'0{row[2]}'
        else:
            num = row[2]
        id = f"{row[3]}tg-TG{num}"
        card = Card.find(id)
        print(card.name)
        if card.name != row[1]:
            return None
    return (id, tcgplayer, images, card.name)

lambda_handler = Mangum(app, lifespan="off")
