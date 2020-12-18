const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define(
    'user',
    {
      id: {
        primaryKey: true,
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
      },
      email: {
        type: DataTypes.STRING,
      },
      name: {
        type: DataTypes.STRING,
      },
      provider: {
        allowNull: false,
        type: DataTypes.ENUM('naver', 'apple'),
      },
    },
    { charset: 'utf8', collate: 'utf8_unicode_ci', tableName: 'user' },
  );
};
