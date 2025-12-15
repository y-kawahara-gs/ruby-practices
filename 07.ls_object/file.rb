# frozen_string_literal: true

require 'etc'

module MyLs
  class File
    def initialize(filename)
      @file_name = filename
      @file_stat = ::File.stat(filename)
    end

    def return_detail
      file_stat = @file_stat
      [
        return_mode,
        file_stat.nlink,
        Etc.getpwuid(file_stat.uid).name,
        Etc.getpwuid(file_stat.gid).name,
        file_stat.size.to_s.rjust(4),
        file_stat.mtime.strftime('%b %e %R'),
        @file_name
      ].join(' ')
    end

    def return_mode
      [return_type, return_permission].join
    end

    def return_type
      mode = @file_stat.mode.to_s(8).rjust(6, '0')
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
      mode = @file_stat.mode.to_s(8).rjust(6, '0')
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
