from flask import (
	Blueprint,
	request,
	jsonify,
	Response,
)

bp = Blueprint("board", __name__, url_prefix="/board")


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

	# Return success message
	rep = jsonify(
		{
			"msg": f"Successfully created user with ID '{user.user_id}'and email '{user.email}'"
		}
	)
	rep.status_code = 201
	return rep

