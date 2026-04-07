import { effectsEn } from './effects-en';

export const effectsRu = {
  ...effectsEn,
  effects: {
    ...effectsEn.effects,
    addicted: 'Зависимость',
    bleeding: 'Кровотечение',
    dehydrated: 'Обезвоживание',
    exhausted: 'Истощение',
    irradiated: 'Облучение',
    poisoned: 'Отравление',
    stunned: 'Оглушение',
  },
};
