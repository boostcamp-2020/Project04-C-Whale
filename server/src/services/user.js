const userModel = require('@models').models.user;

const retrieveById = async id => {
  const foundUser = await userModel.findByPk(id, {
    attributes: ['id', 'email', 'name', 'provider'],
  });
  return foundUser;
};

const retrieveOrCreate = async userData => {
  const { email, name, provider } = userData;
  const user = await userModel.findOrCreate({
    where: { email, provider },
    attributes: ['id', 'email', 'name', 'provider'],
    defaults: { email, name, provider },
  });

  return user;
};

const register = async data => {
  const result = await userModel.create(data);
  return result;
};

module.exports = { retrieveById, retrieveOrCreate, register };
