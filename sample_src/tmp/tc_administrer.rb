require 'rubygems'
require 'test/unit'
require 'test_utils.rb'
include TestUtilsMixIn

#testplan: Test av funksjoner tilgjengelig for alle innloggede brukere

class AdministrerTidsskrifter < Test::Unit::TestCase

  def delete_current_user
    # Slett alle eksisterende data for bruker:

    $browser.goto($test_url + '/authenticate/logout')
    $browser.refresh()

    $browser.goto($test_url + '/authenticate/login')

    $browser.text_field(:name, "username").value = $normalUsername
    $browser.text_field(:name, "password").value = $normalPassword
    $browser.button(:name, 'loginButton').click

    # Gå til adresse som sletter alle data for en bruker
    $browser.goto($test_url + '/ansatte/delete/' + $normalUsername )

  end

  def test_01_first_time_user

    delete_current_user

    # Sjekk at vi ikke er logget inn før vi kjører
    # denne testen
    $browser.goto($test_url + '/authenticate/logout')
    $browser.refresh()

    #task: Gå til innloggingsside
    $browser.goto($test_url + '/authenticate/login')

    assert($browser.contains_text("Brukernavn"))
    assert($browser.contains_text("Passord"))

    $browser.text_field(:name, "username").value = $normalUsername
    $browser.text_field(:name, "password").value = $normalPassword
    $browser.button(:name, 'loginButton').click

    #check: Sjekk at vi er logget inn
    assert($browser.contains_text("Mine abonnementer"))

  end

  def test_02_add_subscription

    assert($browser.contains_text("Du står ikke på listene"),
           "Listen over tidsskrifter man abonnerer på skulle vært tom")

    #task: Abonner på 'Wired'
    $browser.goto($test_url + '/mine_tidsskrifter' )

    $browser.link(:id, 'show_alfabetic').click()
    $browser.link(:id, 'abonner_12').click()

    $browser.refresh()
    #check: Sjekk at wired havner i listen til venstre
#    assert(not($browser.contains_text("Du står ikke på listene")))

    $browser.refresh() ## Denne er bare nødvendig i celere
    $browser.link(:id, 'fjern_12').click()

    # Klikk "Ok" knapp i Firfox:
    #  if(PLATFORM =~/linux/ )
    #      $browser.startClicker("ok")
    #  end

    #check: Sjekk at listen til venstre er tom igjen
    $browser.refresh()
    assert($browser.contains_text("Du står ikke på listene"),
           "Listen over tidsskrifter man abonnerer på skulle vært tom")

  end

  def test_03_admin_functions_prohibited

    #task: Gå til adminsidene (/tidsskrifter)
    #check: Sjekk at vi ikke får tilgang til adminfunksjoner som vanlig bruker

    $browser.goto($test_url + '/tidsskrifter')
    # Sjekk at vi ikke får komme inn på adminsidene

    # Sjekk at vi ikke får administrere tidsskrifter vi ikke
    # er faddere for

  end


  def test_04_admin_functions
    $browser.goto($test_url + '/ansatte/set_administrator/' + $normalUsername )

    $browser.goto($test_url + '/authenticate/logout')
    $browser.refresh()

    #task: Gå til innloggingsside
    $browser.goto($test_url + '/authenticate/login')

    assert($browser.contains_text("Brukernavn"))
    assert($browser.contains_text("Passord"))

    $browser.text_field(:name, "username").value = $normalUsername
    $browser.text_field(:name, "password").value = $normalPassword
    $browser.button(:name, 'loginButton').click

  end

end
