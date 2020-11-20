const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define(
    'user',
    {
      email: {
        primaryKey: true,
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
    { tableName: 'user' },
  );
};
