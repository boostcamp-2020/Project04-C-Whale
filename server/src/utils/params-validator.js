const { IsString, ValidateIf, IsUUID } = require('class-validator');
const errorMessage = require('@utils/custom-error').message;

class ParamsValidator {
  @ValidateIf(o => !!o.projectId)
  @IsString({ message: errorMessage.TYPE_ERROR('projectId') })
  @IsUUID('4', { message: errorMessage.INVALID_INPUT_ERROR('projectId') })
  projectId;

  @ValidateIf(o => !!o.sectionId)
  @IsString({ message: errorMessage.TYPE_ERROR('sectionId') })
  @IsUUID('4', { message: errorMessage.INVALID_INPUT_ERROR('sectionId') })
  sectionId;

  @ValidateIf(o => !!o.taskId)
  @IsString({ message: errorMessage.TYPE_ERROR('taskId') })
  @IsUUID('4', { message: errorMessage.INVALID_INPUT_ERROR('taskId') })
  taskId;

  @ValidateIf(o => !!o.commentId)
  @IsString({ message: errorMessage.TYPE_ERROR('commentId') })
  @IsUUID('4', { message: errorMessage.INVALID_INPUT_ERROR('commentId') })
  commentId;
}

module.exports = ParamsValidator;
