const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define(
    'priority',
    {
      id: {
        primaryKey: true,
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
      },
      title: {
        allowNull: false,
        type: DataTypes.STRING,
      },
    },
    { tableName: 'priority' },
  );
};
