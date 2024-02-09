translate(name,lang){

  Map<String, Object>? data;

  print(lang);

  if(lang=='English'){

    data = {
      "login_text":"Hi! Log in for a personalized experience or sign up now",
      "text_login": "Login",
      "error_phone":"Please enter your phone number",
      "error_password":"Please enter your password",
      "label_phone":"Phone number",
      "label_password":"Password",
      "label_location":"Address",
      "error_location":"Please enter your address",
      "submit_login":"Login",
      "welcome_dash": "Welcome",
      "text_dash": "Member area",
      "contribution":'Contributions',
      "saving":"Savings",
      "payment":"Payments",
      "profil":"Account",
      "empty":"No data",
      "search":"Search",
      "amount_payment": "MY PAYMENTS",
      "total_payment": "TOTAL PAYMENTS",
      "pay_contribution": "PAY MY CONTRIBUTION",
      "title": 'Finalize payment',
      "description": 'Choose a payment method',
      "amount": 'AMOUNT',
      "confirm_data":'Done',
      "wait":'Please wait ...',
      "open_library":'Open gallery',
      "open_camera": "Open camera",
    };

  }else if(lang=='Français'){

    data = {
      "login_text":"Salut ! Connectez-vous pour une expérience personnalisée ou inscrivez-vous dès maintenant",
      "text_login": "Se connecter",
      "error_phone":"Veuillez saisir votre numéro de téléphone",
      "error_password":"Veuillez saisir votre mot de passe",
      "label_phone":"Numéro de téléphone",
      "label_password":"Mot de passe",
      "label_location":"Adresse",
      "error_location":"Veuillez saisir votre adresse",
      "submit_login":"Se connecter",
      "welcome_dash": "Bienvenue",
      "text_dash": "Espace membre",
      "contribution":'Cotisations',
      "saving":"Epargnes",
      "payment":"Paiements",
      "profil":"Informations",
      "empty":"Aucune donnée",
      "search":"Recherche",
      "amount_payment": "MES PAIEMENTS",
      "total_payment": "TOTAL PAIEMENTS",
      "pay_contribution": "PAYER MA COTISATION",
      "title": 'Finaliser le paiement',
      "description": 'Choisissez une méthode de paiement',
      "amount": 'MONTANT',
      "confirm_data":'Enregistrer',
      "wait":"Veuillez patienter ...",
      "open_library":'Ouvrir la galerie',
      "open_camera": "Ouvrir l'appareil photo",
    };

  }

  return data![name];

}