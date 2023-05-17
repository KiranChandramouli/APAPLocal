*-----------------------------------------------------------------------------
* <Rating>-61</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUT.DEL.BEN
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.AUT.DEL.BEN
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine used to delete the beneficiaries
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 28-Dec-2010        Prabhu.N       ODR-2010-08-0031   Initial Creation
*-------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.BENEFICIARY
$INSERT I_System

  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA

  RETURN
*---------
OPEN.PARA:
*---------
  FN.CUS.BEN.LIST = 'F.CUS.BEN.LIST'
  F.CUS.BEN.LIST  = ''
  CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)
  RETURN

*------------
PROCESS.PARA:
*------------

  CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')

  IF PGM.VERSION EQ ',ADD.OWN.BANK.BEN.DE' OR PGM.VERSION EQ ',ADD.OWN.BANK.BEN.DE.CONFIRM' THEN

    GOSUB DEL.BEN.OWN
  END

  IF PGM.VERSION EQ ',ADD.OTHER.BANK.BEN.DE' OR PGM.VERSION EQ ',ADD.OTHER.BANK.BEN.DE.CONFIRM' THEN
    GOSUB DEL.BEN.OTHER
  END

  RETURN
*-----------
DEL.BEN.OWN:
*-----------
  CUS.BEN.LIST.ID = CUSTOMER.ID:'-OWN'
  CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)

  LOCATE R.NEW(ARC.BEN.BEN.ACCT.NO) IN R.CUS.BEN.LIST<1> SETTING Y.BEN.POS THEN
    DEL R.CUS.BEN.LIST<Y.BEN.POS>
  END

  CALL F.WRITE(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST)

  RETURN
*-------------
DEL.BEN.OTHER:
*-------------
  CUS.BEN.LIST.ID = CUSTOMER.ID:'-OTHER'
  CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)
  FLD.POS = ''
  CALL MULTI.GET.LOC.REF('BENEFICIARY','L.BEN.ACCOUNT',FLD.POS)
  LOCATE R.NEW(ARC.BEN.LOCAL.REF)<1,FLD.POS> IN R.CUS.BEN.LIST<1> SETTING Y.BEN.POS THEN
    DEL R.CUS.BEN.LIST<Y.BEN.POS>
  END

  CALL F.WRITE(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST)

  RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------
