




 @test                                                                                                                                    
Dado("que eu realize uma cotação com  {string}, {string}, {string}, {string}, {string}, {string}, {string}, {string}, {string}, {string}, {string}, {string}, {string}, {string}") do |cliente, revenda, nomecliente, tipooperacao, condpagamento, topico, tipovenda, condiFrete, taxainclusa, material, imprime_nfe, nro_nr, nro_Item, descdopedido|
   
    sleep 3 
    visit 'http://srvcrmhom01:8081/PaginaCotacao/?userid={AD93AFE8-46FB-E911-811E-00155D063466}&OrgName=CRM'
   
    sleep 8


   find('#txtPesquisaCliente').set cliente
   find('#txtPesquisaCliente').native.send_keys :tab
   sleep 6 
   find("li", :text => nomecliente).click
   sleep 10 
   
   @descricao_pedido = descdopedido

   @revenda = revenda
   if @revenda.eql?(" ")
      sleep 1
   elsif @revenda. > " "   
      find('#txtPesquisaRevenda').set revenda
      find('#txtPesquisaRevenda').native.send_keys :tab
      sleep 6
   end 
   

   find('input[name="txtTipoOperacao_input"]').set tipooperacao
   find('span[aria-controls="txtTipoOperacao_listbox"]').click
   sleep 3
   find("li", :text => tipooperacao).click
   #binding.pry
   #
 
  
   sleep 2
   find('#txtPesquisaCondicaoPagamento').set condpagamento
   
   # sleep 1
   # find('#txtTopico').set topico
   
   sleep 2
   find('input[aria-owns="txtTipoVenda_listbox"]').set tipovenda
   find('span[aria-controls="txtTipoVenda_listbox"]').click
   sleep 2
   find("li", :text => tipovenda).click
   
   #binding.pry

   
   sleep 2
   @cond_frete = condiFrete
   find('input[aria-owns="txtFrete_listbox"]').set condiFrete
   # page.execute_script("$('#txtFrete option[value=1]').click()")
   #find("li", :text => condiFrete).click
   


   
   # find('#Cabecalho > table > tbody > tr:nth-child(2) > td:nth-child(4) > div > span > span > input.k-formatted-value.K-nboxfontSize.k-input').click
   sleep 2   
   find('span[class="k-numeric-wrap k-state-default k-expand-padding"]').click
   find('#txtPorcentagem').set taxainclusa
   sleep 3
  

   find('#txtMaterial').set material

   
   # #chkNaoImprimeNF
   
   @imprimi_nfe = imprime_nfe
   if @imprimi_nfe ==  "S"
      sleep 1
   elsif @imprimi_nfe == "N"   
       find('#chkNaoImprimeNF').click
      sleep 3
   end   
   
   find('#btnPesquisar').click
   sleep 8

   # binding.pry

         #precisa mapear novos campos abaixo para incluir quantidade e preço

   
   #selecionar quantidade do produto no prieiro CD da tela
   page.find(:xpath, '//*[@id="gridFrozen"]/div[3]/table/tbody/tr/td[4]').click
   sleep 2
   find('#qtde_42').set '1'
   sleep 10

         #selecionar o produto com preço    
   @valor = page.find(:xpath, '//*[@id="gridFrozen"]/div[3]/table/tbody/tr/td[1]').text.gsub('R$', '').gsub(',', '.').to_f
   page.find(:xpath, '//*[@id="gridFrozen"]/div[3]/table/tbody/tr/td[1]').click
  
   find("span", :text => 'Adicionar ao Carrinho +').click   
   sleep 3

   #if para cotação de devolução
   if page.has_css?('#janelaNR > div:nth-child(1) > span > span > input.k-formatted-value.k-input',  :visible => true)
      page.find('#janelaNR > div:nth-child(1) > span > span > input.k-formatted-value.k-input').click
      find('#numNroNR').set '9220124'
      find("#janelaNR > div:nth-child(2) > span > span > input.k-formatted-value.k-input").click
      find('#numNroItem').set '1'
      find('#btnChecaNR').click
      
   elsif page.has_css?('#janelaNR > div:nth-child(2) > span > span > input.k-formatted-value.k-input',  :visible => false)   
      sleep 1
   end

   #gerar cotação   
   sleep 10
   find("span", :text => 'Gerar Cotação').click   #mapeamento novo
   #find('#btnGerarCotacao').click
   sleep 10   
   find("a", :text => 'Abrir Cotação').click
   


   popup = page.driver.browser.window_handles.last
   page.driver.browser.switch_to.window(popup)

   within_frame('contentIFrame0') do
            #Validar codígo terceiro
            @CODTerceiro= find('#Dados_Contato_Dados_Contato_account_fut_int_codterceiro > div.ms-crm-Inline-Value > span').text.gsub('.', '').to_s
            expect(find('#Dados_Contato_Dados_Contato_account_fut_int_codterceiro > div.ms-crm-Inline-Value > span').text.gsub('.', '').to_s).to eql cliente  
            
            
            @valorcotacao = find('#fut_mn_valortotalcotacao1 > div.ms-crm-Inline-Value.ms-crm-Inline-Locked > span').text.gsub('R$', '').gsub(',', '.').to_f
            
            expect(find('#fut_mn_valortotalcotacao > div.ms-crm-Inline-Value.ms-crm-Inline-Locked > span').text.gsub('R$', '').gsub(',', '.').to_f).to eql @valorcotacao
                                   
            
            #Validar Produto
            @produto = page.find(:css, '#gridBodyTable > tbody > tr > td:nth-child(3) > div').text
            # expect(page).to have_text descrição

            
            
            #Validar Campo transportadora
             if page.has_css?('#shipto_freighttermscode > div.ms-crm-Inline-Value > span', :text => 'CIF', :visible => true)
                if page.has_css?('#fut_pl_viatransportadora > div.ms-crm-Inline-Value > span', :text => 'Rodoviário', :visible => true)
                      #puts 'Via transporte: Rodoviário'
                      sleep 1
                elsif page.has_css?('#fut_pl_viatransportadora > div.ms-crm-Inline-Value > span', :text => 'Aéreo', :visible => true)
                     #puts 'Via transporte: Aéreo'
                     sleep 1
                elsif page.has_css?('#fut_pl_viatransportadora > div.ms-crm-Inline-Value > span', :text => 'Retira', :visible => true)
                      #puts 'Via transporte: Retira'
                      sleep 1
                elsif page.has_css?('#fut_pl_viatransportadora > div.ms-crm-Inline-Value > span', :text => 'Aéreo/Rodoviário', :visible => true)
                     #puts 'Via transporte: Aéreo/Rodoviário'
                     sleep 1
                end       
                 
             elsif page.has_css?('#shipto_freighttermscode > div.ms-crm-Inline-Value > span', :text => 'FOB', :visible => true )
                                 #Condições\ do\ Frete_label
                puts 'Campo só poderá vir em branco caso seja FOB'
               
                #abaixo esta a construção para cotação FOB
                #  sleep 2
               #  #selecionar campo via transportadora
               #  find('#fut_pl_viatransportadora > div.ms-crm-Inline-Value.ms-crm-Inline-EmptyValue').click
               #  find('#fut_pl_viatransportadora_i > option:nth-child(4)').click
                
               #  #selecionar campo transportadora
                
               #  find('#fut_lk_transportadora > div.ms-crm-Inline-Value.ms-crm-Inline-Lookup.ms-crm-Inline-EmptyValue').click
               #  # find('#fut_lk_transportadora_ledit').set '#N/A'
               #  # find('#fut_lk_transportadora_ledit').native.send_keys :enter

               #  sleep 3    #fut_lk_transportadora_ledit

               #  #clicar em salvar
               #  find("li[id='quote|NoRelationship|Form|Mscrm.Form.quote.Save']").click
                
               #  sleep 6
               #  #clicar em recalcular
               #  find("li[id='quote|NoRelationship|Form|fut.quote.Button.Recalcular']").click
               #  sleep 12
                
             end   

            #validar campo Imposto
            @imposto = find('#fut_mn_totalimpostos > div.ms-crm-Inline-Value.ms-crm-Inline-Locked > span').text.gsub('R$', '').gsub(',', '.').to_f
            expect(find('#fut_mn_totalimpostos > div.ms-crm-Inline-Value.ms-crm-Inline-Locked > span').text.gsub('R$', '').gsub(',', '.').to_f).not_to eql 0   

            #imprimir validações
            # puts 'Valor Produto: R$' + @valor.to_s
            # puts 'Valor Frete: R$' + @valorfrete.to_s
            # puts 'Valor Despesas: R$' + @valordespe.to_s
            # puts 'Valor Cotação: R$' + @valortotal.to_s
            # puts 'Valor dos impostos: R$' + @imposto.to_s

   end   
  end
  
  Quando("eu realizar as aprovações") do
      
      #clicak em ativar cotação
      sleep 8
      
      find("li[id='quote|NoRelationship|Form|Mscrm.Form.quote.ActivateQuote']").click 
      sleep 6
      page.driver.browser.switch_to.alert.accept #popup - de cotação ativa
      sleep 8
      
      #clicar em gerar pedido
      find('#quote\|NoRelationship\|Form\|Mscrm\.Form\.quote\.CreateOrder > span > a > span').click
      sleep 5
      #dar foco ao IFrame
      within_frame('InlineDialog_Iframe') do
          find('#butBegin').click        
      end      
      
      sleep 30

      find("li[id='salesorder|NoRelationship|Form|fut.salesorder.Button.GerarPedidoNoERP']").click
      
      
  end
  
  Entao("o pedido será gerado") do
      
      sleep 10
      within_frame('contentIFrame0') do
            @numero_pedido =  find('#header_fut_numero_pedido > div.ms-crm-Inline-Value.ms-crm-HeaderTile.ms-crm-Inline-Locked > span').text
            
      end      


      

      
      puts @descricao_pedido    
      puts ' Numero do Pedido ' + @numero_pedido

  end

