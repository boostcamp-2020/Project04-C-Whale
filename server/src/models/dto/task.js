const {
  IsInt,
  IsString,
  IsNotEmpty,
  IsBoolean,
  IsArray,
  MinLength,
  IsDateString,
  ValidateIf,
  IsUUID,
  IsOptional,
  IsEmpty,
} = require('class-validator');
const errorMessage = require('@models/dto/error-messages');
const { isAfterToday } = require('@utils/validator');

class TaskDto {
  @IsEmpty({ groups: ['create'], message: errorMessage.UNNECESSARY_INPUT_ERROR('id') })
  @IsString({ groups: ['retrieve'], message: errorMessage.TYPE_ERROR('id') })
  @IsUUID('4', { groups: ['retrieve'], message: errorMessage.INVALID_INPUT_ERROR('id') })
  id;

  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR('title') })
  @MinLength(1, { groups: ['create'], message: errorMessage.INVALID_INPUT_ERROR('title') })
  title;

  @IsDateString(
    { strict: true },
    { groups: ['create'], message: errorMessage.TYPE_ERROR('dueDate') },
  )
  @isAfterToday('dueDate', { groups: ['create'], message: errorMessage.DUEDATE_ERROR })
  dueDate;

  @IsInt()
  @IsNotEmpty()
  position;

  @IsBoolean()
  @IsNotEmpty()
  isDone;

  @IsOptional({ groups: ['create'] })
  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR('sectionId') })
  @IsUUID('4', { groups: ['create'], message: errorMessage.INVALID_INPUT_ERROR('parentId') })
  parentId;

  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR('sectionId') })
  @IsUUID('4', { groups: ['create'], message: errorMessage.INVALID_INPUT_ERROR('sectionId') })
  sectionId;

  @IsString({ groups: ['create'], message: errorMessage.TYPE_ERROR('projectId') })
  @IsUUID('4', { groups: ['create'], message: errorMessage.INVALID_INPUT_ERROR('projectId') })
  projectId;

  @IsString()
  @IsUUID('4')
  priorityId;

  @IsUUID('4')
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
