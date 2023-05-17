*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.B.POP.DEL(P.IN.CUS.ID)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description   : part of REDO.CCRG.B.POP TSA service
* Linked With   : TSA.SERVICE - ID: REDO.CCRG.POP
* In Parameter  : P.IN.CUS.ID - Customer code of the customer consulted
* Out Parameter :
*--------------------------------------------------------------------------------------------
* Modification Details:
*--------------------------------------------------------------------------------------------
* 27-09-2011 - Creation               hpasquel@temenos.com
*--------------------------------------------------------------------------------------------
* Modification History
* Company Name: APAP
* Developed By: Temenos Application Management
* Program Name: REDO.CCRG
*--------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.CCRG.B.POP.COMMON
*--------------------------------------------------------------------------------------------

  GOSUB PROCESS
  RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
* Delete for P.IN.CUS.ID
*
  CALL F.DELETE(FN.REDO.CCRG.RL.BAL.MAIN,P.IN.CUS.ID)
*
  Y.FILE.NAME    = FN.REDO.CCRG.RL.BAL.DET
  Y.FILE.NAME<2> = 'CUSTOMER.ID EQ ' : P.IN.CUS.ID
  CALL EB.CLEAR.FILE(Y.FILE.NAME, F.REDO.CCRG.RL.BAL.DET)
*
  Y.FILE.NAME    = FN.REDO.CCRG.RL.BAL.CUS.DET
  Y.FILE.NAME<2> = 'CUSTOMER.ID EQ ' : P.IN.CUS.ID
  CALL EB.CLEAR.FILE(Y.FILE.NAME, F.REDO.CCRG.RL.BAL.CUS.DET)

  RETURN
*-----------------------------------------------------------------------------
END
