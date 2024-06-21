const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LoveModule", (m) => {
  const name = m.getParameter("name_", 'Love_name');
  const symbol = m.getParameter("symbol_", 'Love_symbol');

  const love = m.contract("TokenOfLove", [name, symbol]);

  return { love };
});
