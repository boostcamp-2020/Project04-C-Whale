const { IsString, ValidateIf, IsUUID } = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class ParamsValidator {
  @ValidateIf(o => typeof o.projectId !== 'undefined')
  @IsUUID('4', { message: errorMessage.INVALID_INPUT_ERROR('projectId') })
  @IsString({ message: errorMessage.TYPE_ERROR('projectId') })
  projectId;

  @ValidateIf(o => typeof o.sectionId !== 'undefined')
  @IsUUID('4', { message: errorMessage.INVALID_INPUT_ERROR('sectionId') })
  @IsString({ message: errorMessage.TYPE_ERROR('sectionId') })
  sectionId;

  @ValidateIf(o => typeof o.taskId !== 'undefined')
  @IsUUID('4', { message: errorMessage.INVALID_INPUT_ERROR('taskId') })
  @IsString({ message: errorMessage.TYPE_ERROR('taskId') })
  taskId;

  @ValidateIf(o => typeof o.commentId !== 'undefined')
  @IsUUID('4', { message: errorMessage.INVALID_INPUT_ERROR('commentId') })
  @IsString({ message: errorMessage.TYPE_ERROR('commentId') })
  commentId;

  @ValidateIf(o => typeof o.bookmarkId !== 'undefined')
  @IsString({ message: errorMessage.TYPE_ERROR('bookmarkId') })
  @IsUUID('4', { message: errorMessage.INVALID_INPUT_ERROR('bookmarkId') })
  bookmarkId;
}

module.exports = ParamsValidator;
