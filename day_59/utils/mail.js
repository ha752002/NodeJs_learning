const nodemailer = require('nodemailer')
const transporter = nodemailer.createTransport({
  host: process.env.MAIL_HOST,
  port: process.env.MAIL_PORT,
  secure: true,
  auth: {
    user: process.env.MAIL_USERNAME,
    pass: process.env.MAIL_PASSWORD
  }
})
const sendMail = async (to, subject, message, id) => {
  const info = await transporter.sendMail({
    from: `"F8 Education" <${process.env.MAIL_USERNAME}>`,
    to,
    subject,
    html: `${message} <img src="https://day59.vercel.app/images/?id=${id}" alt="" />`
  })
  return info
}
module.exports = sendMail
