require 'rails_helper'

RSpec.feature "Customers", type: :feature do
  let(:customer) { create(:customer) }

  scenario "Verificar o link cadastro de clientes" do
    visit(root_path)
    expect(page).to have_link('Cadastro de Clientes')
  end

  scenario "Verificar link de Novo Cliente" do
    visit(root_path)
    click_on('Cadastro de Clientes')
    expect(page).to have_content('Listando Clientes').and have_link('Novo Cliente')
  end

  scenario "Verificar formulário de Novo Cliente" do
    visit(customers_path)
    click_on('Novo Cliente')
    expect(page).to have_content('Novo Cliente')
  end

  scenario "Cadastra Novo Cliente" do
    visit(new_customer_path)
    customer_name = Faker::Name.name
    fill_in('Nome', with: customer_name)
    fill_in('Email', with: Faker::Internet.email)
    fill_in('Telefone', with: Faker::PhoneNumber.phone_number)
    attach_file('Avatar', "#{Rails.root}/spec/fixtures/avatar.png")
    choose(option: ['S','N'].sample)
    click_on('Criar Cliente') 
    expect(page).to have_content('Cliente cadastrado com sucesso!')
    expect(Customer.last.name).to eq(customer_name)
  end

  scenario "Não Cadastra Novo Cliente Inválido" do
    visit(new_customer_path)
    click_on('Criar Cliente') 
    expect(page).to have_content('não pode ficar em branco')
  end

  scenario "Mostra um Cliente" do
    visit(customer_path customer.id)
    expect(page).to have_content(customer.name).and have_content(customer.email).and have_content(customer.phone)
  end

  scenario "Atualiza um Cliente" do
    visit(edit_customer_path(customer.id))
    new_name = Faker::Name.name
    fill_in('Nome', with: new_name)
    click_on('Atualizar Cliente') 
    expect(page).to have_content('Cliente atualizado com sucesso').and have_content(new_name)
  end

  scenario "Clica no link Mostrar" do 
    customer
    visit(customers_path)
    find(:xpath, "/html/body/table/tbody/tr[1]/td[2]/a").click
    expect(page).to have_content("Ver Cliente")
  end

  scenario "Clica no link Editar" do 
    customer
    visit(customers_path)
    find(:xpath, "/html/body/table/tbody/tr[1]/td[3]/a").click
    expect(page).to have_content("Editar Cliente")
  end

  scenario "Clica no link Excluir", js: true do 
    customer
    visit(customers_path)
    find(:xpath, "/html/body/table/tbody/tr[1]/td[4]/form/button").click
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content("Cliente excluído com sucesso")
  end
end
