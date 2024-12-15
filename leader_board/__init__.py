import os

from flask import Flask
from flask_cors import CORS
from collections.abc import Mapping
from dotenv import load_dotenv

from .score import board_bp

# Replace with your Firebase project credentials


def create_app(test_config: Mapping[str, object] | None = None) -> Flask:
	"""
	create and configure the app
	"""

	load_dotenv()

	app = Flask(__name__, instance_relative_config=True)
	app.config.from_mapping(
		SECRET_KEY="dev",
		DATASTORE_PATH=os.path.join(app.instance_path, "store.json"),
		LOAD_FROM_FILE=True,
	)
	
	CORS(app)

	# Register blueprints (e.g., user, group)
	
	app.register_blueprint(board_bp)

	return app
