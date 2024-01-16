'use strict'
const { Model } = require('sequelize')
module.exports = (sequelize, DataTypes) => {
  class Mail extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  Mail.init(
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
      },
      from: DataTypes.STRING,
      to: DataTypes.STRING,
      subject: DataTypes.STRING,
      content: DataTypes.STRING,
      status: DataTypes.BOOLEAN,
      created_at: DataTypes.DATE
    },
    {
      sequelize,
      modelName: 'Mail',
      tableName: 'mails',
      createdAt: 'created_at',
      updatedAt: 'updated_at'
    }
  )
  return Mail
}
