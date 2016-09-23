unit WinCash.Business.Desconto.RateamentoDesconto;

interface

uses
  Gsoft.Model.LancamentoVenda.Item,
  Gsoft.Model.ValorMonetario,
  WinCash.Business.Desconto.AliquotaGeral,
  WinCash.Business.Desconto.AliquotaDesconto;

type
  TRateamentoDescontoAliquotaGeral = class
  private
  public
    procedure ratear(
  aliquotaDesconto : TDescontoAliquotaGeral;
  valorLiquido : TValorMonetario;
  listaItens : TLancamentoVendaItemLista);
  end;

implementation

{ TRateamentoDescontoAliquotaGeral }

procedure TRateamentoDescontoAliquotaGeral.ratear(
  aliquotaDesconto : TDescontoAliquotaGeral;
  valorLiquido : TValorMonetario;
  listaItens : TLancamentoVendaItemLista);
var
  valorDesconto: TValorMonetario;
  item: TLancamentoVendaItem;
  aliquotaDescontoRateamento: TAliquotaDesconto;
begin
  if not aliquotaDesconto.isValorLiquidoValido(valorLiquido, listaItens.valorTotalBruto) then
    Exit;
  valorDesconto := TValorMonetario.Create(listaItens.valorTotalBruto.valor - valorLiquido.valor);
  aliquotaDescontoRateamento := TAliquotaDesconto.Create(100 * valorDesconto.valor / listaItens.valorTotalBruto.valor);

  for item in listaItens do
    item.valorDescontoFechamento.valor := aliquotaDescontoRateamento.aplicarAliquotaDesconto(item.valorUnitarioBruto.valor);

  if valorLiquido.valor - listaItens.valorTotalLiquido.valor > 0.01 then
  begin
    item := listaItens.itemMaiorValor;
    item.valorDescontoFechamento.valor :=
      item.valorDescontoFechamento.valor + valorLiquido.valor - listaItens.valorTotalLiquido.valor;
  end
  else
  if listaItens.valorTotalLiquido.valor - valorLiquido.valor > 0.01 then
  begin
    item := listaItens.itemMaiorValor;
    item.valorDescontoFechamento.valor :=
      item.valorDescontoFechamento.valor - (listaItens.valorTotalLiquido.valor - valorLiquido.valor);
  end;
end;

end.