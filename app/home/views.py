# coding=utf-8
from . import home
from flask import render_template, redirect, url_for, flash, session, request
from app.home.forms import RegistForm, LoginForm, UserdetailForm, PwdForm
from app.models import User, Userlog,Preview
from werkzeug.security import generate_password_hash
from werkzeug.utils import secure_filename
from app import db, app
from functools import wraps
import uuid
import os
import datetime


# 登陆装饰器
def user_login_req(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user' not in session:
            return redirect(url_for('home.login', next=request.url))
        return f(*args, **kwargs)

    return decorated_function


# 修改文件名称
def change_filename(filename):
    fileinfo = os.path.splitext(filename)
    filename = datetime.datetime.now().strftime("%Y%m%d%H%M%S") + str(uuid.uuid4().hex) + fileinfo[-1]
    return filename


@home.route("/login/", methods=['GET', 'POST'])
def login():
    """ 登陆视图 """
    form = LoginForm()
    if form.validate_on_submit():
        data = form.data
        user = User.query.filter_by(name=data['name']).first()
        if not user.check_pwd(data['pwd']):
            flash('密码错误!', 'err')
            return redirect(url_for('home.login'))
        session['user'] = user.name
        session['user_id'] = user.id
        userlog = Userlog(
            user_id=user.id,
            ip=request.remote_addr
        )
        db.session.add(userlog)
        db.session.commit()
        return redirect(url_for('home.user'))
    return render_template('home/login.html', form=form)


@home.route("/logout/")
def logout():
    """ 退出视图 """
    session.pop('user', None)
    session.pop('user_id', None)
    return redirect(url_for('home.index'))


@home.route('/regist/', methods=['GET', 'POST'])
def regist():
    """ 注册页面 """
    form = RegistForm()
    if form.validate_on_submit():
        data = form.data
        print data
        user = User(
            name=data['name'],
            email=data['email'],
            phone=data['phone'],
            pwd=generate_password_hash(data['pwd']),
            uuid=uuid.uuid4().hex
        )
        db.session.add(user)
        db.session.commit()
        flash('注册成功!', 'ok')
    return render_template('home/regist.html', form=form)


# 会员修改资料
@home.route("/user/", methods=["GET", "POST"])
@user_login_req
def user():
    form = UserdetailForm()
    user = User.query.get(int(session["user_id"]))
    form.face.validators = []
    if request.method == "GET":
        form.name.data = user.name
        form.email.data = user.email
        form.phone.data = user.phone
        form.info.data = user.info
    if form.validate_on_submit():
        data = form.data
        file_face = secure_filename(form.face.data.filename)
        if not os.path.exists(app.config["FC_DIR"]):
            os.makedirs(app.config["FC_DIR"])
            os.chmod(app.config["FC_DIR"], "rw")
        user.face = change_filename(file_face)
        form.face.data.save(app.config["FC_DIR"] + user.face)

        name_count = User.query.filter_by(name=data["name"]).count()
        if data["name"] != user.name and name_count == 1:
            flash("昵称已经存在！", "err")
            return redirect(url_for("home.user"))

        email_count = User.query.filter_by(email=data["email"]).count()
        if data["email"] != user.email and email_count == 1:
            flash("邮箱已经存在！", "err")
            return redirect(url_for("home.user"))

        phone_count = User.query.filter_by(phone=data["phone"]).count()
        if data["phone"] != user.phone and phone_count == 1:
            flash("手机号码已经存在！", "err")
            return redirect(url_for("home.user"))

        user.name = data["name"]
        user.email = data["email"]
        user.phone = data["phone"]
        user.info = data["info"]
        db.session.add(user)
        db.session.commit()
        flash("修改成功！", "ok")
        return redirect(url_for("home.user"))
    return render_template("home/user.html", form=form, user=user)


@home.route('/pwd/', methods=['GET', 'POST'])
@user_login_req
def pwd():
    """修改密码"""
    form = PwdForm()
    if form.validate_on_submit():
        data = form.data
        user = User.query.filter_by(name=session["user"]).first()
        if not user.check_pwd(data["old_pwd"]):
            flash("旧密码错误！", "err")
            return redirect(url_for('home.pwd'))
        user.pwd = generate_password_hash(data["new_pwd"])
        db.session.add(user)
        db.session.commit()
        flash("修改密码成功，请重新登录！", "ok")
        return redirect(url_for('home.login'))
    return render_template("home/pwd.html", form=form)


@home.route('/loginlog/<int:page>', methods=['GET'])
@user_login_req
def loginlog(page=None):
    """登陆日志"""
    if page is None:
        page = 1
    page_data = Userlog.query.filter_by(
        user_id=int(session['user_id'])
    ).order_by(
        Userlog.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template('home/loginlog.html', page_data=page_data)


@home.route('/moviecol/')
@user_login_req
def moviecol():
    """电影收藏"""
    print ('1111')
    return render_template('home/moviecol.html')


@home.route('/comments/')
@user_login_req
def comments():
    """评论"""
    return render_template('home/comments.html')


@home.route("/")
def index():
    """ 首页视图 """
    return render_template('home/index.html')


@home.route("/animation/")
def animation():
    """ 轮播视图 """
    data = Preview.query.all()
    return render_template('home/animation.html',data=data)


@home.route("/search/")
def search():
    """ 搜索视图 """
    return render_template('home/search.html')


@home.route("/play/")
def play():
    """ 详情视图 """
    return render_template('home/play.html')
