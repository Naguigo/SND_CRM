#encoding: utf-8

class Formulario < SitePrism::Page
    #set_url 'http://srvcrmhom01:8081/PaginaCotacao/?userid={AD93AFE8-46FB-E911-811E-00155D063466}&OrgName=CRM'
    
    

    element :cliente, '#txtPesquisaCliente'
    # element :seleciona_Cliente, '#input[placeholder="Selecione o cliente"]'
    # element :tipo_de_operacao, '#txtTipoOperacao'
    # element :cond_pagamento, '#txtPesquisaCondicaoPagamento'    
    # element :topico, '#txtTopico'
    # element :tipo_venda, '#txtTipoVenda' 
    # element :condicoes_de_frete, '#txtFrete'
    # element :apelido, 'input[placeholder="Selecione o apelido"]'
    # element :botaocarrinho, 'btnCarrinho'
    # element :botaopesquisar, '#btnPesquisar'



        def preencher
           cliente.set CONFIG['cliente']
           seleciona_Cliente.set CONFIG['idcliente']
           tipo_de_operacao.set CONFIG['tipooperacao']      
           cond_pagamento.set CONFIG['condpagamento']
           topico.set CONFIG['topico']
           tipo_venda.set CONFIG['tipovenda']  
           condicoes_de_frete.set CONFIG['condiFrete']  
           apelido.set CONFIG['apelido']    
           botaopesquisar.click

        end
end    

