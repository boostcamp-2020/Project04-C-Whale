const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define(
    'comment',
    {
      id: {
        primaryKey: true,
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
      },
      content: {
        allowNull: false,
        type: DataTypes.STRING,
      },
    },
    { charset: 'utf8', collate: 'utf8_unicode_ci', tableName: 'comment' },
  );
};
