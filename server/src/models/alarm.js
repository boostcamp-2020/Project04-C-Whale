const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define(
    'alarm',
    {
      id: {
        primaryKey: true,
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
      },
    },
    { tableName: 'alarm' },
  );
};
