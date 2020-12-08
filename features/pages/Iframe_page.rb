class PaginaIframe < SitePrism::Page

    element :valorcotacao, '#fut_mn_valortotalcotacao > div.ms-crm-Inline-Value.ms-crm-Inline-Locked > span'
    
 end


 class PaginaPadrao < SitePrism::Page
    set_url '/main.aspx?pagetype=entityrecord&etn=quote&id=944eb7d9-9721-ea11-8123-00155d063466#861544312'
    iframe :resultado_cotacao, PaginaIframe, '#contentIFrame0'
     
 end