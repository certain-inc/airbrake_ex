# Changelog

## 0.3.0
- **Breaking:** now requires Elixir 1.17 or later (previously 1.14)
- Upgrade HTTPoison to 3.0 (hackney 4.x), remediating known hackney security advisories
- Update bypass test-server deps (plug, plug_cowboy, cowboy, cowlib) to clear their security advisories

## 0.2.10
- Fix `error_type/1` atom-to-string conversion so atom exception types match the ignore list
- Update maintainer information

## 0.2.9
- Fix a bug introduced in 0.2.8 with the decoding of the exception

## 0.2.8
- Hides filter_parameters option in the exception message and stack trace


## 0.2.7

- Hides all parameters containing a password
- Enhance documentation of filter_parameters option
