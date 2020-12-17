const { IsString, IsUUID } = require('class-validator');

class PositionDto {
  @IsUUID('4', { each: true })
  @IsString({ each: true })
  orderedTasks;
}

module.exports = PositionDto;
