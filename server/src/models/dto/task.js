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
  MinLength,
  IsDateString,
  ValidateIf,
  IsUUID,
} = require('class-validator');
const errorMessage = require('@models/dto/error-messages');
const { isAfterToday } = require('@utils/validator');

class TaskDto {
  @ValidateIf(o => !!o.id)
  @IsString()
  @IsUUID('4')
  id;

  @IsString({ groups: ['create'] }, { message: errorMessage.wrongProperty('title') })
  @MinLength(1, { groups: ['create'] }, { message: errorMessage.wrongProperty('title') })
  title;

  @IsDateString(
    { strict: true },
    { groups: ['create'], message: errorMessage.wrongProperty('dueDate') },
  )
  @isAfterToday('dueDate', { groups: ['create'], message: errorMessage.beforeDueDate })
  dueDate;

  @IsInt()
  @IsNotEmpty()
  position;

  @IsBoolean()
  @IsNotEmpty()
  isDone;

  @IsString()
  @IsUUID('4')
  parentId;

  @IsString({ groups: ['create'], message: errorMessage.wrongProperty('sectionId') })
  @IsUUID('4', { groups: ['create'], message: errorMessage.wrongProperty('sectionId') })
  sectionId;

  @IsString({ groups: ['create'], message: errorMessage.wrongProperty('projectId') })
  @IsUUID('4', { groups: ['create'], message: errorMessage.wrongProperty('projectId') })
  projectId;

  @IsString()
  @IsUUID('4')
  priorityId;

  @IsUUID('4')
  alarmId;

  @IsArray
  orderedTasks;
}

module.exports = TaskDto;
