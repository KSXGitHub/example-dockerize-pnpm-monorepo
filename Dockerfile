FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
COPY . /app
WORKDIR /app

FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

FROM base AS build
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run -r build

FROM base AS common
COPY --from=prod-deps /app/packages/common/node_modules/ /app/packages/common/node_modules
COPY --from=build /app/packages/common/dist /app/packages/common/dist

FROM common AS foo
COPY --from=prod-deps /app/packages/foo/node_modules/ /app/packages/foo/node_modules
COPY --from=build /app/packages/foo/dist /app/packages/foo/dist
WORKDIR /app/packages/foo
CMD [ "pnpm", "start" ]

FROM common AS bar
COPY --from=prod-deps /app/packages/bar/node_modules/ /app/packages/bar/node_modules
COPY --from=build /app/packages/bar/dist /app/packages/bar/dist
WORKDIR /app/packages/bar
CMD [ "pnpm", "start" ]
