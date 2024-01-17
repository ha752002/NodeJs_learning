var express = require('express')
const mailController = require('../controllers/mail.controller')
var router = express.Router()
const models = require('../models/index')
const Mail = models.Mail
/* GET home page. */
router.get('/', function (req, res, next) {
  console.log(req)
  res.render('index', { title: 'Express' })
})
router.get('/images/:id', async function (req, res, next) {
  const { id } = req.params
  const mail = await Mail.findByPk(id)
  if (mail) {
    mail.status = true
    await mail.save()
  }
  res.sendFile('trackingImage.png', { root: './public/images' })
  // next()
})

module.exports = router
