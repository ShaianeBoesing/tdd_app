require 'rails_helper'

RSpec.feature "Welcomes", type: :feature do
  scenario "Mostra mensagem de Bem vindo" do
    visit(root_path)
    expect(page).to have_content("Bem-Vindo")
  end

  scenario "Verificar o link cadastro de clientes" do
    visit(root_path)
    expect(find('ul li')).to have_link('Cadastro de Clientes')
  end
end
