



Dado("que eu esteja na tela de Gerar Cotação.") do
   visit 'main.aspx?area=nav_quotes&etc=1084&page=Area_SND&pageType=EntityList&web=true#813554569'
   sleep 3 
   visit 'http://srvcrmhom01:8081/PaginaCotacao/?userid={AD93AFE8-46FB-E911-811E-00155D063466}&OrgName=CRM'
  
   sleep 8
   
end
  
Quando("eu preecher o formulário e solicitar a Cotação.") do
   find('#txtPesquisaCliente').set CONFIG['cliente']
   find('#txtPesquisaCliente').native.send_keys :enter
   sleep 10 
   find("li", :text => CONFIG['nomecliente']).click
   sleep 10 
   

   find('input[placeholder="Selecione o tipo de operação"]').set CONFIG['tipooperacao']
   sleep 2 
   find('input[placeholder="Selecione o tipo de operação"]').native.send_keys :enter
 
  
   sleep 2
   find('#txtPesquisaCondicaoPagamento').set CONFIG['condpagamento']
   sleep 1
   find('#txtTopico').set CONFIG['topico']
   
   sleep 2
   page.execute_script("$('#txtTipoVenda option[value=0]').click()")
   find("li", :text => 'Comercialização').click
   
   sleep 2
   page.execute_script("$('#txtFrete option[value=1]').click()")
   find("li", :text => 'CIF').click
   
   sleep 2
   #find('input[placeholder="Selecione o apelido"]').set CONFIG['apelido']
   #find("li", :text => CONFIG['apelido']).click
   # binding.pry
   find('input[placeholder="Selecione o segmento"]').set '[1]Acessorio'
   find("li", :text => '[1]Acessorio').click
   #find('#txtDescricao').set CONFIG['descrição']
   
   
   find('#btnPesquisar').click
   sleep 15

   #selecionar o produto com preço 
   #@valor = page.find(:xpath, '//*[@id="gridFrozen"]/div[5]/table/tbody/tr/td[7]').text.gsub('R$', '').gsub(',', '.').to_f
   @valor = page.find(:xpath, '//*[@id="gridFrozen"]/div[5]/table/tbody/tr[3]/td[1]').text.gsub('R$', '').gsub(',', '.').to_f
   #page.find(:xpath, '//*[@id="gridFrozen"]/div[5]/table/tbody/tr/td[7]').click
   page.find(:xpath, '//*[@id="gridFrozen"]/div[5]/table/tbody/tr[3]/td[1]').click
                     
   find("a", :text => 'Adicionar ao Carrinho').click   
     
   #gerar cotação   
   sleep 8
   find('#btnGerarCotacao').click
   sleep 10
   find("a", :text => 'Abrir Cotação').click
   #binding.pry
   
  

  
  
   
    
end
  
Entao("o sistema deve realizar a cotação com os dados informados.") do
   popup = page.driver.browser.window_handles.last
   page.driver.browser.switch_to.window(popup)

   within_frame('contentIFrame0') do
            #Validar codígo terceiro
            CODTerceiro= find('#Dados_Contato_Dados_Contato_account_fut_int_codterceiro > div.ms-crm-Inline-Value > span')
            expect(find('#Dados_Contato_Dados_Contato_account_fut_int_codterceiro > div.ms-crm-Inline-Value > span')).to have_content '230.064'  
            
            #Validar Valor total da cotação
            @valorfrete = find('#freightamount > div.ms-crm-Inline-Value.ms-crm-Inline-Locked > span').text.gsub('R$', '').gsub(',', '.').to_f
            @valordespe = find('#fut_mn_valordespesa > div.ms-crm-Inline-Value.ms-crm-Inline-Locked > span').text.gsub('R$', '').gsub(',', '.').to_f
            @valortotal = soma = (@valor + @valorfrete + @valordespe )
            expect(find('#fut_mn_valortotalcotacao > div.ms-crm-Inline-Value.ms-crm-Inline-Locked > span').text.gsub('R$', '').gsub(',', '.').to_f).to eql @valortotal
                                   
            
            #Validar Produto
            @produto = page.find(:css, '#gridBodyTable > tbody > tr > td:nth-child(3) > div').text
            expect(page).to have_text CONFIG['descrição']

            
            
            #Validar Campo transportadora
             if page.has_css?('#shipto_freighttermscode > div.ms-crm-Inline-Value > span', :text => 'CIF', :visible => true)
                if page.has_css?('#fut_pl_viatransportadora > div.ms-crm-Inline-Value > span', :text => 'Rodoviário', :visible => true)
                      puts 'Via transporte: Rodoviário'
                elsif page.has_css?('#fut_pl_viatransportadora > div.ms-crm-Inline-Value > span', :text => 'Aéreo', :visible => true)
                      puts 'Via transporte: Aéreo'
                elsif page.has_css?('#fut_pl_viatransportadora > div.ms-crm-Inline-Value > span', :text => 'Retira', :visible => true)
                      puts 'Via transporte: Retira'
                elsif page.has_css?('#fut_pl_viatransportadora > div.ms-crm-Inline-Value > span', :text => 'Aéreo/Rodoviário', :visible => true)
                     puts 'Via transporte: Aéreo/Rodoviário'
                end       
                 
             elsif page.has_css?('#shipto_freighttermscode > div.ms-crm-Inline-Value > span', :text => 'CIF', :visible => false )
                puts 'Campo só poderá vir em branco caso seja FOB'
             end   

            #validar campo Imposto
            @imposto = find('#fut_mn_totalimpostos > div.ms-crm-Inline-Value.ms-crm-Inline-Locked > span').text.gsub('R$', '').gsub(',', '.').to_f
            expect(find('#fut_mn_totalimpostos > div.ms-crm-Inline-Value.ms-crm-Inline-Locked > span').text.gsub('R$', '').gsub(',', '.').to_f).not_to eql 0   

            #imprimir validações
            puts 'Valor Produto: R$' + @valor.to_s
            puts 'Valor Frete: R$' + @valorfrete.to_s
            puts 'Valor Despesas: R$' + @valordespe.to_s
            puts 'Valor Cotação: R$' + @valortotal.to_s
            puts 'Valor dos impostos: R$' + @imposto.to_s

   end   
end





