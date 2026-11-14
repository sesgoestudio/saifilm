-- Restaurar las imágenes originales del portafolio SAI FILM.
-- Ejecutar una sola vez en Supabase > SQL Editor. Es seguro volver a ejecutarlo.
insert into public.categories (name,slug,sort_order,is_active)
values
 ('Fotografía','photography',1,true),
 ('Cine y video','film-video',2,true),
 ('Producción creativa','creative-production',3,true)
on conflict (slug) do update set name=excluded.name,is_active=true;

insert into public.projects (title,slug,summary,description,category_id,status,is_featured,sort_order,published_at)
select v.title,v.slug,v.summary,v.description,c.id,'published',v.featured,v.ord,now()
from (values
 ('Experiencias en vivo','live-experiences','Producción audiovisual de experiencias y eventos.','Galería de producciones audiovisuales y experiencias en vivo.','film-video',true,1),
 ('Retratos','portrait-studies','Fotografía de retrato y sesiones personales.','Galería de retratos y fotografía editorial.','photography',false,2),
 ('Sesiones creativas','creative-sessions','Producción visual y sesiones creativas.','Galería de sesiones creativas y producción audiovisual.','film-video',false,3),
 ('Producción visual','visual-production','Contenido visual para marcas e ideas.','Galería de producción creativa y contenido visual.','creative-production',false,4)
) as v(title,slug,summary,description,category_slug,featured,ord)
join public.categories c on c.slug=v.category_slug
on conflict (slug) do update set title=excluded.title,summary=excluded.summary,description=excluded.description,status='published',is_featured=excluded.is_featured,sort_order=excluded.sort_order;

insert into public.project_media (project_id,media_type,external_url,alt_text,caption,is_cover,sort_order)
select p.id,'image',v.image_url,v.alt_text,v.caption,true,0
from (values
 ('live-experiences','https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1200&q=85','Fotografía de una experiencia en vivo','Experiencias en vivo'),
 ('portrait-studies','https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=1200&q=85','Fotografía de retrato','Retratos'),
 ('creative-sessions','https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=1200&q=85','Sesión creativa audiovisual','Sesiones creativas'),
 ('visual-production','https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=1200&q=85','Espacio de producción creativa','Producción visual')
) as v(slug,image_url,alt_text,caption)
join public.projects p on p.slug=v.slug
where not exists(select 1 from public.project_media m where m.project_id=p.id and m.is_cover=true);

update public.projects p
set cover_media_id=m.id
from public.project_media m
where m.project_id=p.id and m.is_cover=true and p.cover_media_id is null;
