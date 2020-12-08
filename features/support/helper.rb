Dir[File.join(File.dirname(__FILE__), '../pages/*_page.rb')].each { |file| require file }


module PageObjects

    def fomulario
        @formulario ||= Formulario.new
    end
  
end


module Helper
    def tirar_foto(nome_arquivo, resultado)
      caminho_arquivo = "reports/screenshots/test_#{resultado}"
      foto = "#{caminho_arquivo}/#{nome_arquivo}.png"
      page.save_screenshot(foto)
      embed(foto, 'image/png', 'Clique aqui')
    end
  end


  