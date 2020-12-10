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
      isImage: {
        allowNull: false,
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
    },
    { tableName: 'comment' },
  );
};
