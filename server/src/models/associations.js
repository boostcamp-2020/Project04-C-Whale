const applyAssociations = sequelize => {
  const { user, project, task, section, comment, bookmark } = sequelize.models;

  user.hasMany(project, { sourceKey: 'id', foreignKey: 'creatorId' });
  project.belongsTo(user, { as: 'creator' });

  project.hasMany(section);
  section.belongsTo(project);

  section.hasMany(task);
  task.belongsTo(section);

  task.hasMany(task, { sourceKey: 'id', foreignKey: 'parentId' });
  task.belongsTo(task, { as: 'parent' });

  task.hasMany(comment);
  comment.belongsTo(task);

  task.hasMany(bookmark);
  bookmark.belongsTo(task);
};

module.exports = applyAssociations;
