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
ProjectMock.$queueResult(expectedData.projects.forEach(project => ProjectMock.build(project)));
LabelMock.$queueResult(expectedData.labels.forEach(label => LabelMock.build(label)));
ProjectMock.$queueResult(expectedData.priorities.forEach(priority => ProjectMock.build(priority)));
AlarmMock.$queueResult(expectedData.alarms.forEach(alarm => AlarmMock.build(alarm)));
TaskMock.$queueResult(expectedData.tasks.forEach(task => TaskMock.build(task)));

module.exports = DBConnectionMock;
