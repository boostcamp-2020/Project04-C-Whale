const { IsString, ValidateIf, IsUUID, IsOptional } = require('class-validator');

class ParamsValidator {
  @IsOptional()
  @IsUUID('4')
  projectId;

  @ValidateIf(o => typeof o.sectionId !== 'undefined')
  @IsUUID('4')
  sectionId;

  @ValidateIf(o => typeof o.taskId !== 'undefined')
  @IsUUID('4')
  taskId;

  @ValidateIf(o => typeof o.commentId !== 'undefined')
  @IsUUID('4')
  commentId;

  @ValidateIf(o => typeof o.bookmarkId !== 'undefined')
  @IsString()
  bookmarkId;
}

module.exports = ParamsValidator;
