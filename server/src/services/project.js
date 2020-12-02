const Op = require('sequelize');
const sequelize = require('@models');
const getTodayStartEnd = require('@utils/today-start-end');

const { models } = sequelize;
const projectModel = models.project;

const retrieveProjects = async () => {
  const projects = await projectModel.findAll({
    attributes: ['id', 'title', [sequelize.fn('COUNT', sequelize.col('tasks.id')), 'taskCount']],
    include: {
      model: models.task,
      attributes: [],
    },
    group: ['project.id'],
  });

  return projects;
};

const retrieveTodayProject = async () => {
  const TODAY = '오늘';

  const { todayStart, todayEnd } = getTodayStartEnd();

  const todayProject = {
    title: TODAY,
  };

  todayProject.taskCount = await models.task.count({
    where: {
      dueDate: {
        [Op.and]: {
          [Op.gt]: todayStart,
          [Op.lt]: todayEnd,
        },
      },
    },
  });

  return todayProject;
};

const retrieveById = async id => {
  const project = await projectModel.findByPk(id, {
    attributes: ['id', 'title', 'isList'],
    include: {
      model: models.section,
      include: {
        model: models.task,
        where: { isDone: false, parentId: null },
        include: [
          'priority',
          'labels',
          'alarm',
          {
            model: models.task,
            where: { isDone: false },
            required: false,
          },
        ],
        required: false,
      },
    },
    order: [
      [models.section, 'position', 'ASC'],
      [models.section, models.task, 'position', 'ASC'],
      [models.section, models.task, models.task, 'position', 'ASC'],
    ],
  });
  return project;
};

const create = async data => {
  const result = await sequelize.transaction(async t => {
    const project = await projectModel.create(data, {
      transaction: t,
    });
    const section = await models.section.create(
      {},
      {
        transaction: t,
      },
    );
    await section.setProject(project, {
      transaction: t,
    });
    return section.projectId;
  });

  return !!result;
};

const findOrCreate = async data => {
  const [result] = await projectModel.findAll({ where: data });
  console.log(result);
  if (result) return true;
  return await create(data);
};

const update = async ({ projectId, ...data }) => {
  const result = await projectModel.update(data, {
    where: {
      id: projectId,
    },
  });

  return result === 1;
};

const remove = async id => {
  const result = await projectModel.destroy({ where: { id } });

  return result === 1;
};

module.exports = {
  retrieveProjects,
  retrieveTodayProject,
  retrieveById,
  create,
  findOrCreate,
  update,
  remove,
};
