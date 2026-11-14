# SAI FILM

Portafolio audiovisual de SAI FILM.

## Arquitectura

- Frontend estático: HTML, CSS y JavaScript modular.
- Hosting: GitHub Pages.
- Backend de datos y autenticación: Supabase.
- Multimedia: Supabase Storage.
- Seguridad: Supabase Auth y Row Level Security (RLS).

## Estructura

```
assets/       Recursos visuales
css/          Estilos globales, componentes y responsive
js/           Navegación, animaciones, proyectos y Supabase
pages/        Secciones del sitio
admin/        Panel administrativo
config/       Configuración pública del cliente
sql/          Esquema, políticas y Storage
```

## Seguridad

El frontend solo podrá contener la URL del proyecto Supabase y una clave publishable. Nunca subir claves secretas ni service_role. Toda tabla expuesta debe tener RLS y políticas de mínimo privilegio.

## Publicación

El sitio se publicará desde la rama `main` mediante GitHub Pages. El archivo `index.html` permanece en la raíz del repositorio.
