from flask import Flask,request,jsonify
import recommendation

app = Flask(__name__)

suggestion_list=[...]
@app.route('/', methods=['GET'])
def recommend_blogs():
    result = recommendation.recommend(request.args.get('token'))
    return jsonify(result)

if __name__=='__main__':
    app.run(port = 5000, debug = True)