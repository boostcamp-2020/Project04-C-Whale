require('module-alias/register');
const SequelizeMock = require('sequelize-mock');
const applyAssociations = require('@models/associations');
const expectedData = require('./expected-data');

const DBConnectionMock = new SequelizeMock();

const UserMock = DBConnectionMock.define('user');
const ProjectMock = DBConnectionMock.define('project');
const TaskMock = DBConnectionMock.define('task');
const SectionMock = DBConnectionMock.define('section');
const CommentMock = DBConnectionMock.define('comment');
const LabelMock = DBConnectionMock.define('label');
const PriorityMock = DBConnectionMock.define('priority');
const BookmarkMock = DBConnectionMock.define('bookmark');
const AlarmMock = DBConnectionMock.define('alarm');

applyAssociations(DBConnectionMock);

UserMock.$queueResult(UserMock.build(expectedData.users[0]));
ProjectMock.$queueResult([
  ProjectMock.build(expectedData.projects[0]),
  ProjectMock.build(expectedData.projects[1]),
]);

module.exports = DBConnectionMock;
