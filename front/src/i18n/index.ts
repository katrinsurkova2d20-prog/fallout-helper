import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';

import fr from './locales/fr';
import en from './locales/en';
import ru from './locales/ru';
import itemsFr from './locales/items-fr';
import itemsEn from './locales/items-en';
import perksFr from './locales/perks-fr';
import perksEn from './locales/perks-en';
import { effectsFr } from './locales/effects-fr';
import { effectsEn } from './locales/effects-en';
import { magazinesFr } from './locales/magazines-fr';
import { magazinesEn } from './locales/magazines-en';
import itemsRu from './locales/items-ru';
import perksRu from './locales/perks-ru';
import { effectsRu } from './locales/effects-ru';
import { magazinesRu } from './locales/magazines-ru';

// Merge item, perk, effects, and magazine translations into base translations
const frMerged = { ...fr, ...itemsFr, ...perksFr, ...effectsFr, ...magazinesFr };
const enMerged = { ...en, ...itemsEn, ...perksEn, ...effectsEn, ...magazinesEn };
const ruMerged = { ...enMerged, ...ru, ...itemsRu, ...perksRu, ...effectsRu, ...magazinesRu };

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: {
      fr: { translation: frMerged },
      en: { translation: enMerged },
      ru: { translation: ruMerged },
    },
    fallbackLng: 'ru',
    supportedLngs: ['fr', 'en', 'ru'],
    interpolation: {
      escapeValue: false,
    },
    detection: {
      order: ['localStorage', 'navigator', 'htmlTag'],
      caches: ['localStorage'],
    },
  });

export default i18n;
