const { IsString, IsUUID, IsOptional } = require('class-validator');

class ParamsValidator {
  @IsOptional()
  @IsUUID('4')
  projectId;

  @IsOptional()
  @IsUUID('4')
  sectionId;

  @IsOptional()
  @IsUUID('4')
  taskId;

  @IsOptional()
  @IsUUID('4')
  commentId;

  @IsOptional()
  @IsString()
  @IsUUID('4')
  bookmarkId;
}

module.exports = ParamsValidator;
