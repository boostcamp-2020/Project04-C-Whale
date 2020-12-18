const {
  IsString,
  IsHexColor,
  MinLength,
  IsBoolean,
  IsEmpty,
  IsOptional,
} = require('class-validator');

class ProjectDto {
  @IsEmpty({ groups: ['create', 'put', 'patch'] })
  id;

  @IsOptional({ groups: ['patch'] })
  @MinLength(1, { groups: ['create', 'put', 'patch'] })
  @IsString({ groups: ['create', 'put', 'patch'] })
  title;

  @IsOptional({ groups: ['patch'] })
  @IsHexColor({ groups: ['create', 'put', 'patch'] })
  @IsString({ groups: ['create', 'put', 'patch'] })
  color;

  @IsOptional({ groups: ['patch'] })
  @IsBoolean({ groups: ['create', 'put', 'patch'] })
  isList;

  @IsOptional({ groups: ['patch'] })
  @IsBoolean({ groups: ['create', 'put', 'patch'] })
  isFavorite;
}

module.exports = ProjectDto;
