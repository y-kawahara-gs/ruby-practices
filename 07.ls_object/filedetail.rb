# frozen_string_literal: true

require 'etc'

class FileDetail
  TYPE_MAP = {
    '14' => 's',
    '12' => 'l',
    '10' => '-',
    '06' => 'b',
    '04' => 'd',
    '02' => 'c'
  }.freeze

  PERMISSION_MAP = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(filename)
    @file_name = filename
    @file_stat = File.stat(filename)
  end

  def to_s
    file_stat = @file_stat
    [
      mode,
      file_stat.nlink,
      Etc.getpwuid(file_stat.uid).name,
      Etc.getpwuid(file_stat.gid).name,
      file_stat.size.to_s.rjust(4),
      file_stat.mtime.strftime('%b %e %R'),
      @file_name
    ].join(' ')
  end

  private

  def mode
    [type, permission].join
  end

  def type
    mode = @file_stat.mode.to_s(8).rjust(6, '0')
    TYPE_MAP[mode[0, 2]]
  end

  def permission
    mode = @file_stat.mode.to_s(8).rjust(6, '0')
    (3..5).map do |number|
      PERMISSION_MAP[mode[number]]
    end
  end
end
