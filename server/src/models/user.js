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
    { tableName: 'user' },
  );
};
