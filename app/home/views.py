# coding=utf-8
from .import home
from flask import render_template, redirect, url_for





@home.route("/login/")
def login():
    """ 登陆视图 """
    return render_template('home/login.html')


@home.route("/logout/")
def logout():
    """ 退出视图 """
    return redirect(url_for('home.index'))


@home.route('/regist/')
def regist():
    """ 注册页面 """
    return render_template('home/regist.html')


@home.route('/user/')
def user():
    """会员中心"""
    return render_template('home/user.html')


@home.route('/pwd/')
def pwd():
    """修改密码"""
    return render_template('home/pwd.html')


@home.route('/loginlog/')
def loginlog():
    """登陆日志"""
    return render_template('home/loginlog.html')


@home.route('/moviecol/')
def moviecol():
    """电影收藏"""
    return render_template('home/moviecol.html')


@home.route('/comments/')
def comments():
    """电影收藏"""
    return render_template('home/comments.html')


@home.route("/")
def index():
    """ 首页视图 """
    return render_template('home/index.html')


@home.route("/animation/")
def animation():
    """ 轮播视图 """
    return render_template('home/animation.html')


@home.route("/search/")
def search():
    """ 搜索视图 """
    return render_template('home/search.html')


@home.route("/play/")
def play():
    """ 详情视图 """
    return render_template('home/play.html')


