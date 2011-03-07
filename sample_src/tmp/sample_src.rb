#testplan: Test av funksjoner tilgjengelig for alle innloggede brukere


    #test: Test1: Sjekk at førstegangsbrukere blir registrert

    #task: Slett alle dataene for en bruker ved å første logge deg inn. 
    #check: Vi får logget inn
    
    #task: Forandre adressen i addressefeltet i nettleseren til ./ansatte/delete/brukernavnet-ditt
    #check: Skal få tilbakemelding om at vi er logget ut. 

    #task: Logg ut ved å gå til adressen ./authenticate/logout 
    #check: Sjekk at vi ikke er logget inn.

    #task: Gå til innloggingsside
    #check: Sjekk at vi er logget inn

    #test: Test2: Legge til abonnement

    #task: Task1: Abonner på 'Wired'
    #check: Check1: Sjekk at wired havner i listen til venstre

    #check: Check2: Sjekk at listen til venstre er tom igjen

    #task: Task2: Gå til adminsidene (/tidsskrifter)
    #check: Check1: Sjekk at vi ikke får tilgang til adminfunksjoner som vanlig bruker

    #task: Task3: Gå til innloggingsside

