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
  @IsUUID('4', { groups: ['retrieve'], message: errorMessage.INVALID_INPUT_ERROR() })
  @IsString({ groups: ['retrieve'], message: errorMessage.TYPE_ERROR() })
  id;

  @IsOptional({ groups: ['patch'] })
  @MinLength(1, { groups: ['create', 'patch'], message: errorMessage.INVALID_INPUT_ERROR() })
  @IsString({ groups: ['create', 'patch'], message: errorMessage.TYPE_ERROR() })
  title;

  @IsOptional({ groups: ['patch'] })
  @isAfterToday('dueDate', { groups: ['create', 'patch'], message: errorMessage.DUEDATE_ERROR() })
  @IsDateString(
    { strict: true },
    { groups: ['create', 'patch'], message: errorMessage.TYPE_ERROR() },
  )
  dueDate;

  @IsOptional({ groups: ['patch'] })
  @IsInt({ groups: ['patch'], message: errorMessage.TYPE_ERROR() })
  position;

  @IsOptional({ groups: ['patch'] })
  @IsBoolean({ groups: ['patch'], message: errorMessage.TYPE_ERROR() })
  isDone;

  @IsOptional({ groups: ['create', 'patch'] })
  @IsUUID('4', {
    groups: ['create', 'patch'],
    message: errorMessage.INVALID_INPUT_ERROR(),
  })
  @IsString({ groups: ['create', 'patch'], message: errorMessage.TYPE_ERROR() })
  parentId;

  @IsEmpty({ groups: ['create'], message: errorMessage.UNNECESSARY_INPUT_ERROR() })
  @IsOptional({ groups: ['patch'] })
  @IsUUID('4', { groups: ['patch'], message: errorMessage.INVALID_INPUT_ERROR() })
  @IsString({ groups: ['patch'], message: errorMessage.TYPE_ERROR() })
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
  @IsString({ groups: ['patch', 'create'], message: errorMessage.TYPE_ERROR() })
  alarmId;
}

module.exports = TaskDto;
