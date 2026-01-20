-- Create table for keyword-based auto-responses
CREATE TABLE IF NOT EXISTS public.admin_chatbot_keywords (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    keyword TEXT NOT NULL,
    response_text TEXT NOT NULL,
    is_exact_match BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create unique index for keywords
CREATE UNIQUE INDEX IF NOT EXISTS idx_admin_chatbot_keywords_keyword 
ON public.admin_chatbot_keywords (LOWER(keyword));

-- Enable RLS
ALTER TABLE public.admin_chatbot_keywords ENABLE ROW LEVEL SECURITY;

-- Only admins can manage keywords
CREATE POLICY "Admins can manage keywords" 
ON public.admin_chatbot_keywords 
FOR ALL 
USING (
    EXISTS (
        SELECT 1 FROM public.user_roles 
        WHERE user_id = auth.uid() AND role = 'admin'
    )
);

-- Create trigger for updated_at
CREATE TRIGGER update_admin_chatbot_keywords_updated_at
BEFORE UPDATE ON public.admin_chatbot_keywords
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Add setting for ignore invalid options (silent mode)
INSERT INTO public.app_settings (key, value)
VALUES ('admin_chatbot_ignore_invalid', 'true')
ON CONFLICT (key) DO UPDATE SET value = 'true', updated_at = now();