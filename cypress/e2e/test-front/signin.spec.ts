describe("Testing Morningnews Frontend", () => {
    it('Register utilisateur et mdp', () => {
      cy.visit('http://localhost:3000');

      cy.get('#signUpUsername').type('johndoe');
      cy.get('#signUpPassword').type('s3cret');
      cy.get('#register').click();
      cy.get('[data-test="sidenav-username"]').should('eq', @johndoe);
    });
  });