const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define(
    'project',
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
      color: {
        allowNull: false,
        type: DataTypes.STRING,
      },
      isList: {
        allowNull: false,
        type: DataTypes.BOOLEAN,
      },
      isFavorite: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
    },
    { tableName: 'project' },
  );
};
