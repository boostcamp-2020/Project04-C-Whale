const { IsString, IsUUID, IsOptional } = require('class-validator');

class PositionDto {
  @IsOptional()
  @IsUUID('4', { each: true })
  @IsString({ each: true })
  orderedTasks;

  @IsOptional()
  @IsUUID('4', { each: true })
  @IsString({ each: true })
  orderedSections;
}

module.exports = PositionDto;
