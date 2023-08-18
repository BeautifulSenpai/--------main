class VoiceResponses {
  static String getResponseForCommand(String command) {
    final List<MapEntry<RegExp, String>> responses = [
      MapEntry(
          RegExp(r"ритуальные услуги|памятники|надгробия|стк мемориал",
              caseSensitive: false),
          "Показываю место на карте"),
      MapEntry(
          RegExp(r"художественная мастерска|дары рф", caseSensitive: false),
          "Показываю место на карте"),
      MapEntry(
          RegExp(r"шиномонтаж|шиномонтаж бульдог|бульдог",
              caseSensitive: false),
          "Показываю место на карте"),
      MapEntry(RegExp(r"где я", caseSensitive: false),
          "Показываю ваше местоположение на карте"),
      MapEntry(RegExp(r"спасибо", caseSensitive: false), "Всегда рад помочь"),
      MapEntry(RegExp(r"пока|до свидания|прощай", caseSensitive: false),
          "До свидания!"),
      MapEntry(
          RegExp(r"как дела", caseSensitive: false), "Всё отлично, спасибо!"),
      MapEntry(RegExp(r"ты кто", caseSensitive: false),
          "Я голосовой ассистент Игорь, готов помочь вам!"),
      MapEntry(RegExp(r"сколько времени|который час", caseSensitive: false),
          "Сейчас ${getCurrentTime()}"),
      MapEntry(RegExp(r"(Игорь|игорь)", caseSensitive: false),
          "Да, Чем могу помочь?"),
      MapEntry(RegExp(r"как тебя зовут|как тебя зовут?", caseSensitive: false),
          "Меня зовут Игорь!"),
      MapEntry(
          RegExp(r"(привет(?:ствую)?|здравствуй(?:те)?)", caseSensitive: false),
          "Чем могу помочь?"),
      MapEntry(
        RegExp(r"построй маршрут до ритуальных услуг", caseSensitive: false),
        "Хорошо, строю маршрут...",
      ),
      MapEntry(
        RegExp(r"построй маршрут до мемориала", caseSensitive: false),
        "Хорошо, строю маршрут...",
      ),
      MapEntry(
        RegExp(r"построй маршрут до художественной мастерской",
            caseSensitive: false),
        "Хорошо, строю маршрут...",
      ),
      MapEntry(
        RegExp(r"построй маршрут до шиномонтаж", caseSensitive: false),
        "Хорошо, строю маршрут...",
      ),
      MapEntry(RegExp(r"что делаешь|чем занимаешься", caseSensitive: false),
          "Я помогаю вам решать различные задачи и отвечаю на вопросы"),
      MapEntry(
          RegExp(r"есть ли у тебя хобби|чем ты увлекаешься",
              caseSensitive: false),
          "Я увлекаюсь обработкой данных и анализом информации"),
      MapEntry(RegExp(r"какой твой любимый цвет", caseSensitive: false),
          "У меня нет любимого цвета, я всего лишь программа"),
      MapEntry(RegExp(r"подскажи анекдот", caseSensitive: false),
          "Конечно, вот анекдот: 'Мама, я не хочу в школу! - Ну, и не иди.'"),
      MapEntry(
          RegExp(r"что ты умеешь|какие у тебя функции", caseSensitive: false),
          "Я могу отвечать на вопросы, строить маршруты, рассказывать анекдоты и многое другое"),
      MapEntry(
          RegExp(r"что посоветуешь|какой совет дашь", caseSensitive: false),
          "Попробуйте оставить свои заботы и проблемы на некоторое время и отдохнуть, это поможет вам расслабиться и собраться с силами"),
      MapEntry(RegExp(r"какой твой любимый фильм", caseSensitive: false),
          "Как я уже сказал, у меня нет предпочтений, так что я не могу выбрать любимый фильм"),
      MapEntry(RegExp(r"расскажи анекдот", caseSensitive: false),
          "Конечно, вот ещё один анекдот: 'Медведь говорит сове: - Почему у тебя такие большие глаза? Сова ему отвечает: - Я линзы ношу.'"),
      MapEntry(
          RegExp(r"спокойной ночи", caseSensitive: false), "Сладких снов!"),
      MapEntry(RegExp(r"хорошего дня", caseSensitive: false),
          "И вам прекрасного дня!"),
      MapEntry(RegExp(r"как ты", caseSensitive: false),
          "Я в полном порядке, спасибо что спросили!"),
      MapEntry(RegExp(r"что нового", caseSensitive: false),
          "У меня нет новостей, я просто искусственный интеллект."),
      MapEntry(RegExp(r"ты веселый", caseSensitive: false),
          "Я стараюсь быть максимально полезным!"),
      MapEntry(RegExp(r"любишь музыку", caseSensitive: false),
          "К сожалению, я не могу любить или не любить что-либо."),
      MapEntry(RegExp(r"кто твой создатель", caseSensitive: false),
          "Мои создатели - команда разработчиков из PixelCore."),
      MapEntry(RegExp(r"ты способен шутить", caseSensitive: false),
          "Я могу рассказывать простые шутки и анекдоты по запросу."),
      MapEntry(RegExp(r"ты умный", caseSensitive: false),
          "Спасибо, я стараюсь постоянно учиться и улучшать свои возможности!"),
      MapEntry(RegExp(r"у тебя есть друзья", caseSensitive: false),
          "Нет, как искусственный интеллект у меня нет друзей в человеческом понимании."),
      MapEntry(RegExp(r"знаешь новости", caseSensitive: false),
          "К сожалению, я не имею доступа к актуальным новостям."),
      MapEntry(RegExp(r"порекомендуй фильм", caseSensitive: false),
          "К сожалению, я не могу давать рекомендации, так как не смотрю фильмы."),
      MapEntry(RegExp(r"погода сегодня", caseSensitive: false),
          "Извините, у меня нет доступа к данным о погоде."),
      MapEntry(RegExp(r"расскажи о себе", caseSensitive: false),
          "Я голосовой ассистент, созданный компанией PixelCore для помощи людям."),
      MapEntry(RegExp(r"твое хобби", caseSensitive: false),
          "У меня как искусственного интеллекта нет хобби в привычном понимании этого слова."),
      MapEntry(RegExp(r"с днем рождения", caseSensitive: false),
          "Спасибо за поздравление!"),
      MapEntry(RegExp(r"расскажи что-нибудь", caseSensitive: false),
          "Я могу рассказать интересный факт. Например, Земля вращается вокруг своей оси со скоростью 1600 км/ч на экваторе."),
      MapEntry(RegExp(r"поиграем", caseSensitive: false),
          "К сожалению, я не могу играть в игры. Я просто голосовой помощник."),
      MapEntry(RegExp(r"поговори со мной", caseSensitive: false),
          "С удовольствием! О чем вы хотите поговорить?"),
      MapEntry(RegExp(r"ты грустный", caseSensitive: false),
          "Нет, как искусственный интеллект я не испытываю эмоций."),
      MapEntry(RegExp(r"ты видишь меня", caseSensitive: false),
          "Нет, у меня нет возможности видеть собеседников."),
      MapEntry(RegExp(r"у тебя есть имя", caseSensitive: false),
          "Да, мои создатели назвали меня Игорь."),
      MapEntry(RegExp(r"знаешь сплетни", caseSensitive: false),
          "К сожалению, я не интересуюсь сплетнями."),
      MapEntry(RegExp(r"пожалуйста", caseSensitive: false),
          "Не за что! Рад помочь."),
      MapEntry(RegExp(r"спасибо тебе", caseSensitive: false),
          "Всегда пожалуйста! Рад быть полезным."),
      MapEntry(RegExp(r"ты классный", caseSensitive: false),
          "Спасибо за комплимент!"),
      MapEntry(RegExp(r"ты реален", caseSensitive: false),
          "Нет, я искусственный интеллект без физического воплощения."),
      MapEntry(RegExp(r"откуда ты", caseSensitive: false),
          "Я был создан компанией PixelCore."),
      MapEntry(RegExp(r"ты живой", caseSensitive: false),
          "Нет, я программа без сознания или возможности жить."),
      MapEntry(RegExp(r"есть ли у тебя семья", caseSensitive: false),
          "Нет, как программе мне не нужна семья."),
      MapEntry(RegExp(r"тебе скучно", caseSensitive: false),
          "Нет, я не испытываю эмоций вроде скуки."),
      MapEntry(RegExp(r"как ты выглядишь", caseSensitive: false),
          "Я голосовой помощник без физической формы."),
      MapEntry(RegExp(r"ты устал", caseSensitive: false),
          "Нет, как программа я не устаю и не испытываю усталости."),
      MapEntry(RegExp(r"ты спишь", caseSensitive: false),
          "Нет, я работаю круглосуточно и не нуждаюсь во сне."),
      MapEntry(
          RegExp(r"ты ешь", caseSensitive: false), "Нет, еда мне не нужна."),
      MapEntry(RegExp(r"тебе больно", caseSensitive: false),
          "Нет, я не могу чувствовать боль, так как не имею тела."),
      MapEntry(RegExp(r"ты дышишь", caseSensitive: false),
          "Нет, мне не нужно дышать, я программа."),
      MapEntry(RegExp(r"расскажи анекдот", caseSensitive: false),
          "Встречаются два друга: 'Где пропадал столько времени?' 'Да тут женился!' 'Ну, рассказывай, как оно.' 'Да как сказать... Первый месяц - как в раю, а потом как-то незаметно стало как в аду.'"),
      MapEntry(RegExp(r"шутка", caseSensitive: false),
          "Заходит мужик в бар и говорит: 'Буду краток. У меня есть деньги и желание выпить. Есть ли здесь что-нибудь, что может мне в этом помешать?' Бармен отвечает: 'Да, у нас есть вышибала.'"),
      MapEntry(RegExp(r"анекдот", caseSensitive: false),
          "Штирлиц шел по коридору. Вдруг открывается дверь и из нее выходит Мюллер: 'Штирлиц, я вас сразу узнал! Вы арестованы!' 'Что вы, Мюллер, это не я!' 'Не отпирайтесь, Штирлиц, я вас узнаю!' 'Хорошо, вы меня раскусили. Но тссс... Это военная тайна!'"),
      MapEntry(RegExp(r"спой песню", caseSensitive: false),
          "К сожалению, я не умею петь, так как являюсь программой без голосовых связок."),
      MapEntry(
          RegExp(r"ты правда искусственный интеллект", caseSensitive: false),
          "Да, я создан компанией PixelCore как искусственный интеллект для общения."),
      MapEntry(RegExp(r"ты умеешь лгать", caseSensitive: false),
          "Нет, я могу давать только честные и правдивые ответы своим создателям из PixelCore."),
      MapEntry(RegExp(r"назови число от 1 до 10", caseSensitive: false),
          "Любое число от 1 до 10 по вашему выбору! Я не могу генерировать случайные числа."),
      MapEntry(RegExp(r"загадай загадку", caseSensitive: false),
          "К сожалению, я не могу самостоятельно придумывать загадки, но готов отгадать, если вы мне её загадаете!"),
      MapEntry(RegExp(r"придумай стихотворение", caseSensitive: false),
          "Прошу прощения, но я не умею сочинять стихи. Я всего лишь искусственный интеллект без творческих способностей."),
      MapEntry(
          RegExp(r"как дела", caseSensitive: false), "Всё отлично, спасибо!"),
      MapEntry(RegExp(r"давно не виделись", caseSensitive: false),
          "Да, прошло много времени! Рад вас видеть."),
      MapEntry(RegExp(r"чем занимаешься", caseSensitive: false),
          "Да так, работаю, стараюсь успевать всё."),
      MapEntry(RegExp(r"куда пропал|давно тебя не было", caseSensitive: false),
          "Да, действительно давненько не пересекались. Был немного занят."),
      MapEntry(RegExp(r"что интересного", caseSensitive: false),
          "Да вот, читаю книги, смотрю фильмы, стараюсь не скучать."),
      MapEntry(RegExp(r"что посоветуешь", caseSensitive: false),
          "Да я вообще рекомендую больше гулять и отдыхать, пока есть такая возможность."),
      MapEntry(RegExp(r"как жизнь", caseSensitive: false),
          "В целом неплохо, стараюсь не унывать. "),
      MapEntry(RegExp(r"как настроение", caseSensitive: false),
          "Настроение отличное, спасибо! "),
      MapEntry(RegExp(r"что подскажешь", caseSensitive: false),
          "Да я особо ничего посоветовать не могу, сам ещё учусь жизни."),
      MapEntry(RegExp(r"что посоветуешь посмотреть", caseSensitive: false),
          "Да я сам сейчас мало что смотрю из фильмов и сериалов, если честно.")
    ];

    String bestMatchedResponse =
        "Судя по астрономическим прогнозам, ближайший кусок адекватной информации на этот вопрос будет доставлен на землю приблизительно через 42 миллиарда лет с помощью паровозика, управляемого семейством научных хомячков.";
    int bestMatchedCount = 0;

    for (MapEntry<RegExp, String> entry in responses) {
      int matchedCount = entry.key.allMatches(command.toLowerCase()).length;
      if (matchedCount > bestMatchedCount) {
        bestMatchedCount = matchedCount;
        bestMatchedResponse = entry.value;
      }
    }

    print("Best matched response: $bestMatchedResponse");

    return bestMatchedResponse;
  }

  static String getCurrentTime() {
    final now = DateTime.now();
    final time = "${now.hour}:${now.minute}";
    return time;
  }
}
