unit WinCash.Business.Desconto.RateamentoAliquotaVendedorProduto;

interface

uses
  Gsoft.Model.LancamentoVenda.Item,
  Gsoft.Model.ValorMonetario,
  Gsoft.Model.AliquotaDesconto,
  WinCash.Business.Desconto.AliquotaVendedorProduto;

type
  TDescontoRateamentoAliquotaVendedorProduto = class
  private
    procedure aplicarDescontoProduto(valorTotalDesconto : TValorMonetario;
      valorTotalItens : TValorMonetario; item : TLancamentoVendaItem;
      aliquotaDescontoVendedor : TAliquotaDesconto);
  public
    procedure ratear(
      valorLiquido : TValorMonetario;
      aliquotaDesconto : TAliquotaDesconto;
      listaItens : TLancamentoVendaItemLista
    );
  end;


implementation

{ TDescontoRateamentoAliquotaVendedorProduto }

procedure TDescontoRateamentoAliquotaVendedorProduto.aplicarDescontoProduto(valorTotalDesconto : TValorMonetario;
      valorTotalItens : TValorMonetario; item : TLancamentoVendaItem;
      aliquotaDescontoVendedor : TAliquotaDesconto);
var
  pesoItem : double;
  desconto : TDescontoAliquotaVendedorProduto;
  valorDescontoAplicadoItem, valorLiquidoFinal : TValorMonetario;
begin
  desconto := TDescontoAliquotaVendedorProduto.Create(aliquotaDescontoVendedor,
    TAliquotaDesconto.Create(item.produto.DescontoMaximo));
  pesoItem := item.valorTotalBruto.valor / valorTotalItens.valor;
  valorDescontoAplicadoItem := TValorMonetario.Create(valorTotalDesconto.valor * pesoItem);
  valorLiquidoFinal := TValorMonetario.Create(
    item.valorTotalBruto.valor -
    item.valorTotalDesconto.valor -
    valorDescontoAplicadoItem.valor
    );

  if desconto.isValorLiquidoValido(valorLiquidoFinal,item.valorTotalBruto) then
    item.valorDescontoFechamento.valor :=
      item.valorDescontoFechamento.valor + valorDescontoAplicadoItem.valor
  else
    item.valorDescontoFechamento.valor := item.valorDescontoFechamento.valor + item.valorDescontoDisponivel.valor;
end;

procedure TDescontoRateamentoAliquotaVendedorProduto.ratear(
  valorLiquido: TValorMonetario; aliquotaDesconto: TAliquotaDesconto;
  listaItens: TLancamentoVendaItemLista);
var
  itensElegiveisDesconto : TLancamentoVendaItemLista;
  item: TLancamentoVendaItem;
  valorDescontoRestante : TValorMonetario;
begin
  itensElegiveisDesconto := TLancamentoVendaItemLista.Create();
  valorDescontoRestante := TValorMonetario.Create(0);
  for item in listaItens do
    item.valorDescontoFechamento.valor := 0;
  repeat
    itensElegiveisDesconto.Clear();
    for item in listaItens do
    begin
      if item.valorDescontoDisponivel.valor > 0  then
        itensElegiveisDesconto.Add(item);
    end;
    valorDescontoRestante.valor := listaItens.valorTotalLiquido.valor - valorLiquido.valor;
    for item in itensElegiveisDesconto do
    begin
      aplicarDescontoProduto(valorDescontoRestante, itensElegiveisDesconto.valorTotalBruto, item, aliquotaDesconto);
    end;
  until (itensElegiveisDesconto.Count = 0) or (listaItens.valorTotalLiquido.Equals(valorLiquido));
end;

end.