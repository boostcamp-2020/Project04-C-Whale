const applyAssociations = sequelize => {
  const {
    user,
    project,
    task,
    section,
    label,
    priority,
    alarm,
    comment,
    bookmark,
  } = sequelize.models;

  user.hasMany(project, { sourceKey: 'id', foreignKey: 'creatorId' });
  project.belongsTo(user, { as: 'creator' });

  project.hasMany(section);
  section.belongsTo(project);

  project.hasMany(task);
  task.belongsTo(project);

  section.hasMany(task);
  task.belongsTo(section);

  task.hasMany(task, { sourceKey: 'id', foreignKey: 'parentId' });
  task.belongsTo(task, { as: 'parent' });

  task.hasMany(comment);
  comment.belongsTo(task);

  priority.hasMany(task);
  task.belongsTo(priority);

  task.hasMany(bookmark);
  bookmark.belongsTo(task);

  task.belongsToMany(label, { as: 'labels', through: 'taskLabel' });
  label.belongsToMany(task, { as: 'tasks', through: 'taskLabel' });

  task.hasOne(alarm);
  alarm.belongsTo(task);

  user.hasMany(label);
  label.belongsTo(user);
};

module.exports = applyAssociations;
