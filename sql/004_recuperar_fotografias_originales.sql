-- Recuperar las fotografías originales del portafolio Wix de SAI FILM.
-- Conserva las fotos en Wix como origen público y permite sustituirlas luego desde el administrador.
with imgs(ord, url) as (
 values
 (1, 'https://static.wixstatic.com/media/8b88f0_4196add38fd54fd4b1ab68d5cb507003~mv2.jpg'),
 (2, 'https://static.wixstatic.com/media/8b88f0_ce3bb1eabf8f460db7a87b22275deb30~mv2.jpg'),
 (3, 'https://static.wixstatic.com/media/8b88f0_d70b60bfd8bd4cb19dcde65d403fc63b~mv2.jpg'),
 (4, 'https://static.wixstatic.com/media/8b88f0_46bab56dab274c5aa100f47b2c73b385~mv2.jpg'),
 (5, 'https://static.wixstatic.com/media/8b88f0_1d0529a4bf3145a4b277bff33c7a4fdc~mv2.jpg'),
 (6, 'https://static.wixstatic.com/media/8b88f0_73cd620e9512437588ebcd33a6d97d99~mv2.jpg'),
 (7, 'https://static.wixstatic.com/media/8b88f0_1c33dc9ce892496a814c94210fd4006b~mv2.jpg'),
 (8, 'https://static.wixstatic.com/media/8b88f0_b744f082c4f34c39b186eef7a512e25a~mv2.jpg'),
 (9, 'https://static.wixstatic.com/media/8b88f0_8fe1bf1d2ed94798a94d361145e0e300~mv2.jpg'),
 (10, 'https://static.wixstatic.com/media/8b88f0_896118e0a094452bbf700612ece49e5f~mv2.jpg'),
 (11, 'https://static.wixstatic.com/media/8b88f0_669cb496788b416199ac3e685678865b~mv2.jpg'),
 (12, 'https://static.wixstatic.com/media/8b88f0_eda500957be34658b80b5eeab1513c8b~mv2.jpg'),
 (13, 'https://static.wixstatic.com/media/8b88f0_a4fb5a1a2c3f404a82e8beb586763e72~mv2.jpg'),
 (14, 'https://static.wixstatic.com/media/8b88f0_27e1b89311db48379f7fef31183c1921~mv2.jpg'),
 (15, 'https://static.wixstatic.com/media/8b88f0_f90e291052ea40c9a95b65a0a8411f07~mv2.jpg'),
 (16, 'https://static.wixstatic.com/media/8b88f0_2bdb5e7aaa04407690e90ce83be53a94~mv2.jpg'),
 (17, 'https://static.wixstatic.com/media/8b88f0_78281c7fd07542c7b4924329f7b07cf2~mv2.jpg'),
 (18, 'https://static.wixstatic.com/media/8b88f0_42eceedcf9aa45d48d4ddacdb6ddffb9~mv2.jpg'),
 (19, 'https://static.wixstatic.com/media/8b88f0_e7a510cd30f14cc796d3a8d29808def5~mv2.jpg'),
 (20, 'https://static.wixstatic.com/media/8b88f0_279ee7bf4aab4a518695cd4594ce0352~mv2.jpg'),
 (21, 'https://static.wixstatic.com/media/8b88f0_de5694586be64655aae9e473a19c3f37~mv2.jpg'),
 (22, 'https://static.wixstatic.com/media/8b88f0_69b16999808f4efbb7d2c263a346d061~mv2.jpg'),
 (23, 'https://static.wixstatic.com/media/8b88f0_9f259748d6f34c47b341780d44096906~mv2.jpg'),
 (24, 'https://static.wixstatic.com/media/8b88f0_99706636b8a84cdd84edd4fdec6bdcb6~mv2.jpg'),
 (25, 'https://static.wixstatic.com/media/8b88f0_cbb5d55037e7443db81674ab4095efa4~mv2.jpg'),
 (26, 'https://static.wixstatic.com/media/8b88f0_1ab149f7264f44c4a914d2c58b6b5382~mv2.jpg'),
 (27, 'https://static.wixstatic.com/media/8b88f0_99727440cb3447118645d0acdfee74d9~mv2.jpg'),
 (28, 'https://static.wixstatic.com/media/8b88f0_a504fefe4c644b4aa6a349afb2332de9~mv2.jpg'),
 (29, 'https://static.wixstatic.com/media/8b88f0_c5feb4587d5f47ac83c24a5b5ac95b02~mv2.jpg'),
 (30, 'https://static.wixstatic.com/media/8b88f0_1a5b312322504b45ac2bf8c49bfdc11c~mv2.jpg'),
 (31, 'https://static.wixstatic.com/media/8b88f0_1153c06262ae4318bda879fdc3162c2f~mv2.jpg')
),
projects as (
 select slug, id, row_number() over(order by case slug
  when 'live-experiences' then 1 when 'portrait-studies' then 2
  when 'creative-sessions' then 3 when 'visual-production' then 4 else 5 end) as n
 from public.projects
 where slug in ('live-experiences','portrait-studies','creative-sessions','visual-production')
),
covers as (
 select p.id as project_id, i.ord, i.url,
        case p.slug when 'live-experiences' then 'Fotografía original de SAI FILM'
         when 'portrait-studies' then 'Retrato original de SAI FILM'
         when 'creative-sessions' then 'Sesión original de SAI FILM'
         else 'Producción visual original de SAI FILM' end as alt
 from projects p join imgs i on i.ord=p.n
)
update public.project_media m
set external_url=c.url, storage_path=null, alt_text=c.alt
from covers c
where m.project_id=c.project_id and m.is_cover=true and m.media_type='image';

with imgs(ord, url) as (
 values
 (1, 'https://static.wixstatic.com/media/8b88f0_4196add38fd54fd4b1ab68d5cb507003~mv2.jpg'),
 (2, 'https://static.wixstatic.com/media/8b88f0_ce3bb1eabf8f460db7a87b22275deb30~mv2.jpg'),
 (3, 'https://static.wixstatic.com/media/8b88f0_d70b60bfd8bd4cb19dcde65d403fc63b~mv2.jpg'),
 (4, 'https://static.wixstatic.com/media/8b88f0_46bab56dab274c5aa100f47b2c73b385~mv2.jpg'),
 (5, 'https://static.wixstatic.com/media/8b88f0_1d0529a4bf3145a4b277bff33c7a4fdc~mv2.jpg'),
 (6, 'https://static.wixstatic.com/media/8b88f0_73cd620e9512437588ebcd33a6d97d99~mv2.jpg'),
 (7, 'https://static.wixstatic.com/media/8b88f0_1c33dc9ce892496a814c94210fd4006b~mv2.jpg'),
 (8, 'https://static.wixstatic.com/media/8b88f0_b744f082c4f34c39b186eef7a512e25a~mv2.jpg'),
 (9, 'https://static.wixstatic.com/media/8b88f0_8fe1bf1d2ed94798a94d361145e0e300~mv2.jpg'),
 (10, 'https://static.wixstatic.com/media/8b88f0_896118e0a094452bbf700612ece49e5f~mv2.jpg'),
 (11, 'https://static.wixstatic.com/media/8b88f0_669cb496788b416199ac3e685678865b~mv2.jpg'),
 (12, 'https://static.wixstatic.com/media/8b88f0_eda500957be34658b80b5eeab1513c8b~mv2.jpg'),
 (13, 'https://static.wixstatic.com/media/8b88f0_a4fb5a1a2c3f404a82e8beb586763e72~mv2.jpg'),
 (14, 'https://static.wixstatic.com/media/8b88f0_27e1b89311db48379f7fef31183c1921~mv2.jpg'),
 (15, 'https://static.wixstatic.com/media/8b88f0_f90e291052ea40c9a95b65a0a8411f07~mv2.jpg'),
 (16, 'https://static.wixstatic.com/media/8b88f0_2bdb5e7aaa04407690e90ce83be53a94~mv2.jpg'),
 (17, 'https://static.wixstatic.com/media/8b88f0_78281c7fd07542c7b4924329f7b07cf2~mv2.jpg'),
 (18, 'https://static.wixstatic.com/media/8b88f0_42eceedcf9aa45d48d4ddacdb6ddffb9~mv2.jpg'),
 (19, 'https://static.wixstatic.com/media/8b88f0_e7a510cd30f14cc796d3a8d29808def5~mv2.jpg'),
 (20, 'https://static.wixstatic.com/media/8b88f0_279ee7bf4aab4a518695cd4594ce0352~mv2.jpg'),
 (21, 'https://static.wixstatic.com/media/8b88f0_de5694586be64655aae9e473a19c3f37~mv2.jpg'),
 (22, 'https://static.wixstatic.com/media/8b88f0_69b16999808f4efbb7d2c263a346d061~mv2.jpg'),
 (23, 'https://static.wixstatic.com/media/8b88f0_9f259748d6f34c47b341780d44096906~mv2.jpg'),
 (24, 'https://static.wixstatic.com/media/8b88f0_99706636b8a84cdd84edd4fdec6bdcb6~mv2.jpg'),
 (25, 'https://static.wixstatic.com/media/8b88f0_cbb5d55037e7443db81674ab4095efa4~mv2.jpg'),
 (26, 'https://static.wixstatic.com/media/8b88f0_1ab149f7264f44c4a914d2c58b6b5382~mv2.jpg'),
 (27, 'https://static.wixstatic.com/media/8b88f0_99727440cb3447118645d0acdfee74d9~mv2.jpg'),
 (28, 'https://static.wixstatic.com/media/8b88f0_a504fefe4c644b4aa6a349afb2332de9~mv2.jpg'),
 (29, 'https://static.wixstatic.com/media/8b88f0_c5feb4587d5f47ac83c24a5b5ac95b02~mv2.jpg'),
 (30, 'https://static.wixstatic.com/media/8b88f0_1a5b312322504b45ac2bf8c49bfdc11c~mv2.jpg'),
 (31, 'https://static.wixstatic.com/media/8b88f0_1153c06262ae4318bda879fdc3162c2f~mv2.jpg')
),
projects as (
 select slug,id,row_number() over(order by case slug
  when 'live-experiences' then 1 when 'portrait-studies' then 2
  when 'creative-sessions' then 3 when 'visual-production' then 4 else 5 end) as n
 from public.projects
 where slug in ('live-experiences','portrait-studies','creative-sessions','visual-production')
)
insert into public.project_media(project_id,media_type,external_url,alt_text,caption,is_cover,sort_order)
select p.id,'image',i.url,'Fotografía original del portafolio SAI FILM','Galería original',false,i.ord
from imgs i
join projects p on p.n=((i.ord-1)%4)+1
where i.ord>4
and not exists(select 1 from public.project_media m where m.external_url=i.url);

-- Confirma cuántas fotos quedan asociadas a cada proyecto.
select p.title, count(m.id) as fotografias
from public.projects p left join public.project_media m on m.project_id=p.id
where p.slug in ('live-experiences','portrait-studies','creative-sessions','visual-production')
group by p.id,p.title,p.sort_order
order by p.sort_order;
