"""User details"""
from flask_restful import Resource, abort
from bson.objectid import ObjectId
from bson import json_util
from flask import jsonify
import zeus_api
import json

# local python modules
from zeus_api.controllers.auth import access_token_required, token_required

# def missing_user_id(id):
#     if id not in zeus_api.user.find_one({"_id": id}):
#         abort(404, message="User {} doesn't exist".format(id))


class User_details(Resource):
    @access_token_required
    def get(self, son):
        print(son)
        # identifier = JSONEncoder(userid)
        # print("Current user: ", current_user)
        # if not current_user:
        #     return jsonify({'message': 'must authenticate'})
        # print(current_user)
        return jsonify({'success': 'hello user'})
