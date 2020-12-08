


#   After do |scenario|
#     scenario_name = scenario.name.gsub(/\s+/,'_').tr('/','_')   
#        if scenario.failed?
#          tirar_foto(scenario_name.downcase!, 'falhou')
#        else
#          tirar_foto(scenario_name.downcase!, 'passou')
#        end
#  end

 
After do
  temp_shot = page.save_screenshot("reports/temp_shot.png")
  shot = Base64.encode64(File.open(temp_shot, "rb").read)
  embed(shot, "image/png", "Clique Aqui")

end  




