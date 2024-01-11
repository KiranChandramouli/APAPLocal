$PACKAGE APAP.REDOCHNLS
*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ATH.VAL.DELAY
**************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.ATH.VAL.DELAY
*********************************************************
*Description:This routine is to identify delay in submission of liquidation on
*             based on PURCHASE.DATE and configured days in REDO.H.ATM.PARAMETER
***********************************************************************
*LINKED WITH: NA
*IN PARAMETER: NA
*OUT PARAMETER: REDO.ATH.STLMT.FILE.PROCESS
******************************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*03.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
* 10-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 10-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 20-12-2023    VIGNESHWARI      ADDED COMMENT FOR INTERFACE CHANGES 
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.ATH.STLMT.FILE.PROCESS.COMMON
$INSERT I_F.REDO.APAP.H.PARAMETER
$INSERT I_F.ATM.TRANSACTION ;* ATM Change by Mario team


  GOSUB PROCESS

  RETURN


*******
PROCESS:
********
**ATM Change by Mario team-Start
  ERROR.READU = ''
  FN.ATM.TRANSACTION = 'F.ATM.TRANSACTION'
  F.ATM.TRANSACTION = ''
  Y.PARAM.DAYS=R.REDO.APAP.H.PARAMETER<PARAM.LOCK.DAYS>
  ATM.TRANSACTION.ID=CARD.NUMBER:'.':Y.FIELD.VALUE
  
  CALL F.READ(FN.ATM.TRANSACTION,ATM.TRANSACTION.ID,R.ATM.TRANSACTION,F.ATM.TRANSACTION,ERR.ATM)
  *CALL F.READU(FN.ATM.TRANSACTION,ATM.TRANSACTION.ID,R.ATM.TRANSACTION,F.ATM.TRANSACTION,ERR.ATM,ATM.REV.ERR)
  IF R.ATM.TRANSACTION EQ '' THEN
*        ERROR.MESSAGE='NOT.VALID.TRANSACTION'
    ERROR.MESSAGE='NO.MATCH.TRANSACTION'
  END

*INICIAN CAMBIOS JORGE
	LOCAL.APPLICATION = 'ATM.TRANSACTION'
    LOCAL.FIELD = 'L.LOCAL.DATE'
    LOCAL.POSITION = ""
    CALL MULTI.GET.LOC.REF(LOCAL.APPLICATION, LOCAL.FIELD, LOCAL.POSITION)
    L.LOCAL.DATE.POS = LOCAL.POSITION<1,1>
*TERMINAN CAMBIOS JORGE

  *Y.ATM.REV.LOC.DATE=R.ATM.REVERSAL<AT.REV.AUDIT.DATE.TIME> --CAMBIO JORGE
  Y.ATM.REV.LOC.DATE=R.ATM.TRANSACTION<AT.REV.LOCAL.REF, L.LOCAL.DATE.POS>  ;*--CAMBIO JORGE
  YREGION=''
  Y.ADD.DAYS='+':Y.PARAM.DAYS:'C'
**ATM Change by Mario team-End
*    CALL CDT(YREGION,Y.ATM.REV.LOC.DATE,Y.ADD.DAYS)

*    IF Y.ATM.REV.LOC.DATE LT TODAY THEN
*        ERROR.MESSAGE='DELAY.SUBMISSION'
*    END

  RETURN

END
