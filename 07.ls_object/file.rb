# frozen_string_literal: true

require 'etc'

module MyLs
  class File
    def initialize(filename)
      @file_name = filename
      @file_stat = ::File.stat(filename)
    end

    def detail(type_map, permission_map)
      file_stat = @file_stat
      [
        mode(type_map, permission_map),
        file_stat.nlink,
        Etc.getpwuid(file_stat.uid).name,
        Etc.getpwuid(file_stat.gid).name,
        file_stat.size.to_s.rjust(4),
        file_stat.mtime.strftime('%b %e %R'),
        @file_name
      ].join(' ')
    end

    def mode(type_map, permission_map)
      [type(type_map), permission(permission_map)].join
    end

    def type(type_map)
      mode = @file_stat.mode.to_s(8).rjust(6, '0')
      type_map[mode[0, 2]]
    end

    def permission(permission_map)
      mode = @file_stat.mode.to_s(8).rjust(6, '0')
      (3..5).map do |number|
        permission_map[mode[number]]
      end
    end
  end
end
