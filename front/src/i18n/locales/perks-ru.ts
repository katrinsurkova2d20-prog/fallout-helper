import perksEn from './perks-en';

export default {
  ...perksEn,
  perks: {
    ...perksEn.perks,
    IronFist: 'Железный кулак',
    Toughness: 'Живучесть',
    GunNut: 'Оружейник',
    Medic: 'Медик',
    FortuneFinder: 'Искатель удачи',
    BloodyMess: 'Кровавая баня',
  },
};
