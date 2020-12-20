const { IsString, IsEmpty, MinLength } = require('class-validator');

class CommentDto {
  @IsEmpty({ groups: ['create', 'update'] })
  id;

  @MinLength(1, {
    groups: ['create', 'update'],
  })
  @IsString({ groups: ['create', 'update'] })
  content;

  @IsEmpty({ groups: ['update'] })
  taskId;
}

module.exports = CommentDto;
