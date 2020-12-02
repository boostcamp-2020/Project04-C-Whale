const labelModel = require('@models').models.label;

const retrieveAll = async userId => {
  const labels = await labelModel.findAll({
    where: { userId },
    attributes: ['id', 'title', 'color'],
  });

  return labels;
};

const retrieveById = async id => {
  const label = await labelModel.findByPk(id, { attributes: ['userId'] });

  return label;
};

const create = async ({ userId, ...data }) => {
  const { title, color } = data;
  const label = await labelModel.create({ title, color, userId });

  return label.userId === userId && label.title === title && label.color === color;
};

const update = async ({ id, ...data }) => {
  const { title, color } = data;
  const result = await labelModel.update({ title, color }, { where: { id } });

  return result[0] === 1;
};

const remove = async id => {
  const result = await labelModel.destroy({ where: { id } });

  return result === 1;
};

module.exports = { retrieveAll, retrieveById, create, update, remove };
