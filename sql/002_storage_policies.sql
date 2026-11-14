-- SAI FILM — Storage policies for bucket: saifilm-media
-- Expected object path: <project-uuid>/<filename>
-- The bucket is public for portfolio image/video delivery.
-- Public bucket downloads are accessible to anyone who has an object URL.
-- These policies protect uploads, updates, deletes, and object listing.

-- Public listing is limited to files belonging to published projects.
drop policy if exists "Public can list published SAI FILM media" on storage.objects;
create policy "Public can list published SAI FILM media"
on storage.objects for select
to anon, authenticated
using (
  bucket_id = 'saifilm-media'
  and exists (
    select 1
    from public.projects p
    where p.id::text = (storage.foldername(name))[1]
      and p.status = 'published'
  )
);

-- Only users explicitly registered in public.admin_users may upload.
drop policy if exists "SAI FILM admins can upload media" on storage.objects;
create policy "SAI FILM admins can upload media"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'saifilm-media'
  and exists (
    select 1 from public.admin_users a
    where a.user_id = (select auth.uid())
  )
);

-- Only SAI FILM admins may update existing media.
drop policy if exists "SAI FILM admins can update media" on storage.objects;
create policy "SAI FILM admins can update media"
on storage.objects for update
to authenticated
using (
  bucket_id = 'saifilm-media'
  and exists (
    select 1 from public.admin_users a
    where a.user_id = (select auth.uid())
  )
)
with check (
  bucket_id = 'saifilm-media'
  and exists (
    select 1 from public.admin_users a
    where a.user_id = (select auth.uid())
  )
);

-- Only SAI FILM admins may delete media.
drop policy if exists "SAI FILM admins can delete media" on storage.objects;
create policy "SAI FILM admins can delete media"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'saifilm-media'
  and exists (
    select 1 from public.admin_users a
    where a.user_id = (select auth.uid())
  )
);
