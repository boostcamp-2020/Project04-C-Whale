const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define(
    'task',
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
      dueDate: {
        type: DataTypes.DATE,
      },
      position: {
        allowNull: false,
        type: DataTypes.INTEGER,
      },
      isDone: {
        allowNull: false,
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      priority: {
        type: DataTypes.ENUM(['1', '2', '3', '4']),
      },
    },
    { tableName: 'task' },
  );
};
