describe("Test visite", () => {
  beforeEach(() => {
    cy.visit('http://localhost:3000');
  });

  it("Test du front", () => {
    function formatDate(date) {
      const options = { month: "short", day: "numeric", year: "numeric" };
      const formattedDate = date.toLocaleString("en-US", options).replace(",", "");

      const day = date.getDate();
      const suffix =
        day === 1 || day === 21 || day === 31
          ? "st"
          : day === 2 || day === 22
          ? "nd"
          : day === 3 || day === 23
          ? "rd"
          : "th";

      return formattedDate.replace(/\d+/, day + suffix);
    }

    const today = formatDate(new Date());

    cy.contains("Articles").should("be.visible");
    cy.contains("Bookmarks").should("be.visible");
    cy.contains(today).should("be.visible");

    cy.get(".Header_date__qfgIk")
      .invoke("text")
      .then((text) => {
        expect(text.trim()).to.eq(today);
      });
  });
});