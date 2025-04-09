from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS # type: ignore

app = Flask(__name__)
CORS(app, resources={"/*": {"origins": "http://35.171.6.244"}}) # ADD IP WITHOUT PORT
app.config.from_object('config.Config')

db = SQLAlchemy(app)

# Database model
class Name(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

# Create the table if it doesn't exist
with app.app_context():
    db.create_all()

# Route to save a name
@app.route('/add_name', methods=['POST'])
def add_name():
    name_data = request.json.get('name')
    if not name_data:
        return jsonify({"error": "Name is required"}), 400

    new_name = Name(name=name_data)
    db.session.add(new_name)
    db.session.commit()
    return jsonify({"message": "Name added successfully!"}), 201

# Route to fetch all names
@app.route('/get_names', methods=['GET'])
def get_names():
    names = Name.query.all()
    return jsonify([name.name for name in names]), 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)
