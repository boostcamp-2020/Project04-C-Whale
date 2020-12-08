const {
  validate,
  validateOrReject,
  Contains,
  IsInt,
  Length,
  IsEmail,
  IsFQDN,
  IsDate,
  Min,
  Max,
  IsString,
  IsDefined,
  IsNotEmpty,
  IsBoolean,
  IsArray,
  MinDate,
} = require('class-validator');

class TaskDto {
  @IsString()
  @Length(36, 36)
  @IsNotEmpty()
  id;

  @IsString()
  @IsNotEmpty()
  title;

  // TODO: custom validation decorator
  @IsDate()
  @MinDate(new Date('2020-12-08'))
  dueDate;

  @IsInt()
  @IsNotEmpty()
  position;

  @IsBoolean()
  @IsNotEmpty()
  isDone;

  @IsString()
  @Length(36, 36)
  parentId;

  @IsString()
  @Length(36, 36)
  sectionId;

  @IsString()
  @Length(36, 36)
  projectId;

  @IsString()
  @Length(36, 36)
  priorityId;

  @Length(36, 36)
  alarmId;

  @IsArray
  orderedTasks;

  // constructor({ id, title, dueDate, position, isDone }) {
  //   this.id = id;
  //   this.title = title;
  //   this.dueDate = dueDate;
  //   this.position = position;
  //   this.isDone = isDone;
  // }
}

// const task = new TaskDto();
// task.id = 'ff4dd832-1567-4d74-b41d-bd85e96ce329';
// task.title = 'zkzkzk';
// task.dueDate = new Date('2020-12-07');
// task.position = 4;
// task.isDone = true;
// task.parentId = 'ff4dd832-1567-4d74-b41d-bd85e96ce329';

// await validateOrReject(task, { gropus }).catch(errors => {
//   console.log('Promise rejected (validation failed). Errors: ', errors);
// });

// sectionId;

// projectId
// priorityId;
// alarmId;
// orderedTasks

module.exports = TaskDto;
