var express = require('express')
var router = express.Router()
const mailController = require('../controllers/mail.controller')
/* GET users listing. */
router.get('/', mailController.sentMail)
router.post('/', mailController.handleSentMail)
router.get('/detail', mailController.detail)
router.get('/detail/:id', mailController.detailEmail)

module.exports = router
