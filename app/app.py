from flask import Flask
from flask_restful import Resource, Api, reqparse
from flask_cors import CORS
import json

application = Flask(__name__)
# application.config['BUNDLE_ERRORS'] = True
api = Api(application)
CORS(application, send_wildcard=True)

with open("./users.json", "r") as f:
    users = json.load(f)

class arithmetic(Resource):
    def post(self):
        try:
            self.parser = reqparse.RequestParser()
            self.parser.add_argument('x', type=int, required=True, location='args', help='X Value')
            self.parser.add_argument('y', type=int, required=True, location='args', help='Y Value')
            self.parser.add_argument('operation', type=str, location='args', help='Mathematical Operators')
            self.args = self.parser.parse_args()

            x = (self.args['x'])
            y = (self.args['y'])
            ops = (self.args['operation'])

            if ops == '-':
                return {'results': x - y}
            elif ops == '*':
                return {'results': x * y}
            elif ops == '/':
                return {'results': x / y}
            else:
                return {'results': x + y}
            
        except Exception as e:
            return {'status': str(e)}

class Users(Resource):
    def get(self):
        ## TODO: Get Users either by id or get all Users
    
    def post(self):
        ## TODO: Create User
    
    def update(self):
        ## TODO: Update User
    
    def delete(self):
        ## TODO: Delete User

        
        
api.add_resource(arithmetic, '/arithmetic')
api.add_resource(Users, '/users')

if __name__ == '__main__':
    application.run(host='0.0.0.0', threaded=True)