# coding=utf-8
import sys

reload(sys)
sys.setdefaultencoding('utf-8')
from . import admin
from flask import Flask, render_template, flash, redirect, url_for, session, request
from app.admin.forms import LoginForm, TagFrom, MovieForm, PrevieForm, PwdForm, AuthForm, RoleForm, AdminForm
from app.models import Admin, Tag, Movie, Preview, User, Comment, Moviecol, Oplog, Adminlog, Userlog, Auth, Role
from functools import wraps
from app import db, app
from werkzeug.utils import secure_filename  # 将filename改成一个安全的名称
import os
import uuid
import datetime


# 上下问处理器
@admin.context_processor
def tpl_extra():
    data = dict(
        online_time=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    )
    return data


def admin_login_req(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.has_key('admin') or session['admin'] is None:
            return redirect(url_for('admin.login', next=request.url))
        return f(*args, **kwargs)

    return decorated_function


# 修改文件名称
def change_filename(filename):
    fileinfo = os.path.splitext(filename)
    filename = datetime.datetime.now().strftime("%Y%m%d%H%M%S") + str(uuid.uuid4().hex) + fileinfo[-1]
    return filename


@admin.route("/")
@admin_login_req
def index():
    """ 后台首页 """
    return render_template('admin/index.html')


@admin.route("/login/", methods=["GET", "POST"])
def login():
    """ 后台登陆 """
    form = LoginForm()
    # 表示表单提交的时候要进行验证
    if form.validate_on_submit():
        data = form.data
        admin = Admin.query.filter_by(name=data["account"]).first()
        if not admin.check_pwd(data['pwd']):
            flash('密码错误!', 'err')
            return redirect(url_for('admin.login'))
        session['admin'] = data['account']
        session['admin_id'] = admin.id
        adminlog = Adminlog(
            admin_id=admin.id,
            ip=request.remote_addr
        )
        db.session.add(adminlog)
        db.session.commit()
        return redirect(request.args.get('next') or url_for('admin.index'))
    return render_template('admin/login.html', form=form)


@admin.route("/logout/")
@admin_login_req
def logout():
    """ 后台退出 """
    session.pop('admin', None)
    session.pop('admin_id', None)
    return render_template('admin/login.html')


@admin.route("/pwd/", methods=['GET', 'POST'])
@admin_login_req
def pwd():
    """后台密码修改"""
    form = PwdForm()
    if form.validate_on_submit():
        data = form.data
        admin = Admin.query.filter_by(name=session['admin']).first()
        from werkzeug.security import generate_password_hash
        admin.pwd = generate_password_hash(data['new_pwd'])
        db.session.add(admin)
        db.session.commit()
        flash('修改密码成功!', 'ok')
        redirect(url_for('admin.logout'))
    return render_template('admin/pwd.html', form=form)


@admin.route("/tag/add/", methods=['GET', 'POST'])
@admin_login_req
def tag_add():
    """后台添加标签页"""
    form = TagFrom()
    if form.validate_on_submit():
        data = form.data
        tag = Tag.query.filter_by(name=data['name']).count()
        if tag == 1:
            flash(u'名称已经纯在!', 'err')
            return redirect(url_for('admin.tag_add'))
        tag = Tag(name=data['name'])
        db.session.add(tag)
        db.session.commit()
        flash(u'添加标签成功', 'ok')
        oplog = Oplog(
            admin_id=session['admin_id'],
            ip=request.remote_addr,
            reason='添加标签%s' % data['name']
        )
        db.session.add(oplog)
        db.session.commit()
        return redirect(url_for('admin.tag_add'))
    return render_template('admin/tag_add.html', form=form)


@admin.route("/tag/list/<int:page>/", methods=['GET'])
@admin_login_req
def tag_list(page=None):
    """后台标签列表"""
    if page is None:
        page = 1
    page_data = Tag.query.order_by(Tag.addtime.desc()).paginate(page=page, per_page=10)  # 当此处填写1的时候遍历部分会出错
    return render_template('admin/tag_list.html', page_data=page_data)


@admin.route('/tag/del/<int:id>/', methods=['GET'])
@admin_login_req
def tag_del(id=None):
    """删除标签"""
    tag = Tag.query.filter_by(id=id).first_or_404()
    db.session.delete(tag)
    db.session.commit()
    flash(u'删除标签成功', 'ok')
    return redirect(url_for('admin.tag_list', page=1))


@admin.route('/tag/edit/<int:id>/', methods=['GET', 'POST'])
@admin_login_req
def tag_edit(id=None):
    """编辑标签"""
    form = TagFrom()
    tag = Tag.query.filter_by(id=id).first_or_404()
    if form.validate_on_submit():
        data = form.data
        tag_count = Tag.query.filter_by(name=data['name']).count()
        if tag.name == data['name'] and tag_count == 1:
            flash(u'名称已经存在!', 'err')
            return redirect(url_for('admin.tag_edit', id=id))
        tag.name = data['name']
        db.session.add(tag)
        db.session.commit()
        flash(u'修改成功!', 'ok')
        return redirect(url_for('admin.tag_edit', id=id))
    return render_template('admin/tag_edit.html', form=form, tag=tag)


@admin.route("/movie/add/", methods=['GET', 'POST'])
@admin_login_req
def movie_add():
    """后台电影添加"""
    form = MovieForm()
    if form.validate_on_submit():
        data = form.data
        file_url = secure_filename(form.url.data.filename)
        file_logo = secure_filename(form.logo.data.filename)
        if not os.path.exists(app.config['UP_DIR']):
            os.makedirs(app.config['UP_DIR'])
            print (os.makedirs(app.config['UP_DIR']))
            os.chmod(app.config['UP_DIR'], 'rw')
        url = change_filename(file_url)
        logo = change_filename(file_logo)
        form.url.data.save(app.config['UP_DIR'] + url)
        form.logo.data.save(app.config['UP_DIR'] + logo)
        movie = Movie(
            title=data['title'],
            url=url,
            info=data['info'],
            logo=logo,
            star=data['star'],
            # playnum=data['playnum'],
            playnum=0,
            # commentnum=data['commentnum'],
            commentnum=0,
            tag_id=data['tag_id'],
            area=data['area'],
            release_time=data['release_time'],
            length=data['length']
        )
        db.session.add(movie)
        db.session.commit()
        flash('添加电影成功!', 'ok')
        return redirect(url_for('admin.movie_add'))
    return render_template('admin/movie_add.html', form=form)


@admin.route("/movie/list/<int:page>", methods=['GET'])
@admin_login_req
def movie_list(page=None):
    """后台电影列表"""
    if page is None:
        page = 1
    page_data = Movie.query.join(Tag).filter(Tag.id == Movie.tag_id).order_by(Movie.addtime.desc()).paginate(page=page,
                                                                                                             per_page=10)  # 当此处填写1的时候遍历部分会出错
    return render_template('admin/movie_list.html', page_data=page_data)


@admin.route('/movie/del/<int:id>/', methods=['GET', 'POST'])
@admin_login_req
def movie_del(id):
    '''电影列表删除'''
    movie = Movie.query.filter_by(id=id).first_or_404()
    db.session.delete(movie)
    db.session.commit()
    flash(u'删除电影成功', 'ok')
    return redirect(url_for('admin.movie_list', page=1))


@admin.route('/movie/edit/<int:id>', methods=['GET', 'POST'])
@admin_login_req
def movie_edit(id=None):
    form = MovieForm()
    form.url.validators = []
    form.logo.validators = []
    movie = Movie.query.get_or_404(int(id))
    if request.method == 'GET':
        form.info.data = movie.info
        form.tag_id.data = movie.tag_id
        form.star.data = movie.star
    if form.validate_on_submit():
        data = form.data
        movie_count = Movie.query.filter_by(title=data['title']).count()
        if movie_count == 1 and movie.title != data['title']:
            flash('片名已经存在!', 'err')
            return redirect(url_for('admin.movie_edit', id=id))

        if not os.path.exists(app.config['UP_DIR']):
            os.makedirs(app.config['UP_DIR'])
            print (os.makedirs(app.config['UP_DIR']))
            os.chmod(app.config['UP_DIR'], 'rw')

        if form.url.data.filename != '':
            file_url = secure_filename(form.url.data.filename)
            movie.url = change_filename(file_url)
            form.url.data.save(app.config['UP_DIR'] + movie.url)
        if form.logo.data.filename != '':
            file_logo = secure_filename(form.logo.data.filename)
            movie.logo = change_filename(movie.file_logo)
            form.logo.data.save(app.config['UP_DIR'] + movie.logo)

        movie.star = data['star']
        movie.tag_id = data['tag_id']
        movie.info = data['info']
        movie.title = data['title']
        movie.area = data['area']
        movie.length = data['length']
        movie.release_time = data['release_time']
        db.session.add(movie)
        db.session.commit()
        flash('修改电影成功!', 'ok')
        return redirect(url_for('admin.movie_edit', id=movie.id))
    return render_template('admin/movie_edit.html', form=form, movie=movie)


@admin.route("/preview/add/", methods=['GET', 'POST'])
@admin_login_req
def preview_add():
    """后台电影预告"""
    form = PrevieForm()
    if form.validate_on_submit():
        data = form.data

        file_logo = secure_filename(form.logo.data.filename)
        if not os.path.exists(app.config['UP_DIR']):
            os.makedirs(app.config['UP_DIR'])
            print (os.makedirs(app.config['UP_DIR']))
            os.chmod(app.config['UP_DIR'], 'rw')

        logo = change_filename(file_logo)

        form.logo.data.save(app.config['UP_DIR'] + logo)
        preview = Preview(
            title=data['title'],
            logo=logo
        )
        db.session.add(preview)
        db.session.commit()
        flash('添加电影预告成功!', 'ok')
        return redirect(url_for('admin.preview_add'))
    return render_template('admin/preview_add.html', form=form)


@admin.route("/preview/list/<int:page>", methods=['GET'])
@admin_login_req
def preview_list(page=None):
    """后台预告列表"""
    if page is None:
        page = 1
    page_data = Preview.query.order_by(Preview.addtime.desc()).paginate(page=page, per_page=10)  # 当此处填写1的时候遍历部分会出错
    return render_template('admin/preview_list.html', page_data=page_data)


@admin.route("/preview/edit/<int:id>", methods=['GET', 'POST'])
@admin_login_req
def preview_edit(id):
    """后台预告编辑"""
    form = PrevieForm()
    preview = Preview.query.get_or_404(int(id))
    if request.method == 'GET':
        form.logo.data = preview.logo
    if form.is_submitted():
        data = form.data
        preview_count = preview.query.filter_by(title=data['title']).count()
        if preview_count == 1 and preview.title != data['title']:
            print '111'
            flash('预告名已经存在!', 'err')
            return redirect(url_for('admin.preview_edit', id=id))

        if not os.path.exists(app.config['UP_DIR']):
            os.makedirs(app.config['UP_DIR'])
            print (os.makedirs(app.config['UP_DIR']))
            os.chmod(app.config['UP_DIR'], 'rw')

        if form.logo.data.filename != '':
            preview.file_logo = secure_filename(form.logo.data.filename)
            preview.logo = change_filename(preview.file_logo)
            form.logo.data.save(app.config['UP_DIR'] + preview.logo)

        preview.title = data['title']
        db.session.add(preview)
        db.session.commit()
        flash('修改预告成功!', 'ok')
        return redirect(url_for('admin.preview_edit', id=preview.id))
    return render_template('admin/preview_edit.html', id=id, form=form, preview=preview)


@admin.route("/preview/del/<int:id>", methods=['GET'])
@admin_login_req
def preview_del(id=None):
    """后台预告删除"""
    preview = Preview.query.filter_by(id=id).first_or_404()
    db.session.delete(preview)
    db.session.commit()
    flash(u'删除预告成功', 'ok')
    return redirect(url_for('admin.preview_list', page=1))


@admin.route("/user/list/<int:page>", methods=['GET', 'POST'])
@admin_login_req
def user_list(page):
    """后台会员列表"""
    if page is None:
        page = 1
    page_data = User.query.order_by(User.addtime.desc()).paginate(page=page, per_page=10)  # 当此处填写1的时候遍历部分会出错
    print ('00000000')
    print page_data
    print ('00000000')
    return render_template('admin/user_list.html', page_data=page_data)


@admin.route("/user/view/<int:id>")
@admin_login_req
def user_view(id=None):
    """后台会员详情"""
    user_data = User.query.filter_by(id=id).first()
    return render_template('admin/user_view.html', user_data=user_data)


@admin.route("/user/del/<int:id>")
@admin_login_req
def user_del(id=None):
    """后台会员删除"""
    user_count = User.query.filter_by(id=id).first_or_404()
    db.session.delete(user_count)
    db.session.commit()
    flash(u'删除会员成功', 'ok')
    return redirect(url_for('admin.user_list', page=1))


@admin.route("/comment/list/<int:page>", methods=['GET', 'POST'])
@admin_login_req
def comment_list(page=None):
    """后台评论详情"""
    if page is None:
        page = 1
    page_data = Comment.query.join(
        Movie
    ).join(
        User
    ).filter(
        Movie.id == Comment.movie_id,
        User.id == Comment.user_id
    ).order_by(Comment.addtime.desc()).paginate(page=page, per_page=10)  # 当此处填写1的时候遍历部分会出错

    return render_template('admin/comment_list.html', comment=page_data)


@admin.route("/comment/del/<int:id>")
@admin_login_req
def comment_del(id=None):
    """后台评论删除"""
    comment_count = Comment.query.filter_by(id=id).first_or_404()
    db.session.delete(comment_count)
    db.session.commit()
    flash(u'删除评论成功', 'ok')
    return redirect(url_for('admin.comment_list', page=1))


@admin.route("/moviecol/list/<int:page>", methods=['GET'])
@admin_login_req
def moviecol_list(page=None):
    """后台电影收藏"""
    if page is None:
        page = 1
    page_data = Moviecol.query.join(
        Movie
    ).join(User).filter(
        Movie.id == Moviecol.movie_id,
        User.id == Moviecol.user_id
    ).order_by(
        Moviecol.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template('admin/moviecol_list.html', page_data=page_data)


@admin.route("/moviecol/del/<int:id>", methods=['GET'])
@admin_login_req
def moviecol_del(id=None):
    """后台评论删除"""
    moviecol_count = Moviecol.query.filter_by(id=id).first_or_404()
    db.session.delete(moviecol_count)
    db.session.commit()
    flash(u'删除收藏成功', 'ok')
    return redirect(url_for('admin.moviecol_list', page=1))


@admin.route("/oplog/list/<int:page>", methods=['GET'])
@admin_login_req
def oplog_list(page=None):
    """后台操作日志"""
    if page is None:
        page = 1
    page_data = Oplog.query.join(
        Admin
    ).filter(
        Admin.id == Oplog.admin_id
    ).order_by(
        Oplog.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template('admin/oplog_list.html', page_data=page_data)


@admin.route("/adminloginlog/list/<int:page>", methods=['GET'])
@admin_login_req
def adminloginlog_list(page=None):
    """后台管理员页面"""
    if page is None:
        page = 1
    page_data = Adminlog.query.join(
        Admin
    ).filter(
        Admin.id == Adminlog.admin_id
    ).order_by(
        Adminlog.addtime.desc()
    ).paginate(page=page, per_page=10)
    print page_data
    return render_template('admin/adminloginlog_list.html', page_data=page_data)


@admin.route("/userloginlog/list/<int:page>")
@admin_login_req
def userloginlog_list(page=None):
    """后台会员管理员页面"""
    if page is None:
        page = 1
    page_data = Userlog.query.join(
        User
    ).filter(
        User.id == Userlog.user_id
    ).order_by(
        Userlog.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template('admin/userloginlog_list.html', page_data=page_data)


@admin.route("/role/add/", methods=['GET', 'POST'])
@admin_login_req
def role_add():
    """后台添加角色"""
    form = RoleForm()
    if form.validate_on_submit():
        data = form.data
        role = Role(
            name=data['name'],
            auths=','.join(map(lambda v: str(v), data['auths']))
        )
        db.session.add(role)
        db.session.commit()
        flash('添加角色成功!', 'ok')
    return render_template('admin/role_add.html', form=form)


@admin.route("/role/list/<int:page>")
@admin_login_req
def role_list(page=None):
    """后台角色列表"""
    if page is None:
        page = 1
    page_data = Role.query.order_by(
        Role.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template('admin/role_list.html', page_data=page_data)


@admin.route('/role/del/<int:id>', methods=['GET'])
@admin_login_req
def role_del(id=None):
    """后台权限删除"""
    role = Role.query.filter_by(id=id).first_or_404()
    db.session.delete(role)
    db.session.commit()
    flash('删除角色成功!', 'ok')
    return redirect(url_for('admin.role_list', page=1))


@admin.route('/role/edit/<int:id>', methods=['GET', 'POST'])
@admin_login_req
def role_edit(id=None):
    form = RoleForm()
    role = Role.query.get_or_404(id)
    if request.method == 'GET':
        auths = role.auths
        form.auths.data = list(map(lambda v: int(v), auths.split(',')))
    if form.validate_on_submit():
        data = form.data
        role.auths = ','.join(map(lambda v: str(v), data['auths']))
        role.name = data['name']
        db.session.add(role)
        db.session.commit()
        flash('修改角色成功!', 'ok')
        redirect(url_for('admin.role_edit', id=id))
    return render_template('admin/role_edit.html', form=form, role=role)


@admin.route("/auth/add/", methods=['GET', 'POST'])
@admin_login_req
def auth_add():
    """后台权限添加"""
    form = AuthForm()
    if form.validate_on_submit():
        data = form.data
        auth = Auth(
            name=data['name'],
            url=data['url']
        )
        db.session.add(auth)
        db.session.commit()
        flash('添加权限成功!', 'ok')
    return render_template('admin/auth_add.html', form=form)


@admin.route("/auth/list/<int:page>", methods=['GET'])
@admin_login_req
def auth_list(page=None):
    """后台权限列表"""
    if page is None:
        page = 1
    page_data = Auth.query.order_by(
        Auth.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template('admin/auth_list.html', page_data=page_data)


@admin.route('/auth/del/<int:id>', methods=['GET'])
@admin_login_req
def auth_del(id=None):
    """后台权限删除"""
    auth = Auth.query.filter_by(id=id).first_or_404()
    db.session.delete(auth)
    db.session.commit()
    flash('删除权限成功!', 'ok')
    return redirect(url_for('admin.auth_list', page=1))


@admin.route('/auth/edit/<int:id>', methods=['GET', 'POST'])
@admin_login_req
def auth_edit(id=None):
    form = AuthForm()
    auth = Auth.query.get_or_404(id)
    if form.validate_on_submit():
        data = form.data
        auth.url = data['url']
        auth.name = data['name']
        db.session.add(auth)
        db.session.commit()
        flash('修改权限成功!', 'ok')
        redirect(url_for('admin.auth_edit', id=id))
    return render_template('admin/auth_edit.html', form=form, auth=auth)


@admin.route("/admin/add/", methods=['GET', 'POST'])
@admin_login_req
def admin_add():
    """后台添加管理员"""
    form = AdminForm()
    from werkzeug.security import generate_password_hash
    if form.validate_on_submit():
        data = form.data
        admin_count = Admin.query.filter_by(name=data['name']).count()
        if admin_count == 1 and Admin.name != data['name']:
            flash('管理员名已经存在!', 'err')
            return redirect(url_for('admin.admin_add', id=id))
        admin = Admin(
            name=data['name'],
            pwd=generate_password_hash(data["pwd"]),
            role_id=data['role_id'],
            is_super=1
        )
        db.session.add(admin)
        db.session.commit()
        flash('添加管理员成功!', 'ok')
    return render_template('admin/admin_add.html', form=form)


@admin.route("/admin/list/<int:page>", methods=['GET', 'POST'])
@admin_login_req
def admin_list(page=None):
    """后台管理员列表"""
    if page is None:
        page = 1
    page_data = Admin.query.join(
        Role
    ).filter(
        Role.id == Admin.role_id
    ).order_by(
        Admin.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template('admin/admin_list.html', page_data=page_data)
