*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BCR.REPORT.DATA.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* En este archivo se registra temporalmente la información que se va a reportar a los Buro de Crédito.
* En esta aplicación se agrupan los datos requeridos por los formatos indicados por TransUnion y DataCredito
* Este archivo es actualizado automáticamente por el servicio REDO.BCR.REPORT.GEN
*
* @author ejijon@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/10/2010 - First Version
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("DATA.ID", T24_String)      ;* Define Table id
*-----------------------------------------------------------------------------

  CALL Table.addField("EMP.ENTIDAD", T24_String, '', '')
  CALL Table.addField("EMP.RNC", T24_String, '', '')
  CALL Table.addField("EMP.SIGLAS", T24_String, '', '')
  CALL Table.addField("EMP.RAZONSOCIAL", T24_String, '', '')
  CALL Table.addReservedField("RESERVED.EMP1")
  CALL Table.addReservedField("RESERVED.EMP2")
  CALL Table.addReservedField("RESERVED.EMP3")
  CALL Table.addReservedField("RESERVED.EMP4")
  CALL Table.addField("CUS.ID", T24_String, '', '')
  CALL Table.addField("CUS.RELACION", T24_String, '', '')
  CALL Table.addField("CUS.NOMBRE", T24_String, '', '')
  CALL Table.addField("CUS.GENERO", T24_String, '', '')
  CALL Table.addField("CUS.CEDULAOLD", T24_String, '', '')
  CALL Table.addField("CUS.CEDULANEW", T24_String, '', '')
  CALL Table.addField("CUS.RNC", T24_String, '', '')
  CALL Table.addField("CUS.PASAPORTE", T24_String, '', '')
  CALL Table.addField("CUS.NACIONALIDAD", T24_String, '', '')
  CALL Table.addField("CUS.LICENCIA", T24_String, '', '')
  CALL Table.addField("CUS.FNAC", T24_Date, '', '')
  CALL Table.addField("CUS.CIUDADNAC", T24_String, '', '')
  CALL Table.addField("CUS.PAISNAC", T24_String, '', '')
  CALL Table.addField("CUS.ESTCIVIL", T24_String, '', '')
  CALL Table.addField("CUS.NUMDEP", T24_Numeric, '', '')
  CALL Table.addField("CUS.CONYUGE", T24_String, '', '')
  CALL Table.addField("CUS.CONYUGEID", T24_String, '', '')
  CALL Table.addField("CUS.TELF.CASA", T24_String, '', '')
  CALL Table.addField("CUS.TELF.TRABAJO", T24_String, '', '')
  CALL Table.addField("CUS.TELF.CELULAR", T24_String, '', '')
  CALL Table.addField("CUS.BEEPER", T24_String, '', '')
  CALL Table.addField("CUS.FAX", T24_String, '', '')
  CALL Table.addField("CUS.TELF.OTRO", T24_String, '', '')
  CALL Table.addField("CUS.DIR.CALLE1", T24_String, '', '')
  CALL Table.addField("CUS.DIR.ESQUI1", T24_String, '', '')
  CALL Table.addField("CUS.DIR.NUMERO1", T24_String, '', '')
  CALL Table.addField("CUS.DIR.EDIFI1", T24_String, '', '')
  CALL Table.addField("CUS.DIR.PISO1", T24_String, '', '')
  CALL Table.addField("CUS.DIR.DPTO1", T24_String, '', '')
  CALL Table.addField("CUS.DIR.URB1", T24_String, '', '')
  CALL Table.addField("CUS.DIR.SECTOR1", T24_String, '', '')
  CALL Table.addField("CUS.DIR.CIUDAD1", T24_String, '', '')
  CALL Table.addField("CUS.DIR.PROVIN1", T24_String, '', '')
  CALL Table.addField("CUS.DIR.CALLE2", T24_String, '', '')
  CALL Table.addField("CUS.DIR.ESQUI2", T24_String, '', '')
  CALL Table.addField("CUS.DIR.NUMERO2", T24_String, '', '')
  CALL Table.addField("CUS.DIR.EDIFI2", T24_String, '', '')
  CALL Table.addField("CUS.DIR.PISO2", T24_String, '', '')
  CALL Table.addField("CUS.DIR.DPTO2", T24_String, '', '')
  CALL Table.addField("CUS.DIR.URB2", T24_String, '', '')
  CALL Table.addField("CUS.DIR.SECTOR2", T24_String, '', '')
  CALL Table.addField("CUS.DIR.CIUDAD2", T24_String, '', '')
  CALL Table.addField("CUS.DIR.PROVIN2", T24_String, '', '')
  CALL Table.addReservedField("RESERVED.CUS1")
  CALL Table.addReservedField("RESERVED.CUS2")
  CALL Table.addReservedField("RESERVED.CUS3")
  CALL Table.addReservedField("RESERVED.CUS4")
  CALL Table.addField("LOAN.ID", T24_String, '', '')
  CALL Table.addField("LOAN.CCY", T24_String, '', '')
  CALL Table.addField("LOAN.TIPO", T24_String, '', '')
  CALL Table.addField("LOAN.FPAGO", T24_String, '', '')
  CALL Table.addField("LOAN.CTA.NUM", T24_String, '', '')
  CALL Table.addField("LOAN.CTA.RELACION", T24_String, '', '')
  CALL Table.addField("LOAN.CTA.DESCRIP", T24_String, '', '')
  CALL Table.addField("LOAN.CTA.STATUS", T24_String, '', '')
  CALL Table.addField("LOAN.COMENTESPEC", T24_String, '', '')
  CALL Table.addField("LOAN.FAPERTURA", T24_Date, '', '')
  CALL Table.addField("LOAN.FVENCIMIENTO", T24_Date, '', '')
  CALL Table.addField("LOAN.MONTO", T24_Numeric, '', '')
  CALL Table.addField("LOAN.LIMITE", T24_Numeric, '', '')
  CALL Table.addField("LOAN.TOPCREDITO", T24_Numeric, '', '')
  CALL Table.addField("LOAN.NUMCUOTAS", T24_Numeric, '', '')
  CALL Table.addField("LOAN.MONTOCUOTA", T24_String, '', '')
  CALL Table.addField("LOAN.FCORTE", T24_Date, '', '')
  CALL Table.addField("LOAN.ULTACT", T24_Date, '', '')
  CALL Table.addField("LOAN.MONTULTPAGO", T24_Date, '', '')
  CALL Table.addField("LOAN.BALANACT", T24_Numeric, '', '')
  CALL Table.addField("LOAN.MONTOATRASO", T24_Numeric, '', '')
  CALL Table.addField("LOAN.CUOATRASADAS", T24_Numeric, '', '')
  CALL Table.addField("LOAN.CLASIFICACTA", T24_String, '', '')
  CALL Table.addField("LOAN.COMENTSUBSCRI", T24_String, '', '')
  CALL Table.addField("LOAN.ESTATUSCTA", T24_String, '', '')
  CALL Table.addField("LOAN.ESTADOCTA", T24_String, '', '')
  CALL Table.addField("LOAN.SALDO1", T24_Numeric, '', '')
  CALL Table.addField("LOAN.SALDO2", T24_Numeric, '', '')
  CALL Table.addField("LOAN.SALDO3", T24_Numeric, '', '')
  CALL Table.addField("LOAN.SALDO4", T24_Numeric, '', '')
  CALL Table.addField("LOAN.SALDO5", T24_Numeric, '', '')
  CALL Table.addField("LOAN.SALDO6", T24_Numeric, '', '')
  CALL Table.addField("LOAN.SALDO7", T24_Numeric, '', '')
  CALL Table.addReservedField("RESERVED.LOAN1")
  CALL Table.addReservedField("RESERVED.LOAN2")
  CALL Table.addReservedField("RESERVED.LOAN3")
  CALL Table.addReservedField("RESERVED.LOAN4")
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
