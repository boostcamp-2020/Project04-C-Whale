const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define(
    'section',
    {
      id: {
        primaryKey: true,
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
      },
      title: {
        type: DataTypes.STRING,
      },
      position: {
        type: DataTypes.INTEGER,
      },
    },
    { charset: 'utf8', collate: 'utf8_unicode_ci', tableName: 'section' },
  );
};
