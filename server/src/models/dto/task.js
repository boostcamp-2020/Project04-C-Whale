const {
  IsInt,
  IsString,
  IsBoolean,
  MinLength,
  IsDateString,
  IsUUID,
  IsOptional,
  IsEmpty,
} = require('class-validator');
const errorMessage = require('@utils/error-messages');
const { isAfterToday } = require('@utils/validator');

class TaskDto {
  @IsEmpty({ groups: ['create', 'patch'], message: errorMessage.UNNECESSARY_INPUT_ERROR('id') })
  @IsString({ groups: ['retrieve'], message: errorMessage.TYPE_ERROR('id') })
  @IsUUID('4', { groups: ['retrieve'], message: errorMessage.INVALID_INPUT_ERROR('id') })
  id;

  @IsOptional({ groups: ['patch'] })
  @IsString({ groups: ['create', 'patch'], message: errorMessage.TYPE_ERROR('title') })
  @MinLength(1, { groups: ['create', 'patch'], message: errorMessage.INVALID_INPUT_ERROR('title') })
  title;

  @IsOptional({ groups: ['patch'] })
  @IsDateString(
    { strict: true },
    { groups: ['create', 'patch'], message: errorMessage.TYPE_ERROR('dueDate') },
  )
  @isAfterToday('dueDate', { groups: ['create', 'patch'], message: errorMessage.DUEDATE_ERROR })
  dueDate;

  @IsOptional({ groups: ['patch'] })
  @IsInt({ groups: ['patch'], message: errorMessage.TYPE_ERROR('position') })
  position;

  @IsOptional({ groups: ['patch'] })
  @IsBoolean({ groups: ['patch'], message: errorMessage.TYPE_ERROR('isDone') })
  isDone;

  @IsOptional({ groups: ['create', 'patch'] })
  @IsString({ groups: ['create', 'patch'], message: errorMessage.TYPE_ERROR('parentId') })
  @IsUUID('4', {
    groups: ['create', 'patch'],
    message: errorMessage.INVALID_INPUT_ERROR('parentId'),
  })
  parentId;

  @IsEmpty({ groups: ['create'], message: errorMessage.UNNECESSARY_INPUT_ERROR('id') })
  @IsOptional({ groups: ['patch'] })
  @IsString({ groups: ['patch'], message: errorMessage.TYPE_ERROR('sectionId') })
  @IsUUID('4', { groups: ['patch'], message: errorMessage.INVALID_INPUT_ERROR('sectionId') })
  sectionId;

  @IsEmpty({ groups: ['create'], message: errorMessage.UNNECESSARY_INPUT_ERROR('id') })
  @IsOptional({ groups: ['patch'] })
  @IsString({ groups: ['patch'], message: errorMessage.TYPE_ERROR('projectId') })
  @IsUUID('4', { groups: ['patch'], message: errorMessage.INVALID_INPUT_ERROR('projectId') })
  projectId;

  @IsOptional({ groups: ['patch'] })
  @IsUUID('4', { groups: ['patch'], message: errorMessage.INVALID_INPUT_ERROR('priorityId') })
  priorityId;

  @IsOptional({ groups: ['patch'] })
  @IsUUID('4', { groups: ['patch'], message: errorMessage.INVALID_INPUT_ERROR('alarmId') })
  alarmId;
}

module.exports = TaskDto;
