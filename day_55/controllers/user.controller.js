const userModel = require('../models/user.model')
const moment = require('moment')
const { object, string } = require('yup')
module.exports = {
  index: async (req, res) => {
    const { status, keyword } = req.query
    let statusBool
    if (status === 'active' || status === 'inactive') {
      statusBool = status === 'active' ? true : false
    }

    //Đọc dữ liệu từ database
    const users = await userModel.all(statusBool, keyword)
    const msg = req.flash('msg')
    res.render('users/index', { users, moment, status, keyword, msg })
  },
  add: (req, res) => {
    // const errors = req.flash("errors");
    // console.log(errors);
    // console.log(req.errors);
    res.render('users/add', { req })
  },
  handleAdd: async (req, res) => {
    const schema = object({
      name: string().required('Tên bắt buộc phải nhập'),
      email: string()
        .required('Email bắt buộc phải nhập')
        .email('Email không đúng định dạng')
        .test('unique', 'Email đã tồn tại trên hệ thống', async (value) => {
          return await userModel.emailUnique(value)
        })
    })
    try {
      const body = await schema.validate(req.body, { abortEarly: false })
      body.status = body.status === '1' ? true : false
      await userModel.create(body)
      req.flash('msg', 'Thêm người dùng thành công')
      return res.redirect('/users')
    } catch (e) {
      const errors = Object.fromEntries(
        e?.inner.map((item) => [item.path, item.message])
      )
      req.flash('errors', errors)
      req.flash('old', req.body)
    }
    return res.redirect('/users/add')
  },
  edit: async (req, res) => {
    const { id } = req.params
    const user = await userModel.find(id)
    res.render('users/edit', { user, req })
  },
  handleEdit: async (req, res) => {
    const { id } = req.params
    const schema = object({
      name: string().required('Tên bắt buộc phải nhập'),
      email: string()
        .required('Email bắt buộc phải nhập')
        .email('Email không đúng định dạng')
        .test('unique', 'Email đã tồn tại trên hệ thống', async (value) => {
          return await userModel.emailUnique(value, id)
        })
    })
    try {
      const body = await schema.validate(req.body, { abortEarly: false })
      body.status = body.status === '1' ? true : false
      await userModel.update(id, body)
      req.flash('msg', 'Cập nhật người dùng thành công')
      return res.redirect('/users')
    } catch (e) {
      const errors = Object.fromEntries(
        e?.inner.map((item) => [item.path, item.message])
      )
      req.flash('errors', errors)
      req.flash('old', req.body)
    }
    return res.redirect(`/users/edit/${id}`)
  },
  delete: async (req, res) => {
    const { id } = req.params
    console.log(id)
    await userModel.delete(id)
    req.flash('msg', 'Xóa người dùng thành công')
    res.redirect('/users')
  }
}
