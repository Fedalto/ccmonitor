class Alias
  def self.ecom(infos)
    infos.map do |info|
      if info['name'] == 'ecom'
        btype = info['build_type'].split('.')
        if btype.size > 1
          if btype[1] == 'preview'
            index = 2
          else
            index = 1
          end
          info['name'] = btype[index]
          index += 1
          if btype[index].size == 2
            info['name'] += ' ' + btype[index]
          end
        end
      end
      info
    end
  end
end
