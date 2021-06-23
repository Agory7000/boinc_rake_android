# boinc_rake_android
Изменения кода BOINC и RakeSearch для запуска вычислительных экспериментов.

Generator.cpp - измененный генератор входных файлов рабочих единиц из RakeWuGenerator;
starting_parameters.txt - стартовые параметры генерации;
main.cpp - измененный main-файл RakeWuGenerator;
sample_work_generator.cpp - код программы-демона, настроенной на распознавание входных файлов из RakeWuGenerator и преобразующей их в рабочие единицы;
Makefile - измененный makefile из /boinc/samples/example_app, чтобы скрипты из /boinc/android корректно распознавали вычислительный код RakeSearch.
