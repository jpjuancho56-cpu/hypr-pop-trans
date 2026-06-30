import sys
import json
import spacy

try:
    nlp = spacy.load("en_core_web_sm")
except Exception:
    # Por si acaso no se ha descargado el modelo en el entorno de ejecución
    import os
    os.system("python -m spacy download en_core_web_sm")
    nlp = spacy.load("en_core_web_sm")

def procesar(texto):
    doc = nlp(texto.strip())
    # Tomamos la primera palabra significativa encontrada
    for token in doc:
        if not token.is_punct and not token.is_space:
            return {
                "lemma": token.lemma_.lower(),
                "pos_tag": token.pos_
            }
    # Si es solo puntuación o vacío
    return {"lemma": texto.strip().lower(), "pos_tag": "UNKNOWN"}

if __name__ == "__main__":
    if len(sys.argv) > 1:
        resultado = procesar(sys.argv[1])
        print(json.dumps(resultado))
    else:
        print(json.dumps({"lemma": "", "pos_tag": "UNKNOWN"}))
        