import itemsEn from './items-en';

export default {
  ...itemsEn,
  items: {
    ...itemsEn.items,
    weapons: {
      ...itemsEn.items.weapons,
      '10mm Pistol': 'Пистолет 10 мм',
      'Assault Rifle': 'Штурмовая винтовка',
      'Combat Rifle': 'Боевая винтовка',
      'Hunting Rifle': 'Охотничья винтовка',
      'Submachine Gun': 'Пистолет-пулемёт',
      'Combat Shotgun': 'Боевой дробовик',
      'Laser Pistol': 'Лазерный пистолет',
      'Fat Man': 'Фэтмен',
      'Minigun': 'Миниган',
      'Combat Knife': 'Боевой нож',
      'Machete': 'Мачете',
      'Baseball Bat': 'Бейсбольная бита',
      'Frag Grenade': 'Осколочная граната',
      'Molotov Cocktail': 'Коктейль Молотова',
    },
    ammunition: {
      ...itemsEn.items.ammunition,
      '10mm Rounds': 'Патроны 10 мм',
      '.308 Rounds': 'Патроны .308',
      'Shotgun Shells': 'Дробовые патроны',
      'Fusion Cells': 'Ячейки синтеза',
      'Missiles': 'Ракеты',
      'Mini Nuke': 'Мини-ядерный заряд',
    },
  },
};
