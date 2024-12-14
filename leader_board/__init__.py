import os

from flask import Flask
from collections.abc import Mapping

from app.db import UserStorage, GroupStorage, EventStorage
from .score import board


def create_app(test_config: Mapping[str, object] | None = None) -> Flask:
	"""
	create and configure the app
	"""

	app = Flask(__name__, instance_relative_config=True)
	app.config.from_mapping(
		SECRET_KEY="dev",
		DATASTORE_PATH=os.path.join(app.instance_path, "store.json"),
		LOAD_FROM_FILE=True,
	)

	if test_config is None:
		# load the instance config, if it exists, when not testing
		app.config.from_pyfile("config.py", silent=True)
	else:
		# load the test config if passed in
		app.config.from_mapping(test_config)

	# ensure the instance folder exists
	try:
		os.makedirs(app.instance_path)
	except OSError:
		pass

	app.teardown_appcontext(UserStorage.dispose)
	app.teardown_appcontext(GroupStorage.dispose)
	app.teardown_appcontext(EventStorage.dispose)

	# Register blueprints (e.g., user, group)
	app.register_blueprint(user_bp)
	app.register_blueprint(event_bp)
	app.register_blueprint(group_bp)

	return app
