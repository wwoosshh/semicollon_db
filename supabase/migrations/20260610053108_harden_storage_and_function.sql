-- 트리거 함수의 보안 모드를 명시 (기본값과 동일하지만 린터 경고 억제)
alter function public.set_updated_at() security invoker;

-- images 버킷 방어적 제한: 백엔드(service_role)가 유일한 업로더지만,
-- 실수/오설정에 대비해 5MB·이미지 MIME만 허용
update storage.buckets
set file_size_limit = 5242880,
    allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
where id = 'images';
