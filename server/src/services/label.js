const assignLabelToTask = async (task, labelIdList) => {
  await task.setLabels(JSON.parse(labelIdList));
};

module.exports = { assignLabelToTask };
