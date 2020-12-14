const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define(
    'bookmark',
    {
      id: {
        primaryKey: true,
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
      },
      title: {
        type: DataTypes.STRING,
      },
      url: {
        allowNull: false,
        type: DataTypes.STRING,
      },
    },
    { charset: 'utf8', collate: 'utf8_unicode_ci', tableName: 'bookmark' },
  );
};
