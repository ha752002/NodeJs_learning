const models = require('../models/index')
const Mail = models.Mail
const sendMail = require('../utils/mail')
const moment = require('moment')
module.exports = {
  sentMail: async (req, res, next) => {
    console.log('Here')
    res.render('mail', { title: 'Gửi email' })
  },
  handleSentMail: async (req, res, next) => {
    const { email, subject, content } = req.body
    try {
      const mail = await Mail.create({
        from: process.env.MAIL_USERNAME,
        to: email,
        subject: subject,
        content: content,
        status: false
      })
      const id = mail.dataValues.id
      const info = await sendMail(email, subject, content, id)
    } catch (error) {}

    res.redirect('/mail')
  },

  detail: async (req, res, next) => {
    const mails = await Mail.findAll({
      order: [['created_at', 'DESC']]
    })
    res.render('mail/detail', { title: 'Chi tiết email đã gửi', mails, moment })
  },
  detailEmail: async (req, res, next) => {
    const { id } = req.params
    const mail = await Mail.findByPk(id)
    res.render('mail/detailEmail', { title: 'Chi tiết email', mail, moment })
  }
}
