const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define(
    'label',
    {
      id: {
        primaryKey: true,
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
      },
      title: {
        allowNull: false,
        type: DataTypes.STRING,
        defaultValue: 'untitled',
      },
      color: {
        type: DataTypes.STRING,
      },
    },
    { tableName: 'label' },
  );
};
