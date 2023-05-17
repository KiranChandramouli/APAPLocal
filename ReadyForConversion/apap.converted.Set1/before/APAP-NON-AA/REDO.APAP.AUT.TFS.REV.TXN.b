*-----------------------------------------------------------------------------
* <Rating>-77</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.AUT.TFS.REV.TXN
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.TFS.REV.TXN
*--------------------------------------------------------------------------------------------------------
*Description       : This is an AUTHORISATION routine, the routine checks if the RECORD.STATUS is RNAU
*                    and the local field L.RTE.FORM is set to YES then writes the record into local
*                    file F.REDO.FT.TT.REV
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                 Description
*   ------             -----               -------------              -------------
* 22 July 2010     Shiva Prasad Y      ODR-2009-10-0318 B.126        Initial Creation
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
  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
  FN.REDO.FT.TT.REV = 'F.REDO.FT.TT.REV'
  F.REDO.FT.TT.REV  = ''
  CALL OPF(FN.REDO.FT.TT.REV,F.REDO.FT.TT.REV)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
  GOSUB FIND.MULTI.LOCAL.REF

  IF R.NEW(TFS.RECORD.STATUS) EQ 'RNAU' AND R.NEW(TFS.LOCAL.REF)<1,LOC.L.RTE.FORM.POS> EQ 'YES' THEN
    GOSUB WRITE.PROCESS
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
**************
WRITE.PROCESS:
**************
  REDO.FT.TT.REV.ID = ID.NEW:';':R.NEW(TFS.CURR.NO)
  GOSUB READ.REDO.FT.TT.REV
  GOSUB WRITE.REDO.FT.TT.REV

  RETURN
*--------------------------------------------------------------------------------------------------------
********************
READ.REDO.FT.TT.REV:
********************
* In this para of the code, file REDO.FT.TT.REV is read
  R.REDO.FT.TT.REV  = ''
  REDO.FT.TT.REV.ER = ''
  CALL F.READ(FN.REDO.FT.TT.REV,REDO.FT.TT.REV.ID,R.REDO.FT.TT.REV,F.REDO.FT.TT.REV,REDO.FT.TT.REV.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
WRITE.REDO.FT.TT.REV:
*********************
* In this para of the code, values are written to file REDO.FT.TT.REV
  CALL F.WRITE(FN.REDO.FT.TT.REV,REDO.FT.TT.REV.ID,R.REDO.FT.TT.REV)

  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
  APPL.ARRAY = 'T24.FUND.SERVICES'
  FLD.ARRAY  = 'L.RTE.FORM'
  FLD.POS    = ''

  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.RTE.FORM.POS =  FLD.POS<1,1>

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
