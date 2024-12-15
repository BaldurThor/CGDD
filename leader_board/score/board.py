import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from dotenv import load_dotenv
from os import getenv

from flask import (
	Blueprint,
	request,
	jsonify,
	Response,
)


bp = Blueprint("board", __name__, url_prefix="/board")

load_dotenv()

DB_URL = getenv("FIREBASE_DB_URL")

cred = credentials.Certificate("firebase_cred.json")
firebase_admin.initialize_app(cred, {
	'databaseURL': DB_URL
})

db = firestore.client()



@bp.post("/")
def create_user() -> Response:
	"""
	Handles registering a new user
	POST /user

	Body (* required)
	- *email: string
	- *password: string
	- *first_name: string
	- *last_name: string
	"""
	body: dict[str, str] = request.get_json()

	print(body)

	ref = db.collection("fishing").document()

	ref.set({"test":1234})

	# Return success message
	rep = jsonify(
		{
			"msg": "aw man"
		}
	)
	print("Got request")
	rep.status_code = 201
	return rep


@bp.get("/")
def get_data() -> Response:

	ref = db.collection("fishing").stream()
	for doc in ref:
		print(doc.to_dict())


	# Return success message
	rep = jsonify(
		{
			"msg": "aw man"
		}
	)
	print("Got request")
	rep.status_code = 201
	return rep

