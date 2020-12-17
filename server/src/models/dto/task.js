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
const errorMessage = require('@utils/custom-error').message;
const { isAfterToday } = require('@utils/validator');

class TaskDto {
  @IsEmpty({ groups: ['create', 'patch'], message: errorMessage.UNNECESSARY_INPUT_ERROR() })
  @IsString({ groups: ['retrieve'], message: errorMessage.TYPE_ERROR() })
  @IsUUID('4', { groups: ['retrieve'], message: errorMessage.INVALID_INPUT_ERROR() })
  id;

  @IsOptional({ groups: ['patch'] })
  @IsString({ groups: ['create', 'patch'], message: errorMessage.TYPE_ERROR() })
  @MinLength(1, { groups: ['create', 'patch'], message: errorMessage.INVALID_INPUT_ERROR() })
  title;

  @IsOptional({ groups: ['patch'] })
  @IsDateString(
    { strict: true },
    { groups: ['create', 'patch'], message: errorMessage.TYPE_ERROR() },
  )
  @isAfterToday('dueDate', { groups: ['create', 'patch'], message: errorMessage.DUEDATE_ERROR() })
  dueDate;

  @IsOptional({ groups: ['patch'] })
  @IsInt({ groups: ['patch'], message: errorMessage.TYPE_ERROR() })
  position;

  @IsOptional({ groups: ['patch'] })
  @IsBoolean({ groups: ['patch'], message: errorMessage.TYPE_ERROR() })
  isDone;

  @IsOptional({ groups: ['create', 'patch'] })
  @IsString({ groups: ['create', 'patch'], message: errorMessage.TYPE_ERROR() })
  @IsUUID('4', {
    groups: ['create', 'patch'],
    message: errorMessage.INVALID_INPUT_ERROR(),
  })
  parentId;

  @IsEmpty({ groups: ['create'], message: errorMessage.UNNECESSARY_INPUT_ERROR() })
  @IsOptional({ groups: ['patch'] })
  @IsString({ groups: ['patch'], message: errorMessage.TYPE_ERROR() })
  @IsUUID('4', { groups: ['patch'], message: errorMessage.INVALID_INPUT_ERROR() })
  sectionId;

  @IsOptional({ groups: ['patch', 'create'] })
  @IsEnum(['1', '2', '3', '4'], {
    groups: ['patch', 'create'],
    message: errorMessage.INVALID_INPUT_ERROR(),
  })
  priority;

  @IsOptional({ groups: ['patch', 'create'] })
  @IsUUID('4', {
    groups: ['patch', 'create'],
    message: errorMessage.INVALID_INPUT_ERROR(),
  })
  alarmId;
}

module.exports = TaskDto;
