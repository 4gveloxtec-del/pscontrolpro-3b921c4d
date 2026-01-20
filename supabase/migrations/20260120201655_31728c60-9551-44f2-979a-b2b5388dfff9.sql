-- Adicionar coluna para armazenar o número do WhatsApp conectado
ALTER TABLE public.whatsapp_seller_instances 
ADD COLUMN IF NOT EXISTS connected_phone TEXT NULL;

-- Comentário para documentação
COMMENT ON COLUMN public.whatsapp_seller_instances.connected_phone IS 'Número do WhatsApp conectado à instância (formato: 5511999999999)';