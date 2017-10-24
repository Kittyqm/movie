# coding=utf-8
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import os

from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
import pymysql
app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql://root:mysql@127.0.0.1:3306/movies"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
app.config["SECRET_KEY"] = "3021d87718e043f49dad499fe3494a9d"
app.config['UP_DIR'] = os.path.join(os.path.abspath(os.path.dirname(__file__)), 'static/uploads/')
app.config['FC_DIR'] = os.path.join(os.path.abspath(os.path.dirname(__file__)), 'static/uploads/users')
app.debug = True
db = SQLAlchemy(app)

from app.home import home as home_blueprint
from app.admin import admin as admin_blueprint

app.register_blueprint(home_blueprint)
app.register_blueprint(admin_blueprint, url_prefix="/admin")

# 微信配置
WECHAT_WEBSITE_APP_ID = "wx9d2b3cec1b25d4a4"
WECHAT_WEBSITE_APP_SECRET = "80cc447f0fb17b7b74733666b99ab3b6"


@app.errorhandler(404)
def page_not_fount(error):
    return render_template('home/404.html'), 404
