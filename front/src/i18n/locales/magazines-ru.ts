import { magazinesEn } from './magazines-en';

export const magazinesRu = {
  ...magazinesEn,
  magazines: {
    ...magazinesEn.magazines,
    title: 'Журналы',
  },
};
