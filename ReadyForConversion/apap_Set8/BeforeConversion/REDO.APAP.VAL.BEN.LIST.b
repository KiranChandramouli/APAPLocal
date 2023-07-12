*-----------------------------------------------------------------------------
* <Rating>-34</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.VAL.BEN.LIST
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.BEN.LIST
*--------------------------------------------------------------------------------------------------------
*Description       : This is a VALIDATION routine, attached to the local reference field L.FT.BEN.LIST,
*                    the routine populates the local field L.TT.BENEFICAIR with the same value as that
*                    selected in L.FT.BEN.LIST
*Linked With       : Version T24.FUND.SERVICES,ADMIN.CHQ
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                 Description
*   ------             -----               -------------              -------------
* 13 July 2010     Shiva Prasad Y      ODR-2009-10-0318 B.126        Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.T24.FUND.SERVICES
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
  IF MESSAGE EQ 'VAL' THEN
    RETURN
  END
  IF NOT(COMI) THEN
    RETURN
  END
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

  GOSUB FIND.MULTI.LOCAL.REF
  R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.BENEFICIAR.POS> = COMI

  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained

  APPL.ARRAY = 'T24.FUND.SERVICES'
  FLD.ARRAY  = 'L.TT.BENEFICIAR'
  FLD.POS    = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

  LOC.L.TT.BENEFICIAR.POS = FLD.POS<1,1>

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
