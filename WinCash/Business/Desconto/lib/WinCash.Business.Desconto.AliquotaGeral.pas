unit WinCash.Business.Desconto.AliquotaGeral;

interface

uses
  Gsoft.Model.AliquotaDesconto,
  Gsoft.Model.ValorMonetario;

type
  TDescontoAliquotaGeral = class
  private
    FAliquotaDescontoMaximo : TAliquotaDesconto;
  public
    property aliquotaDescontoMaximo: TAliquotaDesconto read FAliquotaDescontoMaximo;
    constructor Create(aAliquotaDescontoMaximo : TAliquotaDesconto);
    function descontoMaximo(valorTotalBruto : TValorMonetario) : TValorMonetario;
    function isValorLiquidoValido(valorTotalLiquido, valorTotalBruto: TValorMonetario) : boolean;
  end;

implementation

{$D+}

{ TDescontoAliquotaGeral }

constructor TDescontoAliquotaGeral.Create(aAliquotaDescontoMaximo: TAliquotaDesconto);
begin
  self.FAliquotaDescontoMaximo := aAliquotaDescontoMaximo;
end;

function TDescontoAliquotaGeral.descontoMaximo(valorTotalBruto : TValorMonetario) : TValorMonetario;
begin
  result := TValorMonetario.Create(valorTotalBruto.valor * self.aliquotaDescontoMaximo.aliquota / 100);
end;

function TDescontoAliquotaGeral.isValorLiquidoValido(valorTotalLiquido, valorTotalBruto: TValorMonetario) : boolean;
var
  valorTotalLiquidoMinimo: TValorMonetario;
begin
  valorTotalLiquidoMinimo := TValorMonetario.Create(valorTotalBruto.valor - self.descontoMaximo(valorTotalBruto).valor);
  result := TValorMonetario.Create(valorTotalLiquidoMinimo.valor - valorTotalLiquido.valor).valor < 0.01;
end;

end.
