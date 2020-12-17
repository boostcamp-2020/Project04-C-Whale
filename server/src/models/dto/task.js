const {
  IsInt,
  IsString,
  IsBoolean,
  MinLength,
  IsDateString,
  IsUUID,
  IsOptional,
  IsEmpty,
  IsEnum,
} = require('class-validator');
const { message: errorMessage } = require('@utils/custom-error');
const { isAfterToday } = require('@utils/validator');

class TaskDto {
  @IsEmpty({ groups: ['create', 'patch'] })
  id;

  @IsOptional({ groups: ['patch'] })
  @MinLength(1, { groups: ['create', 'patch'] })
  @IsString({ groups: ['create', 'patch'] })
  title;

  @IsOptional({ groups: ['patch'] })
  @isAfterToday('dueDate', {
    groups: ['create', 'patch'],
    message: errorMessage.DUEDATE_ERROR_EN(),
  })
  @IsDateString({ strict: true }, { groups: ['create', 'patch'] })
  dueDate;

  @IsOptional({ groups: ['patch'] })
  @IsInt({ groups: ['patch'] })
  position;

  @IsOptional({ groups: ['patch'] })
  @IsBoolean({ groups: ['patch'] })
  isDone;

  @IsOptional({ groups: ['create', 'patch'] })
  @IsUUID('4', { groups: ['create', 'patch'] })
  @IsString({ groups: ['create', 'patch'] })
  parentId;

  @IsEmpty({ groups: ['create'] })
  @IsOptional({ groups: ['patch'] })
  @IsUUID('4', { groups: ['patch'] })
  @IsString({ groups: ['patch'] })
  sectionId;

  @IsOptional({ groups: ['patch', 'create'] })
  @IsEnum(['1', '2', '3', '4'], { groups: ['patch', 'create'] })
  priority;

  @IsOptional({ groups: ['patch', 'create'] })
  @IsUUID('4', { groups: ['patch', 'create'] })
  @IsString({ groups: ['patch', 'create'] })
  alarmId;
}

module.exports = TaskDto;
