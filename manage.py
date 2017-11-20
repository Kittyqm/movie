# coding:utf8
from app import app
from flask_script import Manager

manage = Manager(app)

if __name__ == "__main__":
    manage.run(host='0.0.0.0', port=8290)
