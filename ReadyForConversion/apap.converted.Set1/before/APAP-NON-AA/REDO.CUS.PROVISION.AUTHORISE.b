*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CUS.PROVISION.AUTHORISE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.PROVISION.PARAMETER.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.CUS.PROVISION.AUTHORISE is an authorisation routine attached to the TEMPLATE
*                    - REDO.H.CUSTOMER.PROVISIONING;
*Linked With       : TEMPLATE-REDO.H.CUSTOMER.PROVISIONING
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.H.CUSTOMER.PROVISIONING           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 24 Sep 2010        JEEVA T           ODR-2009-11-0159 B.23A        Initial Creation
*******************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB PROCESS.PARA

  RETURN
*-------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

  Y.PRINC              = R.NEW(REDO.CUS.PROV.PROV.PRINC)
  Y.PRINC.INT          = R.NEW(REDO.CUS.PROV.PROV.INTEREST)
  Y.PROV.RES           = R.NEW(REDO.CUS.PROV.PROV.RESTRUCT)
  Y.PROV.FX            = R.NEW(REDO.CUS.PROV.PROV.FX)
  Y.TOTOL =Y.PRINC + Y.PRINC.INT + Y.PROV.RES + Y.PROV.FX
  R.NEW(REDO.CUS.PROV.TOTAL.PROV) = Y.PRINC + Y.PRINC.INT + Y.PROV.RES + Y.PROV.FX
  RETURN
*-------------------------------------------------------------------------
END
