const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define('bookmark', {
    id: {
      primaryKey: true,
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
    },
    url: {
      allowNull: false,
      type: DataTypes.STRING,
    },
  });
};
