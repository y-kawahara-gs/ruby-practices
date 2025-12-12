# frozen_string_literal: true

require 'etc'

module MyLs
  class File
    def initialize(filename)
      @name = filename
      @info = ::File.stat(filename)
    end

    def return_detail
      info = @info
      [
        return_mode,
        info.nlink,
        Etc.getpwuid(info.uid).name,
        Etc.getpwuid(info.gid).name,
        info.size.to_s.rjust(4),
        info.mtime.strftime('%b %e %R'),
        @name
      ].join(' ')
    end

    def return_mode
      [return_type, return_permission].join
    end

    def return_type
      mode = @info.mode.to_s(8).rjust(6, '0')
      {
        '14' => 's',
        '12' => 'l',
        '10' => '-',
        '06' => 'b',
        '04' => 'd',
        '02' => 'c'
      }[mode[0, 2]]
    end

    def return_permission
      mode = @info.mode.to_s(8).rjust(6, '0')
      (3..5).map do |number|
        {
          '0' => '---',
          '1' => '--x',
          '2' => '-w-',
          '3' => '-wx',
          '4' => 'r--',
          '5' => 'r-x',
          '6' => 'rw-',
          '7' => 'rwx'
        }[mode[number]]
      end
    end
  end
end
